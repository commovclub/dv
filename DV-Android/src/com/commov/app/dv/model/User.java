package com.commov.app.dv.model;

import com.google.gson.annotations.SerializedName;

/**
 * 用户信息结构
 */
public class User {
	@SerializedName("uid")
	private String uid;// string /Grammar用户系统的uid，非第三方uid
	@SerializedName("username")
	private String username;
	@SerializedName("loginType")
	private String loginType;// string暂时支持 sina,qq

	
	private String userId;
	private String message;
	
	public String getUid() {
		return uid;
	}

	public void setUid(String uid) {
		this.uid = uid;
	}

	public String getUsername() {
		return username;
	}

	public void setUsername(String username) {
		this.username = username;
	}

	public String getLoginType() {
		return loginType;
	}

	public void setLoginType(String loginType) {
		this.loginType = loginType;
	}

	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}

	public String getMessage() {
		return message;
	}

	public void setMessage(String message) {
		this.message = message;
	}
	
}
