package com.commov.app.dv.model;

import com.google.gson.annotations.SerializedName;

/**
 * 通用结果
 * 
 * @author skg
 * 
 */
public class Result {
	// 0 操作成功
	public static final int result_code_success = 0;
	// 1 参数无效
	public static final int result_code_param_invalid = 1;
	// 10001 用户token 过期
	public static final int result_code_token_bad = 10001;
	// 20001 词条不存在
	public static final int result_code_section_not_exist = 20001;

	@SerializedName("code")
	private int resultCode = -1;
	@SerializedName("msg")
	private String msg;

	public String getMsg() {
		return msg;
	}

	public int getResultCode() {
		return resultCode;
	}

	/**
	 * 判断响应结果是否是成功的
	 * 
	 * @return
	 */
	public boolean isSuccess() {
		return resultCode == result_code_success;
	}
}
