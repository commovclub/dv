package com.commov.app.dv;

import android.content.Context;
import android.content.Intent;
import android.graphics.Bitmap;
import android.os.Bundle;
import android.view.View;
import android.view.View.OnClickListener;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import android.widget.ProgressBar;

import com.commov.app.dv.utils.Utils;
import com.commov.app.dv.widget.CommonHeaderBar;
import com.commov.app.dv.widget.CommonHeaderBar.OnNavgationListener;
import com.commov.app.dv.R;

public class WebActivity extends BaseActivity {

	public static final String KEY_TITLE = "web_act_title";
	public static final String KEY_WEB_PAGE_PATH = "web_act_page_path";
	private WebView webview;
	private View loadErrorHint;
	private ProgressBar progressBar;
	private String orginalPath;

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_web);
		CommonHeaderBar header = (CommonHeaderBar) findViewById(R.id.common_header);
		header.setOnNavgationListener(navgationListener);
		header.addFromLeft(CommonHeaderBar.NAV_BACK);
		String title = getIntent().getStringExtra(KEY_TITLE);
		header.setTitle(title);
		orginalPath = getIntent().getStringExtra(KEY_WEB_PAGE_PATH);
		//
		progressBar = (ProgressBar) findViewById(R.id.progress_bar);
		webview = (WebView) findViewById(R.id.webview);
		loadErrorHint = findViewById(R.id.load_error_hint);
		loadErrorHint.setOnClickListener(onClickListener);
		webview.getSettings().setJavaScriptEnabled(true);
		webview.setWebViewClient(webviewClient);
		webview.setBackgroundColor(0);
		webview.loadUrl(orginalPath);
	}

	private OnClickListener onClickListener = new OnClickListener() {

		@Override
		public void onClick(View v) {
			if (v.getId() == R.id.load_error_hint) {
				Utils.checkViewVisibility(loadErrorHint, View.GONE);
				webview.loadUrl(orginalPath);
			}
		}
	};

	private final String empty_url = "";
	private WebViewClient webviewClient = new WebViewClient() {

		@Override
		public boolean shouldOverrideUrlLoading(WebView view, String url) {
			return super.shouldOverrideUrlLoading(view, url);
		}

		@Override
		public void onPageStarted(WebView view, String url, Bitmap favicon) {
			super.onPageStarted(view, url, favicon);
			Utils.checkViewVisibility(progressBar, View.VISIBLE);
		}

		@Override
		public void onPageFinished(WebView view, String url) {
			super.onPageFinished(view, url);
			Utils.checkViewVisibility(progressBar, View.GONE);
		}

		@Override
		public void onReceivedError(WebView view, int errorCode,
				String description, String failingUrl) {
			super.onReceivedError(view, errorCode, description, failingUrl);
			Utils.Toast(WebActivity.this, R.string.weibo_loading_failed);
			webview.loadUrl(empty_url);
			Utils.checkViewVisibility(loadErrorHint, View.VISIBLE);
		}

	};
	private OnNavgationListener navgationListener = new OnNavgationListener() {

		@Override
		public void onItemClick(View v, int actionId, CommonHeaderBar nav) {
			switch (actionId) {
			case CommonHeaderBar.NAV_BACK:
				finish();
				break;
			}
		}
	};

	public static void startWebActivity(Context context, int titleResId,
			String url) {
		if (context == null) {
			return;
		}
		startWebActivity(context, context.getString(titleResId), url);
	}

	public static void startWebActivity(Context context, String title,
			String url) {
		Intent intent = new Intent(context, WebActivity.class);
		if (title != null) {
			intent.putExtra(KEY_TITLE, title);
		}
		if (url != null) {
			intent.putExtra(KEY_WEB_PAGE_PATH, url);
		}
		context.startActivity(intent);
	}
}
