package com.commov.app.dv.utils;

import com.google.gson.Gson;
import com.google.gson.JsonSyntaxException;

public class JsonUtils {
	private JsonUtils() {
	}

	public static <T> T fromJson(String json, Class<T> t) {
		T result = null;
		if (json != null && t != null) {
			Gson gson = new Gson();
			try {
				result = gson.fromJson(json, t);
			} catch (JsonSyntaxException e) {
				e.printStackTrace();
			}
		}
		return result;
	}

	public static String toJson(Object obj) {
		String result = null;
		if (obj != null) {
			Gson gson = new Gson();
			try {
				result = gson.toJson(obj);
			} catch (JsonSyntaxException e) {
				e.printStackTrace();
			}
		}
		return result;
	}
}
