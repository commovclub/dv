package com.commov.app.dv.widget;

import android.content.Context;
import android.support.v4.view.ViewPager;
import android.util.AttributeSet;
import android.view.MotionEvent;

public class UnScrollViewPager extends ViewPager {

	private boolean isCanScroll = true;

	public UnScrollViewPager(Context context) {
		super(context);
	}

	public UnScrollViewPager(Context context, AttributeSet attrs) {
		super(context, attrs);
	}

	public void setScanScroll(boolean isCanScroll) {
		this.isCanScroll = isCanScroll;
	}

	@Override
	public void scrollTo(int x, int y) {
		if (isCanScroll)
			super.scrollTo(x, y);
	}

	@Override
	public boolean onTouchEvent(MotionEvent arg0) {
		return false;// super.onTouchEvent(arg0);
	}
}
