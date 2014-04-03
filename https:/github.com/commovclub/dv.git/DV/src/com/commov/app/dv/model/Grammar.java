package com.commov.app.dv.model;

import java.io.Serializable;
import java.util.List;

import com.google.gson.annotations.SerializedName;

/**
 * 词条结构
 */
public class Grammar implements Serializable {
	private static final long serialVersionUID = -5023035437375323767L;
	@SerializedName("grammarId")
	private int id;// grammarId//词条id/int
	@SerializedName("title")
	private String title;// title//string
	@SerializedName("grammarTagId")
	private int grammarTagId;// grammarTagId//语法标签id/int
	@SerializedName("explainQuantity")
	private int explainQuantity;// explainQuantity//服务器上词条解析的数量/int
	@SerializedName("version")
	private int version;// version//词条每次修改，version都会递增/int/0,1,2…
	@SerializedName("lastOperate")
	private String lastOperate;// lastOperate//最后测操作行为/String/
	private long createTime;// createTime//创建时间/时间戳
	@SerializedName("lastUpdateTime")
	private long lastUpdateTime;// 最后更新时间/时间戳
	@SerializedName("keyWords")
	private List<Keyword> keywords;// 关联关系
	//
	private Tag tag;

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
	}

	public int getGrammarTagId() {
		return grammarTagId;
	}

	public void setGrammarTagId(int grammarTagId) {
		this.grammarTagId = grammarTagId;
	}

	public int getExplainQuantity() {
		return explainQuantity;
	}

	public void setExplainQuantity(int explainQuantity) {
		this.explainQuantity = explainQuantity;
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

	public long getCreateTime() {
		return createTime;
	}

	public void setCreateTime(long createTime) {
		this.createTime = createTime;
	}

	public long getLastUpdateTime() {
		return lastUpdateTime;
	}

	public void setLastUpdateTime(long lastUpdateTime) {
		this.lastUpdateTime = lastUpdateTime;
	}

	public List<Keyword> getKeywords() {
		return keywords;
	}

	public void setKeywords(List<Keyword> keywords) {
		this.keywords = keywords;
	}

	public Tag getTag() {
		return tag;
	}

	public void setTag(Tag tag) {
		this.tag = tag;
	}

}
