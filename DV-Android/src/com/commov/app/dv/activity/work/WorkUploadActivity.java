package com.commov.app.dv.activity.work;

import java.io.File;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.http.NameValuePair;
import org.apache.http.message.BasicNameValuePair;

import android.app.Activity;
import android.content.Intent;
import android.content.res.Configuration;
import android.net.Uri;
import android.os.Bundle;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.Button;
import android.widget.EditText;
import android.widget.GridView;

import com.araneaapps.android.libs.logger.ALog;
import com.chute.android.photopickerplus.models.enums.MediaType;
import com.chute.android.photopickerplus.util.intent.PhotoPickerPlusIntentWrapper;
import com.chute.sdk.v2.model.AssetModel;
import com.commov.app.dv.BaseActivity;
import com.commov.app.dv.R;
import com.commov.app.dv.adapter.WorkGridAdapter;
import com.commov.app.dv.common.ServerAPI;
import com.commov.app.dv.conn.ConnectionHelper;
import com.commov.app.dv.conn.ConnectionHelper.RequestReceiver;
import com.commov.app.dv.utils.SharedPreferencesHelper;
import com.commov.app.dv.utils.Utils;
import com.commov.app.dv.widget.ProgressWheel;

public class WorkUploadActivity extends BaseActivity implements OnClickListener {

    public static final String KEY_SELECTED_ITEMS = "keySelectedItems";
    public static final String KEY_VIDEO_PATH = "keyVideoPath";
    private GridView grid;
    private WorkGridAdapter adapter;
    private ArrayList<AssetModel> accountMediaList;
    private EditText descET;

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_work_upload);
        findViewById(R.id.ib_back).setOnClickListener(this);
        Button startButton = (Button) findViewById(R.id.gcButtonPhotoPicker);
        startButton.setOnClickListener(new OnPhotoPickerClickListener());
        progressWheel = (ProgressWheel) findViewById(R.id.pw_spinner);
        grid = (GridView) findViewById(R.id.gcGrid);
        if (savedInstanceState != null) {
            accountMediaList = savedInstanceState
                    .getParcelableArrayList(KEY_SELECTED_ITEMS);
            adapter = new WorkGridAdapter(WorkUploadActivity.this,
                    accountMediaList);
        } else {
            adapter = new WorkGridAdapter(WorkUploadActivity.this,
                    new ArrayList<AssetModel>());
        }
        grid.setAdapter(adapter);
        grid.setOnItemClickListener(new MediaItemClickListener());

        int orientation = getResources().getConfiguration().orientation;
        if (orientation == Configuration.ORIENTATION_LANDSCAPE) {
            grid.setNumColumns(4);
        }
        findViewById(R.id.b_upload_work).setOnClickListener(this);
        descET = (EditText) findViewById(R.id.et_desc);
    }

    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.ib_back:
                finish();
                break;
            case R.id.b_upload_work:
                hideKeyboard();
                if (descET.getText().toString().trim().length() == 0) {
                    Utils.Toast(WorkUploadActivity.this, "请先输入您作品的描述");
                    return;
                }
                if (accountMediaList == null || accountMediaList.size() == 0) {
                    Utils.Toast(WorkUploadActivity.this,
                            "请点击上面的‘去相册选作品’\n按钮添加您的图片作品");
                    return;
                }
                uploadWork();
        }
    }

    private void uploadWork() {
        showLoadingDialog("提交作品中...");
        String url = ServerAPI.prefix + "portfolio/upload/"
                + sph.getValue(SharedPreferencesHelper.USERID);
        
        ConnectionHelper conn = ConnectionHelper.obtainInstance();
        List<NameValuePair> nvp = new ArrayList<NameValuePair>();
        nvp.add(new BasicNameValuePair("description", descET.getText().toString().trim()));
        nvp.add(new BasicNameValuePair("title",""));
        Map<String, File> files = new HashMap<String, File>();
        for (int i = 0; i < accountMediaList.size(); i++)
        {
            AssetModel assetModel = accountMediaList.get(i);
            files.put("qqfile"+(i+1), new File(assetModel.getUrl()));
        }
        conn.httpPost(url, 0,nvp,files, requestReceiver);
    }

    private RequestReceiver requestReceiver = new RequestReceiver() {

        @Override
        public void onResult(int resultCode, int requestId, String rawResponses) {
            dismissLoadingDialog();
            if (resultCode == RESULT_STATE_OK) {
                if (rawResponses != null && rawResponses.length() > 0) {
                    Utils.Toast(WorkUploadActivity.this, "作品提交成功");
                    finish();
                    return;
                }
            }
            Utils.simpleNetBadNotify(WorkUploadActivity.this);
        }
    };

    private class OnPhotoPickerClickListener implements OnClickListener {

        @Override
        public void onClick(View v) {
            hideKeyboard();
            PhotoPickerPlusIntentWrapper wrapper = new PhotoPickerPlusIntentWrapper(
                    WorkUploadActivity.this);
            wrapper.startActivityForResult(WorkUploadActivity.this);
        }
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (resultCode != Activity.RESULT_OK) {
            return;
        }
        final PhotoPickerPlusIntentWrapper wrapper = new PhotoPickerPlusIntentWrapper(
                data);
        accountMediaList = wrapper.getMediaCollection();
        adapter.changeData(accountMediaList);
        ALog.d(wrapper.getMediaCollection().toString());

    }

    @Override
    protected void onSaveInstanceState(Bundle outState) {
        outState.putParcelableArrayList(KEY_SELECTED_ITEMS, accountMediaList);
        super.onSaveInstanceState(outState);
    }

    private final class MediaItemClickListener implements OnItemClickListener {

        @Override
        public void onItemClick(AdapterView<?> parent, View view, int position,
                long id) {
            AssetModel asset = adapter.getItem(position);
            String type = asset.getType();
            if (type.equals(MediaType.VIDEO.name().toLowerCase())) {
                if (asset.getVideoUrl().contains("http")) {
                    Intent intent = new Intent(Intent.ACTION_VIEW);
                    intent.setData(Uri.parse(asset.getVideoUrl()));
                    startActivity(intent);
                }
            }
        }

    }
}
