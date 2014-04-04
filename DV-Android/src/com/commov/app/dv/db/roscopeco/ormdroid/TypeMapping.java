package com.commov.app.dv.db.roscopeco.ormdroid;

import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;

/**
 * A mapping between Java types and SQL data. Implementations
 * of this interface are registered with the {@link TypeMapper}
 * class.
 */
public interface TypeMapping {
  /**
   * @return the Java type this mapping handles.
   */
  public Class<?> javaType();
  
  /**
   * @return the SQL type for the specified concrete Java type.
   */
  public String sqlType(Class<?> concreteType);

  /**
   * <p>Encode the specified value for storage in the database (i.e. for insertion
   * into an SQL INSERT or UPDATE statement).</p>
   * 
   * <p><strong>Note</strong>: The supplied database parameter may be null. If
   * this is the case then the framework does not expect any persistence to
   * take place during the call. Implementations <strong>must</strong> account
   * for this possibility, and <strong>may</strong> throw a sensible exception
   * (e.g. IllegalArgumentException) to indicate that they cannot handle the 
   * specified object without a database handle.</p>
   * 
   * <p>For an example of this, see {@link EntityTypeMapping}, which uses the 
   * database to persist transient objects. When the mapper is called during
   * query creation (with a null database) an exception is thrown, indicating
   * that it does not make sense to query for records matching a transient
   * object.</p>
   * 
   *  
   * @param db The {@link SQLiteDatabase} to use, or <code>null</code>.
   * @param value The value to encode.
   * 
   * @return An SQL compatible value string, suitably escaped for insertion into an SQL statement.
   */
  public String encodeValue(SQLiteDatabase db, Object value);
  
  /**
   * <p>Decode the specified SQL data to a Java object.</p>
   *  
   * @param db The {@link SQLiteDatabase} to use, or <code>null</code>.
   * @param expectedType The Java type the framework expects in return.
   * @param c The database cursor to read from.
   * @param columnIndex The column index containing the data.
   * @return An instance of <code>expectedType</code> representing the data.
   */
  public Object decodeValue(SQLiteDatabase db, Class<?> expectedType, Cursor c, int columnIndex);
}