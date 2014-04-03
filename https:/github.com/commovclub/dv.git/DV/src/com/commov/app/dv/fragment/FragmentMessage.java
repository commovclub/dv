package com.commov.app.dv.fragment;

import java.util.ArrayList;
import java.util.List;

import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;

import com.commov.app.dv.R;
import com.commov.app.dv.adapter.MessageAdapter;
import com.commov.app.dv.common.ServerAPI;
import com.commov.app.dv.conn.ConnectionHelper;
import com.commov.app.dv.conn.ConnectionHelper.RequestReceiver;
import com.commov.app.dv.model.Message;
import com.commov.app.dv.utils.SharedPreferencesHelper;
import com.commov.app.dv.utils.Utils;
import com.google.gson.Gson;
import com.google.gson.JsonArray;
import com.google.gson.JsonParser;
import com.handmark.pulltorefresh.library.PullToRefreshBase.Mode;
import com.handmark.pulltorefresh.library.PullToRefreshBase.OnRefreshListener2;
import com.handmark.pulltorefresh.library.PullToRefreshListView;

public class FragmentMessage extends BaseFragment implements
        OnRefreshListener2, android.view.View.OnClickListener {
    private Button allButton, digitalButton, scienceButton;
    private int type;// category index
    private static final int SYSTEM_MESSAGE = 1;
    private static final int PROJECT_MESSAGE = 2;
    private static final int PRIVATE_MESSAGE = 3;

    private PullToRefreshListView mPullRefreshListview;
    private MessageAdapter mAdapter;
    private List<Message> mData = new ArrayList<Message>();
    private int pageNumber = 1;

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
            Bundle savedInstanceState) {
        rootView = inflater.inflate(R.layout.fragment_message, null);
        sph = new SharedPreferencesHelper(this.getActivity());
        allButton = (Button) rootView.findViewById(R.id.buttonIndex1);
        digitalButton = (Button) rootView.findViewById(R.id.buttonIndex2);
        scienceButton = (Button) rootView.findViewById(R.id.buttonIndex3);
        allButton.setText("系统消息");
        digitalButton.setText("项目消息");
        scienceButton.setText("私信");

        allButton.setOnClickListener(this);
        digitalButton.setOnClickListener(this);
        scienceButton.setOnClickListener(this);
        mPullRefreshListview = (PullToRefreshListView) rootView
                .findViewById(R.id.pull_refresh_listview);
        mPullRefreshListview.setMode(Mode.BOTH);
        mPullRefreshListview.setOnRefreshListener(this);
        type = SYSTEM_MESSAGE;// 系统消息
        mAdapter = new MessageAdapter(this.getActivity());
        mPullRefreshListview.getRefreshableView().setAdapter(mAdapter);
        onPullDownToRefresh();
        return rootView;
    }
    
    @Override
    public void onResume() {
        super.onResume();
        onPullDownToRefresh();
    }

    @Override
    public void onPullDownToRefresh() {
        pageNumber = 1;
        mData = new ArrayList<Message>();
        mPullRefreshListview.setRefreshing();
        getMessageList();
    }

    @Override
    public void onPullUpToRefresh() {
        if (mData.size() == pageNumber * 10) {
            pageNumber++;
            mPullRefreshListview.setRefreshing();
            getMessageList();
        } else {
            Utils.Toast(this.getActivity(), "已经全部加载");
            mPullRefreshListview.onRefreshComplete();
        }
    }

    private void getMessageList() {
        String url = "";
        StringBuffer sb = new StringBuffer();
        sb.append("?pageSize=10");
        sb.append("&pageNumber=");
        sb.append(pageNumber);
        if (type == SYSTEM_MESSAGE) {
            url = ServerAPI.prefix + "message/system/list";
        } else if (type == PROJECT_MESSAGE) {
            url = ServerAPI.prefix + "message/lead/list";
        } else if (type == PRIVATE_MESSAGE) {
            url = ServerAPI.prefix + "message/private/"
                    + sph.getValue(SharedPreferencesHelper.USERID);
        }
        url = url+sb.toString();
        ConnectionHelper conn = ConnectionHelper.obtainInstance();
        conn.httpGet(url, 0, requestReceiver);
    }

    private RequestReceiver requestReceiver = new RequestReceiver() {

        @Override
        public void onResult(int resultCode, int requestId, String rawResponses) {

            mPullRefreshListview.onRefreshComplete();
            if (resultCode == RESULT_STATE_OK) {
                if (rawResponses != null && rawResponses.length() > 0) {
                    JsonParser parser = new JsonParser();
                    JsonArray jsonArray = parser.parse(rawResponses)
                            .getAsJsonArray();
                    for (int i = 0; i < jsonArray.size(); i++) {
                        Message message = new Gson().fromJson(jsonArray.get(i),
                                Message.class);
                        mData.add(message);
                    }
                    mAdapter.setData(mData, true);
                    return;
                }
            }
            Utils.simpleNetBadNotify(FragmentMessage.this.getActivity());
        }
    };

    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.buttonIndex1:
                type = 1;
                allButton.setBackgroundResource(R.drawable.segment_selected);
                digitalButton.setBackgroundResource(R.drawable.segment_normal);
                scienceButton.setBackgroundResource(R.drawable.segment_normal);
                break;
            case R.id.buttonIndex2:
                type = 2;
                allButton.setBackgroundResource(R.drawable.segment_normal);
                digitalButton
                        .setBackgroundResource(R.drawable.segment_selected);
                scienceButton.setBackgroundResource(R.drawable.segment_normal);
                break;
            case R.id.buttonIndex3:
                type = 3;
                allButton.setBackgroundResource(R.drawable.segment_normal);
                digitalButton.setBackgroundResource(R.drawable.segment_normal);
                scienceButton
                        .setBackgroundResource(R.drawable.segment_selected);

                break;
        }
        mData = new ArrayList<Message>();
        pageNumber = 1;
        getMessageList();
    }

}
