package com.commov.app.dv.common;

import java.net.URLEncoder;
import java.util.List;

import org.apache.http.NameValuePair;
import org.apache.http.message.BasicNameValuePair;

import android.content.Context;

import com.commov.app.dv.model.Note;
import com.commov.app.dv.utils.Utils;

/**
 * 服务器接口
 */
public class ServerAPI {
	private ServerAPI() {
	}

	public static String prefix = CommonParam.server_info_prefix;// 服务器接口地址
	private static String REQUEST_COMMON_PARAMS;// 请求公用携带参数
	private static final String URL_NEWS_LIST = "info/list/%s?pageNumber%s&pageSize=10";//token uuid, pageNumber
	private static final String URL_NEWS_DETAIL = "info/%s";//

	private static final String URL_EVENT_LIST = "event/list/%s?pageNumber%s&pageSize=10";//token
	private static final String URL_EVENT_DETAIL = "event/%s/%s";
	private static final String URL_CONTACT_LIST = "member/list/%s?";//token
	private static final String URL_CONTACT = "member/%s";//token
	private static final String URL_LOGIN = "member/login";

	/**
	 * 新闻列表
	 */
	public static String newList(Context context,int pageNumber) {
		return obtainUrl(context, prefix, URL_NEWS_LIST, ServerAPI.getToken(context),pageNumber);
	}
	
	/**
	 * 新闻详细
	 */
	public static String newsDetail(Context context, String uuid) {
		return obtainUrl(context, prefix, URL_NEWS_DETAIL, uuid);
	}
	
	/**
	 * 活动列表
	 */
	public static String eventList(Context context,int pageNumber) {
		return obtainUrl(context, prefix, URL_EVENT_LIST, ServerAPI.getToken(context),pageNumber);
	}
	
	/**
	 * 活动详细
	 */
	public static String eventDetail(Context context, String uuid, String userId) {
		return obtainUrl(context, prefix, URL_EVENT_DETAIL, uuid,userId);
	}
	
	/**
	 * 人员列表
	 */
	public static String contactList(Context context) {
		return obtainUrl(context, prefix, URL_CONTACT_LIST, ServerAPI.getToken(context));
	}
	
	/**
	 *login
	 */
	public static String login(Context context) {
		return obtainUrl(context, prefix, URL_LOGIN);
	}
	
	private static String getToken(Context context){
		return "test_token";
	}

	// TODO是否不需要同步studyplan，note，这个时候只需要同步知识架构就可以了
	private static final String refer_checkSync = "sync/checkSync.intf?keywordWholeVersion=%s&tagWholeVersion=%s&grammarWholeVersion=%s&studyPlanWholeVersion=%s&uid=%s";
	private static final String refer_getAllKeywords = "keyword/getAllKeywords.intf?";
	private static final String refer_syncKeywords = "keyword/syncKeywords.intf?wholeVersion=%s";
	private static final String refer_getAllTags = "grammar/getAllTags.intf?";
	private static final String refer_syncTags = "grammar/syncTags.intf?wholeVersion=%s";
	private static final String refer_getAllGrammars = "grammar/getAllGrammars.intf?";
	private static final String refer_syncGrammars = "grammar/syncGrammars.intf?wholeVersion=%s";
	private static final String refer_getGrammarExplain = "grammar/getGrammarExplain.intf?grammarId=%s";
	private static final String refer_syncGrammarExplain = "grammar/syncGrammarExplain.intf?grammarId=%d&maxUpdateTime=%s&action=%s";
	private static final String refer_thirdPartLogin = "user/thirdPartLogin.intf?provider=%s&uid=%s&username=%s&nickName=%s";
	private static final String refer_logout = "user/logout.intf?uid=%s";
	private static final String refer_syncNote = "note/syncNote.intf?";
	private static final String refer_addNote = "note/addNote.intf?";
	private static final String refer_deleteNote = "note/deleteNote.intf?uid=%s&noteId=%s";
	private static final String refer_syncStudyPlay = "note/syncStudyPlay.intf?";
	private static final String refer_deleteStudyPlan = "note/deleteStudyPlan.intf?uid=%s&studyPlanId=%s";
	private static final String refer_updateStudyPlay = "note/updateStudyPlay.intf?uid=%s&studyPlanId=%s&state=%s";
	//
	private static final String refer_feedback = "soft/feedback.intf?content=%s&uid=%s";
	private static final String refer_updateVersion = "soft/updateVersion.intf?platform=%s&version=%s";
	//
	private static final String refer_app_help_page = "soft/softHelp.intf?";
	private static final String refer_app_relief_explain_page = "soft/reliefExplain.intf?";

	/**
	 * 检查同步信息状态
	 * 
	 * @param context
	 * @param keywordWholeVersion
	 * @param tagWholeVersion
	 * @param grammarWholeVersion
	 * @param studyPlanWholeVersion
	 * @param uid
	 * @return
	 */
	public static String checkSync(Context context,
			Integer keywordWholeVersion, Integer tagWholeVersion,
			Integer grammarWholeVersion, Integer studyPlanWholeVersion,
			String uid) {
		return obtainUrl(context, prefix, refer_checkSync, keywordWholeVersion,
				tagWholeVersion, grammarWholeVersion, studyPlanWholeVersion,
				uid);
	}

	/**
	 * 获取所有关键字
	 */
	public static String getAllKeywords(Context context) {
		return obtainUrl(context, prefix, refer_getAllKeywords);
	}

	/**
	 * 同步Keywords
	 */
	public static String syncKeywords(Context context, int tagWholeVersion) {
		return obtainUrl(context, prefix, refer_syncKeywords, tagWholeVersion);
	}

	/**
	 * 获取Tags
	 */
	public static String getAllTags(Context context) {
		return obtainUrl(context, prefix, refer_getAllTags);
	}

	/**
	 * 同步Tag
	 */
	public static String syncTags(Context context, int keywordWholeVersion) {
		return obtainUrl(context, prefix, refer_syncTags, keywordWholeVersion);
	}

	/**
	 * 获取所有词条
	 */
	public static String getAllGrammars(Context context) {
		return obtainUrl(context, prefix, refer_getAllGrammars);
	}

	/**
	 * 同步词条
	 */
	public static String syncGrammars(Context context, int wholeVersion) {
		return obtainUrl(context, prefix, refer_syncGrammars, wholeVersion);
	}

	/**
	 * 获取词条解析
	 */
	public static String getGrammarExplain(Context context, int grammarId) {
		return obtainUrl(context, prefix, refer_getGrammarExplain, grammarId);
	}

	public static final int action_grammar_explain_just_check = 0;
	public static final int action_grammar_explain_update = 1;

	/**
	 * 同步词条解释
	 */
	public static String syncGrammarExplain(Context context, int grammarId,
			String maxUpdateTime, int action) {
		return obtainUrl(context, prefix, refer_syncGrammarExplain, grammarId,
				maxUpdateTime, action);
	}

	/**
	 * 第三方用户登录
	 * 
	 * @param uid
	 *            第三方用户UID
	 */
	public static String thirdPartLogin(Context context, String provider,
			String uid, String username, String nickName) {
		return obtainUrl(context, prefix, refer_thirdPartLogin, provider, uid,
				username, nickName);
	}

	/**
	 * 退出登录
	 * 
	 * @param context
	 * @param uid
	 *            系统内部UID不是第三方用户的UID
	 * @return
	 */
	public static String logout(Context context, String uid) {
		return obtainUrl(context, prefix, refer_logout, uid);
	}

	/**
	 * 同步笔记
	 * 
	 * <pre>
	 * POST
	 * </pre>
	 */
	public static String syncNote(Context context, String uid,
			int noteWholeVersion, List<NameValuePair> postDataOut) {
		if (postDataOut != null) {
			postDataOut.add(new BasicNameValuePair("uid", uid));
			postDataOut.add(new BasicNameValuePair("noteWholeVersion", String
					.valueOf(noteWholeVersion)));
		}
		return obtainUrl(context, prefix, refer_syncNote);
	}

	// uid 用户id String 必须
	// note Note 的JSON格式字符串
	// noteImage
	/**
	 * 添加笔记
	 * 
	 * <pre>
	 * Post
	 * upload image name:noteImage
	 * </pre>
	 */
	public static String addNote(Context context, String uid, Note note,
			List<NameValuePair> postData) {
		if (postData != null) {
			postData.add(new BasicNameValuePair("uid", uid));
			if (note != null) {
				postData.add(new BasicNameValuePair("grammarId", String
						.valueOf(note.getGrammarId())));
				postData.add(new BasicNameValuePair("type", String.valueOf(note
						.getType())));
				if (note.getType() == Note.CONTENT_TYPE_TEXT) {
					postData.add(new BasicNameValuePair("content", String
							.valueOf(note.getContent())));
				}
				postData.add(new BasicNameValuePair("createTime", String
						.valueOf(note.getNoteCreateTime())));
			}
		}
		return obtainUrl(context, prefix, refer_addNote);
	}

	/**
	 * 删除笔记
	 * 
	 * @param uid
	 *            自己用户系统的用户uid
	 * @param noteId
	 */
	public static String deleteNote(Context context, String uid, int noteId) {
		return obtainUrl(context, prefix, refer_deleteNote, uid, noteId);
	}

	/**
	 * 同步学习笔记
	 * 
	 * <pre>
	 * POST
	 * </pre>
	 */
	public static String syncStudyPlay(Context context, String uid,
			int studyPlanWholeVersion, List<NameValuePair> postDataOut) {
		if (postDataOut != null) {
			postDataOut.add(new BasicNameValuePair("uid", uid));
			postDataOut.add(new BasicNameValuePair("studyPlanWholeVersion",
					String.valueOf(studyPlanWholeVersion)));
		}
		return obtainUrl(context, prefix, refer_syncStudyPlay);
	}

	/**
	 * 删除学习计划
	 * 
	 * @param uid
	 *            自己用户系统的用户uid
	 */
	public static String deleteStudyPlan(Context context, String uid,
			int studyPlanId) {
		return obtainUrl(context, prefix, refer_deleteStudyPlan, uid,
				studyPlanId);
	}

	/**
	 * 修改学习计划
	 */
	public static String updateStudyPlay(Context context, String uid,
			int studyPlanId, int newState) {
		return obtainUrl(context, prefix, refer_updateStudyPlay, uid,
				studyPlanId, newState);
	}

	/**
	 * 意见反馈
	 */
	public static String feedback(Context context, String content, String uid) {
		return obtainUrl(context, prefix, refer_feedback, content, uid);
	}

	/**
	 * 升级
	 */
	public static String updateVersion(Context context, String platform,
			String version) {
		return obtainUrl(context, prefix, refer_updateVersion, platform,
				version);
	}

	/**
	 * 帮户页面
	 */
	public static String getAppHelpPage(Context context) {
		return obtainUrl(context, prefix, refer_app_help_page);
	}

	/**
	 * 免责说明页面
	 */
	public static String getAppReliefExplainPage(Context context) {
		return obtainUrl(context, prefix, refer_app_relief_explain_page);
	}

	private static String obtainUrl(Context context, String urlPrefix,
			String pathRefer, Object... formatValues) {
		if (formatValues != null) {
			int length = formatValues.length;
			for (int i = 0; i < length; i++) {
				Object obj = formatValues[i];
				if (obj == null) {
					formatValues[i] = "";
				} else if (obj instanceof String) {
					obj = URLEncoder.encode((String) obj);
					formatValues[i] = obj;
				}
			}
		}
		StringBuffer strBuffer = new StringBuffer(urlPrefix);
		strBuffer.append(String.format(pathRefer, formatValues));
//		if (strBuffer.lastIndexOf("?") != (strBuffer.length() - 1)) {// 最后一位不是"?"
//			strBuffer.append('&');
//		}
		//strBuffer.append(getDeviceParams(context));
		return strBuffer.toString();
	}

	/**
	 * 获取数据接口的公用URL参数
	 * 
	 * @return
	 */
	private static String getDeviceParams(Context context) {
		if (REQUEST_COMMON_PARAMS == null) {
			StringBuffer strBuffer = new StringBuffer();
			strBuffer.append("ver=");// 版本号
			strBuffer.append(Utils.getAppVersionName(context));
			strBuffer.append("&dev=");// 设备类型(iphone, ipad, android)
			strBuffer.append(URLEncoder.encode(CommonParam.DEVICE_TAG));
			REQUEST_COMMON_PARAMS = strBuffer.toString();
		}
		return REQUEST_COMMON_PARAMS;
	}

	// private static String linkWithTag(int[] vars, String tag) {
	// String voteStr = "";
	// if (tag == null) {
	// tag = ",";
	// }
	// if (vars != null && vars.length > 0) {
	// int size = vars.length;
	// for (int i = 0; i < size; i++) {
	// voteStr += vars[i] + tag;
	// }
	// int index = voteStr.lastIndexOf(tag);
	// if (index > 0) {
	// voteStr = voteStr.substring(0, index);
	// }
	// }
	// return voteStr;
	// }
}
