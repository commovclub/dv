package com.commov.app.dv.model;

import java.io.File;

import com.commov.app.dv.common.CommonParam;
import com.google.gson.annotations.SerializedName;

/**
 * 笔记内容结构
 * 
 */
public class Note {
	public static final int CONTENT_TYPE_TEXT = 0;
	public static final int CONTENT_TYPE_IMAGE = 1;
	@SerializedName("id")
	private int id = CommonParam.empty_id;// id//int
	@SerializedName("grammarId")
	private int grammarId;// grammarId//词条id
	@SerializedName("type")
	private int type;// type/content类型//value(0,1)。0:text，1:image
	@SerializedName("content")
	private String content;// content//当type=0时,是text，type=1表示image地址
	@SerializedName("version")
	private int version = CommonParam.empty_version;// version////每次修改，version都会递增/int/0,1,2…
	@SerializedName("lastOperate")
	private String lastOperate;// lastOperate//最后测操作行为/String/可能的值(A:增加U：更新D:删除)
	@SerializedName("noteCreateTime")
	private long noteCreateTime;// noteCreateTime////笔记创建的时间，客户端决定/timestamp
	//
	public static final int LOCAL_STATE_NORMAL = 0;
	public static final int LOCAL_STATE_ADD = 1;
	public static final int LOCAL_STATE_DELETE = 2;
	private int localState = LOCAL_STATE_NORMAL;//
	//
	private String ownerUid;

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public int getGrammarId() {
		return grammarId;
	}

	public void setGrammarId(int grammarId) {
		this.grammarId = grammarId;
	}

	public int getType() {
		return type;
	}

	public void setType(int type) {
		this.type = type;
	}

	public String getContent() {
		return content;
	}

	public void setContent(String content) {
		this.content = content;
	}

	public int getVersion() {
		return version;
	}

	public void setVersion(int version) {
		this.version = version;
	}

	public String getLastOperate() {
		return lastOperate;
	}

	public void setLastOperate(String lastOperate) {
		this.lastOperate = lastOperate;
	}

	public long getNoteCreateTime() {
		return noteCreateTime;
	}

	public void setNoteCreateTime(long noteCreateTime) {
		this.noteCreateTime = noteCreateTime;
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

	public File getLocalNoteImageFile() {
		String fileName = Long.toHexString(getNoteCreateTime()) + ".jpg";
		return new File(CommonParam.note_local_img_dir, fileName);
	}

	@Override
	public String toString() {
		return "Note [id=" + id + ", grammarId=" + grammarId + ", type=" + type
				+ ", content=" + content + ", version=" + version
				+ ", lastOperate=" + lastOperate + ", noteCreateTime="
				+ noteCreateTime + ", localState=" + localState + "]";
	}

	// ---------------Note sync---------------//
	@SerializedName("studyPlanId")
	private int studyPlanId;

	/**
	 * 只有同步数据的时候，该值才有效
	 * 
	 * @return
	 */
	public int getSyncStudyPlanId() {
		return studyPlanId;
	}

}
