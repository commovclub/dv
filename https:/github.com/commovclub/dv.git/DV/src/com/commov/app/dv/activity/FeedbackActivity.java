package com.commov.app.dv.activity;

import android.os.Bundle;
import android.text.Editable;
import android.view.View;
import android.widget.EditText;
import android.widget.TextView;

import com.commov.app.dv.BaseActivity;
import com.commov.app.dv.R;
import com.commov.app.dv.common.InputLengthControler;
import com.commov.app.dv.common.ServerAPI;
import com.commov.app.dv.conn.ConnectionHelper;
import com.commov.app.dv.conn.ConnectionHelper.RequestReceiver;
import com.commov.app.dv.model.Result;
import com.commov.app.dv.utils.JsonUtils;
import com.commov.app.dv.utils.Utils;
import com.commov.app.dv.widget.CommonHeaderBar;
import com.commov.app.dv.widget.CommonHeaderBar.OnNavgationListener;

public class FeedbackActivity extends BaseActivity {

	private EditText editText;
	private TextView lengthHintTv;

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_feedback_layout);
		editText = (EditText) findViewById(R.id.feedback_edittext);
		lengthHintTv = (TextView) findViewById(R.id.feedback_length_hint_msg);
		InputLengthControler controler = new InputLengthControler();
		controler.config(editText, 140, lengthHintTv);
		
		CommonHeaderBar header = (CommonHeaderBar) findViewById(R.id.common_header);
		header.addFromLeft(CommonHeaderBar.NAV_BACK);
		header.addFromRight(CommonHeaderBar.NAV_OK);
		header.setTitle(R.string.feedback);
		header.setOnNavgationListener(onNavgationListener);
	}

	private OnNavgationListener onNavgationListener = new OnNavgationListener() {

		@Override
		public void onItemClick(View v, int actionId, CommonHeaderBar nav) {
			switch (actionId) {
			case CommonHeaderBar.NAV_OK:
				postFeedback();
				break;
			case CommonHeaderBar.NAV_BACK:
				finish();
				break;
			}
		}
	};

	private void postFeedback() {
		Editable editable = editText.getText();
		if (editable == null || editable.length() <= 0) {
			Utils.Toast(this, "输入反馈内容");
		} else {
			showLoadingDialog();
			String content = editable.toString();
			String url = ServerAPI.feedback(this, content, null);
			ConnectionHelper conn = ConnectionHelper.obtainInstance();
			conn.httpGet(url, 0, rr);
		}
	}

	private RequestReceiver rr = new RequestReceiver() {

		@Override
		public void onResult(int resultCode, int requestId, String rawResponses) {
			dismissLoadingDialog();
			if (resultCode == RESULT_STATE_OK) {
				Result result = JsonUtils.fromJson(rawResponses, Result.class);
				if (result != null && result.isSuccess()) {
					Utils.Toast(FeedbackActivity.this,
							R.string.feedback_commit_success);
					finish();
					return;
				}
			}
			Utils.simpleNetBadNotify(FeedbackActivity.this);
		}
	};
}
