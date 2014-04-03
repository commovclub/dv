package com.commov.app.dv.model.result;

import java.util.List;

import com.commov.app.dv.model.GrammarExplain;
import com.commov.app.dv.model.Result;
import com.google.gson.annotations.SerializedName;

public class GrammarExplainResult extends Result {
	@SerializedName("maxUpdateTime")
	private String maxUpdateTime;
	@SerializedName("explainList")
	private List<GrammarExplain> explainList;

	public List<GrammarExplain> getExplainList() {
		return explainList;
	}

	public void setExplainList(List<GrammarExplain> explainList) {
		this.explainList = explainList;
	}

	public String getMaxUpdateTime() {
		return maxUpdateTime;
	}

	public void setMaxUpdateTime(String maxUpdateTime) {
		this.maxUpdateTime = maxUpdateTime;
	}

}
