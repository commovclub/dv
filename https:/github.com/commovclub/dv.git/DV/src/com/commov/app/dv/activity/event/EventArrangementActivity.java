package com.commov.app.dv.activity.event;

import java.util.ArrayList;
import java.util.List;

import android.os.Bundle;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.ListView;

import com.commov.app.dv.BaseActivity;
import com.commov.app.dv.R;
import com.commov.app.dv.adapter.ArrangementAdapter;
import com.commov.app.dv.common.ServerAPI;
import com.commov.app.dv.conn.ConnectionHelper;
import com.commov.app.dv.conn.ConnectionHelper.RequestReceiver;
import com.commov.app.dv.model.event.Arrangement;
import com.commov.app.dv.model.event.ArrangementList;
import com.commov.app.dv.model.event.Event;
import com.commov.app.dv.utils.Utils;
import com.commov.app.dv.widget.ProgressWheel;
import com.google.gson.Gson;
import com.google.gson.JsonArray;
import com.google.gson.JsonParser;

public class EventArrangementActivity extends BaseActivity implements
		OnClickListener {
	private ListView mPullRefreshListview;
	private ArrangementAdapter mAdapter;
	private List<ArrangementList> arrangementList;
	private Event event;

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_arrangement);
        progressWheel = (ProgressWheel) findViewById(R.id.pw_spinner);
		findViewById(R.id.ib_back).setOnClickListener(this);
		mPullRefreshListview = (ListView) this.findViewById(R.id.listView);
		if (getIntent().getExtras().get("event") != null) {
			event = (Event) getIntent().getExtras().get("event");

		}
		arrangementList = new ArrayList<ArrangementList>();
		getEventArrangmentList();
	}

	@Override
	public void onClick(View v) {
		switch (v.getId()) {
		case R.id.ib_back:
			finish();
			break;
		}
	}

	private void getEventArrangmentList() {
        progressWheel.spin();
		String url = ServerAPI.prefix + "event/" + event.getUuid()
				+ "/schedule";
		ConnectionHelper conn = ConnectionHelper.obtainInstance();
		conn.httpGet(url, 0, requestReceiver);
	}

	private RequestReceiver requestReceiver = new RequestReceiver() {

		@Override
		public void onResult(int resultCode, int requestId, String rawResponses) {
            progressWheel.stopSpinning();
			if (resultCode == RESULT_STATE_OK) {
				if (rawResponses != null && rawResponses.length() > 0) {
					Gson gson = new Gson();
					JsonParser parser = new JsonParser();
					JsonArray jsonArray = parser.parse(rawResponses)
							.getAsJsonArray();
					for (int i = 0; i < jsonArray.size(); i++) {
						ArrangementList eventArrangement = gson.fromJson(
								jsonArray.get(i), ArrangementList.class);
						JsonArray detailJson = jsonArray.get(i).getAsJsonObject().getAsJsonArray("schedule");
						List<Arrangement> details = new ArrayList<Arrangement>();
						for (int j = 0; j < detailJson.size(); j++) {
							Arrangement detail = gson.fromJson(detailJson.get(j),
									Arrangement.class);
							details.add(detail);
						}
						eventArrangement.setArrangementList(details);
						arrangementList.add(eventArrangement);
					}
					
					mAdapter = new ArrangementAdapter(EventArrangementActivity.this, arrangementList);
					mPullRefreshListview.setAdapter(mAdapter);
					return;

				}
			}
			Utils.simpleNetBadNotify(EventArrangementActivity.this);
		}
	};

}