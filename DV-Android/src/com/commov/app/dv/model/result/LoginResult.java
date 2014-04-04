package com.commov.app.dv.model.result;

import com.commov.app.dv.model.Result;
import com.google.gson.annotations.SerializedName;

public class LoginResult extends Result {
	// private User user;
	@SerializedName("uid")
	private String uid;

	public String getUid() {
		return uid;
	}

	public void setUid(String uid) {
		this.uid = uid;
	}

}
