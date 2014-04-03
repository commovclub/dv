package com.commov.app.dv.widget.appmsg;

import android.app.Activity;
import android.view.Gravity;

import com.commov.app.dv.widget.appmsg.AppMsg.Style;


public class ToastUtils {
	public static class STYLE {
		public static final int STYLE_ALERT = 0;
		public static final int STYLE_CONFIRM = 1;
		public static final int STYLE_INFO = 2;
	}

	public static class GRAVITY {
		public static final int GRAVITY_TOP = 0;
		public static final int GRAVITY_BOTTOM = 1;
		public static final int GRAVITY_CENTER = 2;
	}

	public static void toast(Activity context, int resId) {
		AppMsg.makeText(context, resId, checkStyle(STYLE.STYLE_INFO)).show();
	}

	public static void toast(Activity context, CharSequence text) {
		AppMsg.makeText(context, text, checkStyle(STYLE.STYLE_INFO)).show();
	}

	public static void toast(Activity context, int resId, int style) {
		AppMsg.makeText(context, resId, checkStyle(style)).show();
	}

	public static void toast(Activity context, CharSequence text, int style) {
		AppMsg.makeText(context, text, checkStyle(style)).show();
	}

	public static void toast(Activity context, int resId, int style, int gravity) {
		AppMsg.makeText(context, resId, checkStyle(style))
				.setLayoutGravity(checkGravity(gravity)).show();
	}

	public static void toast(Activity context, CharSequence text, int style,
			int gravity) {
		AppMsg.makeText(context, text, checkStyle(style))
				.setLayoutGravity(checkGravity(gravity)).show();
	}

	private static Style checkStyle(int style) {
		AppMsg.Style appMsgstyle = AppMsg.STYLE_INFO;
		switch (style) {
		case STYLE.STYLE_ALERT:
			appMsgstyle = AppMsg.STYLE_ALERT;
			break;
		case STYLE.STYLE_CONFIRM:
			appMsgstyle = AppMsg.STYLE_CONFIRM;
			break;
		case STYLE.STYLE_INFO:
		default:
			appMsgstyle = AppMsg.STYLE_INFO;
			break;
		}
		return appMsgstyle;
	}

	private static int checkGravity(int gravity) {
		int mGravity = Gravity.TOP;
		switch (gravity) {
		case GRAVITY.GRAVITY_TOP:
		default:
			mGravity = Gravity.TOP;
			break;
		case GRAVITY.GRAVITY_BOTTOM:
			mGravity = Gravity.BOTTOM;
			break;
		case GRAVITY.GRAVITY_CENTER:
			mGravity = Gravity.CENTER;
			break;
		}
		return mGravity;
	}
}
