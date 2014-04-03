package com.commov.app.dv.db.roscopeco.ormdroid;

import android.database.Cursor;
import android.database.DatabaseUtils;
import android.database.sqlite.SQLiteDatabase;

/**
 * <p>Simple {@link TypeMapping} that encodes it's values via the 
 * {@link java.lang.Object#toString()} method.</p>
 * 
 * <p>This is the default mapping, used when no custom mapping
 * is supplied for a given type. As a default, it will map to
 * the <code>VARCHAR</code> data type.</p>
 * 
 * @see TypeMapper#setDefaultMapping(TypeMapping)
 */
public class StringTypeMapping implements TypeMapping {
  private Class<?> mJavaType; 
  private String mSqlType;
  
  public StringTypeMapping(Class<?> type, String sqlType) {
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
    return DatabaseUtils.sqlEscapeString(value.toString());
  }

  @Override
public Object decodeValue(SQLiteDatabase db, Class<?> expectedType, Cursor c, int columnIndex) {
    return c.getString(columnIndex);
  }
}