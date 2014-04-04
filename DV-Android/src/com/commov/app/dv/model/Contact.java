package com.commov.app.dv.model;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

public class Contact implements Serializable {
	private static final long serialVersionUID = 1L;
	private String realname;
	private String description;
	private String category;
	private String uuid;
	private String title;
	private String weixin;
	private String qq;
	private String phone;
	private List<String> telList = new ArrayList<String>();
	private String province;
	private String city;
	private String address;
	private String tags;
	private List<String> tagList = new ArrayList<String>();
	private String image;
	private String avatar;
	private String birthDay;
	private String location;
	private String gender;
	private boolean hasFollowed;


	public String getRealname() {
		return realname;
	}

	public void setRealname(String realname) {
		this.realname = realname;
	}

	public String getDescription() {
		return description;
	}

	public void setDescription(String description) {
		this.description = description;
	}
	
	public String getCategory() {
		return category;
	}

	public void setCategory(String category) {
		this.category = category;
	}

	public String getUuid() {
		return uuid;
	}

	public void setUuid(String uuid) {
		this.uuid = uuid;
	}

	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
	}

	public String getWeixin() {
		return weixin;
	}

	public void setWeixin(String weixin) {
		this.weixin = weixin;
	}

	public String getQq() {
		return qq;
	}

	public void setQq(String qq) {
		this.qq = qq;
	}

	public String getPhone() {
		return phone;
	}

	public void setPhone(String phone) {
		this.phone = phone;
	}

	public List<String> getTelList() {
		return telList;
	}

	public void setTelList(List<String> telList) {
		this.telList = telList;
	}

	public String getProvince() {
		return province;
	}

	public void setProvince(String province) {
		this.province = province;
	}

	public String getCity() {
		return city;
	}

	public void setCity(String city) {
		this.city = city;
	}

	public String getAddress() {
		return address;
	}

	public void setAddress(String address) {
		this.address = address;
	}

	public String getTags() {
		return tags;
	}

	public void setTags(String tags) {
		this.tags = tags;
	}

	public List<String> getTagList() {
		return tagList;
	}

	public void setTagList(List<String> tagList) {
		this.tagList = tagList;
	}

	public String getImage() {
		return image;
	}

	public void setImage(String image) {
		this.image = image;
	}

	public String getAvatar() {
		return avatar;
	}

	public void setAvatar(String avatar) {
		this.avatar = avatar;
	}

	public String getBirthDay() {
		return birthDay;
	}

	public void setBirthDay(String birthDay) {
		this.birthDay = birthDay;
	}

	public String getLocation() {
		return location;
	}

	public void setLocation(String location) {
		this.location = location;
	}

	public String getGender() {
		return gender;
	}

	public void setGender(String gender) {
		this.gender = gender;
	}

    public boolean isHasFollowed() {
        return hasFollowed;
    }

    public void setHasFollowed(boolean hasFollowed) {
        this.hasFollowed = hasFollowed;
    }

    public static List<Contact> getDummyList() {
		List<Contact> contactList = new ArrayList<Contact>();
		String[] stringArr = { "鸠魔智", "Jim", "慕容博", "阿碧", "郭靖", "黄蓉", "杨过",
				"苗若兰", "令狐冲", "小龙女", "胡斐", "水笙", "任盈盈", "白琇", "狄云", "石破天",
				"殷素素", "张翠山", "张无忌", "青青", "袁冠南", "萧中慧", "袁承志", "乔峰", "王语嫣",
				"段玉", "虚竹", "苏星河", "丁春秋", "庄聚贤", "阿紫", "阿朱", "萧远山", "慕容复",
				"Lily", "Ethan", "DavidSmall", "DavidBig", "James",
				"Kobe Brand", "Kobe Crand" };
		for (int i = 0; i < stringArr.length; i++) {
			Contact contact = new Contact();
			contact.setRealname(stringArr[i]);
			contact.setDescription("Java 软件工程师 NO. " + i + " 先就职于xxxx科技发展有限公司");
			if (i % 3 == 0) {
				contact.setCategory("数字，科技");
			} else if (i % 3 == 1) {
				contact.setCategory("数字");
			} else if (i % 3 == 2) {
				contact.setCategory("科技");
			}
			contact.qq = "1234567";
			contact.weixin = "这是我的微信号";
			List<String> telList = new ArrayList<String>();
			telList.add("1345678900");
			telList.add("010-80009000");
			contact.setTelList(telList);
			contactList.add(contact);

		}
		return contactList;
	}

}
