package com.commov.app.dv.model.result;

import java.util.List;

import com.commov.app.dv.model.Result;
import com.commov.app.dv.model.Tag;
import com.google.gson.annotations.SerializedName;

public class TagResult extends Result {
	@SerializedName("tags")
	private List<Tag> tags;
	@SerializedName("whole_version")
	private int wholeVersion;

	public List<Tag> getTags() {
		return tags;
	}

	public void setTags(List<Tag> tags) {
		this.tags = tags;
	}

	public int getWholeVersion() {
		return wholeVersion;
	}

	public void setWholeVersion(int wholeVersion) {
		this.wholeVersion = wholeVersion;
	}

}
