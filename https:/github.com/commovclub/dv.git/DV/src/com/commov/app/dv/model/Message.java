package com.commov.app.dv.model;

import java.io.Serializable;

import com.commov.app.dv.db.roscopeco.ormdroid.Entity;

public class Message extends Entity implements Serializable {
    private static final long serialVersionUID = 1L;
    private String uuid;
    private String fromMemberId;
    private String fromMemberName;
    private String fromMemberAvatar;
    private String toMemberId;
    private String toMemberName;
    private String toMemberAvatar;
    private String message;
    private String status;// new , read
    private long createdAt;

    public String getUuid() {
        return uuid;
    }

    public void setUuid(String uuid) {
        this.uuid = uuid;
    }

    public String getFromMemberId() {
        return fromMemberId;
    }

    public void setFromMemberId(String fromMemberId) {
        this.fromMemberId = fromMemberId;
    }

    public String getFromMemberName() {
        return fromMemberName;
    }

    public void setFromMemberName(String fromMemberName) {
        this.fromMemberName = fromMemberName;
    }

    public String getFromMemberAvatar() {
        return fromMemberAvatar;
    }

    public void setFromMemberAvatar(String fromMemberAvatar) {
        this.fromMemberAvatar = fromMemberAvatar;
    }

    public String getToMemberId() {
        return toMemberId;
    }

    public void setToMemberId(String toMemberId) {
        this.toMemberId = toMemberId;
    }

    public String getToMemberName() {
        return toMemberName;
    }

    public void setToMemberName(String toMemberName) {
        this.toMemberName = toMemberName;
    }

    public String getToMemberAvatar() {
        return toMemberAvatar;
    }

    public void setToMemberAvatar(String toMemberAvatar) {
        this.toMemberAvatar = toMemberAvatar;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public long getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(long createdAt) {
        this.createdAt = createdAt;
    }
}
