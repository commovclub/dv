package com.commov.app.dv.push;

import android.app.Notification;
import android.content.Context;

import com.baidu.android.pushservice.CustomPushNotificationBuilder;
import com.commov.app.dv.R;

public class PushNotificationBuilderPlus extends CustomPushNotificationBuilder {
	private static final long serialVersionUID = -5833951500818182070L;

	public PushNotificationBuilderPlus(Context context) {
		// R.layout.push_notification_layout//user default layout
		super(0, R.id.notification_icon, R.id.notification_title,
				R.id.notification_text);
		//
		setNotificationFlags(Notification.FLAG_AUTO_CANCEL);
		setNotificationDefaults(Notification.DEFAULT_SOUND
				| Notification.DEFAULT_VIBRATE);
		setStatusbarIcon(context.getApplicationInfo().icon);
		// setLayoutDrawable(R.drawable.icon_push);
	}

	@Override
	public Notification construct(Context arg0) {
		Notification notification = super.construct(arg0);
		if (notification != null) {
			try {
				notification.contentView.setLong(R.id.notification_time,
						"setTime", System.currentTimeMillis());
				notification.contentView.setImageViewResource(
						android.R.id.icon, R.drawable.icon_push);
			} catch (Exception e) {
			}
		}
		return notification;
	}
}
