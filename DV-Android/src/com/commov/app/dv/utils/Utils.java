package com.commov.app.dv.utils;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.FileReader;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.UUID;
import java.util.regex.Pattern;

import android.app.Activity;
import android.content.Context;
import android.content.pm.ApplicationInfo;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.content.pm.PackageManager.NameNotFoundException;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Matrix;
import android.media.ExifInterface;
import android.net.ConnectivityManager;
import android.net.NetworkInfo;
import android.net.NetworkInfo.State;
import android.os.Bundle;
import android.os.Environment;
import android.provider.Settings;
import android.provider.Settings.Secure;
import android.view.View;
import android.widget.Toast;

import com.commov.app.dv.R;
import com.commov.app.dv.common.DeviceUuidFactory;
import com.commov.app.dv.widget.appmsg.ToastUtils;

public class Utils {
	private Utils() {
	}
	
	public static final String TAG = "PushDemoActivity";
	public static final String RESPONSE_METHOD = "method";
	public static final String RESPONSE_CONTENT = "content";
	public static final String RESPONSE_ERRCODE = "errcode";
	protected static final String ACTION_LOGIN = "com.baidu.pushdemo.action.LOGIN";
	public static final String ACTION_MESSAGE = "com.baiud.pushdemo.action.MESSAGE";
	public static final String ACTION_RESPONSE = "bccsclient.action.RESPONSE";
	public static final String ACTION_SHOW_MESSAGE = "bccsclient.action.SHOW_MESSAGE";
	protected static final String EXTRA_ACCESS_TOKEN = "access_token";
	public static final String EXTRA_MESSAGE = "message";
	public static final String ACTION_BACKTOTOP = "com.bfxh.main";

	// 获取AppKey
	public static String getMetaValue(Context context, String metaKey) {
		Bundle metaData = null;
		String apiKey = null;
		if (context == null || metaKey == null) {
			return null;
		}
		try {
			ApplicationInfo ai = context.getPackageManager()
			        .getApplicationInfo(context.getPackageName(),
			                PackageManager.GET_META_DATA);
			if (null != ai) {
				metaData = ai.metaData;
			}
			if (null != metaData) {
				apiKey = metaData.getString(metaKey);
			}
		} catch (NameNotFoundException e) {

		}
		return apiKey;
	}

	public static boolean hasSDCard() {
		if (Environment.MEDIA_MOUNTED.endsWith(Environment
		        .getExternalStorageState())) {
			return true;
		}
		return false;
	}

	public static String getSavingPath() {
		final StringBuffer sb = new StringBuffer();
		File sdCardDir;
		if (Utils.hasSDCard()) {
			sdCardDir = Environment.getExternalStorageDirectory();
		} else {
			return null;
		}
		sb.append(sdCardDir);

		sb.append("/data/.data/");

		return sb.toString();

	}

	static public String getContents(File aFile) {
		// ...checks on aFile are elided
		StringBuilder contents = new StringBuilder();

		try {
			// use buffering, reading one line at a time
			// FileReader always assumes default encoding is OK!
			BufferedReader input = new BufferedReader(new FileReader(aFile));
			try {
				String line = null; // not declared within while loop
				/*
				 * readLine is a bit quirky : it returns the content of a line
				 * MINUS the newline. it returns null only for the END of the
				 * stream. it returns an empty String if two newlines appear in
				 * a row.
				 */
				while ((line = input.readLine()) != null) {
					contents.append(line);
					contents.append(System.getProperty("line.separator"));
				}
			} finally {
				input.close();
			}
		} catch (IOException ex) {
			ex.printStackTrace();
		}

		return contents.toString();
	}

	public static String generatorAndroidId(Context context) {
		String android_id = Settings.System.getString(
		        context.getContentResolver(), Secure.ANDROID_ID);
		if (android_id != null && android_id.length() > 22) {
			android_id = android_id.substring(0, 22);
		}
		if (android_id == null) {
			android_id = UUID.randomUUID().toString();
		}
		if (android_id.length() > 22) {
			android_id = android_id.substring(0, 22);
		}
		return android_id;
	}

	public static boolean isValidEmailAddress(String address) {
		Pattern EMAIL_PATTERN = Pattern
				.compile("^[\\w\\.=-]+@[\\w\\.-]+\\.[\\w]{2,9}$");
		return EMAIL_PATTERN.matcher(address).matches() ? true : false;
	}

	public static String getDeviceID(Context context) {
		DeviceUuidFactory df = new DeviceUuidFactory(context);
		return df.getDeviceUuid().toString();
	}

	public static String getBuildModel() {
		return android.os.Build.MODEL;
	}

	public static String getBuildVersionSDK() {
		return android.os.Build.VERSION.SDK;
	}

	public static int getBuildVersionSDKInt() {
		return android.os.Build.VERSION.SDK_INT;
	}

	public static String getBuildVersionRelease() {
		return android.os.Build.VERSION.RELEASE;
	}

	public static boolean isNetworkAvailable(Context context) {
		ConnectivityManager cm = (ConnectivityManager) context
				.getSystemService(Context.CONNECTIVITY_SERVICE);
		NetworkInfo info = cm.getActiveNetworkInfo();
		return (info != null && info.isConnected());
	}

	public static boolean isWifiNetworkAvailable(Context context) {
		ConnectivityManager cm = (ConnectivityManager) context
				.getSystemService(Context.CONNECTIVITY_SERVICE);
		State wifi = cm.getNetworkInfo(ConnectivityManager.TYPE_WIFI)
				.getState();
		return (wifi == State.CONNECTED);
	}

	public static String getAppVersionName(Context context) {
		String versionname = "0";
		PackageManager pm = context.getPackageManager();
		PackageInfo pi;
		try {
			pi = pm.getPackageInfo(context.getPackageName(), 0);
			versionname = pi.versionName;
		} catch (NameNotFoundException e) {
			e.printStackTrace();
		}
		return versionname;
	}

	public static int getAppVersionCode(Context context) {
		int versioncode = Integer.MAX_VALUE;
		PackageManager pm = context.getPackageManager();
		PackageInfo pi;
		try {
			pi = pm.getPackageInfo(context.getPackageName(), 0);
			versioncode = pi.versionCode;
		} catch (NameNotFoundException e) {
			e.printStackTrace();
		}
		return versioncode;
	}

	public static String getAppPkgName(Context context) {
		String pkgName = null;
		PackageManager pm = context.getPackageManager();
		PackageInfo pi;
		try {
			pi = pm.getPackageInfo(context.getPackageName(), 0);
			pkgName = pi.packageName;
		} catch (NameNotFoundException e) {
			e.printStackTrace();
		}
		return pkgName;
	}

	public static int getScreenWidth(Context context) {
		return context.getResources().getDisplayMetrics().widthPixels;
	}

	public static float getScreenDensity(Context context) {
		return context.getResources().getDisplayMetrics().density;
	}

	public static int dipToPx(Context context, int dip) {
		return (int) (context.getResources().getDisplayMetrics().density * dip + 0.5f);
	}

	public static boolean isSDCardMounted() {
		if (android.os.Environment.getExternalStorageState().equals(
				android.os.Environment.MEDIA_MOUNTED)) {// sdCard存在
			return true;
		} else {
			return false;
		}
	}

	public static String trim(String str) {
		if (str == null || str.equals("")) {
			return str;
		} else {
			return str.replaceAll("^[　 ]+|[\r?]+|[\n?]+|[　 ]+$", "");
		}
	}

	public static String leftTrim(String str) {
		if (str == null || str.equals("")) {
			return str;
		} else {
			return str.replaceAll("^[　 ]+", "");
		}
	}

	public static String rightTrim(String str) {
		if (str == null || str.equals("")) {
			return str;
		} else {
			return str.replaceAll("[　 ]+$", "");
		}
	}

	public static String validRule(String rule) {
		if (rule == null || rule.equals("")) {
			return rule;
		} else {
			return rule.replaceAll("\\$\\d{1,}\\$", "");
		}
	}

	public static void checkViewVisibility(View view, int visibility) {
		if (view != null && view.getVisibility() != visibility) {
			view.setVisibility(visibility);
		}
	}

	public static boolean intToBool(int value) {
		return value == 1;
	}

	public static int boolToInt(boolean value) {
		return value ? 1 : 0;
	}

	public static void simpleNetBadNotify(Context context) {
		Toast(context, R.string.simple_network_bad_hint);
	}

	public static void Toast(Context context, int msgResId) {
		if (context != null) {
			String msg;
			try {
				msg = context.getString(msgResId);
			} catch (Exception e) {
				e.printStackTrace();
				return;
			}
			Toast(context, msg);
		}

	}

	public static void Toast(Context context, String msg) {
		if (context == null) {
			return;
		}
		if (context instanceof Activity) {
			ToastUtils.toast((Activity) context, msg,
					ToastUtils.STYLE.STYLE_INFO,
					ToastUtils.GRAVITY.GRAVITY_CENTER);
		} else {
			Toast.makeText(context, msg, Toast.LENGTH_SHORT).show();
		}
	}

	public static Bitmap decodeFile(String path, int maxSize) {
		File f = new File(path);
		int IMAGE_MAX_SIZE = maxSize;
		Bitmap b = null;
		FileInputStream fis = null;
		try {
			// 获取图片的旋转角度
			ExifInterface exifInterface = new ExifInterface(path);
			int tag = exifInterface.getAttributeInt(
					ExifInterface.TAG_ORIENTATION, -1);
			int orientation = 0;
			if (tag == ExifInterface.ORIENTATION_ROTATE_90) {
				orientation = 90;
			} else if (tag == ExifInterface.ORIENTATION_ROTATE_180) {
				orientation = 180;
			} else if (tag == ExifInterface.ORIENTATION_ROTATE_270) {
				orientation = 270;
			}

			Matrix m = new Matrix();// Matrix保存角度信息
			m.setRotate(orientation);

			BitmapFactory.Options options = new BitmapFactory.Options();
			options.inJustDecodeBounds = true;
			BitmapFactory.decodeFile(path, options);
			double scale = 1;
			if (options.outHeight > IMAGE_MAX_SIZE
					|| options.outWidth > IMAGE_MAX_SIZE) {
				scale = Math.pow(
						2,
						(int) Math.round(Math.log(IMAGE_MAX_SIZE
								/ (double) Math.max(options.outHeight,
										options.outWidth))
								/ Math.log(0.5)));
			}
			options.inJustDecodeBounds = false;
			options.inSampleSize = (int) scale;
			fis = new FileInputStream(f);
			b = BitmapFactory.decodeStream(fis, null, options);

			int width = b.getWidth();
			int height = b.getHeight();
			// 根据Matrix进行旋转，将图片放正
			b = Bitmap.createBitmap(b, 0, 0, width, height, m, true);
			if (fis != null) {
				fis.close();
			}
			return b;
		} catch (FileNotFoundException e) {
			// e.printStackTrace();
			return null;
		} catch (Exception e) {
			e.printStackTrace();
			return null;
		} catch (OutOfMemoryError e) {
			e.printStackTrace();
			return null;
		}

	}

	public static void bitMapToFilePath(Bitmap mBitmap, String path) {
		FileOutputStream fos = null;
		File file = null;
		try {
			file = new File(path);
			if (!file.exists()) {
				file.createNewFile();
			}
			fos = new FileOutputStream(file);
			mBitmap.compress(Bitmap.CompressFormat.JPEG, 100, fos);
			fos.flush();
			// filePath = file.getPath();

		} catch (FileNotFoundException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			if (fos != null) {
				try {
					fos.close();
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
		}
	}

	public static final char max_postfix = '+';
	public static final int max_style_1_value = 999;

	/**
	 * int转成字符串并做最大值过滤(9999+,样式)
	 * 
	 * @param value
	 * @param maxValue
	 * @param maxPostfix
	 * @return
	 */
	public static String intToStringStyle1(int value) {
		if (value < max_style_1_value) {
			return String.valueOf(value);
		} else if (value > max_style_1_value) {
			value = max_style_1_value;
		}
		StringBuilder sb = new StringBuilder();
		return sb.append(value).append(max_postfix).toString();
	}
	
	public static String getLongDateToString(long longTime){
		SimpleDateFormat sdf= new SimpleDateFormat("yyyy年MM月dd日 HH:mm");
		java.util.Date dt = new Date(longTime);  
		String sDateTime = sdf.format(dt);
		return sDateTime;
	}
	
	public static String getLongDateToShortString(long longTime){
        SimpleDateFormat sdf= new SimpleDateFormat("MM月dd日 HH:mm");
        java.util.Date dt = new Date(longTime);  
        String sDateTime = sdf.format(dt);
        return sDateTime;
    }
}
