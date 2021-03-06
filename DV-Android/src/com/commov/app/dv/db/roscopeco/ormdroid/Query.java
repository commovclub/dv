package com.commov.app.dv.db.roscopeco.ormdroid;

import java.util.List;

import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;
import android.util.Log;

import com.commov.app.dv.DVApp;
import com.commov.app.dv.db.roscopeco.ormdroid.Entity.EntityMapping;



/**
 * <p>
 * Represents and assists with building a database query that will load an
 * object (or graph). Mostly this class will be used indirectly via the
 * {@link Entity#query} method.
 * </p>
 * 
 * <p>
 * Example usage:
 * </p>
 * 
 * <ul>
 * <li>MyModel m = {@link Entity#query Entity.query}(MyModel.class).
 * {@link #where where}({@link #eql eql}("id", 1)).{@link #execute execute}()</li>
 * <li>MyModel m = {@link Entity#query Entity.query}(MyModel.class).
 * {@link #where where}({@link #eql eql}("name", "Joe")).{@link #execute
 * execute}()</li>
 * <li>List<MyModel> l = {@link Entity#query Entity.query}(MyModel.class).
 * {@link #where where}({@link #eql eql}("city", "London")).
 * {@link #executeMulti() executeMulti}()</li>
 * <li>List<MyModel> l = {@link Entity#query Entity.query}(MyModel.class).
 * {@link #executeMulti executeMulti}()</li>
 * <li>MyModel m = {@link Entity#query Entity.query}(MyModel.class).
 * {@link #where where}({@link #and and}({@link #eql eql}("name", "Joe"),
 * {@link #eql eql}("city", "London"))).{@link #execute execute}()</li>
 * </ul>
 */
public class Query<T extends Entity> {
	private static final String TAG = "Query";

	static interface SQLExpression {
		String generate();
	}

	static class BinExpr implements SQLExpression {
		static final String EQ = " = ";
		static final String NE = " != ";
		static final String LT = " < ";
		static final String GT = " > ";
		static final String LEQ = " <= ";
		static final String GEQ = " >= ";

		final String op;
		final String column;
		final Object value;

		public BinExpr(String op, String column, Object value) {
			this.op = op;
			this.column = column;
			this.value = value;
		}

		@Override
		public String generate() {
			return column + op + value;
		}
	}

	static class LogicalExpr implements SQLExpression {
		final String op;
		final SQLExpression lhs, rhs;

		public LogicalExpr(String op, SQLExpression lhs, SQLExpression rhs) {
			this.op = op;
			this.lhs = lhs;
			this.rhs = rhs;
		}

		@Override
		public String generate() {
			StringBuilder sb = new StringBuilder();
			sb.append("(").append(lhs.generate()).append(" ").append(op)
			        .append(" ").append(rhs.generate()).append(")");
			return sb.toString();
		}
	}

	private static StringBuilder joinStrings(StringBuilder sb,
	        String... strings) {
		if (strings.length < 1) {
			return sb.append("*");
		} else {
			sb.append(strings[0]);
			for (int i = 1; i < strings.length; i++) {
				sb.append(", ").append(strings[i]);
			}
			return sb;
		}
	}

	private final Class<T> mClass;
	private final EntityMapping mEntityMapping;
	private String sqlCache, sqlCache1;
	private SQLExpression whereExpr;
	private String[] orderByColumns;
	private int limit = -1;

	public Query(Class<T> clz) {
		mEntityMapping = Entity.getEntityMapping(mClass = clz);
	}

	public static <T extends Entity> Query<T> query(Class<T> clz) {
		return new Query<T>(clz);
	}

	public static SQLExpression eql(String column, Object value) {
		return new BinExpr(BinExpr.EQ, column, TypeMapper.encodeValue(null,
		        value));
	}

	public static SQLExpression neq(String column, Object value) {
		return new BinExpr(BinExpr.NE, column, TypeMapper.encodeValue(null,
		        value));
	}

	public static SQLExpression lt(String column, Object value) {
		return new BinExpr(BinExpr.LT, column, TypeMapper.encodeValue(null,
		        value));
	}

	public static SQLExpression gt(String column, Object value) {
		return new BinExpr(BinExpr.GT, column, TypeMapper.encodeValue(null,
		        value));
	}

	public static SQLExpression leq(String column, Object value) {
		return new BinExpr(BinExpr.LEQ, column, TypeMapper.encodeValue(null,
		        value));
	}

	public static SQLExpression geq(String column, Object value) {
		return new BinExpr(BinExpr.GEQ, column, TypeMapper.encodeValue(null,
		        value));
	}

	public static SQLExpression and(SQLExpression lhs, SQLExpression rhs) {
		return new LogicalExpr("AND", lhs, rhs);
	}

	public static SQLExpression or(SQLExpression lhs, SQLExpression rhs) {
		return new LogicalExpr("OR", lhs, rhs);
	}

	public Query<T> where(SQLExpression expr) {
		sqlCache = null;
		sqlCache1 = null;
		whereExpr = expr;
		return this;
	}

	public Query<T> orderBy(String... columns) {
		sqlCache = null;
		sqlCache1 = null;
		orderByColumns = columns;
		return this;
	}

	public Query<T> limit(int limit) {
		sqlCache = null;
		sqlCache1 = null;
		this.limit = limit;
		return this;
	}

	private String generate(int limit) {
		StringBuilder sb = new StringBuilder().append("SELECT * FROM ").append(
		        mEntityMapping.mTableName);
		if (whereExpr != null) {
			sb.append(" WHERE ").append(whereExpr.generate());
		}
		if (orderByColumns != null && orderByColumns.length > 0) {
			joinStrings(sb.append(" ORDER BY "), orderByColumns);
		}
		if (limit > -1) {
			sb.append(" LIMIT ").append(limit);
		}
		return sb.toString();
	}

	public String toSql() {
		if (sqlCache == null) {
			return sqlCache = generate(this.limit);
		} else {
			return sqlCache;
		}
	}

	@Override
	public String toString() {
		return toSql();
	}

	/**
	 * Execute the query on the default database, returning only a single
	 * result. If the query would return multiple results, only the first will
	 * be returned by this method.
	 */
	public T execute() {
		SQLiteDatabase db = DVApp.getDefaultDatabase();
		try {
			return execute(db);
		} finally {
			db.close();
		}
	}

	/**
	 * Execute the query on the specified database, returning only a single
	 * result. If the query would return multiple results, only the first will
	 * be returned by this method.
	 */
	public T execute(SQLiteDatabase db) {
		EntityMapping map = Entity.getEntityMappingEnsureSchema(db, mClass);

		if (sqlCache1 == null) {
			sqlCache1 = generate(1);
		}
		String sql = sqlCache1;
		Log.v(TAG, sql);
		Cursor c = db.rawQuery(sql, null);
		if (c.moveToFirst()) {
			return map.<T> load(db, c);
		} else {
			return null;
		}
	}

	/**
	 * Execute the query on the default database, returning all results.
	 */
	public List<T> executeMulti() {
		SQLiteDatabase db = DVApp.getDefaultDatabase();
		try {
			return executeMulti(db);
		} finally {
			db.close();
		}
	}

	/**
	 * Execute the query on the default database, returning 200 results.
	 */
	public List<T> execute200OrderByIdDesc() {
		SQLiteDatabase db = DVApp.getDefaultDatabase();
		try {
			String sql;
			StringBuilder sb = new StringBuilder().append("SELECT * FROM ")
			        .append(mEntityMapping.mTableName);
			if (whereExpr != null) {
				sb.append(" WHERE ").append(whereExpr.generate());
			}
			sb.append(" ORDER BY id  DESC");

			sb.append(" LIMIT ").append(200);

			sql = sb.toString();
			Log.v(TAG, sql);
			return Entity.getEntityMappingEnsureSchema(db, mClass).loadAll(db,
			        db.rawQuery(sql, null));
		} finally {
			db.close();
		}
	}
	

	/**
	 * Execute the query on the specified database, returning all results.
	 */
	public List<T> executeMulti(SQLiteDatabase db) {
		String sql = toSql();
		Log.v(TAG, sql);
		return Entity.getEntityMappingEnsureSchema(db, mClass).loadAll(db,
		        db.rawQuery(sql, null));
	}
}
