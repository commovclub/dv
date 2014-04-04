package com.commov.app.dv.utils;

import com.google.gson.Gson;
import com.google.gson.JsonSyntaxException;

public class GsonUtils {
	private GsonUtils() {
	}

	public static <T> T fromJson(String json, Class<T> t) {
		// TODO need try?
		T result = null;
		if (json != null && t != null) {
			Gson gson = new Gson();
			try {
				result = gson.fromJson(json, t);
			} catch (JsonSyntaxException e) {
			}
		}
		return result;
	}

	public static String toJson(Object obj) {
		String result = null;
		// TODO need try ?
		if (obj != null) {
			Gson gson = new Gson();
			result = gson.toJson(obj);
		}
		return result;
	}
}
