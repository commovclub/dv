package com.commov.app.dv.utils;

import java.util.Map;

import android.content.Context;
import android.content.SharedPreferences;

/**
 * A helper class for preference. <br>
 * 
 * @author Zhao Zhicheng
 * 
 */
public class SharedPreferencesHelper {
	public static String DEFAULT_PREFERENCE_NAME = "BJBFXH";
	SharedPreferences sp;
	SharedPreferences.Editor editor;
	Context context;
	public static String SESSION_ID = "session_id";
	public static String TOKEN = "token";
	public static String DEVICE_TOKEN = "device_token";//for push
	public static String REAL_NAME = "realname";
	public static String USER_NAME = "username";
	public static String EVENTS = "events";
	public static String EVENTS_BANNER = "events_banner";
	public static String NEWS = "news";
	public static String CONTACTS = "contacts";
	public static String USERID = "user_id";

	public SharedPreferencesHelper(final Context c, final String name) {
		if (c == null) {
			throw new IllegalArgumentException("The context should be not null");
		}
		context = c;
		sp = context.getSharedPreferences(name, Context.MODE_PRIVATE);
		editor = sp.edit();
	}

	public SharedPreferencesHelper(final Context c) {
		this(c, DEFAULT_PREFERENCE_NAME);
	}

	public void putValue(final String key, final String value) {
		editor.putString(key, value);
	}

	public void putInt(final String key, final Integer value) {
		editor.putInt(key, value);
	}

	public void putFloat(final String key, final Float value) {
		editor.putFloat(key, value);
	}

	public void putBoolean(final String key, final Boolean value) {
		editor.putBoolean(key, value);

	}

	public void putLong(final String key, final Long value) {
		editor.putLong(key, value);

	}

	public String getValue(final String key) {
		return sp.getString(key, null);
	}

	public int getInt(final String key) {
		return sp.getInt(key, 0);
	}

	public long getlong(final String key) {
		return sp.getLong(key, 0);
	}

	public boolean getBoolean(final String key, final boolean def) {
		return sp.getBoolean(key, def);
	}

	public float getFloat(final String key) {
		return sp.getFloat(key, 0);
	}

	public boolean commit() {
		return editor.commit();
	}

	public void remove(final String key) {
		if (sp.contains(key)) {
			editor.remove(key);
		}
	}

	public Map<String, ?> getAll() {
		return sp.getAll();
	}

	public void removeAll(int index) {
		if (sp.contains(SESSION_ID + index)) {
			editor.remove(SESSION_ID + index);
		}

	}

}
