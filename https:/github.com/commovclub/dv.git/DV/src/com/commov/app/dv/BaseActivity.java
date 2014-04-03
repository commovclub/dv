package com.commov.app.dv;

import android.app.Activity;
import android.app.ProgressDialog;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.view.inputmethod.InputMethodManager;

import com.commov.app.dv.conn.ConnectionHelper;
import com.commov.app.dv.utils.SharedPreferencesHelper;
import com.commov.app.dv.widget.ProgressWheel;
import com.umeng.analytics.MobclickAgent;

public abstract class BaseActivity extends Activity {
    // Animation
    public static final int show_from_right2left = R.anim.slide_in_from_right;
    public static final int dismiss_from_left2right = R.anim.slide_out_to_right;
    public static final int no_animation = 0;
    //
    private int mEnterAnim = show_from_right2left;
    private int mExitAnim = dismiss_from_left2right;
    private boolean actAnimEnabled = true;
    private ProgressDialog dialog;
    protected SharedPreferencesHelper sph;
    protected ProgressWheel progressWheel;

    @Override
    protected void onStart() {
        super.onStart();
    }

    @Override
    protected void onResume() {
        super.onResume();
        MobclickAgent.onResume(this);
    }

    @Override
    protected void onPause() {
        super.onPause();
        MobclickAgent.onPause(this);
    }

    @Override
    protected void onStop() {
        super.onStop();
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        sph = new SharedPreferencesHelper(this);
    }

    protected void showLoadingDialog() {
        if (dialog == null) {
            dialog = new ProgressDialog(this);
            dialog.setCancelable(false);
            dialog.setMessage(getString(R.string.comitting));
        }
        if (dialog.isShowing()) {
            return;
        } else {
            dialog.show();
        }
    }

    protected void showLoadingDialog(String message) {
        if (dialog == null) {
            dialog = new ProgressDialog(this);
            dialog.setCancelable(false);
            dialog.setMessage(message);
        }
        if (dialog.isShowing()) {
            return;
        } else {
            dialog.show();
        }
    }

    protected void dismissLoadingDialog() {
        if (dialog == null) {
            return;
        }
        if (dialog.isShowing()) {
            dialog.dismiss();
        }
    }

    public void hideKeyboard() {
        ((InputMethodManager)getSystemService(Context.INPUT_METHOD_SERVICE)).hideSoftInputFromWindow(BaseActivity.this.getCurrentFocus().getWindowToken(), InputMethodManager.HIDE_NOT_ALWAYS);
//        InputMethodManager imm = (InputMethodManager) getSystemService(Context.INPUT_METHOD_SERVICE);  
//        imm.toggleSoftInput(0, InputMethodManager.HIDE_NOT_ALWAYS);  
    }

    public void setCustomActivityAnimState(boolean enable) {
        actAnimEnabled = enable;
    }

    public int getEnterAnim() {
        return mEnterAnim;
    }

    public void setEnterAnim(int enterAnim) {
        mEnterAnim = enterAnim;
    }

    public int getExitAnim() {
        return mExitAnim;
    }

    public void setExitAnim(int exitAnim) {
        mExitAnim = exitAnim;
    }

    @Override
    public void startActivityForResult(Intent intent, int requestCode) {
        super.startActivityForResult(intent, requestCode);
        overridePendingTransitionIn();
    }

    @Override
    public void finish() {
        super.finish();
        overridePendingTransitionOut();
    }

    public void overridePendingTransitionIn() {
        if (actAnimEnabled) {
            super.overridePendingTransition(mEnterAnim, no_animation);
        }
    }

    public void overridePendingTransitionOut() {
        if (actAnimEnabled) {
            super.overridePendingTransition(no_animation, mExitAnim);
        }
    }

    /**
     * 连接帮助类
     * 
     * @return
     */
    public ConnectionHelper getConnection() {
        return ConnectionHelper.obtainInstance();
    }
}
