package com.commov.app.dv.model.result;

import com.commov.app.dv.model.Result;
import com.commov.app.dv.model.UpdateInfo;
import com.google.gson.annotations.SerializedName;

/**
 * 检查同步信息的结果
 */
public class CheckSyncResult extends Result {
	@SerializedName("keyWord")
	private UpdateInfo keyword;
	@SerializedName("tag")
	private UpdateInfo tag;
	@SerializedName("grammar")
	private UpdateInfo grammar;
	@SerializedName("studyPlan")
	private UpdateInfo studyPlan;

	public UpdateInfo getKeyword() {
		return keyword;
	}

	public void setKeyword(UpdateInfo keyword) {
		this.keyword = keyword;
	}

	public UpdateInfo getTag() {
		return tag;
	}

	public void setTag(UpdateInfo tag) {
		this.tag = tag;
	}

	public UpdateInfo getGrammar() {
		return grammar;
	}

	public void setGrammar(UpdateInfo grammar) {
		this.grammar = grammar;
	}

	public UpdateInfo getStudyPlan() {
		return studyPlan;
	}

	public void setStudyPlan(UpdateInfo studyPlan) {
		this.studyPlan = studyPlan;
	}

	public boolean haveUpdate() {
		if (keyword != null && keyword.getUpdateCount() > 0) {
			return true;
		}
		if (tag != null && tag.getUpdateCount() > 0) {
			return true;
		}
		if (grammar != null && grammar.getUpdateCount() > 0) {
			return true;
		}
		if (studyPlan != null && studyPlan.getUpdateCount() > 0) {
			return true;
		}
		return false;
	}

}
