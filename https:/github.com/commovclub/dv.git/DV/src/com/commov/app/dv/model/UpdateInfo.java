package com.commov.app.dv.model;

import com.google.gson.annotations.SerializedName;

public class UpdateInfo {
	@SerializedName("updateCount")
	private int updateCount;// updateCount//表明有多少需要更新
	@SerializedName("wholeVersion")
	private int wholeVersion;// wholeVersion//服务器上最新整体版本号//string

	public UpdateInfo() {
	}

	public UpdateInfo(int updateCount, int wholeVersion) {
		this.updateCount = updateCount;
		this.wholeVersion = wholeVersion;
	}

	public int getUpdateCount() {
		return updateCount;
	}

	public void setUpdateCount(int updateCount) {
		this.updateCount = updateCount;
	}

	public int getWholeVersion() {
		return wholeVersion;
	}

	public void setWholeVersion(int wholeVersion) {
		this.wholeVersion = wholeVersion;
	}

}
