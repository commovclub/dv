package com.commov.app.dv.model.result;

import java.util.List;

import com.commov.app.dv.common.CommonParam;
import com.commov.app.dv.model.Result;
import com.google.gson.annotations.SerializedName;

public abstract class SyncResult<T> extends Result {
	@SerializedName("syncFind")
	private List<T> syncFind;
	@SerializedName("syncDelete")
	private List<T> syncDelete;
	@SerializedName("syncUpdate")
	private List<T> syncUpdate;
	@SerializedName("wholeVersion")
	private int wholeVersion = CommonParam.empty_whole_version;

	public List<T> getSyncFind() {
		return syncFind;
	}

	public void setSyncFind(List<T> syncFind) {
		this.syncFind = syncFind;
	}

	public List<T> getSyncDelete() {
		return syncDelete;
	}

	public void setSyncDelete(List<T> syncDelete) {
		this.syncDelete = syncDelete;
	}

	public List<T> getSyncUpdate() {
		return syncUpdate;
	}

	public void setSyncUpdate(List<T> syncUpdate) {
		this.syncUpdate = syncUpdate;
	}

	public int getWholeVersion() {
		return wholeVersion;
	}

	public void setWholeVersion(int wholeVersion) {
		this.wholeVersion = wholeVersion;
	}

	/**
	 * 本地可见的更新数（add，update，不包含delete）
	 * 
	 * @return
	 */
	public int getLocalVisiableUpdateSize() {
		int size = 0;
		if (syncFind != null) {
			size += syncFind.size();
		}
		if (syncUpdate != null) {
			size += syncUpdate.size();
		}
		return size;
	}
}
