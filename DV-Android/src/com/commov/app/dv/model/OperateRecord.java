package com.commov.app.dv.model;

/**
 * 操作记录行为
 */
public interface OperateRecord {
	/** 添加操作 */
	public static final String OPERATE_ADD = "A";
	/** 更新操作 */
	public static final String OPERATE_UPDATE = "U";
	/** 删除操作 */
	public static final String OPERATE_DELTE = "D";
	/** 未知的操作 */
	public static final String OPERATE_UNKNOW = "-1";
}
