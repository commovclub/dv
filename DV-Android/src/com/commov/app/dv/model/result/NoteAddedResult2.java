package com.commov.app.dv.model.result;

import com.commov.app.dv.model.Result;
import com.google.gson.annotations.SerializedName;

public class NoteAddedResult2 extends Result {
	@SerializedName("noteId")
	private int noteId;
	@SerializedName("studyPlanId")
	private int studyPlanId;
	@SerializedName("state")
	private int state;
	@SerializedName("version")
	private int version;
	@SerializedName("noteCreateTime")
	private long noteCreateTime;
	@SerializedName("wholeVersion")
	private int wholeVersion;
	@SerializedName("grammarId")
	private int grammarId;
	@SerializedName("studyPalnVersion")
	private int studyPalnVersion;
	@SerializedName("studyPalnWholeVersion")
	private int studyPalnWholeVersion;
	@SerializedName("studyPlanCreateTime")
	private long studyPlanCreateTime;

	public int getNoteId() {
		return noteId;
	}

	public void setNoteId(int noteId) {
		this.noteId = noteId;
	}

	public int getStudyPlanId() {
		return studyPlanId;
	}

	public void setStudyPlanId(int studyPlanId) {
		this.studyPlanId = studyPlanId;
	}

	public int getState() {
		return state;
	}

	public void setState(int state) {
		this.state = state;
	}

	public int getVersion() {
		return version;
	}

	public void setVersion(int version) {
		this.version = version;
	}

	public long getNoteCreateTime() {
		return noteCreateTime;
	}

	public void setNoteCreateTime(long noteCreateTime) {
		this.noteCreateTime = noteCreateTime;
	}

	public int getWholeVersion() {
		return wholeVersion;
	}

	public void setWholeVersion(int wholeVersion) {
		this.wholeVersion = wholeVersion;
	}

	public int getGrammarId() {
		return grammarId;
	}

	public void setGrammarId(int grammarId) {
		this.grammarId = grammarId;
	}

	public int getStudyPalnVersion() {
		return studyPalnVersion;
	}

	public void setStudyPalnVersion(int studyPalnVersion) {
		this.studyPalnVersion = studyPalnVersion;
	}

	public int getStudyPalnWholeVersion() {
		return studyPalnWholeVersion;
	}

	public void setStudyPalnWholeVersion(int studyPalnWholeVersion) {
		this.studyPalnWholeVersion = studyPalnWholeVersion;
	}

	public long getStudyPlanCreateTime() {
		return studyPlanCreateTime;
	}

	public void setStudyPlanCreateTime(long studyPlanCreateTime) {
		this.studyPlanCreateTime = studyPlanCreateTime;
	}

}
