package com.commov.app.dv.fragment;

import java.util.ArrayList;
import java.util.List;

import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import com.commov.app.dv.R;
import com.commov.app.dv.adapter.NewsAdapter;
import com.commov.app.dv.common.ServerAPI;
import com.commov.app.dv.conn.ConnectionHelper;
import com.commov.app.dv.conn.ConnectionHelper.RequestReceiver;
import com.commov.app.dv.model.DVImage;
import com.commov.app.dv.model.News;
import com.commov.app.dv.utils.SharedPreferencesHelper;
import com.commov.app.dv.utils.Utils;
import com.commov.app.dv.widget.ProgressWheel;
import com.commov.app.dv.widget.TabContainer.TabTools;
import com.google.gson.Gson;
import com.google.gson.JsonArray;
import com.google.gson.JsonParser;
import com.handmark.pulltorefresh.library.PullToRefreshBase.Mode;
import com.handmark.pulltorefresh.library.PullToRefreshBase.OnRefreshListener2;
import com.handmark.pulltorefresh.library.PullToRefreshListView;

/**
 * News Fragment
 * 
 * 
 */
public class FragmentNews extends BaseFragment implements TabTools,
        OnRefreshListener2 {
    private PullToRefreshListView mPullRefreshListview;
    private NewsAdapter mAdapter;
    private List<News> mData = new ArrayList<News>();
    private int pageNumber = 1;
    private boolean firstLoad = false;

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
            Bundle savedInstanceState) {
        rootView = inflater.inflate(R.layout.fragment_news, null);
        sph = new SharedPreferencesHelper(this.getActivity());
        progressWheel = (ProgressWheel) findViewById(R.id.pw_spinner);
        mPullRefreshListview = (PullToRefreshListView) rootView
                .findViewById(R.id.pull_refresh_listview);
        mPullRefreshListview.setMode(Mode.BOTH);
        mPullRefreshListview.setOnRefreshListener(this);
        mAdapter = new NewsAdapter(this.getActivity());
        mPullRefreshListview.getRefreshableView().setAdapter(mAdapter);
        onPullDownToRefresh();
        return rootView;
    }

    @Override
    public void onPause() {
        super.onPause();
    }

    @Override
    public void onResume() {
        super.onResume();

    }

    @Override
    public void onPullDownToRefresh() {
        pageNumber = 1;
        mData = new ArrayList<News>();
        mPullRefreshListview.setRefreshing();
        getNewsList();

    }

    @Override
    public void onPullUpToRefresh() {
        if (mData.size() == pageNumber * 10) {
            pageNumber++;
            mPullRefreshListview.setRefreshing();
            getNewsList();
        } else {
            Utils.Toast(this.getActivity(), "已经全部加载");
            mPullRefreshListview.onRefreshComplete();
        }
    }

    private void getNewsList() {
        if (!firstLoad) {
            progressWheel.spin();
            showLoadingDialog();
        }
        String url = ServerAPI.newList(FragmentNews.this.getActivity(),
                pageNumber);
        ConnectionHelper conn = ConnectionHelper.obtainInstance();
        conn.httpGet(url, 0, requestReceiver);
    }

    private RequestReceiver requestReceiver = new RequestReceiver() {

        @Override
        public void onResult(int resultCode, int requestId, String rawResponses) {
            if (!firstLoad) {
                progressWheel.stopSpinning();
                dismissLoadingDialog();
                firstLoad = true;
            }
            mPullRefreshListview.onRefreshComplete();
            if (resultCode == RESULT_STATE_OK) {
                if (rawResponses != null && rawResponses.length() > 0) {
                    JsonParser parser = new JsonParser();
                    JsonArray jsonArray = parser.parse(rawResponses)
                            .getAsJsonArray();
                    for (int i = 0; i < jsonArray.size(); i++) {
                        News news = new Gson().fromJson(jsonArray.get(i),
                                News.class);
                        List<DVImage> images = news.getImages();
                        if (images != null
                                && (images.size() == 2 || images.size() == 1)) {
                            news.setPath(images.get(0).getFilePath());
                            news.setType(News.ONE_PIC);
                        } else if (images != null && images.size() > 2) {
                            news.setPath(images.get(0).getFilePath());
                            news.setPath2(images.get(1).getFilePath());
                            news.setPath3(images.get(2).getFilePath());
                            news.setType(News.THREE_PIC);
                        } else {
                            news.setType(News.ZERO_PIC);
                        }
                        news.setTime(Utils.getLongDateToString(news
                                .getCreatedAt()));
                        mData.add(news);
                    }
                    sph.putValue(SharedPreferencesHelper.NEWS, rawResponses);
                    sph.commit();
                    // FragmentNews.this.getActivity().finish();
                    mAdapter.setData(mData, true);
                    return;
                }
            }
            String newsJson = sph.getValue(SharedPreferencesHelper.NEWS);
            if (newsJson != null && newsJson.length() > 0) {
                JsonParser parser = new JsonParser();
                JsonArray jsonArray = parser.parse(newsJson).getAsJsonArray();
                for (int i = 0; i < jsonArray.size(); i++) {
                    mData.add(new Gson().fromJson(jsonArray.get(i), News.class));
                }
                mAdapter.setData(mData, true);
            }
            Utils.simpleNetBadNotify(FragmentNews.this.getActivity());
        }
    };

}
