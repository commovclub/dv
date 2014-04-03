package com.commov.app.dv;

import java.util.HashMap;
import java.util.Map;

import android.content.Context;
import android.content.pm.ApplicationInfo;
import android.content.pm.PackageManager;
import android.database.sqlite.SQLiteDatabase;
import android.util.Log;

import com.araneaapps.android.libs.logger.ALog;
import com.araneaapps.android.libs.logger.ALog.DebugLevel;
import com.chute.android.photopickerplus.PhotoPickerPlusApp;
import com.chute.android.photopickerplus.config.PhotoPicker;
import com.chute.android.photopickerplus.config.PhotoPickerConfiguration;
import com.chute.android.photopickerplus.models.enums.DisplayType;
import com.chute.android.photopickerplus.models.enums.LocalServiceType;
import com.chute.sdk.v2.api.Chute;
import com.chute.sdk.v2.api.authentication.AuthConstants;
import com.chute.sdk.v2.model.enums.AccountType;
import com.commov.app.dv.db.roscopeco.ormdroid.Entity;
import com.commov.app.dv.db.roscopeco.ormdroid.ORMDroidException;
import com.commov.app.dv.db.roscopeco.ormdroid.Query;

public class DVApp extends PhotoPickerPlusApp {
    private static DVApp singleton;
    private Context mContext;
    private String mDBName;

    private static void initInstance(DVApp app, Context ctx) {
        if (app.mContext == null)
            app.attachBaseContext(app.mContext = ctx.getApplicationContext());
    }

    public static boolean isInitialized() {
        return (singleton != null);
    }

    /**
     * <p>
     * Intialize the ORMDroid framework. This <strong>must</strong> be called
     * before using any of the methods that use the default database.
     * </p>
     * 
     * <p>
     * If your application doesn't use the default database (e.g. you pass in
     * your own {@link SQLiteDatabase} handle to the
     * {@link Query#execute(SQLiteDatabase)} and
     * {@link Entity#save(SQLiteDatabase)} methods) the you don't
     * <i>technically</i> need to call this, but it doesn't hurt.
     * </p>
     * 
     * <p>
     * This method may be called multiple times - subsequent calls are simply
     * ignored.
     * </p>
     * 
     * @param ctx
     *            A {@link Context} within the application to initialize.
     */
    public static void initialize(Context ctx) {
        if (!isInitialized()) {
            initInstance(singleton = new DVApp(), ctx);
        }
    }

    /**
     * Obtain the singleton instance of this class.
     * 
     * @return the singleton instance.
     */
    public static DVApp getSingleton() {
        if (!isInitialized()) {
            Log.e("DVApp", "ORMDroid is not initialized");
            throw new ORMDroidException(
                    "ORMDroid is not initialized - You must call DVApp.initialize");
        }

        return singleton;
    }

    /**
     * Obtain the default database used by the framework. This is a convenience
     * that calls {@link #getDatabase()} on the singleton instance.
     * 
     * @return the default database.
     */
    public static SQLiteDatabase getDefaultDatabase() {
        return getSingleton().getDatabase();
    }

    private void initDatabaseConfig() {
        try {
            ApplicationInfo ai = mContext.getPackageManager()
                    .getApplicationInfo(mContext.getPackageName(),
                            PackageManager.GET_META_DATA);
            mDBName = ai.metaData.get("ormdroid.database.name").toString();
        } catch (Exception e) {
            throw new ORMDroidException(
                    "ORMDroid database configuration not found; Did you set properties in your app manifest?",
                    e);
        }
    }

    /**
     * Get the database name used by the framework in this application.
     * 
     * @return The database name.
     */
    public String getDatabaseName() {
        if (mDBName == null) {
            initDatabaseConfig();
        }
        return mDBName;
    }

    /**
     * Get the database used by the framework in this application.
     * 
     * @return The database.
     */
    public SQLiteDatabase getDatabase() {
        return openOrCreateDatabase(getDatabaseName(), 0, null);
    }

    @Override
    public void onCreate() {
        super.onCreate();
        if (singleton != null) {
            throw new IllegalStateException(
                    "DVApp already initialized!");
        }
        singleton = this;
        mContext = getApplicationContext();
        initInstance(this, getApplicationContext());

        ALog.setDebugTag("PhotoPicker");
        ALog.setDebugLevel(DebugLevel.ALL);

        /**
         * Fill in using "app_id" and "app_secret" values from your Chute
         * application.
         * 
         * See <a href="https://apps.getchute.com">https://apps.getchute.com</a>
         */

        Chute.init(this, new AuthConstants("APP_ID", "APP_SECRET"));

        Map<AccountType, DisplayType> map = new HashMap<AccountType, DisplayType>();
        map.put(AccountType.INSTAGRAM, DisplayType.GRID);

        PhotoPickerConfiguration config = new PhotoPickerConfiguration.Builder(
                getApplicationContext()).isMultiPicker(true)
                .defaultAccountDisplayType(DisplayType.GRID)
                // .accountDisplayType(map)
                // .accountList(AccountType.FLICKR, AccountType.DROPBOX,
                // AccountType.INSTAGRAM, AccountType.GOOGLE,
                // AccountType.YOUTUBE)
                .localMediaList(LocalServiceType.ALL_MEDIA,
                        LocalServiceType.CAMERA_MEDIA)
                // LocalServiceType.RECORD_VIDEO,
                // LocalServiceType.LAST_VIDEO_CAPTURED)
                // .configUrl(ConfigEndpointURLs.SERVICES_CONFIG_URL)
                .supportImages(true).supportVideos(false).build();
        PhotoPicker.getInstance().init(config);

    }

}
