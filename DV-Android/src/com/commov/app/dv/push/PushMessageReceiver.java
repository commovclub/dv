package com.commov.app.dv.push;

import org.json.JSONException;
import org.json.JSONObject;

import android.app.AlertDialog;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.os.Handler;
import android.util.Log;

import com.baidu.android.pushservice.PushConstants;
import com.commov.app.dv.MainTabActivity;
import com.commov.app.dv.utils.SharedPreferencesHelper;
import com.commov.app.dv.utils.Utils;

/**
 * Push消息处理receiver
 */
public class PushMessageReceiver extends BroadcastReceiver {
	/** TAG to Log */
	public static final String TAG = PushMessageReceiver.class.getSimpleName();
	protected SharedPreferencesHelper sph;

	AlertDialog.Builder builder;
	private Context context;
	private String tokenFromBaidu;

	/**
	 * @param context
	 *            Context
	 * @param intent
	 *            接收的intent
	 */
	@Override
	public void onReceive(final Context context, Intent intent) {
		sph = new SharedPreferencesHelper(context);
		this.context = context;
		Log.d(TAG, ">>> Receive intent: \r\n" + intent);

		if (intent.getAction().equals(PushConstants.ACTION_MESSAGE)) {
			// 获取消息内容
			String message = intent.getExtras().getString(
			        PushConstants.EXTRA_PUSH_MESSAGE_STRING);

			// 消息的用户自定义内容读取方式
			Log.i(TAG, "onMessage: " + message);

			// 自定义内容的json串
			Log.d(TAG,
			        "EXTRA_EXTRA = "
			                + intent.getStringExtra(PushConstants.EXTRA_EXTRA));

			// 用户在此自定义处理消息,以下代码为demo界面展示用

			Intent responseIntent = null;
			responseIntent = new Intent(Utils.ACTION_MESSAGE);
			responseIntent.putExtra(Utils.EXTRA_MESSAGE, message);
			responseIntent.setClass(context, MainTabActivity.class);
			responseIntent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
			context.startActivity(responseIntent);

		} else if (intent.getAction().equals(PushConstants.ACTION_RECEIVE)) {
			// 处理绑定等方法的返回数据
			// PushManager.startWork()的返回值通过PushConstants.METHOD_BIND得到

			// 获取方法
			final String method = intent
			        .getStringExtra(PushConstants.EXTRA_METHOD);
			// 方法返回错误码。若绑定返回错误（非0），则应用将不能正常接收消息。
			// 绑定失败的原因有多种，如网络原因，或access token过期。
			// 请不要在出错时进行简单的startWork调用，这有可能导致死循环。
			// 可以通过限制重试次数，或者在其他时机重新调用来解决。
			int errorCode = intent.getIntExtra(PushConstants.EXTRA_ERROR_CODE,
			        PushConstants.ERROR_SUCCESS);
			String content = "";
			if (intent.getByteArrayExtra(PushConstants.EXTRA_CONTENT) != null) {
				// 返回内容
				content = new String(
				        intent.getByteArrayExtra(PushConstants.EXTRA_CONTENT));
			}

			// String appid = "";
			String channelid = "";
			String userid = "";

			try {
				JSONObject jsonContent = new JSONObject(content);
				JSONObject params = jsonContent
				        .getJSONObject("response_params");
				// appid = params.getString("appid");
				channelid = params.getString("channel_id");
				userid = params.getString("user_id");
				String token = sph
				        .getValue(SharedPreferencesHelper.DEVICE_TOKEN);
				if (token == null || token.length() == 0) {
					tokenFromBaidu = channelid + userid;
					new Thread(new UpdateTokenThread()).start();
				}
			} catch (JSONException e) {
				Log.e(Utils.TAG, "Parse bind json infos error: " + e);
			}

			// 可选。通知用户点击事件处理
		} else if (intent.getAction().equals(
		        PushConstants.ACTION_RECEIVER_NOTIFICATION_CLICK)) {
			Log.d(TAG, "intent=" + intent.toUri(0));

			// 自定义内容的json串
			Log.d(TAG,
			        "EXTRA_EXTRA = "
			                + intent.getStringExtra(PushConstants.EXTRA_EXTRA));
			/*
			 * Intent aIntent = new Intent();
			 * aIntent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
			 * aIntent.setClass(context, MainActivity.class); String title =
			 * intent .getStringExtra(PushConstants.EXTRA_NOTIFICATION_TITLE);
			 * aIntent.putExtra(PushConstants.EXTRA_NOTIFICATION_TITLE, title);
			 * String content = intent
			 * .getStringExtra(PushConstants.EXTRA_NOTIFICATION_CONTENT);
			 * aIntent.putExtra(PushConstants.EXTRA_NOTIFICATION_CONTENT,
			 * content);
			 * 
			 * context.startActivity(aIntent);
			 */
		}
	}

	private class UpdateTokenThread implements Runnable {
		@Override
		public void run() {
			final android.os.Message message = new android.os.Message();
			try {
				updateToken();
				message.what = 1;

			} catch (final Exception e) {

				message.what = 0;
			}
			mHandler.sendMessage(message);
		}
	}

	/**
	 * Check the login .
	 * 
	 * @throws Exception
	 */
	private void updateToken() throws Exception {
//		try {
//			String url = Constant.APP_ACTIVATION;
//			StringBuffer sbParamers = new StringBuffer();
//			sbParamers.append("device_type=");
//			sbParamers.append(Constant.DEVICE_TYPE_ANDROID);
//			sbParamers.append("&device=");
//			sbParamers.append(Utils.generatorAndroidId(context));
//			if (tokenFromBaidu!=null) {
//				sbParamers.append("&device_token=");
//				sbParamers.append(tokenFromBaidu);
//			}
//			String strs = new HttpURLConnectionHelper().getPostData(url,
//			        context, sbParamers.toString());
//			LoginObject user = new Gson().fromJson(strs.toString(),
//			        LoginObject.class);
//			sph.putValue(SharedPreferencesHelper.TOKEN, user.getToken());
//			sph.commit();
//
//		} catch (BFXHException e) {
//			throw new Exception(e);
//		}
	}

	Handler mHandler = new Handler() {
		@Override
		public void handleMessage(final android.os.Message msg) {
			// update UI at here
			if (msg.what == 1) {
				sph.putValue(SharedPreferencesHelper.DEVICE_TOKEN,tokenFromBaidu
				        );
				sph.commit();
			} else if (msg.what == 0) {

			}
		}
	};
}
