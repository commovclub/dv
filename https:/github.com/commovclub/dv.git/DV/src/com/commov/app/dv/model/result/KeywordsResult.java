package com.commov.app.dv.model.result;

import java.util.List;

import com.commov.app.dv.model.Keyword;
import com.commov.app.dv.model.Result;
import com.google.gson.annotations.SerializedName;

public class KeywordsResult extends Result {
	@SerializedName("keywords")
	private List<Keyword> keywords;
	@SerializedName("wholeVersion")
	private int wholeVersion;

	public List<Keyword> getKeywords() {
		return keywords;
	}

	public void setKeywords(List<Keyword> keywords) {
		this.keywords = keywords;
	}

	public int getWholeVersion() {
		return wholeVersion;
	}

	public void setWholeVersion(int wholeVersion) {
		this.wholeVersion = wholeVersion;
	}

}
