package com.commov.app.dv.model;

import java.io.Serializable;
import java.util.List;

public class Work implements Serializable {
    private static final long serialVersionUID = 1L;
    private String uuid;
    private String memberId;
    private String title;
    private String summary;
    private String description;
    private long createdAt;
    private List<DVImage> files;

    public String getUuid() {
	return uuid;
    }

    public void setUuid(String uuid) {
	this.uuid = uuid;
    }

    public String getMemberId() {
	return memberId;
    }

    public void setMemberId(String memberId) {
	this.memberId = memberId;
    }

    public String getTitle() {
	return title;
    }

    public void setTitle(String title) {
	this.title = title;
    }

    public String getSummary() {
	return summary;
    }

    public void setSummary(String summary) {
	this.summary = summary;
    }

    public String getDescription() {
	return description;
    }

    public void setDescription(String description) {
	this.description = description;
    }

    public long getCreatedAt() {
	return createdAt;
    }

    public void setCreatedAt(long createdAt) {
	this.createdAt = createdAt;
    }

    public List<DVImage> getFiles() {
	return files;
    }

    public void setFiles(List<DVImage> files) {
	this.files = files;
    }
}
