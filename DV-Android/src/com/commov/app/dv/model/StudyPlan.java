package com.commov.app.dv.model;

import com.commov.app.dv.common.CommonParam;
import com.google.gson.annotations.SerializedName;

/**
 * 学习计划
 */
public class StudyPlan {
	public static final int state_waitting_review = 0;
	public static final int state_archiv = 1;
	@SerializedName("id")
	private int id = CommonParam.empty_id;// id/int
	@SerializedName("state")
	private int state;// state////知识点状态// value (0,1)。0:待复习，1:归档
	@SerializedName("grammarId")
	private int grammarId;// grammarId//词条id
	@SerializedName("version")
	private int version = CommonParam.empty_version;// version//每次修改，version都会递增/int/0,1,2…
	@SerializedName("createTime")
	private long createTime;
	//
	public static final int LOCAL_STATE_NORMAL = 0;
	public static final int LOCAL_STATE_DELETED = 1;
	private int localState = LOCAL_STATE_NORMAL;//
	private String ownerUid;

	public StudyPlan() {

	}

	public StudyPlan(int grammarId, int state, long createTime) {
		this.grammarId = grammarId;
		this.state = state;
		this.createTime = createTime;
	}

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public int getState() {
		return state;
	}

	public void setState(int state) {
		this.state = state;
	}

	public int getGrammarId() {
		return grammarId;
	}

	public void setGrammarId(int grammarId) {
		this.grammarId = grammarId;
	}

	public int getVersion() {
		return version;
	}

	public void setVersion(int version) {
		this.version = version;
	}

	public long getCreateTime() {
		return createTime;
	}

	public void setCreateTime(long createTime) {
		this.createTime = createTime;
	}

	/**
	 * 获取本地的状态
	 * 
	 * @return
	 */
	public int getLocalState() {
		return localState;
	}

	/**
	 * 设置本地的状态
	 */
	public void setLocalState(int localState) {
		this.localState = localState;
	}

	public String getOwnerUid() {
		return ownerUid;
	}

	public void setOwnerUid(String ownerUid) {
		this.ownerUid = ownerUid;
	}

}
