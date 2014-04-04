package com.commov.app.dv.model.result;

import java.util.List;

import com.commov.app.dv.model.GrammarExplain;
import com.commov.app.dv.utils.Utils;
import com.google.gson.annotations.SerializedName;

public class GrammarExplainSyncResult extends SyncResult<GrammarExplain> {
	@SerializedName("maxUpdateTime")
	private String maxUpdateTime;
	@SerializedName("haveUpdate")
	private int haveUpdate;

	public boolean isHaveUpdate() {
		return Utils.intToBool(haveUpdate);
	}

	public void setHaveUpdate(boolean haveUpdate) {
		this.haveUpdate = Utils.boolToInt(haveUpdate);
	}

	public int getChangedCount() {
		int count = 0;
		List<?> list = getSyncFind();
		if (list != null) {
			count += list.size();
		}
		return count + getNewOrUpdateCount();
	}

	public int getNewOrUpdateCount() {
		int count = 0;
		List<?> list = getSyncFind();
		if (list != null) {
			count += list.size();
		}
		list = getSyncUpdate();
		if (list != null) {
			count += list.size();
		}
		return count;
	}

	public String getMaxUpdateTime() {
		return maxUpdateTime;
	}

	public void setMaxUpdateTime(String maxUpdateTime) {
		this.maxUpdateTime = maxUpdateTime;
	}

}
