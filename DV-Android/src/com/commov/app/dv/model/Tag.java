package com.commov.app.dv.model;

import java.io.Serializable;

import com.google.gson.annotations.SerializedName;

/**
 * 标签信息结构
 */
public class Tag implements Serializable {
	private static final long serialVersionUID = -6277608085734044451L;
	@SerializedName("tagId")
	private int id;// tagId//标签ID/int
	@SerializedName("tagName")
	private String tagName;// tagName//标签名称/string
	@SerializedName("tagDesc")
	private String tagDesc;// tagDesc//标签描述/string
	@SerializedName("version")
	private int version;// version//标签版本/int
	@SerializedName("lastOperate")
	private String lastOperate;// lastOperate//最后的操作(A:增加 U：更新 D:删除 )

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public String getTagName() {
		return tagName;
	}

	public void setTagName(String tagName) {
		this.tagName = tagName;
	}

	public String getTagDesc() {
		return tagDesc;
	}

	public void setTagDesc(String tagDesc) {
		this.tagDesc = tagDesc;
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

}
