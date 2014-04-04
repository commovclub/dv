package com.commov.app.dv.model.result;

import com.commov.app.dv.model.Result;
import com.google.gson.annotations.SerializedName;

public class StudyPlanWholeVersionResult extends Result {
	@SerializedName("studyPlanWholeVersion")
	private int studyPlanWholeVersion;

	public int getStudyPlanWholeVersion() {
		return studyPlanWholeVersion;
	}

	public void setStudyPlanWholeVersion(int studyPlanWholeVersion) {
		this.studyPlanWholeVersion = studyPlanWholeVersion;
	}

}
