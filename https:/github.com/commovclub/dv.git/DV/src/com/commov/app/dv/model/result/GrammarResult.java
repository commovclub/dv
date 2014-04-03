package com.commov.app.dv.model.result;

import java.util.List;

import com.commov.app.dv.model.Grammar;
import com.commov.app.dv.model.Result;
import com.google.gson.annotations.SerializedName;

/**
 * 词条结果
 */
public class GrammarResult extends Result {
	@SerializedName("grammars")
	private List<Grammar> grammars;
	@SerializedName("wholeVersion")
	private int wholeVersion;// wholeVersion

	public List<Grammar> getGrammars() {
		return grammars;
	}

	public void setGrammars(List<Grammar> grammars) {
		this.grammars = grammars;
	}

	public int getWholeVersion() {
		return wholeVersion;
	}

	public void setWholeVersion(int wholeVersion) {
		this.wholeVersion = wholeVersion;
	}

}
