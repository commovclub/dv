package com.commov.app.dv.activity.event;

import android.os.Bundle;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.androidquery.AQuery;
import com.androidquery.util.Constants;
import com.commov.app.dv.BaseActivity;
import com.commov.app.dv.R;
import com.commov.app.dv.common.ServerAPI;
import com.commov.app.dv.conn.ConnectionHelper;
import com.commov.app.dv.conn.ConnectionHelper.RequestReceiver;
import com.commov.app.dv.model.event.Arrangement;
import com.commov.app.dv.utils.Utils;
import com.commov.app.dv.widget.ProgressWheel;
import com.commov.app.dv.widget.RoundedImageView;
import com.google.gson.Gson;

public class EventArrangementDetailActivity extends BaseActivity implements
		OnClickListener {
	private Arrangement arrangement;
	private TextView titleTV, timeTV, descTV, nameTV, introduceTV;
	private RoundedImageView avatar;

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_arrangement_detail);
        progressWheel = (ProgressWheel) findViewById(R.id.pw_spinner);
		findViewById(R.id.ib_back).setOnClickListener(this);
		titleTV = (TextView)this.findViewById(R.id.tv_title);
		timeTV = (TextView)this.findViewById(R.id.tv_time);
		descTV  = (TextView)this.findViewById(R.id.tv_desc);
		nameTV =  (TextView)this.findViewById(R.id.tv_name);
		introduceTV =  (TextView)this.findViewById(R.id.tv_speech_desc);
		avatar = (RoundedImageView) this.findViewById(R.id.iv_avatar);
		avatar.setOnClickListener(this);
		int width = Utils.getScreenWidth(this);
		LinearLayout.LayoutParams params = new LinearLayout.LayoutParams(
				width / 6, width / 6);
		params.setMargins(10, 10, 10, 10);
		avatar.setLayoutParams(params);
		avatar.setCornerRadius(width / 8);
		if (getIntent().getExtras().get("arrangement") != null) {
			arrangement = (Arrangement) getIntent().getExtras().get(
					"arrangement");
			titleTV.setText(arrangement.getTitle());
			timeTV.setText(arrangement.getTime());
		}
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
		String url = ServerAPI.prefix + "event/schedule/"
				+ arrangement.getUuid();
		ConnectionHelper conn = ConnectionHelper.obtainInstance();
		conn.httpGet(url, 0, requestReceiver);
	}

	private RequestReceiver requestReceiver = new RequestReceiver() {

		@Override
		public void onResult(int resultCode, int requestId, String rawResponses) {
            progressWheel.stopSpinning();
			if (resultCode == RESULT_STATE_OK) {
				if (rawResponses != null && rawResponses.length() > 0) {
					arrangement = new Gson().fromJson(rawResponses, Arrangement.class);
					titleTV.setText(arrangement.getTitle());
					timeTV.setText(arrangement.getTime());
					descTV.setText(arrangement.getDescription());
					nameTV.setText(arrangement.getSpeaker());
					introduceTV.setText(arrangement.getSpeakerIntro());
					if(arrangement.getImage()!=null&&arrangement.getImage().length()>0){
						new AQuery(EventArrangementDetailActivity.this).id(R.id.iv_avatar).image(
							arrangement.getImage(), true, true, 0, Constants.INVISIBLE);
					}
					return;
				}
			}
			Utils.simpleNetBadNotify(EventArrangementDetailActivity.this);
		}
	};

}