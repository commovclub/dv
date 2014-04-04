package com.commov.app.dv.db.roscopeco.ormdroid;

public class ORMDroidException extends RuntimeException {
  private static final long serialVersionUID = -7532838248066730353L;

  public ORMDroidException() {
  }

  public ORMDroidException(String detailMessage) {
    super(detailMessage);
  }

  public ORMDroidException(Throwable throwable) {
    super(throwable);
  }

  public ORMDroidException(String detailMessage, Throwable throwable) {
    super(detailMessage, throwable);
  }
}
