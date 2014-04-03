package com.commov.app.dv.model.event;

import java.io.Serializable;
import java.util.List;

public class Arrangement  implements Serializable {
	private static final long serialVersionUID = 1L;
	private String time;
	private String title;
	private String tagline;
	private String uuid;
	private String eventId;
	private String description;
	private String speaker;
	private String speakerIntro;
	private String image;
	private List files;
	public String getTime() {
		return time;
	}
	public void setTime(String time) {
		this.time = time;
	}
	public String getTitle() {
		return title;
	}
	public void setTitle(String title) {
		this.title = title;
	}
	public String getSubTitle() {
		return tagline;
	}
	public void setSubTitle(String subTitle) {
		this.tagline = subTitle;
	}
	public String getTagline() {
		return tagline;
	}
	public void setTagline(String tagline) {
		this.tagline = tagline;
	}
	public String getUuid() {
		return uuid;
	}
	public void setUuid(String uuid) {
		this.uuid = uuid;
	}
	public String getEventId() {
		return eventId;
	}
	public void setEventId(String eventId) {
		this.eventId = eventId;
	}
	public String getSpeaker() {
		return speaker;
	}
	public void setSpeaker(String speaker) {
		this.speaker = speaker;
	}
	public String getSpeakerIntro() {
		return speakerIntro;
	}
	public void setSpeakerIntro(String speakerIntro) {
		this.speakerIntro = speakerIntro;
	}
	public String getImage() {
		return image;
	}
	public void setImage(String image) {
		this.image = image;
	}
	public String getDescription() {
		return description;
	}
	public void setDescription(String description) {
		this.description = description;
	}
	public List getFiles() {
		return files;
	}
	public void setFiles(List files) {
		this.files = files;
	}
	
}
