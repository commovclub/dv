package com.commov.app.dv.common;

import android.content.Context;
import android.content.SharedPreferences;

public class Keys {
	private Keys() {
	}

	// 默认组SharedPreferences文件名
	public static final String source = "grammar_keys_value";

	// public final static String whole_version_keyword =
	// "whole_version_keyword";
	// public final static String whole_version_tag = "whole_version_tag";
	// public final static String whole_version_grammar = "whole_version_tag";
	// public final static String whole_version_study_plan =
	// "whole_version_study_plan";
	// //
	// public final static String update_count_keyword = "update_count_keyword";
	// public final static String update_count_tag = "update_count_tag";
	// public final static String update_count_grammar = "update_count_grammar";
	// public final static String update_count_study_plan =
	// "update_count_study_plan";
	// public final static String sync_have_update = "need_sync_total_count";
	//
	public final static String app_grammar = "app_grammar";
	public final static String app_note = "app_note";

	public static SharedPreferences source(Context context) {
		return source(context, source);
	}

	public static SharedPreferences source(Context context, String sourceName) {
		return context.getSharedPreferences(sourceName, Context.MODE_PRIVATE);
	}
}
