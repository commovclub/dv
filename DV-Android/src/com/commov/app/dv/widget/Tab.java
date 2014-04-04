package com.commov.app.dv.widget;

import android.content.Intent;
import android.view.View;
import android.view.ViewGroup;

import com.commov.app.dv.widget.TabContainer.TabTools;

/**
 * Tab
 * 
 * @author skg
 * 
 */
public abstract class Tab {
	private TabTools mTabTools;

	protected void setTabTools(TabTools tabTools) {
		mTabTools = tabTools;
	}

	public abstract void onCreate(ViewGroup bodyParent,
			ViewGroup indicatorParent);

	public abstract void onDestroy();

	/**
	 * 准备要被显示
	 */
	protected void berforShow() {
		// Log.e("ttt1", getClass().getCanonicalName() + "--berforShow");
	}

	/**
	 * 显示完毕
	 */
	protected void onShow() {
		// Log.e("ttt1", getClass().getCanonicalName() + "--onShow");
	}

	/**
	 * 完全消失了
	 */
	protected void onDismissed() {
		// Log.e("ttt1", getClass().getCanonicalName() + "--onDismissed");
	}

	protected void onTabContainerVisibleChanged(boolean isShow) {

	}

	public abstract View getTabBody();

	public abstract View getTabIndicator();

	protected void onActivityResult(int requestCode, int resultCode, Intent data) {
	}

	public void startActivityForResult(Intent intent, int requestCode) {
		if (mTabTools == null) {
			throw new RuntimeException(" Tab Tools is bad");
		}
		mTabTools.startActivityForResult(intent, requestCode);
	}

	public void startActivity(Intent intent) {
		if (mTabTools == null) {
			throw new RuntimeException(" Tab Tools is bad");
		}
		mTabTools.startActivity(intent);
	}
}
