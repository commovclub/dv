package com.commov.app.dv.db.roscopeco.ormdroid;

public class TypeMappingException extends RuntimeException {
  private static final long serialVersionUID = 823640983705249637L;

  public TypeMappingException() {
  }

  public TypeMappingException(String detailMessage) {
    super(detailMessage);
  }

  public TypeMappingException(Throwable throwable) {
    super(throwable);
  }

  public TypeMappingException(String detailMessage, Throwable throwable) {
    super(detailMessage, throwable);
  }
}
