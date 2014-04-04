package com.commov.app.dv.common;

import java.net.URLEncoder;

import android.content.Context;

import com.commov.app.dv.utils.Utils;

/**
 * 服务器接口
 */
public class ServerAPI {
	private ServerAPI() {
	}

	public static String prefix = CommonParam.server_info_prefix;// 服务器接口地址
	private static String REQUEST_COMMON_PARAMS;// 请求公用携带参数
	private static final String URL_NEWS_LIST = "info/list/%s?pageNumber%s&pageSize=10";//token uuid, pageNumber
	private static final String URL_NEWS_DETAIL = "info/%s";//

	private static final String URL_EVENT_LIST = "event/list/%s?pageNumber%s&pageSize=10";//token
	private static final String URL_EVENT_DETAIL = "event/%s/%s";
	private static final String URL_CONTACT_LIST = "member/list/%s?";//token
	private static final String URL_CONTACT = "member/%s";//token
	private static final String URL_LOGIN = "member/login";

	/**
	 * 新闻列表
	 */
	public static String newList(Context context,int pageNumber) {
		return obtainUrl(context, prefix, URL_NEWS_LIST, ServerAPI.getToken(context),pageNumber);
	}
	
	/**
	 * 新闻详细
	 */
	public static String newsDetail(Context context, String uuid) {
		return obtainUrl(context, prefix, URL_NEWS_DETAIL, uuid);
	}
	
	/**
	 * 活动列表
	 */
	public static String eventList(Context context,int pageNumber) {
		return obtainUrl(context, prefix, URL_EVENT_LIST, ServerAPI.getToken(context),pageNumber);
	}
	
	/**
	 * 活动详细
	 */
	public static String eventDetail(Context context, String uuid, String userId) {
		return obtainUrl(context, prefix, URL_EVENT_DETAIL, uuid,userId);
	}
	
	/**
	 * 人员列表
	 */
	public static String contactList(Context context) {
		return obtainUrl(context, prefix, URL_CONTACT_LIST, ServerAPI.getToken(context));
	}
	
	/**
	 *login
	 */
	public static String login(Context context) {
		return obtainUrl(context, prefix, URL_LOGIN);
	}
	
	private static String getToken(Context context){
		return "test_token";
	}

	private static String obtainUrl(Context context, String urlPrefix,
			String pathRefer, Object... formatValues) {
		if (formatValues != null) {
			int length = formatValues.length;
			for (int i = 0; i < length; i++) {
				Object obj = formatValues[i];
				if (obj == null) {
					formatValues[i] = "";
				} else if (obj instanceof String) {
					obj = URLEncoder.encode((String) obj);
					formatValues[i] = obj;
				}
			}
		}
		StringBuffer strBuffer = new StringBuffer(urlPrefix);
		strBuffer.append(String.format(pathRefer, formatValues));
		return strBuffer.toString();
	}

	/**
	 * 获取数据接口的公用URL参数
	 * 
	 * @return
	 */
	private static String getDeviceParams(Context context) {
		if (REQUEST_COMMON_PARAMS == null) {
			StringBuffer strBuffer = new StringBuffer();
			strBuffer.append("ver=");// 版本号
			strBuffer.append(Utils.getAppVersionName(context));
			strBuffer.append("&dev=");// 设备类型(iphone, ipad, android)
			strBuffer.append(URLEncoder.encode(CommonParam.DEVICE_TAG));
			REQUEST_COMMON_PARAMS = strBuffer.toString();
		}
		return REQUEST_COMMON_PARAMS;
	}
}
