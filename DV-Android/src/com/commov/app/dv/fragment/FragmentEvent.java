package com.commov.app.dv.fragment;

import java.util.ArrayList;
import java.util.List;

import android.app.Activity;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import com.commov.app.dv.R;
import com.commov.app.dv.adapter.EventAdapter;
import com.commov.app.dv.common.ServerAPI;
import com.commov.app.dv.conn.ConnectionHelper;
import com.commov.app.dv.conn.ConnectionHelper.RequestReceiver;
import com.commov.app.dv.model.event.Event;
import com.commov.app.dv.utils.SharedPreferencesHelper;
import com.commov.app.dv.utils.Utils;
import com.commov.app.dv.widget.TabContainer.TabTools;
import com.google.gson.Gson;
import com.google.gson.JsonArray;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import com.handmark.pulltorefresh.library.PullToRefreshBase.Mode;
import com.handmark.pulltorefresh.library.PullToRefreshBase.OnRefreshListener2;
import com.handmark.pulltorefresh.library.PullToRefreshListView;

/**
 * Event Fragment
 * 
 * 
 */
public class FragmentEvent extends BaseFragment implements TabTools,
        OnRefreshListener2 {
    private PullToRefreshListView mPullRefreshListview;
    private EventAdapter mAdapter;
    private List<Event> mData;
    private List<Event> bannerData;
    private int pageNumber = 1;

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
            Bundle savedInstanceState) {
        rootView = inflater.inflate(R.layout.fragment_event, null);
        sph = new SharedPreferencesHelper(this.getActivity());
        mPullRefreshListview = (PullToRefreshListView) rootView
                .findViewById(R.id.pull_refresh_listview);
        mPullRefreshListview.setMode(Mode.BOTH);
        mPullRefreshListview.setOnRefreshListener(this);

        mAdapter = new EventAdapter(this.getActivity());
        mPullRefreshListview.getRefreshableView().setAdapter(mAdapter);
        this.onPullDownToRefresh();
        return rootView;
    }

    @Override
    public void onPullDownToRefresh() {
        pageNumber = 1;
        mData = new ArrayList<Event>();
        bannerData = new ArrayList<Event>();
        mPullRefreshListview.setRefreshing();
        getEventList();

    }

    @Override
    public void onPullUpToRefresh() {
        if (mData.size() == pageNumber * 10) {
            pageNumber++;
            mPullRefreshListview.setRefreshing();
            getEventList();
        } else {
            Utils.Toast(this.getActivity(), "已经全部加载");
            mPullRefreshListview.onRefreshComplete();
        }
    }

    private void getEventList() {
        // showLoadingDialog();
        String url = ServerAPI.eventList(FragmentEvent.this.getActivity(),
                pageNumber);
        ConnectionHelper conn = ConnectionHelper.obtainInstance();
        conn.httpGet(url, 0, requestReceiver);
    }

    private RequestReceiver requestReceiver = new RequestReceiver() {

        @Override
        public void onResult(int resultCode, int requestId, String rawResponses) {
            // dismissLoadingDialog();
            mPullRefreshListview.onRefreshComplete();
            if (resultCode == RESULT_STATE_OK) {
                if (rawResponses != null && rawResponses.length() > 0) {
                    Gson gson = new Gson();
                    JsonParser parser = new JsonParser();
                    JsonObject jsonObject = parser.parse(rawResponses)
                            .getAsJsonObject();
                    JsonArray jsonArray = jsonObject.getAsJsonArray("events");
                    for (int i = 0; i < jsonArray.size(); i++) {
                        Event event = gson.fromJson(jsonArray.get(i),
                                Event.class);
                        event.setTime(Utils.getLongDateToString(event
                                .getCreatedAt()));
                        mData.add(event);
                    }
                    sph.putValue(SharedPreferencesHelper.EVENTS, rawResponses);
                    sph.commit();
                    // banner
                    JsonArray jsonBannerArray = jsonObject
                            .getAsJsonArray("banner");
                    for (int i = 0; i < jsonBannerArray.size(); i++) {
                        bannerData.add(gson.fromJson(jsonBannerArray.get(i),
                                Event.class));
                    }
                    mAdapter.setData(mData, bannerData, true);

                    return;

                }
            }
            // 失败后显示上次获取的活动
            /*
             * String eventJson = sph.getValue(SharedPreferencesHelper.EVENTS);
             * if (eventJson != null && eventJson.length() > 0) { JsonParser
             * parser = new JsonParser(); JsonArray jsonArray =
             * parser.parse(eventJson).getAsJsonArray(); for (int i = 0; i <
             * jsonArray.size(); i++) { mData.add(new
             * Gson().fromJson(jsonArray.get(i), Event.class)); }
             * mAdapter.setData(mData, true); }
             */
            Utils.simpleNetBadNotify(FragmentEvent.this.getActivity());
        }
    };
    
    @Override
    public void onAttach(Activity activity) {
        super.onAttach(activity);
        System.out.println("AAAAAAAAAA____onAttach");
    }
 
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        System.out.println("AAAAAAAAAA____onCreate");
    }
    
    @Override
    public void onActivityCreated(Bundle savedInstanceState) {
        super.onActivityCreated(savedInstanceState);
        System.out.println("AAAAAAAAAA____onActivityCreated");
    }
 
    @Override
    public void onStart() {
        super.onStart();
        System.out.println("AAAAAAAAAA____onStart");
    }
 
    @Override
    public void onResume() {
        super.onResume();
        System.out.println("AAAAAAAAAA____onResume");
    }
 
    @Override
    public void onPause() {
        super.onPause();
        System.out.println("AAAAAAAAAA____onPause");
    }
 
    @Override
    public void onStop() {
        super.onStop();
        System.out.println("AAAAAAAAAA____onStop");
    }
 
    @Override
    public void onDestroyView() {
        super.onDestroyView();
        System.out.println("AAAAAAAAAA____onDestroyView");
    }
 
    @Override
    public void onDestroy() {
        super.onDestroy();
        System.out.println("AAAAAAAAAA____onDestroy");
    }
 
    @Override
    public void onDetach() {
        super.onDetach();
        System.out.println("AAAAAAAAAA____onDetach");
    }

}
