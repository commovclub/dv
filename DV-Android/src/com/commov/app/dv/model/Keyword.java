package com.commov.app.dv.model;

import java.io.Serializable;

import com.google.gson.annotations.SerializedName;

/**
 * 关键字
 */
public class Keyword implements Serializable {
	private static final long serialVersionUID = -7375167664464241457L;
	@SerializedName("keywordId")
	private int id;// keywordId//id//int
	@SerializedName("name")
	private String name;// name//关键词名称//string
	@SerializedName("version")
	private int version;// version//关键词版本//int
	@SerializedName("lastOperate")
	private String lastOperate;// 最后的操作//string(A:增加 U：更新 D:删除 )

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
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
