package com.commov.app.dv.db.roscopeco.ormdroid;

import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;

/*
 * TODO: this could be folded into StringTypeMapping, by having a flag that
 * determines whether or not we sqlescape the resulting string...?
 * 
 *     Obviously would make things more difficult when load()ing...
 */
public class NumericTypeMapping implements TypeMapping {
  private Class<?> mJavaType; 
  private String mSqlType;
  
  public NumericTypeMapping(Class<?> type, String sqlType) {
    mJavaType = type;
    mSqlType = sqlType;      
  }

  @Override
public Class<?> javaType() {
    return mJavaType;
  }

  @Override
public String sqlType(Class<?> concreteType) {
    return mSqlType;
  }

  @Override
public String encodeValue(SQLiteDatabase db, Object value) {
    if (value instanceof Boolean) {
      return (Boolean)value ? "1" : "0";
    } else {      
      return value.toString();
    }
  }

  // TODO this will cause exceptions when trying to unbox into smaller types...
  //        or worse, silently lose data... Look into this!
  @Override
public Object decodeValue(SQLiteDatabase db, Class<?> expectedType, Cursor c, int columnIndex) {
    if (expectedType.equals(Boolean.class) || expectedType.equals(boolean.class)) {
      int i = c.getInt(columnIndex);
      return (i == 0) ? false : true;
    } else {
      return c.getInt(columnIndex);
    }
  }
}