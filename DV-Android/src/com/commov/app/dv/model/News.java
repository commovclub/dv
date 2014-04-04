package com.commov.app.dv.model;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

import com.commov.app.dv.db.roscopeco.ormdroid.Column;
import com.commov.app.dv.db.roscopeco.ormdroid.Entity;

public class News extends Entity implements Serializable {
    private static final long serialVersionUID = 1L;
    @Column(primaryKey = true)
    public int id;
    public String title;
    public String summary;
    private List<DVImage> images;
    public String uuid;
    public long createdAt;
    public String content;

    public String time;
    public String desc;
    public String path;
    public String path2;
    public String path3;
    public int type;
    public boolean favorite;
    public static int ONE_PIC = 1;
    public static int THREE_PIC = 3;
    public static int ZERO_PIC = 0;
    
    public News(){
        
    }

    public String getSummary() {
        return summary;
    }

    public void setSummary(String summary) {
        this.summary = summary;
    }

    public List<DVImage> getImages() {
        return images;
    }

    public void setImages(List<DVImage> images) {
        this.images = images;
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

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getTime() {
        return time;
    }

    public void setTime(String time) {
        this.time = time;
    }

    public String getDesc() {
        return desc;
    }

    public void setDesc(String desc) {
        this.desc = desc;
    }

    public String getPath() {
        return path;
    }

    public void setPath(String path) {
        this.path = path;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public static List<News> getDummyList() {
        List<News> newsList = new ArrayList<News>();
        for (int i = 1; i <= 20; i++) {
            News news = new News();
            news.setTitle("Digital Village 于1月17日举行了声势浩大的Opening Party ： " + i);
            news.setTime("2014年1月" + i + "日");
            news.content = "据央视新闻网报道，COMMOV于1月17日举行了隆重的Opening Party。众多数字界与科技界的大腕级人物出席";
            if (i % 3 == 0) {
                news.type = ONE_PIC;
            } else if (i % 3 == 1) {
                news.type = ZERO_PIC;
            } else if (i % 3 == 2) {
                news.type = THREE_PIC;
            }
            newsList.add(news);
        }
        return newsList;
    }

    public String getPath2() {
        return path2;
    }

    public void setPath2(String path2) {
        this.path2 = path2;
    }

    public String getPath3() {
        return path3;
    }

    public void setPath3(String path3) {
        this.path3 = path3;
    }

    public int getType() {
        return type;
    }

    public void setType(int type) {
        this.type = type;
    }

    public boolean isFavorite() {
        return favorite;
    }

    public void setFavorite(boolean favorite) {
        this.favorite = favorite;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    

}
