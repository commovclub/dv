package com.commov.app.dv.model;

import java.util.List;

import com.google.gson.annotations.SerializedName;

/**
 * 词条解释
 */
public class GrammarExplain {
	@SerializedName("explainId")
	private int id;// explainId//词条解释id/int
	@SerializedName("grammarId")
	private int grammarId;// grammarId//所属词条id/int
	@SerializedName("title")
	private String title;// 解释标题/string
	@SerializedName("images")
	private List<String> images;
	@SerializedName("content")
	private String content;// content//词条解释内容 /string (html 格式内容片段)
	@SerializedName("createTime")
	private long createTime;// createTime//词条解释创建时间/timestamp
	@SerializedName("lastUpdateTime")
	private long lastUpdateTime;// lastUpdateTime//最后更新时间/timestamp
	@SerializedName("version")
	private int version;// version//解释版本/int
	@SerializedName("lastOperate")
	private String lastOperate;// lastOperate//可能的值( A:增加 U：更新 D:删除)

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

	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
	}

	public List<String> getImages() {
		// images = new ArrayList<String>();
		// images.add("http://c.hiphotos.baidu.com/pic/w%3D230/sign=9bae1c80cc11728b302d8b21f8fdc3b3/72f082025aafa40f01555dccaa64034f78f0190b.jpg");
		// images.add("http://e.hiphotos.baidu.com/album/w%3D2048/sign=75a9d26409fa513d51aa6bde095554fb/359b033b5bb5c9eaf1e8445bd439b6003af3b36b.jpg");
		// images.add("http://b.hiphotos.baidu.com/album/w%3D2048/sign=dfc40d0f7dd98d1076d40b311507b90e/5fdf8db1cb134954f83a7397574e9258d1094a19.jpg");
		// images.add("http://c.hiphotos.baidu.com/album/w%3D2048/sign=df35e18921a446237ecaa262ac1a730e/e850352ac65c1038e1545531b3119313b07e891f.jpg");
		// images.add("http://h.hiphotos.baidu.com/album/w%3D2048/sign=16ca5368b7fd5266a72b3b149f20962b/8326cffc1e178a822e002023f703738da977e871.jpg");
		// images.add("http://g.hiphotos.baidu.com/album/w%3D2048/sign=12b190ebcdbf6c81f7372be88806b035/9345d688d43f87942af13cadd31b0ef41bd53a22.jpg");
		// images.add("http://d.hiphotos.baidu.com/album/w%3D2048/sign=291dcce463d0f703e6b292dc3cc2503d/6159252dd42a28349795acf85ab5c9ea15cebf16.jpg");
		return images;
	}

	public void setImages(List<String> images) {
		this.images = images;
	}

	public String getContent() {
		return content;
	}

	public void setContent(String content) {
		this.content = content;
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

	/**
	 * 同步数据
	 */
	public static final int server_action_sync = 0;
	/**
	 * 仅仅检查是否有更新
	 */
	public static final int server_action_just_check_sync = 1;
}
