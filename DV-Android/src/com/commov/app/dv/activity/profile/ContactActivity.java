package com.commov.app.dv.activity.profile;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.http.NameValuePair;

import android.app.Activity;
import android.app.AlertDialog;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.net.Uri;
import android.os.Bundle;
import android.os.Environment;
import android.provider.MediaStore;
import android.util.DisplayMetrics;
import android.util.Log;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.FrameLayout;
import android.widget.LinearLayout;
import android.widget.TextView;
import android.widget.Toast;

import com.androidquery.AQuery;
import com.androidquery.util.Constants;
import com.commov.app.dv.BaseActivity;
import com.commov.app.dv.R;
import com.commov.app.dv.adapter.WorkAdapter;
import com.commov.app.dv.common.ServerAPI;
import com.commov.app.dv.conn.ConnectionHelper;
import com.commov.app.dv.conn.ConnectionHelper.RequestReceiver;
import com.commov.app.dv.model.Contact;
import com.commov.app.dv.model.Work;
import com.commov.app.dv.utils.SharedPreferencesHelper;
import com.commov.app.dv.utils.Utils;
import com.commov.app.dv.widget.ProgressWheel;
import com.commov.app.dv.widget.RoundedImageView;
import com.commov.app.dv.widget.uitableview.Item;
import com.commov.app.dv.widget.uitableview.UITableView;
import com.commov.app.dv.widget.uitableview.UITableView.ClickListener;
import com.google.gson.Gson;
import com.google.gson.JsonArray;
import com.google.gson.JsonParser;
import com.handmark.pulltorefresh.library.PullToRefreshBase.Mode;
import com.handmark.pulltorefresh.library.PullToRefreshBase.OnRefreshListener2;
import com.handmark.pulltorefresh.library.PullToRefreshListView;

public class ContactActivity extends BaseActivity implements OnClickListener,
        OnRefreshListener2 {

    private TextView textViewName, textViewDesc;
    private Button editButton, baseButton, contactButton, worksButton,
            followingButton, privateMessageButton;
    private RoundedImageView avatar;
    private UITableView table1, table2, table3;
    private TextView title1, title2, title3, avatarHint;

    private int index;
    private Contact contact;
    private final int CAPTURE_IMAGE = 1;
    private final int SELECT_IMAGE = 2;
    private final int PHOTORESOULT = 5;
    private final int EDITCONTACT = 6;

    private boolean isEdit = false;
    // for works
    private PullToRefreshListView mPullRefreshListview;
    private WorkAdapter mAdapter;
    private List<Work> mData = new ArrayList<Work>();
    private int pageNumber = 1;
    private TextView emptyTV;
    private LinearLayout profileLinearLayout;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_contact);
        sph = new SharedPreferencesHelper(this);
        progressWheel = (ProgressWheel) findViewById(R.id.pw_spinner);
        findViewById(R.id.ib_back).setOnClickListener(this);
        textViewName = (TextView) this.findViewById(R.id.tv_name);
        textViewDesc = (TextView) this.findViewById(R.id.tv_desc);
        editButton = (Button) this.findViewById(R.id.b_edit);
        baseButton = (Button) this.findViewById(R.id.buttonIndex1);
        contactButton = (Button) this.findViewById(R.id.buttonIndex2);
        worksButton = (Button) this.findViewById(R.id.buttonIndex3);
        followingButton = (Button) this.findViewById(R.id.b_following);
        privateMessageButton = (Button) this
                .findViewById(R.id.b_privateMessage);

        editButton.setOnClickListener(this);
        baseButton.setOnClickListener(this);
        contactButton.setOnClickListener(this);
        worksButton.setOnClickListener(this);
        followingButton.setOnClickListener(this);
        privateMessageButton.setOnClickListener(this);
        if (getIntent().getExtras() != null
                && getIntent().getExtras().get("contact") != null) {
            contact = (Contact) getIntent().getExtras().get("contact");
            editButton.setVisibility(View.GONE);
            String userId = sph.getValue(SharedPreferencesHelper.USERID);
            if (userId != null && userId.equals(contact.getUuid())) {
                followingButton.setVisibility(View.GONE);
                privateMessageButton.setVisibility(View.GONE);
            } else {
                followingButton.setVisibility(View.VISIBLE);
                privateMessageButton.setVisibility(View.VISIBLE);
            }
        } else {// 个人空间
            contact = new Contact();
            contact.setUuid(sph.getValue(SharedPreferencesHelper.USERID));
            editButton.setVisibility(View.VISIBLE);
            followingButton.setVisibility(View.GONE);
            privateMessageButton.setVisibility(View.GONE);
            worksButton.setVisibility(View.GONE);
        }
        textViewName.setText(contact.getRealname());
        textViewDesc.setText(contact.getDescription());

        avatar = (RoundedImageView) this.findViewById(R.id.iv_avatar);
        avatarHint = (TextView) this.findViewById(R.id.tv_avatar_hint);
        avatar.setOnClickListener(this);
        int width = Utils.getScreenWidth(this);
        FrameLayout.LayoutParams params = new FrameLayout.LayoutParams(
                width / 4, width / 4);
        params.setMargins(10, 10, 10, 10);
        avatar.setLayoutParams(params);
        avatar.setCornerRadius(width / 8);
        if (contact.getAvatar() != null && contact.getAvatar().length() > 0) {
            new AQuery(this).id(R.id.iv_avatar).image(contact.getAvatar(),
                    true, true, 0, Constants.INVISIBLE);
        }
        // detail section
        table1 = (UITableView) this.findViewById(R.id.tableView1);
        table2 = (UITableView) this.findViewById(R.id.tableView2);
        table3 = (UITableView) this.findViewById(R.id.tableView3);
        title1 = (TextView) this.findViewById(R.id.tv_title1);
        title2 = (TextView) this.findViewById(R.id.tv_title2);
        title3 = (TextView) this.findViewById(R.id.tv_title3);

        // for works
        profileLinearLayout = (LinearLayout) this.findViewById(R.id.ll_profile);
        sph = new SharedPreferencesHelper(this);
        emptyTV = (TextView) findViewById(R.id.tv_empty);
        mPullRefreshListview = (PullToRefreshListView) this
                .findViewById(R.id.pull_refresh_listview);
        mPullRefreshListview.setMode(Mode.BOTH);
        mPullRefreshListview.setOnRefreshListener(this);
        mAdapter = new WorkAdapter(this);
        mPullRefreshListview.getRefreshableView().setAdapter(mAdapter);
        // initial base information
        index = 1;
        initUI();
        getContact();
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);

        if (requestCode == EDITCONTACT) {
            if (data!=null&&data.getExtras()!=null&&data.getExtras().get("contact")!=null) {
                contact = (Contact) data.getExtras().get("contact");
                initUI();
                return;
            }
        }
        Uri uriImage;
        if ((requestCode == CAPTURE_IMAGE) && resultCode == Activity.RESULT_OK) {
            File imageDir = new File(Environment.getExternalStorageDirectory()
                    + "/.hseq");
            File imageFile = new File(imageDir.getPath(), "Pic.jpg");
            startPhotoZoom(Uri.fromFile(imageFile));
            return;
        }

        if (data == null)
            return;
        if ((requestCode == SELECT_IMAGE) && resultCode == Activity.RESULT_OK) {
            uriImage = data.getData();
            startPhotoZoom(uriImage);
            return;
        }

        if (requestCode == PHOTORESOULT) {
            try {
                File imageDir = new File(
                        Environment.getExternalStorageDirectory() + "/.hseq");
                File cutTempFile = new File(imageDir.getPath(), "Temp.jpg");
                FileInputStream is = new FileInputStream(cutTempFile);
                Bitmap bitmap = BitmapFactory.decodeStream(is);
                avatar.setImageBitmap(bitmap);
                this.uploadAvatar(cutTempFile);
            } catch (Exception e) {
                Log.d("", e.getMessage());
            }
        }
    }

    private void startPhotoZoom(Uri uri) {
        Intent intent = new Intent("com.android.camera.action.CROP");
        intent.setDataAndType(uri, "image/*");
        File imageDir = new File(Environment.getExternalStorageDirectory()
                + "/.hseq");
        File imageFile = new File(imageDir.getPath(), "Temp.jpg");
        intent.putExtra("output", Uri.fromFile(imageFile));
        intent.putExtra("crop", "true");
        // aspectX aspectY rotation
        intent.putExtra("aspectX", 1);
        intent.putExtra("aspectY", 1);
        // outputX outputY height and width
        final DisplayMetrics dm = this.getResources().getDisplayMetrics();
        int width = dm.widthPixels - 20;
        intent.putExtra("outputX", width);
        intent.putExtra("outputY", width);
        // intent.putExtra("return-data", true);
        intent.putExtra("scale", true);

        startActivityForResult(intent, PHOTORESOULT);
    }

    private void initUI() {
        textViewName.setText(contact.getRealname());
        textViewDesc.setText(contact.getDescription());
        if (contact.getAvatar() != null && contact.getAvatar().length() > 0) {
            new AQuery(this).id(R.id.iv_avatar).image(contact.getAvatar(),
                    true, true, 0, Constants.INVISIBLE);
        }
        if (contact.isHasFollowed()) {
            followingButton.setText("取消关注");
        } else {
            followingButton.setText("关注");
        }
        emptyTV.setVisibility(View.GONE);
        if (index < 3) {
            profileLinearLayout.setVisibility(View.VISIBLE);
            mPullRefreshListview.setVisibility(View.GONE);
            table1.setVisibility(View.VISIBLE);
            table2.setVisibility(View.VISIBLE);
            table3.setVisibility(View.VISIBLE);
            title1.setVisibility(View.VISIBLE);
            title2.setVisibility(View.VISIBLE);
            title3.setVisibility(View.VISIBLE);
            table1.setShowEdit(isEdit);
            table2.setShowEdit(isEdit);
            table3.setShowEdit(isEdit);
            table1.clear();
            table2.clear();
            table3.clear();
        } else {
            profileLinearLayout.setVisibility(View.GONE);
            mPullRefreshListview.setVisibility(View.VISIBLE);
        }
        if (index == 1) {
            title1.setText("基本信息");
            title2.setText("标签");
            title3.setText("一句话简介");
            Item i0 = new Item("姓名");
            i0.setSummary(contact.getRealname());
            table1.addItem(i0);
            Item i1 = new Item("性别");
            i1.setSummary(contact.getGender());
            table1.addItem(i1);
            // Item i2 = new Item("生日");
            // i2.setSummary(contact.getBirthDay());
            // table1.addItem(i2);
            Item i3 = new Item("地区");
            i3.setSummary(contact.getCity());
            table1.addItem(i3);
            Item i4 = new Item("职位");
            i4.setSummary(contact.getTitle());
            table1.addItem(i4);
            Item i5 = new Item("分类");
            i5.setSummary(contact.getCategory());
            table1.addItem(i5);
            StringBuffer sb = new StringBuffer();
            if (contact.getTags() != null) {
                contact.setTagList(Arrays.asList(contact.getTags().split(",")));
                for (int i = 0; i < contact.getTagList().size(); i++) {
                    sb.append(contact.getTagList().get(i).toString());
                    sb.append("   ");
                }
            }
            Item i21 = new Item(null);
            i21.setSummary(sb.toString());
            table2.addItem(i21);
            Item i31 = new Item(null);
            i31.setSummary(contact.getDescription());
            table3.addItem(i31);
            table1.setClickListener(new CustomClickListener11());
            table2.setClickListener(new CustomClickListener12());
            table3.setClickListener(new CustomClickListener13());
            table1.commit();
            table2.commit();
            table3.commit();
        } else if (index == 2) {
            title1.setText("QQ");
            title2.setText("电话");
            title3.setText("微信");
            Item i0 = new Item(contact.getQq());
            table1.addItem(i0);
            if (contact.getPhone() != null) {
                contact.setTelList(Arrays.asList(contact.getPhone().split(",")));
            }
            for (int i = 0; i < contact.getTelList().size(); i++) {
                String tel = contact.getTelList().get(i);
                Item iTel = new Item(tel, true);
                table2.addItem(iTel);
            }
            Item i31 = new Item(contact.getWeixin());
            table3.addItem(i31);
            table1.setClickListener(new CustomClickListener21());
            table2.setClickListener(new CustomClickListener22());
            table3.setClickListener(new CustomClickListener23());
            table1.commit();
            table2.commit();
            table3.commit();
        } else if (index == 3) {
            onPullDownToRefresh();
        }
    }

    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.ib_back:
                finish();
                break;
            case R.id.b_edit:
                isEdit = !isEdit;
                if (isEdit) {
                    editButton.setText("完成");
                    avatarHint.setVisibility(View.VISIBLE);
                } else {
                    editButton.setText("编辑");
                    avatarHint.setVisibility(View.GONE);
                }
                this.initUI();
                break;
            case R.id.iv_avatar:
                if (isEdit) {
                    this.selectedAvatar();
                }
                break;
            case R.id.buttonIndex1:
                index = 1;
                baseButton.setBackgroundResource(R.drawable.segment_selected);
                contactButton.setBackgroundResource(R.drawable.segment_normal);
                worksButton.setBackgroundResource(R.drawable.segment_normal);
                this.initUI();
                break;
            case R.id.buttonIndex2:
                index = 2;
                baseButton.setBackgroundResource(R.drawable.segment_normal);
                contactButton
                        .setBackgroundResource(R.drawable.segment_selected);
                worksButton.setBackgroundResource(R.drawable.segment_normal);
                this.initUI();
                break;
            case R.id.buttonIndex3:
                index = 3;
                baseButton.setBackgroundResource(R.drawable.segment_normal);
                contactButton.setBackgroundResource(R.drawable.segment_normal);
                worksButton.setBackgroundResource(R.drawable.segment_selected);
                this.initUI();
                break;
            case R.id.b_privateMessage:

                break;
            case R.id.b_following:
                if (contact.isHasFollowed()) {// 取消关注
                    removeFollowing();
                } else {// 关注
                    addFollowing();
                }
                break;
        }
    }

    private void getContact() {

        String url = ServerAPI.prefix + "member/" + contact.getUuid() + "/"
                + sph.getValue(SharedPreferencesHelper.USERID);

        ConnectionHelper conn = ConnectionHelper.obtainInstance();
        conn.httpGet(url, 0, requestReceiver);
    }

    private void addFollowing() {
        showLoadingDialog();

        String url = ServerAPI.prefix + "member/addfollow/"
                + sph.getValue(SharedPreferencesHelper.USERID) + "/"
                + contact.getUuid();

        ConnectionHelper conn = ConnectionHelper.obtainInstance();
        conn.httpGet(url, 1, requestReceiver);
    }

    private void removeFollowing() {
        showLoadingDialog();
        String url = ServerAPI.prefix + "member/removefollow/"
                + sph.getValue(SharedPreferencesHelper.USERID) + "/"
                + contact.getUuid();

        ConnectionHelper conn = ConnectionHelper.obtainInstance();
        conn.httpGet(url, 2, requestReceiver);
    }

    private void getWorkList() {
        emptyTV.setVisibility(View.GONE);
        String url = ServerAPI.prefix + "portfolio/list/" + contact.getUuid();
        ConnectionHelper conn = ConnectionHelper.obtainInstance();
        conn.httpGet(url, 3, requestReceiver);
    }

    private void uploadAvatar(File file) {
        showLoadingDialog("上传头像");
        String url = ServerAPI.prefix + "member/"
                + sph.getValue(SharedPreferencesHelper.USERID)
                + "/updateAvatar";

        ConnectionHelper conn = ConnectionHelper.obtainInstance();
        Map<String, File> files = new HashMap<String, File>();
        files.put("qqfile", file);

        conn.httpPost(url, 4, new ArrayList<NameValuePair>(), files,
                requestReceiver);
    }

    private RequestReceiver requestReceiver = new RequestReceiver() {

        @Override
        public void onResult(int resultCode, int requestId, String rawResponses) {
            dismissLoadingDialog();
            mPullRefreshListview.onRefreshComplete();
            if (requestId == 0 && resultCode == RESULT_STATE_OK) {
                if (rawResponses != null && rawResponses.length() > 0) {
                    contact = new Gson().fromJson(rawResponses, Contact.class);
                    if (contact.getGender().equals("man")) {
                        contact.setGender("男");
                    } else if (contact.getGender().equals("woman")) {
                        contact.setGender("女");
                    }
                    initUI();
                    return;
                }
            }
            if (requestId == 1 && resultCode == RESULT_STATE_OK) {
                if (rawResponses != null && rawResponses.length() > 0) {
                    followingButton.setText("取消关注");
                    contact.setHasFollowed(true);
                    Utils.Toast(ContactActivity.this, "关注成功");
                    return;
                }
            }
            if (requestId == 2 && resultCode == RESULT_STATE_OK) {
                if (rawResponses != null && rawResponses.length() > 0) {
                    followingButton.setText("关注");
                    contact.setHasFollowed(false);
                    Utils.Toast(ContactActivity.this, "取消关注成功");
                    return;
                }
            }
            if (requestId == 3 && resultCode == RESULT_STATE_OK) {
                if (rawResponses != null && rawResponses.length() > 0) {
                    JsonParser parser = new JsonParser();
                    JsonArray jsonArray = parser.parse(rawResponses)
                            .getAsJsonArray();
                    for (int i = 0; i < jsonArray.size(); i++) {
                        Work work = new Gson().fromJson(jsonArray.get(i),
                                Work.class);

                        mData.add(work);
                    }
                    if (mData == null || mData.size() == 0) {
                        emptyTV.setVisibility(View.VISIBLE);
                    } else {
                        emptyTV.setVisibility(View.GONE);
                    }
                    mAdapter.setData(mData, true);
                    return;
                }
            }
            if (requestId == 4 && resultCode == RESULT_STATE_OK) {
                if (rawResponses != null && rawResponses.length() > 0) {
                    Utils.Toast(ContactActivity.this, "头像上传成功");
                    return;
                }
            }

            Utils.simpleNetBadNotify(ContactActivity.this);
        }
    };

    private class CustomClickListener11 implements ClickListener {

        @Override
        public void onClick(int index) {
            if (!isEdit) {
                return;
            }
            if (index == 0) {
                Utils.Toast(ContactActivity.this, "姓名不能修改");
            } else if (index == 1) {
                Utils.Toast(ContactActivity.this, "性别不能修改");
            }

            // else if (index == 2) {
            //
            // Intent intent = new Intent(ContactActivity.this,
            // ProfileEditTextViewActivity.class);
            // intent.putExtra("title", "生日");
            // intent.putExtra("value", contact.getBirthDay());
            // startActivityForResult(intent, 113);
            // }

            else if (index == 2) {
                Intent intent = new Intent(ContactActivity.this,
                        ProfileEditLocationActivity.class);
                intent.putExtra("title", "地区");
                intent.putExtra("value", contact.getCity());
                intent.putExtra("type", ProfileEditActivity.LOCATION);
                intent.putExtra("contact", contact);
                startActivityForResult(intent, EDITCONTACT);
            } else if (index == 3) {
                Intent intent = new Intent(ContactActivity.this,
                        ProfileEditActivity.class);
                intent.putExtra("title", "职位");
                intent.putExtra("value", contact.getTitle());
                intent.putExtra("type", ProfileEditActivity.CAREER);
                intent.putExtra("contact", contact);
                startActivityForResult(intent, EDITCONTACT);
            } else if (index == 4) {
                Intent intent = new Intent(ContactActivity.this,
                        ProfileEditActivity.class);
                intent.putExtra("title", "分类");
                intent.putExtra("contact", contact);
                intent.putExtra("type", ProfileEditActivity.CATEGORY);
                intent.putExtra("value", contact.getCategory());
                startActivityForResult(intent, EDITCONTACT);
            }
        }
    }

    private class CustomClickListener12 implements ClickListener {

        @Override
        public void onClick(int index) {

            if (isEdit) {
                Intent intent = new Intent(ContactActivity.this,
                        ProfileEditActivity.class);
                intent.putExtra("title", "标签");
                intent.putExtra("contact", contact);
                intent.putExtra("value", contact.getTags());
                intent.putExtra("lines", 4);
                intent.putExtra("type", ProfileEditActivity.TAG);
                startActivityForResult(intent, EDITCONTACT);
            }
        }
    }

    private class CustomClickListener13 implements ClickListener {

        @Override
        public void onClick(int index) {

            if (isEdit) {
                Intent intent = new Intent(ContactActivity.this,
                        ProfileEditActivity.class);
                intent.putExtra("title", "一句话简介");
                intent.putExtra("value", contact.getDescription());
                intent.putExtra("contact", contact);
                intent.putExtra("lines", 4);
                intent.putExtra("type", ProfileEditActivity.DESC);
                startActivityForResult(intent, EDITCONTACT);
            }
        }
    }

    private class CustomClickListener21 implements ClickListener {

        @Override
        public void onClick(int index) {
            Intent intent = new Intent(ContactActivity.this,
                    ProfileEditActivity.class);
            intent.putExtra("title", "QQ");
            intent.putExtra("value", contact.getQq());
            intent.putExtra("type", ProfileEditActivity.QQ);
            intent.putExtra("contact", contact);
            startActivityForResult(intent, EDITCONTACT);
        }
    }

    private class CustomClickListener22 implements ClickListener {

        @Override
        public void onClick(int index) {

            if (!isEdit) {
                Intent intent = new Intent(Intent.ACTION_DIAL, Uri.parse("tel:"
                        + contact.getTelList().get(index)));
                ContactActivity.this.startActivity(intent);
            } else {
                Intent intent = new Intent(ContactActivity.this,
                        ProfileEditActivity.class);
                intent.putExtra("title", "电话");
                intent.putExtra("value", contact.getPhone());
                intent.putExtra("type", ProfileEditActivity.TELPHONE);
                intent.putExtra("contact", contact);
                startActivityForResult(intent, EDITCONTACT);
            }
        }
    }

    private class CustomClickListener23 implements ClickListener {

        @Override
        public void onClick(int index) {
            Intent intent = new Intent(ContactActivity.this,
                    ProfileEditActivity.class);
            intent.putExtra("title", "微信");
            intent.putExtra("value", contact.getWeixin());
            intent.putExtra("type", ProfileEditActivity.WEIXIN);
            intent.putExtra("contact", contact);
            startActivityForResult(intent, EDITCONTACT);
        }
    }

    private void selectedAvatar() {
        AlertDialog.Builder builder = new AlertDialog.Builder(this);
        builder.setTitle("上传头像");
        builder.setNegativeButton("相册选照片",
                new DialogInterface.OnClickListener() {
                    @Override
                    public void onClick(final DialogInterface dlg,
                            final int sumthin) {
                        Intent intent = new Intent();
                        intent.setType("image/*");
                        intent.setAction(Intent.ACTION_GET_CONTENT);
                        startActivityForResult(
                                Intent.createChooser(intent, "Select Picture"),
                                SELECT_IMAGE);
                    }
                });
        builder.setPositiveButton("立即拍照片",
                new DialogInterface.OnClickListener() {
                    @Override
                    public void onClick(final DialogInterface dlg,
                            final int sumthin) {
                        PackageManager pm = getPackageManager();
                        if (pm.hasSystemFeature(PackageManager.FEATURE_CAMERA)) {
                            Intent intent = new Intent(
                                    "android.media.action.IMAGE_CAPTURE");

                            File imageDir = new File(Environment
                                    .getExternalStorageDirectory() + "/.hseq");
                            File imageFile = new File(imageDir.getPath(),
                                    "Pic.jpg");
                            if (!imageDir.exists()) {
                                imageDir.mkdirs();
                            }
                            if (!imageFile.exists()) {
                                try {
                                    imageFile.createNewFile();
                                } catch (IOException e) {
                                    Log.d("", e.getMessage());
                                }
                            }
                            intent.putExtra(MediaStore.EXTRA_OUTPUT,
                                    Uri.fromFile(imageFile));
                            startActivityForResult(intent, CAPTURE_IMAGE);
                        } else {
                            Toast.makeText(getBaseContext(),
                                    "Camera is not available",
                                    Toast.LENGTH_LONG).show();
                        }
                    }
                });

        builder.show();
    }

    @Override
    public void onPullDownToRefresh() {
        pageNumber = 1;
        mData = new ArrayList<Work>();
        mPullRefreshListview.setRefreshing();
        getWorkList();

    }

    @Override
    public void onPullUpToRefresh() {
        if (mData.size() == pageNumber * 10) {
            pageNumber++;
            mPullRefreshListview.setRefreshing();
            getWorkList();
        } else {
            Utils.Toast(this, "已经全部加载");
            mPullRefreshListview.onRefreshComplete();
        }
    }
}