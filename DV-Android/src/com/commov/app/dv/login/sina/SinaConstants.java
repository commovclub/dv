package com.commov.app.dv.login.sina;

public final class SinaConstants {
	private SinaConstants() {

	}

	//
	public static final String APP_KEY = "3425851065";
	public static String APP_SECRET = "310a8944819d79f8bb0b3da3100703ec";
	public static final String REDIRECT_URL = "http://www.wordhot.net/satgrammar/callback";
	//
	public static final String SCOPE = "email,direct_messages_read,direct_messages_write,"
			+ "friendships_groups_read,friendships_groups_write,statuses_to_me_read,"
			+ "follow_app_official_microblog";
	private static final String api_get_token_url = "https://api.weibo.com/oauth2/access_token?client_id=%s&client_secret=%s&grant_type=authorization_code&code=%s&redirect_uri=%s";

	public static final String getTokenUrl(String code) {
		return String.format(api_get_token_url, APP_KEY, APP_SECRET, code,
				REDIRECT_URL);
	}
}
