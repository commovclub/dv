package com.commov.app.dv.activity.work;

import java.util.ArrayList;
import java.util.List;

import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.TextView;

import com.commov.app.dv.BaseActivity;
import com.commov.app.dv.R;
import com.commov.app.dv.adapter.WorkAdapter;
import com.commov.app.dv.common.ServerAPI;
import com.commov.app.dv.conn.ConnectionHelper;
import com.commov.app.dv.conn.ConnectionHelper.RequestReceiver;
import com.commov.app.dv.model.Work;
import com.commov.app.dv.utils.SharedPreferencesHelper;
import com.commov.app.dv.utils.Utils;
import com.commov.app.dv.widget.ProgressWheel;
import com.google.gson.Gson;
import com.google.gson.JsonArray;
import com.google.gson.JsonParser;
import com.handmark.pulltorefresh.library.PullToRefreshBase.Mode;
import com.handmark.pulltorefresh.library.PullToRefreshBase.OnRefreshListener2;
import com.handmark.pulltorefresh.library.PullToRefreshListView;

public class WorksActivity extends BaseActivity implements OnClickListener,
        OnRefreshListener2 {
    private PullToRefreshListView mPullRefreshListview;
    private WorkAdapter mAdapter;
    private List<Work> mData = new ArrayList<Work>();
    private int pageNumber = 1;
    private Work deletedWork;
    private TextView emptyTV;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_works);
        sph = new SharedPreferencesHelper(this);
        progressWheel = (ProgressWheel) findViewById(R.id.pw_spinner);
        emptyTV = (TextView)  findViewById(R.id.tv_empty);
        findViewById(R.id.ib_back).setOnClickListener(this);
        findViewById(R.id.b_upload_work).setOnClickListener(this);

        mPullRefreshListview = (PullToRefreshListView) this
                .findViewById(R.id.pull_refresh_listview);
        mPullRefreshListview.setMode(Mode.BOTH);
        mPullRefreshListview.setOnRefreshListener(this);
        mAdapter = new WorkAdapter(this);
        mPullRefreshListview.getRefreshableView().setAdapter(mAdapter);
    }

    protected void onResume() {
        super.onResume();
        onPullDownToRefresh();
    }

    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.ib_back:
                finish();
                break;
            case R.id.b_upload_work:
                Intent intent = new Intent(WorksActivity.this,
                        WorkUploadActivity.class);
                startActivity(intent);
        }
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

    private void getWorkList() {
        progressWheel.spin();
        emptyTV.setVisibility(View.GONE);
        StringBuffer sb = new StringBuffer();
        sb.append("?pageSize=10");
        sb.append("&pageNumber=");
        sb.append(pageNumber);
        String url = ServerAPI.prefix + "portfolio/list/"
                + sph.getValue(SharedPreferencesHelper.USERID);
        ConnectionHelper conn = ConnectionHelper.obtainInstance();
        conn.httpGet(url, 0, requestReceiver);
    }

    private RequestReceiver requestReceiver = new RequestReceiver() {

        @Override
        public void onResult(int resultCode, int requestId, String rawResponses) {
            progressWheel.stopSpinning();
            mPullRefreshListview.onRefreshComplete();
            if (requestId == 0 && resultCode == RESULT_STATE_OK) {
                if (rawResponses != null && rawResponses.length() > 0) {
                    JsonParser parser = new JsonParser();
                    JsonArray jsonArray = parser.parse(rawResponses)
                            .getAsJsonArray();
                    for (int i = 0; i < jsonArray.size(); i++) {
                        Work work = new Gson().fromJson(jsonArray.get(i),
                                Work.class);

                        mData.add(work);
                    }
                    if(mData==null || mData.size()==0){
                        emptyTV.setVisibility(View.VISIBLE);
                    }else{
                        emptyTV.setVisibility(View.GONE);
                    }
                    mAdapter.setData(mData, true);
                    return;
                }
            }
            if (requestId == 1 && resultCode == RESULT_STATE_OK) {
                if (rawResponses != null && rawResponses.length() > 0) {
                    Utils.Toast(WorksActivity.this, "该作品删除成功");
                    mData.remove(deletedWork);
                    if(mData==null || mData.size()==0){
                        emptyTV.setVisibility(View.VISIBLE);
                    }else{
                        emptyTV.setVisibility(View.GONE);
                    }
                    mAdapter.setData(mData, true);
                    return;
                }
            }
            Utils.simpleNetBadNotify(WorksActivity.this);
        }
    };

    public void deleteWork(Work work) {
        deletedWork  = work;
        progressWheel = (ProgressWheel) findViewById(R.id.pw_spinner);

        progressWheel.setText("删除作品中...");
        progressWheel.spin();
        String url = ServerAPI.prefix + "portfolio/delete/" + work.getUuid();
        ConnectionHelper conn = ConnectionHelper.obtainInstance();
        conn.httpGet(url, 1, requestReceiver);
    }
}
