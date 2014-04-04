package com.commov.app.dv.model.event;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

import com.commov.app.dv.db.roscopeco.ormdroid.Column;
import com.commov.app.dv.db.roscopeco.ormdroid.Entity;

public class Event extends Entity implements Serializable {
    private static final long serialVersionUID = 1L;
    @Column(primaryKey = true)
    public int id;
    public String title;
    public String image;
    public String content;
    public String time;
    public int applyNum;// 参加的人数
    public String uuid;
    public long createdAt;
    public boolean hasApplied;

    public Event() {

    }

    public boolean isFavorite() {
        return favorite;
    }

    public void setFavorite(boolean favorite) {
        this.favorite = favorite;
    }

    public boolean favorite;

    public String getImage() {
        return image;
    }

    public void setImage(String image) {
        this.image = image;
    }

    public int getApplyNum() {
        return applyNum;
    }

    public void setApplyNum(int applyNum) {
        this.applyNum = applyNum;
    }

    public String getUuid() {
        return uuid;
    }

    public void setUuid(String uuid) {
        this.uuid = uuid;
    }

    public long getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(long createdAt) {
        this.createdAt = createdAt;
    }

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

    public String getPath() {
        return image;
    }

    public void setPath(String path) {
        this.image = path;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public boolean isHasApplied() {
        return hasApplied;
    }

    public void setHasApplied(boolean hasApplied) {
        this.hasApplied = hasApplied;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public static List<Event> getDummyList() {
        List<Event> eventList = new ArrayList<Event>();
        for (int i = 1; i <= 20; i++) {
            Event event = new Event();
            event.setTitle("Digital Village Opening Party  NO." + i);
            event.setTime("2014年1月" + i + "日 09:30");
            event.setApplyNum(i + 30);
            eventList.add(event);
        }
        return eventList;
    }
}
