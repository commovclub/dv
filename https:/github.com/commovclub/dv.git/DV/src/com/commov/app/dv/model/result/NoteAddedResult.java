package com.commov.app.dv.model.result;

import com.commov.app.dv.model.Result;
import com.commov.app.dv.model.StudyPlan;
import com.google.gson.annotations.SerializedName;

public class NoteAddedResult extends Result {
	@SerializedName("noteId")
	private int noteId;
	@SerializedName("studyPlan")
	private StudyPlan studyPlan;
	@SerializedName("studyPlanWholeVersion")
	private int studyPlanWholeVersion;

	public int getNoteId() {
		return noteId;
	}

	public void setNoteId(int noteId) {
		this.noteId = noteId;
	}

	public StudyPlan getStudyPlan() {
		return studyPlan;
	}

	public void setStudyPlan(StudyPlan studyPlan) {
		this.studyPlan = studyPlan;
	}

	public int getStudyPlanWholeVersion() {
		return studyPlanWholeVersion;
	}

	public void setStudyPlanWholeVersion(int studyPlanWholeVersion) {
		this.studyPlanWholeVersion = studyPlanWholeVersion;
	}

}
