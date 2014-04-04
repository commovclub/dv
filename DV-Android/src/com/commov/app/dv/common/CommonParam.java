package com.commov.app.dv.common;

import java.io.File;
import java.io.IOException;

import android.os.Environment;
import android.util.Log;

public class CommonParam {
	public static final String TAG = "CommonParam";
    public static final String APP_ID = "wxc4fa0aa3dee9488d";

	private CommonParam() {
	}

	public static final boolean DEBUG = Boolean.FALSE;
	//
	public static String server_info_prefix = "http://www.danaaa.com/dv/api/";

	public static final String DEVICE_TAG = "android";

	public static final int CONNECTION_HELPER_TIMEOUT = 20000;// ms

	public static final int empty_whole_version = -1;
	public static final int check_sync_grammar_explain_min_time_interval;
	static {
		if (DEBUG) {
			check_sync_grammar_explain_min_time_interval = 1000 * 10;
			Log.d(TAG,
					"user debug mode check_sync_grammar_explain_min_time_interval:"
							+ check_sync_grammar_explain_min_time_interval);
		} else {
			check_sync_grammar_explain_min_time_interval = 1000 * 60 * 5;
		}
	}
	//
	public static final String SDCARD_DIR = Environment
			.getExternalStorageDirectory().toString() + File.separator;
	public static final String SAVE_PATH = SDCARD_DIR + "Satgrammar/";
	//
	public static final File cache_dir;
	public static final File note_local_img_dir;
	public static final File temp_note_take_picture_file;
	//
	static {
		cache_dir = makeDir(SAVE_PATH);
		note_local_img_dir = makeDir(SAVE_PATH + "note");
		temp_note_take_picture_file = makeFile(SAVE_PATH + "temp_note_img");
	}

	private static File makeDir(String path) {
		File fileDir = new File(path);
		if (!fileDir.exists()) { // 若不存在
			fileDir.mkdir();
		}
		if (DEBUG) {
			Log.d(TAG, "create dir:" + fileDir.getAbsolutePath()
					+ " file exists:" + fileDir.exists() + "  is a dir:"
					+ fileDir.isDirectory());
		}
		return fileDir;
	}

	private static File makeFile(String path) {
		File file = new File(path);
		if (!file.exists()) { // 若不存在
			try {
				file.createNewFile();
			} catch (IOException e) {
				e.printStackTrace();
			}
		}
		if (DEBUG) {
			Log.d(TAG,
					"create file:" + file.getAbsolutePath() + " file exists:"
							+ file.exists() + "  is a file:" + file.isFile());
		}
		return file;
	}

	//
	public static final int empty_version = -1;
	public static final int empty_id = -1;
	//
	public static final int note_content_max_length = 100;
	//
	public static final int note_img_max_width = 500;
	public static final int note_img_max_height = 500;
	public static final int note_img_compress_qulity = 90;
	//
	public static final int search_result_count_msg_show_time = 3000;
	//
	// need-config-for diffs package
	// test
	// public static final String BAIDU_PUSH_APIKEY="Z2OlGf4AiAOEaRtO0ZDPR7vL";
	// 正式
	public static final String ACTION_NOTE_DB_CHANGED = "com.yuanda.satgrammar.action_note_db_change";
	public static final String ACTION_GRAMMAR_WHOLE_VERSION_CHANGED = "com.yuanda.satgrammar.action_grammar_whole_version_changed";
	public static final String ACTION_LOGIN_USER_CHANGED = "com.yuanda.satgrammar.action_login_user_changed";
	public static final String ACTION_STUDY_PLAN_CHANGED = "com.yuanda.satgrammar.study_plan_changed";
	// need-config-for diffs package end
	// static {
	// MobclickAgent.setDebugMode(DEBUG);
	// }
}
