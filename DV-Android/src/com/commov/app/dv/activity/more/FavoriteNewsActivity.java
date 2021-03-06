package com.commov.app.dv.activity.more;

import java.util.ArrayList;
import java.util.List;

import android.os.Bundle;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.TextView;

import com.commov.app.dv.BaseActivity;
import com.commov.app.dv.R;
import com.commov.app.dv.adapter.NewsAdapter;
import com.commov.app.dv.db.roscopeco.ormdroid.Entity;
import com.commov.app.dv.model.News;
import com.commov.app.dv.utils.SharedPreferencesHelper;
import com.commov.app.dv.widget.ProgressWheel;
import com.handmark.pulltorefresh.library.PullToRefreshBase.Mode;
import com.handmark.pulltorefresh.library.PullToRefreshBase.OnRefreshListener2;
import com.handmark.pulltorefresh.library.PullToRefreshListView;

public class FavoriteNewsActivity extends BaseActivity implements
        OnRefreshListener2 {
    private PullToRefreshListView mPullRefreshListview;
    private NewsAdapter mAdapter;
    private List<News> mData = new ArrayList<News>();
    private TextView emptyTV;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_favorite_news);
        findViewById(R.id.ib_back).setOnClickListener(new OnClickListener() {

            @Override
            public void onClick(View v) {
                finish();
            }

        });
        progressWheel = (ProgressWheel) findViewById(R.id.pw_spinner);
        emptyTV = (TextView) findViewById(R.id.tv_empty);
        sph = new SharedPreferencesHelper(this);
        progressWheel = (ProgressWheel) findViewById(R.id.pw_spinner);
        mPullRefreshListview = (PullToRefreshListView) this
                .findViewById(R.id.pull_refresh_listview);
        mPullRefreshListview.setMode(Mode.PULL_DOWN_TO_REFRESH);
        mPullRefreshListview.setOnRefreshListener(this);
        mAdapter = new NewsAdapter(this);
        mPullRefreshListview.getRefreshableView().setAdapter(mAdapter);
        getNewsList();
    }

    @Override
    public void onResume() {
        super.onResume();
        getNewsList();
    }

    @Override
    public void onPullDownToRefresh() {
        mData = new ArrayList<News>();
        getNewsList();
    }

    private void getNewsList() {

        mData = Entity.query(News.class).execute200OrderByIdDesc();
        if (mData == null || mData.size() == 0) {
            emptyTV.setVisibility(View.VISIBLE);
        } else {
            emptyTV.setVisibility(View.GONE);
        }
        mAdapter.setData(mData, true);
        mPullRefreshListview.onRefreshComplete();
    }

    @Override
    public void onPullUpToRefresh() {
        // TODO Auto-generated method stub

    }

}