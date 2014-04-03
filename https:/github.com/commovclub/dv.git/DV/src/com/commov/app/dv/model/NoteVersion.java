package com.commov.app.dv.model;

import com.commov.app.dv.common.CommonParam;

public class NoteVersion {
	private String uid;
	private int noteWholeVersion = CommonParam.empty_whole_version;
	private int studyPlanWholeVersion = CommonParam.empty_whole_version;

	public String getUid() {
		return uid;
	}

	public void setUid(String uid) {
		this.uid = uid;
	}

	public int getNoteWholeVersion() {
		// return noteWholeVersion;
		// 当前study plan whole version 和 note whole version 使用同一个版本号
		return studyPlanWholeVersion;
	}

	public void setNoteWholeVersion(int noteWholeVersion) {
		this.noteWholeVersion = noteWholeVersion;
	}

	public int getStudyPlanWholeVersion() {
		return studyPlanWholeVersion;
	}

	public void setStudyPlanWholeVersion(int studyPlanWholeVersion) {
		this.studyPlanWholeVersion = studyPlanWholeVersion;
	}

}
