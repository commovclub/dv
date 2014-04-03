package com.commov.app.dv.model.result;

import com.commov.app.dv.model.Result;
import com.google.gson.annotations.SerializedName;

public class UpdateResult extends Result {
	@SerializedName("needUpdate")
	private int needUpdate;// 是否需要升级（0：不需要、1：需要）
	@SerializedName("updateInfo")
	private String updateInfo;
	@SerializedName("downloadUrl")
	private String downloadUrl;

	public int getNeedUpdate() {
		return needUpdate;
	}

	public void setNeedUpdate(int needUpdate) {
		this.needUpdate = needUpdate;
	}

	public String getUpdateInfo() {
		return updateInfo;
	}

	public void setUpdateInfo(String updateInfo) {
		this.updateInfo = updateInfo;
	}

	public String getDownloadUrl() {
		return downloadUrl;
	}

	public void setDownloadUrl(String downloadUrl) {
		this.downloadUrl = downloadUrl;
	}

}
