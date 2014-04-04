package com.commov.app.dv.activity.more;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import net.sourceforge.pinyin4j.PinyinHelper;
import net.sourceforge.pinyin4j.format.HanyuPinyinOutputFormat;
import net.sourceforge.pinyin4j.format.exception.BadHanyuPinyinOutputFormatCombination;
import android.content.Context;
import android.graphics.PixelFormat;
import android.os.Bundle;
import android.os.Handler;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup.LayoutParams;
import android.view.WindowManager;
import android.widget.AbsListView;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.ListAdapter;
import android.widget.ListView;
import android.widget.TextView;

import com.commov.app.dv.BaseActivity;
import com.commov.app.dv.R;
import com.commov.app.dv.adapter.ContactListAdapter;
import com.commov.app.dv.common.ServerAPI;
import com.commov.app.dv.conn.ConnectionHelper;
import com.commov.app.dv.conn.ConnectionHelper.RequestReceiver;
import com.commov.app.dv.model.Contact;
import com.commov.app.dv.utils.SharedPreferencesHelper;
import com.commov.app.dv.utils.Utils;
import com.commov.app.dv.widget.ProgressWheel;
import com.commov.app.dv.widget.RightCharacterListView;
import com.commov.app.dv.widget.RightCharacterListView.OnTouchingLetterChangedListener;
import com.google.gson.Gson;
import com.google.gson.JsonArray;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import com.handmark.pulltorefresh.library.PullToRefreshBase.Mode;
import com.handmark.pulltorefresh.library.PullToRefreshBase.OnRefreshListener;
import com.handmark.pulltorefresh.library.PullToRefreshListView;

public class FollowActivity extends BaseActivity implements OnRefreshListener,
        ListView.OnScrollListener, OnItemClickListener,
        android.view.View.OnClickListener {
    private PullToRefreshListView mPullRefreshListview;
    private List<Contact> allData;// cache all the contacts with both categories
    private List<Contact> mData;// the contacts by all, digital, science
    private RightCharacterListView letterListView;
    private Handler handler;
    private DisapearThread disapearThread;
    private int scrollState;
    private ListAdapter listAdapter;
    private TextView txtOverlay;
    private WindowManager windowManager;
    private String[] stringArr = new String[0];
    private String[] stringArr3 = new String[0];
    private ArrayList<String> arrayList = new ArrayList<String>();
    private ArrayList<String> arrayList2 = new ArrayList<String>();
    private ArrayList<String> arrayList3 = new ArrayList<String>();

    private Map<String, String> map = new HashMap<String, String>();
    private Map<String, ArrayList<Contact>> mapContact = new HashMap<String, ArrayList<Contact>>();

    private TextView emptyTV, titleTV;
    private int type;
    public static final int TYPE_FOLLOWING = 1;
    public static final int TYPE_FOLLOWED = 2;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_follow);
        progressWheel = (ProgressWheel) findViewById(R.id.pw_spinner);
        emptyTV = (TextView) findViewById(R.id.tv_empty);
        titleTV = (TextView) findViewById(R.id.tv_title);
        findViewById(R.id.ib_back).setOnClickListener(this);
        if (getIntent().getExtras().get("type") != null) {
            type = (Integer) getIntent().getExtras().get("type");
            if (type == TYPE_FOLLOWING) {
                titleTV.setText("我关注的好友");
            } else {
                titleTV.setText("关注我的好友");
            }
        }
        letterListView = (RightCharacterListView) findViewById(R.id.rightCharacterListView);
        letterListView
                .setOnTouchingLetterChangedListener(new LetterListViewListener());
        handler = new Handler();
        // 初始化首字母悬浮提示框
        txtOverlay = (TextView) LayoutInflater.from(this).inflate(
                R.layout.popup_char, null);
        txtOverlay.setVisibility(View.INVISIBLE);
        WindowManager.LayoutParams lp = new WindowManager.LayoutParams(
                LayoutParams.WRAP_CONTENT, LayoutParams.WRAP_CONTENT,
                WindowManager.LayoutParams.TYPE_APPLICATION,
                WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE
                        | WindowManager.LayoutParams.FLAG_NOT_TOUCHABLE,
                PixelFormat.TRANSLUCENT);
        windowManager = (WindowManager) this
                .getSystemService(Context.WINDOW_SERVICE);
        windowManager.addView(txtOverlay, lp);
        // 初始化ListAdapter
        disapearThread = new DisapearThread();

        mPullRefreshListview = (PullToRefreshListView) this
                .findViewById(R.id.pull_refresh_listview);
        mPullRefreshListview.setMode(Mode.PULL_DOWN_TO_REFRESH);
        mPullRefreshListview.setOnRefreshListener(this);
        mPullRefreshListview.setOnScrollListener(this);
    }

    protected void onResume() {
        super.onResume();
        this.onRefresh();
    }

    private String converterToPinYin(String chinese) {
        String pinyinString = "";
        char[] charArray = chinese.toCharArray();
        // 根据需要定制输出格式，我用默认的即可
        HanyuPinyinOutputFormat defaultFormat = new HanyuPinyinOutputFormat();
        try {
            // 遍历数组，ASC码大于128进行转换
            for (int i = 0; i < charArray.length; i++) {
                if (charArray[i] > 128) {
                    // charAt(0)取出首字母
                    pinyinString += PinyinHelper.toHanyuPinyinStringArray(
                            charArray[i], defaultFormat)[0].charAt(0);
                } else {
                    pinyinString += charArray[i];
                }
            }
            return pinyinString;
        } catch (BadHanyuPinyinOutputFormatCombination e) {
            e.printStackTrace();
            return null;
        }
    }

    private void parseContacts() {
        arrayList = new ArrayList<String>();
        arrayList2 = new ArrayList<String>();
        arrayList3 = new ArrayList<String>();
        map.clear();
        mapContact.clear();
        stringArr3 = new String[0];
        mData = new ArrayList<Contact>();
        mData.addAll(allData);
        for (int i = mData.size() - 1; i >= 0; i--) {
            Contact contact = mData.get(i);
            String userName = contact.getRealname();
            String pinyin = converterToPinYin(userName);
            if (pinyin == null || pinyin.length() == 0) {
                pinyin = "#";
            }
            arrayList.add(pinyin.toLowerCase());
            String charStr = pinyin.toUpperCase().substring(0, 1);
            if (!arrayList2.contains(charStr)) {
                arrayList2.add(charStr);
            }
            ArrayList<Contact> list = mapContact.get(charStr);
            if (list == null) {
                list = new ArrayList<Contact>();
            }
            list.add(contact);
            mapContact.put(charStr, list);
            map.put(userName, pinyin);
        }
        stringArr = new String[mData.size()];
        stringArr = (String[]) arrayList.toArray(stringArr);
        Arrays.sort(stringArr);
        // arrayList3.add("#");
        for (int i = 0; i < arrayList2.size(); i++) {
            String string = (String) arrayList2.get(i);
            arrayList3.add(string.toUpperCase());
        }

        stringArr3 = (String[]) arrayList3.toArray(stringArr3);// 得到右侧英文字母列表
        Arrays.sort(stringArr3);
        letterListView.setB(stringArr3);

        ArrayList<Contact> contacts = new ArrayList<Contact>();
        for (int i = 0; i < stringArr3.length; i++) {
            if (mapContact.containsKey(stringArr3[i]))
                contacts.addAll(mapContact.get(stringArr3[i]));
        }
        listAdapter = new ContactListAdapter(this, contacts, null, this,
                map);
        mPullRefreshListview.getRefreshableView().setAdapter(listAdapter);
    }

    public void onScroll(AbsListView view, int firstVisibleItem,
            int visibleItemCount, int totalItemCount) {
        if (firstVisibleItem < (stringArr.length - 1))
            txtOverlay.setText(String.valueOf(stringArr[firstVisibleItem]
                    .toUpperCase().charAt(0)));// 泡泡文字以第一个可见列表为准
    }

    public void onScrollStateChanged(AbsListView view, int scrollState) {
        this.scrollState = scrollState;
        if (scrollState == ListView.OnScrollListener.SCROLL_STATE_IDLE) {
            handler.removeCallbacks(disapearThread);
            // 提示延迟1.5s再消失
            boolean bool = handler.postDelayed(disapearThread, 1500);
        } else {
            txtOverlay.setVisibility(View.VISIBLE);
        }
    }

    public void onItemClick(AdapterView<?> parent, View view, int position,
            long id) {
    }

    private class DisapearThread implements Runnable {
        public void run() {
            // 避免在1.5s内，用户再次拖动时提示框又执行隐藏命令。
            if (scrollState == ListView.OnScrollListener.SCROLL_STATE_IDLE) {
                txtOverlay.setVisibility(View.INVISIBLE);
            }
        }
    }

    public void onDestroy() {
        super.onDestroy();
        // 将txtOverlay删除。
        txtOverlay.setVisibility(View.INVISIBLE);
        windowManager.removeView(txtOverlay);
    }

    /**
     * 把单个英文字母或者字符串转换成数字ASCII码
     * 
     * @param input
     * @return
     */
    public static int character2ASCII(String input) {
        char[] temp = input.toCharArray();
        StringBuilder builder = new StringBuilder();
        for (char each : temp) {
            builder.append((int) each);
        }
        String result = builder.toString();
        return Integer.parseInt(result);
    }

    @Override
    public void onRefresh() {
        getContactList();
    }

    private void getContactList() {
        progressWheel.spin();
        emptyTV.setVisibility(View.GONE);
        String url = ServerAPI.prefix
                + ((type == TYPE_FOLLOWING) ? "member/following/"
                        : "member/followed/")
                + sph.getValue(SharedPreferencesHelper.USERID);
        ConnectionHelper conn = ConnectionHelper.obtainInstance();
        conn.httpGet(url, 0, requestReceiver);
    }

    private RequestReceiver requestReceiver = new RequestReceiver() {

        @Override
        public void onResult(int resultCode, int requestId, String rawResponses) {
            progressWheel.stopSpinning();
            mPullRefreshListview.onRefreshComplete();
            if (resultCode == RESULT_STATE_OK) {
                if (rawResponses != null && rawResponses.length() > 0) {
                    Gson gson = new Gson();
                    JsonParser parser = new JsonParser();
                    JsonObject jsonObject = parser.parse(rawResponses)
                            .getAsJsonObject();
                    JsonArray jsonArray = jsonObject.getAsJsonArray("members");
                    mData = new ArrayList<Contact>();
                    for (int i = 0; i < jsonArray.size(); i++) {
                        Contact contact = gson.fromJson(jsonArray.get(i),
                                Contact.class);
                        if (contact.getGender() != null) {
                            if (contact.getGender().equals("man")) {
                                contact.setGender("男");
                            } else if (contact.getGender().equals("woman")) {
                                contact.setGender("女");
                            } else {
                                contact.setGender("");
                            }
                        }
                        mData.add(contact);
                    }
                    if (type == TYPE_FOLLOWING
                            && (mData == null || mData.size() == 0)) {
                        emptyTV.setVisibility(View.VISIBLE);
                        emptyTV.setText("你还没有关注任何好友");
                    }else if (type == TYPE_FOLLOWED
                            && (mData == null || mData.size() == 0)) {
                        emptyTV.setVisibility(View.VISIBLE);
                        emptyTV.setText("还没有任何好友关注你");
                    }else{
                        emptyTV.setVisibility(View.GONE);
                    }
                    
                    allData = new ArrayList<Contact>();
                    allData.addAll(mData);
                    parseContacts();
                    return;
                }
            }
            Utils.simpleNetBadNotify(FollowActivity.this);
        }
    };

    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.ib_back:
                finish();
                break;
        }
    }

    public class LetterListViewListener implements
            OnTouchingLetterChangedListener {

        @Override
        public void onTouchingLetterChanged(final String s) {

            int num = 1;
            for (int i = 0; i < stringArr.length; i++) {
                if ("A".equals(s)) {
                    num = 0;
                } else if (character2ASCII(stringArr[i].substring(0, 1)) < (character2ASCII(s) + 32)) {
                    num += 1;
                }
            }
            mPullRefreshListview.getRefreshableView().setSelectionFromTop(num,
                    0);
            if (num < (stringArr.length - 1))
                txtOverlay.setText(String.valueOf(stringArr[num].toUpperCase()
                        .charAt(0)));// 泡泡文字以第一个可见列表为准
            txtOverlay.setVisibility(View.VISIBLE);
            handler.removeCallbacks(disapearThread);
            handler.postDelayed(disapearThread, 1500);
        }
    }
}