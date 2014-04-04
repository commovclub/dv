package com.commov.app.dv.model;

/**
 * 词条解释跟更新信息
 */
public class GrammarExplainSyncInfo {
	private int grammarId;
	private boolean haveUpdate;
	private String localVersionTag;
	private long lastCheckSyncTime;

	public int getGrammarId() {
		return grammarId;
	}

	public void setGrammarId(int grammarId) {
		this.grammarId = grammarId;
	}

	public boolean isHaveUpdate() {
		return haveUpdate;
	}

	public void setHaveUpdate(boolean haveUpdate) {
		this.haveUpdate = haveUpdate;
	}

	public String getLocalVersionTag() {
		return localVersionTag;
	}

	public void setLocalVersionTag(String localVersionTag) {
		this.localVersionTag = localVersionTag;
	}

	public long getLastCheckSyncTime() {
		return lastCheckSyncTime;
	}

	public void setLastCheckSyncTime(long lastCheckSyncTime) {
		this.lastCheckSyncTime = lastCheckSyncTime;
	}

}
