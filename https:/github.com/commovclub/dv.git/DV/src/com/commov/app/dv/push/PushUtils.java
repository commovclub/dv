package com.commov.app.dv.push;

import java.util.ArrayList;
import java.util.List;

import com.baidu.android.pushservice.PushConstants;
import com.baidu.android.pushservice.PushManager;
import com.baidu.android.pushservice.PushNotificationBuilder;
import com.commov.app.dv.utils.Utils;

import android.content.Context;
import android.content.pm.ApplicationInfo;
import android.content.pm.PackageManager;
import android.content.pm.PackageManager.NameNotFoundException;
import android.os.Bundle;

public class PushUtils {
	public static final String TAG = "PushUtils";

	public static String getApiKey(Context context) {
		return getMetaValue(context, "api_key");
	}

	// 获取AppKey
	public static String getMetaValue(Context context, String metaKey) {
		Bundle metaData = null;
		String apiKey = null;
		if (context == null || metaKey == null) {
			return null;
		}
		try {
			ApplicationInfo ai = context.getPackageManager()
					.getApplicationInfo(context.getPackageName(),
							PackageManager.GET_META_DATA);
			if (null != ai) {
				metaData = ai.metaData;
			}
			if (null != metaData) {
				apiKey = metaData.getString(metaKey);
			}
		} catch (NameNotFoundException e) {

		}
		return apiKey;
	}

	/**
	 * 注册Push
	 * 
	 * @param context
	 */
	public static void registerPush(Context context) {
		// 设置自定义的通知样式，如果想使用系统默认的可以不加这段代码
		PushNotificationBuilder cBuilder = new PushNotificationBuilderPlus(
				context);
		PushManager.setNotificationBuilder(context, 1, cBuilder);
		//
		List<String> tags = new ArrayList<String>();
		tags.add(Utils.getAppVersionName(context));
		PushManager.setTags(context, tags);
		// 百度Push
		PushManager.startWork(context, PushConstants.LOGIN_TYPE_API_KEY,
				PushUtils.getApiKey(context));
	}

}
