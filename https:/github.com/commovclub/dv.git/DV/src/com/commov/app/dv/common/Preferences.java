package com.commov.app.dv.common;

import java.util.ArrayList;
import java.util.List;

import android.content.Context;
import android.content.SharedPreferences;
import android.content.SharedPreferences.OnSharedPreferenceChangeListener;

public class Preferences {
	private static Preferences instance;
	protected SharedPreferences sp_instance;
	private static final String share_preference_name = "grammar_sp_preferences";
	private static List<PreferencesObserver> observers = new ArrayList<PreferencesObserver>();
	public final static String key_whole_version_keyword = "key_whole_version_keyword";
	public final static String key_whole_version_tag = "key_whole_version_tag";
	public final static String key_whole_version_grammar = "key_whole_version_grammar";
	//
	public final static String key_update_count_keyword = "key_update_count_keyword";
	public final static String key_update_count_tag = "key_update_count_tag";
	public final static String key_update_count_grammar = "key_update_count_grammar";
	//
	public final static String key_have_sync_task = "key_have_sync_task";
	//
	private final static int empty_whole_version = CommonParam.empty_whole_version;
	//
	private final static String key_user_uid = "key_user_uid";

	public interface PreferencesObserver {
		public void onPreferencesChanged(Preferences preference, String key);
	}

	private static OnSharedPreferenceChangeListener share_pre_Listener = new OnSharedPreferenceChangeListener() {
		@Override
		public void onSharedPreferenceChanged(
				SharedPreferences sharedPreferences, String key) {
			for (PreferencesObserver ob : observers) {
				ob.onPreferencesChanged(instance, key);
			}
		}
	};

	/**
	 * 请小心使用该方法，必须配合unregister在不需要的时候取消注册，否则会出现内存泄露
	 * 
	 * @param observer
	 */
	public void registerObserver(PreferencesObserver observer) {
		if (observer != null && !observers.contains(observer)) {
			observers.add(observer);
		}
	}

	public void unregisterObserver(PreferencesObserver observer) {
		if (observer != null) {
			observers.remove(observer);
		}
	}

	private Preferences(Context context) {
		sp_instance = context.getSharedPreferences(share_preference_name, 0);
		sp_instance
				.registerOnSharedPreferenceChangeListener(share_pre_Listener);
	}

	public static Preferences getInstance(Context context) {
		return instance == null ? instance = new Preferences(context)
				: instance;
	}

	public int getWholeVersionKeyword() {
		return sp_instance.getInt(key_whole_version_keyword,
				empty_whole_version);
	}

	public void setWholeVersionKeyword(int wholeVersion) {
		sp_instance.edit().putInt(key_whole_version_keyword, wholeVersion)
				.commit();
	}

	public int getWholeVersionTag() {
		return sp_instance.getInt(key_whole_version_tag, empty_whole_version);
	}

	public void setWholeVersionTag(int wholeVersion) {
		sp_instance.edit().putInt(key_whole_version_tag, wholeVersion).commit();
	}

	public int getWholeVersionGrammar() {
		return sp_instance.getInt(key_whole_version_grammar,
				empty_whole_version);
	}

	public void setWholeVersionGrammar(int wholeVersion) {
		sp_instance.edit().putInt(key_whole_version_grammar, wholeVersion)
				.commit();
	}

	public int getUpdateCountKeyword() {
		return sp_instance.getInt(key_update_count_keyword, 0);
	}

	public void setUpdateKeyword(int updateCount) {
		sp_instance.edit().putInt(key_update_count_keyword, updateCount)
				.commit();
	}

	public int getUpdateCountTag() {
		return sp_instance.getInt(key_update_count_tag, 0);
	}

	public void setUpdateTag(int updateCount) {
		sp_instance.edit().putInt(key_update_count_tag, updateCount).commit();
	}

	public int getUpdateCountGrammar() {
		return sp_instance.getInt(key_update_count_grammar, 0);
	}

	public void setUpdateGrammar(int updateCount) {
		sp_instance.edit().putInt(key_update_count_grammar, updateCount)
				.commit();
	}

	public boolean haveSyncTask() {
		return sp_instance.getBoolean(key_have_sync_task, Boolean.FALSE);
	}

	public void setHaveSyncTask(boolean haveSyncTask) {
		sp_instance.edit().putBoolean(key_have_sync_task, haveSyncTask)
				.commit();
	}

	public String getLoginUid() {
		return sp_instance.getString(key_user_uid, null);
	}

	public void setLogin(String uid) {
		sp_instance.edit().putString(key_user_uid, uid).commit();
	}

	public void logout() {
		sp_instance.edit().remove(key_user_uid).commit();
	}

	public boolean isLogin() {
		return getLoginUid() != null;
	}
}
