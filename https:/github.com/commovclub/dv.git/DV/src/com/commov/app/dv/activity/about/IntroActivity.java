package com.commov.app.dv.activity.about;

import java.util.ArrayList;
import java.util.List;

import org.apache.http.NameValuePair;
import org.apache.http.message.BasicNameValuePair;

import android.content.Intent;
import android.graphics.Color;
import android.os.Bundle;
import android.text.Html;
import android.view.GestureDetector;
import android.view.Gravity;
import android.view.MotionEvent;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.View.OnTouchListener;
import android.view.animation.AccelerateInterpolator;
import android.view.animation.AlphaAnimation;
import android.view.animation.Animation;
import android.view.animation.TranslateAnimation;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ImageButton;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;
import android.widget.ViewFlipper;

import com.commov.app.dv.BaseActivity;
import com.commov.app.dv.MainTabActivity;
import com.commov.app.dv.R;
import com.commov.app.dv.common.ServerAPI;
import com.commov.app.dv.conn.ConnectionHelper;
import com.commov.app.dv.conn.ConnectionHelper.RequestReceiver;
import com.commov.app.dv.model.User;
import com.commov.app.dv.utils.SharedPreferencesHelper;
import com.commov.app.dv.utils.Utils;
import com.commov.app.dv.widget.CirclePageIndicator;
import com.google.gson.Gson;

public class IntroActivity extends BaseActivity implements
		GestureDetector.OnGestureListener, OnTouchListener,
		Animation.AnimationListener {
	// 背景flipper
	private ViewFlipper flipper;
	// 标题flipper
	private ViewFlipper textFlipper;
	// 最小响应滑动距离
	private static final int FLING_MIN_DISTANCE = 100;
	private static final int FLING_MIN_VELOCITY = 200;
	private static final int FLING_DURATION = 250;
	private static float ACCVAL = 0.4f;
	private CirclePageIndicator indic;
	private GestureDetector mGestureDetector;

	// 需要显示的介绍背景图片
	private int[] photosList = new int[] { R.drawable.intro1,
			R.drawable.intro2, R.drawable.intro3 };
	// 需要显示的介绍文案，与背景图片配对
	String[] titleText = { "", "", "" };

	// login section
	private Button loginButton, loginActionButton;
	private LinearLayout loginLinearLayout;
	private EditText  userNameET,passwordET;

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_intro);
		sph = new SharedPreferencesHelper(this);
		String userId=sph.getValue(SharedPreferencesHelper.USERID);
		if(userId!=null&&userId.length()>0){
			Intent intent = new Intent(IntroActivity.this,
					MainTabActivity.class);
			IntroActivity.this.startActivity(intent);
			IntroActivity.this.finish();
		}
		textFlipper = (ViewFlipper) findViewById(R.id.titles);
		for (int i = 0; i < photosList.length; i++) {
			TextView tv = new TextView(this);
			tv.setTextSize(25);
			tv.setShadowLayer(1, 1, 1, Color.BLACK);
			String message = titleText[i];
			tv.setText(Html.fromHtml(message));
			tv.setTextColor(android.graphics.Color.WHITE);
			tv.setGravity(Gravity.CENTER);
			textFlipper.addView(tv);
		}
		flipper = (ViewFlipper) findViewById(R.id.photos);
		for (int i = 0; i < photosList.length; i++) {
			ImageView iv = new ImageView(this);
			iv.setBackgroundResource(photosList[i]);
			flipper.addView(iv);
		}
		// 注册一个用于手势识别的类
		mGestureDetector = new GestureDetector(this, this);
		mGestureDetector.setIsLongpressEnabled(true);
		// 给mFlipper设置一个listener
		flipper.setOnTouchListener(this);
		// flipper.getAnimation().setAnimationListener(this);
		textFlipper.setOnTouchListener(this);
		// 允许长按住ViewFlipper,这样才能识别拖动等手势
		flipper.setLongClickable(true);
		textFlipper.setLongClickable(true);
		indic = (CirclePageIndicator) findViewById(R.id.viewflowindic);
		indic.setViewPager(photosList.length);
		indic.setCurrentItem(0);
		// login section
		userNameET = (EditText)this.findViewById(R.id.et_username);
		passwordET = (EditText)this.findViewById(R.id.et_password);
 
		loginActionButton = (Button) this.findViewById(R.id.buttonLoginAction);
		loginActionButton.setOnClickListener(new OnClickListener() {
			@Override
			public void onClick(View v) {
				if(userNameET.getText().toString().trim().length()==0){
					Utils.Toast(IntroActivity.this, "请输入用户名");
					return;
				}
				if(passwordET.getText().toString().trim().length()==0){
					Utils.Toast(IntroActivity.this, "请输入密码");
					return;
				}
				hideKeyboard();
				login();
			}
		});
		ImageButton infoButton = (ImageButton) this
				.findViewById(R.id.buttonInfo);
		infoButton.setOnClickListener(new OnClickListener() {
			@Override
			public void onClick(View v) {
				Intent intent = new Intent(IntroActivity.this,
						InfoActivity.class);
				intent.putExtra("visible_bottombar", "true");
				IntroActivity.this.startActivity(intent);
			}
		});
		loginLinearLayout = (LinearLayout) this
				.findViewById(R.id.ll_loginsection);
		loginButton = (Button) this.findViewById(R.id.buttonLogin);
		loginButton.setOnClickListener(new OnClickListener() {
			@Override
			public void onClick(View v) {
				loginButton.setVisibility(View.INVISIBLE);
				loginLinearLayout.setVisibility(View.VISIBLE);
				indic.setVisibility(View.INVISIBLE);
			}
		});
	}
	
	private void login() {
		//showLoadingDialog();
		String url = ServerAPI.login(IntroActivity.this);
		ConnectionHelper conn = ConnectionHelper.obtainInstance();
		List<NameValuePair> nvp = new ArrayList<NameValuePair>();
		nvp.add(new BasicNameValuePair("username", userNameET.getText().toString().trim()));
		nvp.add(new BasicNameValuePair("password",
				passwordET.getText().toString().trim()));
		conn.httpPost(url, 0,nvp, requestReceiver);
	}

	private RequestReceiver requestReceiver = new RequestReceiver() {

		@Override
		public void onResult(int resultCode, int requestId, String rawResponses) {
			if (resultCode == RESULT_STATE_OK) {
				if (rawResponses != null && rawResponses.length() > 0) {
					User user = new Gson().fromJson(rawResponses, User.class);
					if(user.getUserId()!=null&&user.getUserId().length()>0){
						Utils.Toast(IntroActivity.this, "登陆成功");
						sph.putValue(SharedPreferencesHelper.USERID, user.getUserId());
						sph.commit();
						Intent intent = new Intent(IntroActivity.this,
						        MainTabActivity.class);
						IntroActivity.this.startActivity(intent);
						IntroActivity.this.finish();
					}else{
						Utils.Toast(IntroActivity.this, "登陆失败 " +user.getMessage());
					}
					return;
				}
			}
			Utils.simpleNetBadNotify(IntroActivity.this);
		}
	};

	public boolean onFling(MotionEvent e1, MotionEvent e2, float velocityX,
			float velocityY) {
		if (e1.getX() - e2.getX() > FLING_MIN_DISTANCE
				&& Math.abs(velocityX) > FLING_MIN_VELOCITY) {
			// 当像左侧滑动的时候
			// 设置View进入屏幕时候使用的动画
			flipper.setInAnimation(inAlphaAnimation());
			// 设置View退出屏幕时候使用的动画
			flipper.setOutAnimation(outAlphaAnimation());
			flipper.showNext();
			textFlipper.setInAnimation(inFromRightAnimation());
			textFlipper.setOutAnimation(outToLeftAnimation());
			textFlipper.showNext();
		} else if (e2.getX() - e1.getX() > FLING_MIN_DISTANCE
				&& Math.abs(velocityX) > FLING_MIN_VELOCITY) {
			// 当像右侧滑动的时候
			flipper.setInAnimation(inAlphaAnimation());
			flipper.setOutAnimation(outAlphaAnimation());
			flipper.showPrevious();
			textFlipper.setInAnimation(inFromLeftAnimation());
			textFlipper.setOutAnimation(outToRightAnimation());
			textFlipper.showPrevious();
		}
		return false;
	}

	/**
	 * 定义从右侧进入的动画效果
	 * 
	 * @return
	 */
	protected Animation inFromRightAnimation() {
		Animation inFromRight = new TranslateAnimation(
				Animation.RELATIVE_TO_PARENT, +1.0f,
				Animation.RELATIVE_TO_PARENT, 0.0f,
				Animation.RELATIVE_TO_PARENT, 0.0f,
				Animation.RELATIVE_TO_PARENT, 0.0f);
		inFromRight.setDuration(FLING_DURATION);
		inFromRight.setInterpolator(new AccelerateInterpolator(ACCVAL));
		return inFromRight;
	}

	/**
	 * 定义透明
	 * 
	 * @return
	 */
	protected Animation inAlphaAnimation() {
		Animation inAlphaAnim = new AlphaAnimation(0.1f, 1.0f);
		inAlphaAnim.setDuration(FLING_DURATION);
		inAlphaAnim.setInterpolator(new AccelerateInterpolator(ACCVAL));
		inAlphaAnim.setAnimationListener(this);
		return inAlphaAnim;
	}

	protected Animation outAlphaAnimation() {
		Animation outAlphaAnim = new AlphaAnimation(1.0f, 0.1f);
		outAlphaAnim.setDuration(FLING_DURATION);
		outAlphaAnim.setAnimationListener(this);
		outAlphaAnim.setInterpolator(new AccelerateInterpolator(0.4f));
		return outAlphaAnim;
	}

	/**
	 * 定义从左侧退出的动画效果
	 * 
	 * @return
	 */
	protected Animation outToLeftAnimation() {
		Animation outtoLeft = new TranslateAnimation(
				Animation.RELATIVE_TO_PARENT, 0.0f,
				Animation.RELATIVE_TO_PARENT, -1.0f,
				Animation.RELATIVE_TO_PARENT, 0.0f,
				Animation.RELATIVE_TO_PARENT, 0.0f);
		outtoLeft.setDuration(FLING_DURATION);
		outtoLeft.setInterpolator(new AccelerateInterpolator(ACCVAL));
		return outtoLeft;
	}

	/**
	 * 定义从左侧进入的动画效果
	 * 
	 * @return
	 */
	protected Animation inFromLeftAnimation() {
		Animation inFromLeft = new TranslateAnimation(
				Animation.RELATIVE_TO_PARENT, -1.0f,
				Animation.RELATIVE_TO_PARENT, 0.0f,
				Animation.RELATIVE_TO_PARENT, 0.0f,
				Animation.RELATIVE_TO_PARENT, 0.0f);
		inFromLeft.setDuration(FLING_DURATION);
		inFromLeft.setInterpolator(new AccelerateInterpolator(ACCVAL));
		return inFromLeft;
	}

	/**
	 * 定义从右侧退出时的动画效果
	 * 
	 * @return
	 */
	protected Animation outToRightAnimation() {
		Animation outtoRight = new TranslateAnimation(
				Animation.RELATIVE_TO_PARENT, 0.0f,
				Animation.RELATIVE_TO_PARENT, +1.0f,
				Animation.RELATIVE_TO_PARENT, 0.0f,
				Animation.RELATIVE_TO_PARENT, 0.0f);
		outtoRight.setDuration(FLING_DURATION);
		outtoRight.setInterpolator(new AccelerateInterpolator(ACCVAL));
		return outtoRight;
	}

	@Override
	public boolean onTouch(View arg0, MotionEvent arg1) {
		return mGestureDetector.onTouchEvent(arg1);
	}

	public void onShowPress(MotionEvent e) {
	}

	public boolean onSingleTapUp(MotionEvent e) {
		return true;
	}

	// 用户按下触摸屏，并拖动，由1个MotionEvent ACTION_DOWN, 多个ACTION_MOVE触发
	public boolean onScroll(MotionEvent e1, MotionEvent e2, float distanceX,
			float distanceY) {
		return true;
	}

	// 用户长按触摸屏，由多个MotionEvent ACTION_DOWN触发
	public void onLongPress(MotionEvent e) {
	}

	@Override
	// 用户轻触触摸屏，由1个MotionEvent ACTION_DOWN触发
	public boolean onDown(MotionEvent arg0) {
		return true;
	}

	@Override
	public void onAnimationEnd(Animation arg0) {
		indic.setCurrentItem(flipper.getDisplayedChild());
	}

	@Override
	public void onAnimationRepeat(Animation arg0) {
	}

	@Override
	public void onAnimationStart(Animation arg0) {

	}

}
