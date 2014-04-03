package com.commov.app.dv.activity;

import java.util.ArrayList;
import java.util.List;

import org.apache.http.NameValuePair;

import android.app.AlertDialog;
import android.content.DialogInterface;
import android.content.Intent;
import android.graphics.Bitmap;
import android.net.Uri;
import android.os.Bundle;
import android.view.View;
import android.view.View.OnClickListener;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import android.widget.Button;
import android.widget.ImageButton;
import android.widget.TextView;
import android.widget.Toast;

import com.commov.app.dv.BaseActivity;
import com.commov.app.dv.R;
import com.commov.app.dv.activity.event.EventArrangementActivity;
import com.commov.app.dv.common.CommonParam;
import com.commov.app.dv.common.ServerAPI;
import com.commov.app.dv.conn.ConnectionHelper;
import com.commov.app.dv.conn.ConnectionHelper.RequestReceiver;
import com.commov.app.dv.db.roscopeco.ormdroid.Entity;
import com.commov.app.dv.model.Message;
import com.commov.app.dv.model.News;
import com.commov.app.dv.model.event.Event;
import com.commov.app.dv.utils.SharedPreferencesHelper;
import com.commov.app.dv.utils.Utils;
import com.commov.app.dv.widget.ProgressWheel;
import com.commov.app.dv.widget.TitleWebView;
import com.google.gson.Gson;
import com.tencent.mm.sdk.openapi.IWXAPI;
import com.tencent.mm.sdk.openapi.WXAPIFactory;
import com.umeng.socialize.bean.SHARE_MEDIA;
import com.umeng.socialize.bean.SocializeEntity;
import com.umeng.socialize.controller.RequestType;
import com.umeng.socialize.controller.UMServiceFactory;
import com.umeng.socialize.controller.UMSocialService;
import com.umeng.socialize.controller.UMWXHandler;
import com.umeng.socialize.controller.listener.SocializeListeners.SnsPostListener;

public class DetailActivity extends BaseActivity implements OnClickListener {
    private ImageButton favorateButton, shareButton;
    private Button arrangementButton, applyButton;
    private TitleWebView webView;
    private News news;
    private Event event;
    private Message message;
    //根据收藏的新闻判断接口读取的新闻是否已经收藏
    private List<Event> eventsFavorite;
    //根据收藏的活动断接口读取的活动那个是否已经收藏
    private List<News> newsFavorite;
    private TextView title, time;
    // for share by UMeng
    private IWXAPI api;
    private final UMSocialService mController = UMServiceFactory
            .getUMSocialService("com.umeng.share", RequestType.SOCIAL);

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_detail);
        // api = WXAPIFactory.createWXAPI(this, CommonParam.APP_ID);
        api = WXAPIFactory.createWXAPI(this, CommonParam.APP_ID, false);
        api.registerApp(CommonParam.APP_ID);
        findViewById(R.id.ib_back).setOnClickListener(this);
        progressWheel = (ProgressWheel) findViewById(R.id.pw_spinner);
        shareButton = (ImageButton) findViewById(R.id.ib_share);
        shareButton.setOnClickListener(this);
        favorateButton = (ImageButton) findViewById(R.id.ib_favorite);
        favorateButton.setOnClickListener(this);
        arrangementButton = (Button) findViewById(R.id.b_arrangement);
        arrangementButton.setOnClickListener(this);
        applyButton = (Button) findViewById(R.id.b_apply);
        applyButton.setOnClickListener(this);
        title = (TextView) findViewById(R.id.tv_title);
        time = (TextView) findViewById(R.id.tv_time);
        webView = (TitleWebView) findViewById(R.id.webView);
        webView.setWebViewClient(new WebViewClient() {

            @Override
            public void onPageStarted(WebView view, String url, Bitmap favicon) {
                super.onPageStarted(view, url, favicon);

            }

            @Override
            public void onPageFinished(WebView view, String url) {
                super.onPageFinished(view, url);
            }

            @Override
            public void onReceivedError(WebView view, int errorCode,
                    String description, String failingUrl) {
                super.onReceivedError(view, errorCode, description, failingUrl);
            }

            @Override
            public boolean shouldOverrideUrlLoading(WebView view, String url) {
                if (url.startsWith(WebView.SCHEME_TEL)) {
                    Intent intent = new Intent(Intent.ACTION_DIAL);
                    intent.setData(Uri.parse(url));
                    startActivity(intent);
                    return true;
                } else if (url.startsWith(WebView.SCHEME_MAILTO)) {
                    Intent intent = new Intent(Intent.ACTION_VIEW);
                    intent.setData(Uri.parse(url));
                    startActivity(intent);
                    return true;
                } else {
                    return super.shouldOverrideUrlLoading(view, url);
                }
            }
        });

        if (getIntent().getExtras().get("news") != null) {
            news = (News) getIntent().getExtras().get("news");
            title.setText(news.getTitle());
            time.setText(news.getTime());
            getNewsDetail();
            arrangementButton.setVisibility(View.GONE);
            newsFavorite = Entity.query(News.class).execute200OrderByIdDesc();
            for (int i = 0; i < newsFavorite.size(); i++) {
                if (newsFavorite.get(i).getUuid().equals(news.getUuid())) {
                    news.setFavorite(true);
                    news.setId(newsFavorite.get(i).getId());
                    break;
                }
            }
            if (news.isFavorite()) {
                favorateButton.setImageResource(R.drawable.favorite_selected);
            } else {
                favorateButton.setImageResource(R.drawable.favorite_unselected);
            }
        } else if (getIntent().getExtras().get("event") != null) {
            event = (Event) getIntent().getExtras().get("event");
            title.setText(event.getTitle());
            time.setText(event.getTime());
            getEventDetail();
            arrangementButton.setVisibility(View.VISIBLE);
            applyButton.setVisibility(View.VISIBLE);
            if (event.isHasApplied()) {
                applyButton.setText("已报名");
            } else {
                applyButton.setText("报名");
            }
            eventsFavorite = Entity.query(Event.class)
                    .execute200OrderByIdDesc();
            for (int i = 0; i < eventsFavorite.size(); i++) {
                if (eventsFavorite.get(i).getUuid().equals(event.getUuid())) {
                    event.setFavorite(true);
                    event.setId(eventsFavorite.get(i).getId());

                    break;
                }
            }
            if (event.isFavorite()) {
                favorateButton.setImageResource(R.drawable.favorite_selected);
            } else {
                favorateButton.setImageResource(R.drawable.favorite_unselected);
            }
        } else if (getIntent().getExtras().get("message") != null) {
            message = (Message) getIntent().getExtras().get("message");
            title.setText(Utils.getLongDateToString(message.getCreatedAt()));
            // time.setText(arrangement.getSubTitle());
            webView.loadUrl(message.getMessage());
            webView.loadDataWithBaseURL("",
                    appendWebContent(message.getMessage()), "text/html",
                    "UTF-8", "");
            arrangementButton.setVisibility(View.GONE);
            favorateButton.setVisibility(View.GONE);
            shareButton.setVisibility(View.GONE);
            this.readMessage();
        }
    }

    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.ib_back:
                finish();
                break;
            case R.id.ib_favorite:

                if (news != null) {
                    if (news.isFavorite()) {
                        favorateButton
                                .setImageResource(R.drawable.favorite_unselected);
                        Toast.makeText(this, "取消收藏成功", Toast.LENGTH_SHORT)
                                .show();
                        news.setFavorite(false);
                        news.setTransient(false);
                        news.delete();
                    } else {
                        favorateButton
                                .setImageResource(R.drawable.favorite_selected);
                        Toast.makeText(this, "收藏成功", Toast.LENGTH_SHORT).show();
                        news.setFavorite(true);
                        news.save();
                    }
                } else if (event != null) {
                    if (event.isFavorite()) {
                        favorateButton
                                .setImageResource(R.drawable.favorite_unselected);
                        Toast.makeText(this, "取消收藏成功", Toast.LENGTH_SHORT)
                                .show();
                        event.setFavorite(false);
                        event.setTransient(false);
                        event.delete();
                    } else {
                        favorateButton
                                .setImageResource(R.drawable.favorite_selected);
                        Toast.makeText(this, "收藏成功", Toast.LENGTH_SHORT).show();
                        event.setFavorite(true);
                        event.save();
                    }
                }
                break;
            case R.id.ib_share:
                share();
                /*
                 * Intent intent = new Intent(Intent.ACTION_SEND); // 启动分享发送的属性
                 * intent.setType("text/plain"); // 分享发送的数据类型 if (news != null)
                 * { intent.putExtra(Intent.EXTRA_SUBJECT, news.getTitle()); //
                 * 分享的主题 intent.putExtra(Intent.EXTRA_TEXT, news.getContent());
                 * // 分享的内容 } else { intent.putExtra(Intent.EXTRA_SUBJECT,
                 * event.getTitle()); // 分享的主题
                 * intent.putExtra(Intent.EXTRA_TEXT, event.getContent()); //
                 * 分享的内容 }
                 * 
                 * this.startActivity(Intent.createChooser(intent, "选择分享"));//
                 * 目标应用选择对话框的标题
                 */
                break;

            case R.id.b_arrangement:
                Intent intentArrangement = new Intent(DetailActivity.this,
                        EventArrangementActivity.class);
                intentArrangement.putExtra("event", event);
                DetailActivity.this.startActivity(intentArrangement);
                break;
            case R.id.b_apply:
                if (!event.isHasApplied()) {
                    AlertDialog.Builder builder = new AlertDialog.Builder(this);
                    builder.setMessage("报名该活动")
                            .setCancelable(true)
                            .setPositiveButton("确定",
                                    new DialogInterface.OnClickListener() {
                                        @Override
                                        public void onClick(
                                                DialogInterface dialog,
                                                int which) {
                                            applyEvent();
                                        }
                                    }).setNegativeButton("取消", null);
                    builder.create().show();
                } else {
                    Utils.Toast(DetailActivity.this, "请不要重复报名");
                }

                break;
        }
    }

    private void share() {

        String contentUrl = "http://www.danaaa.com";
        mController.setAppWebSite(SHARE_MEDIA.RENREN, contentUrl);
        mController.getConfig().removePlatform(SHARE_MEDIA.QZONE);
        // 设置分享平台选择面板的平台显示顺序
        mController.getConfig().setPlatformOrder(SHARE_MEDIA.WEIXIN,
                SHARE_MEDIA.WEIXIN_CIRCLE, SHARE_MEDIA.SINA, SHARE_MEDIA.QQ,
                SHARE_MEDIA.RENREN, SHARE_MEDIA.DOUBAN, SHARE_MEDIA.EMAIL,
                SHARE_MEDIA.SMS);
        mController.setShareContent("Test");
        // 添加微信平台，参数1为当前Activity, 参数2为用户申请的AppID, 参数3为点击分享内容跳转到的目标url
        UMWXHandler wxHandler = mController.getConfig().supportWXPlatform(this,
                CommonParam.APP_ID, contentUrl);

        mController.setEntityName(this.getResources().getString(
                R.string.app_name));
        // 设置分享标题
        wxHandler.setWXTitle(this.getResources().getString(R.string.app_name));
        // 支持微信朋友圈
        UMWXHandler circleHandler = mController.getConfig()
                .supportWXCirclePlatform(this, CommonParam.APP_ID, contentUrl);
        circleHandler.setCircleTitle(this.getResources().getString(
                R.string.app_name));
        mController.getConfig().registerListener(new SnsPostListener() {

            @Override
            public void onStart() {

            }

            @Override
            public void onComplete(SHARE_MEDIA platform, int eCode,
                    SocializeEntity entity) {

            }
        });
        mController.openShare(this, false);
    }

    private void getNewsDetail() {
        progressWheel.spin();
        String url = ServerAPI.newsDetail(this, news.getUuid());
        ConnectionHelper conn = ConnectionHelper.obtainInstance();
        conn.httpGet(url, 0, requestReceiver);
    }

    private void getEventDetail() {
        progressWheel.spin();
        String url = ServerAPI.eventDetail(this, event.getUuid(),
                sph.getValue(SharedPreferencesHelper.USERID));
        ConnectionHelper conn = ConnectionHelper.obtainInstance();
        conn.httpGet(url, 1, requestReceiver);
    }

    private void applyEvent() {
        progressWheel.spin();
        String url = ServerAPI.prefix + "event/" + event.getUuid() + "/"
                + sph.getValue(SharedPreferencesHelper.USERID) + "/apply";
        ConnectionHelper conn = ConnectionHelper.obtainInstance();
        conn.httpPost(url, 2, new ArrayList<NameValuePair>(), requestReceiver);
    }

    private void readMessage() {
        String url = ServerAPI.prefix + "message/read/" + message.getUuid();
        ConnectionHelper conn = ConnectionHelper.obtainInstance();
        conn.httpGet(url, 3, requestReceiver);
    }

    private RequestReceiver requestReceiver = new RequestReceiver() {

        @Override
        public void onResult(int resultCode, int requestId, String rawResponses) {
            progressWheel.stopSpinning();
            if (requestId == 0 && resultCode == RESULT_STATE_OK) {
                if (rawResponses != null && rawResponses.length() > 0) {
                    News newNews = new Gson()
                            .fromJson(rawResponses, News.class);
                    title.setText(newNews.getTitle());
                    time.setText(news.getTime());
                    webView.loadDataWithBaseURL("",
                            appendWebContent(newNews.getContent()),
                            "text/html", "UTF-8", "");
                    return;
                }
            }
            if (requestId == 1 && resultCode == RESULT_STATE_OK) {
                if (rawResponses != null && rawResponses.length() > 0) {
                    Event newEvent = new Gson().fromJson(rawResponses,
                            Event.class);
                    title.setText(newEvent.getTitle());
                    time.setText(event.getTime());
                    if (event.isHasApplied()) {
                        applyButton.setText("已报名");
                    } else {
                        applyButton.setText("报名");
                    }
                    webView.loadDataWithBaseURL("",
                            appendWebContent(newEvent.getContent()),
                            "text/html", "UTF-8", "");
                    return;
                }
            }
            if (requestId == 2 && resultCode == RESULT_STATE_OK) {
                if (rawResponses != null && rawResponses.length() > 0) {
                    Utils.Toast(DetailActivity.this, "报名成功！");
                    applyButton.setText("已报名");
                    event.setHasApplied(true);
                    return;
                }
            }
            if (requestId == 3 && resultCode == RESULT_STATE_OK) {
                if (rawResponses != null && rawResponses.length() > 0) {
                    return;
                }
            }
            Utils.simpleNetBadNotify(DetailActivity.this);
        }
    };

    private String appendWebContent(String content) {
        if (content == null) {
            return "";
        }
        content = content + "<Br><Br><Br><Br><Br><Br><Br><Br><Br>";
        return content;
    }
}
