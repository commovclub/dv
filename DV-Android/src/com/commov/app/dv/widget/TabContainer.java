package com.commov.app.dv.widget;

import java.util.ArrayList;
import java.util.List;

import android.content.Context;
import android.content.Intent;
import android.util.AttributeSet;
import android.view.View;
import android.view.ViewGroup;
import android.view.animation.AccelerateDecelerateInterpolator;
import android.widget.Scroller;

import com.commov.app.dv.widget.TabIndicator.TabIndicatorListener;

/**
 * 可滑动的Tab容器
 * 
 * @author skg
 * 
 */
public class TabContainer extends ViewGroup {
	private TabIndicator mTabIndicator;
	private Scroller mScroller;

	public TabContainer(Context context, AttributeSet attrs) {
		super(context, attrs);
		init();
	}

	public TabContainer(Context context) {
		super(context);
		init();
	}

	private void init() {
		mScroller = new Scroller(getContext(),
				new AccelerateDecelerateInterpolator());
	}

	private final int fps = 1000 / 60;
	private Runnable scrollRunnable = new Runnable() {
		@Override
		public void run() {
			if (mScroller.isFinished()) {
				if (waittingScrollFinish) {
					waittingScrollFinish = false;
					onTabChanged();
				}
				return;
			}
			mScroller.computeScrollOffset();
			scrollTo(mScroller.getCurrX(), getScrollY());
			postDelayed(this, fps);
		}
	};

	protected void onVisibilityChanged(View changedView, int visibility) {
		super.onVisibilityChanged(changedView, visibility);
		if (visibility == View.VISIBLE) {
			for (Tab tab : tabList) {
				tab.onShow();
				tab.onTabContainerVisibleChanged(true);
			}
		} else {
			for (Tab tab : tabList) {
				tab.onDismissed();
				tab.onTabContainerVisibleChanged(false);
			}
		}
	}

	private int currentTabIndex;
	private Tab[] towTabs = new Tab[2];
	private static final int tab_need_show = 0;
	private static final int tab_need_dismis = 1;

	public void setCurrentTab(int tabIndex, boolean anim) {
		if (mTabIndicator != null) {
			mTabIndicator.setCurrentTab(tabIndex);
		}
		scrollTabTo(tabIndex, anim, 300);
	}

	private boolean waittingScrollFinish = false;

	public void scrollTabTo(int tabIndex, boolean anim, int duration) {
		int childCount = getChildCount();
		if (childCount <= 0) {
			return;
		}
		if (tabIndex < 0) {
			tabIndex = childCount - 1;
		} else if (tabIndex >= childCount) {
			tabIndex = 0;
		}
		towTabs[tab_need_dismis] = getCurrentTab();
		currentTabIndex = tabIndex;
		towTabs[tab_need_show] = getCurrentTab();
		if (towTabs[tab_need_dismis] == towTabs[tab_need_show]) {
			towTabs[tab_need_dismis] = null;
		}
		View v = getChildAt(tabIndex);
		int scrollTargetX = v.getLeft();
		int startScrollX = getScrollX();
		if (anim) {
			beforTabChange();
			waittingScrollFinish = true;
			mScroller.startScroll(startScrollX, 0,
					scrollTargetX - startScrollX, 0, duration);
			post(scrollRunnable);
		} else {
			beforTabChange();
			scrollTo(scrollTargetX, getScrollY());
			onTabChanged();
		}
	}

	private void beforTabChange() {
		if (towTabs[tab_need_show] != null) {
			towTabs[tab_need_show].berforShow();
		}
	}

	private void onTabChanged() {
		if (towTabs[tab_need_show] != null) {
			towTabs[tab_need_show].onShow();
		}
		if (towTabs[tab_need_dismis] != null) {
			towTabs[tab_need_dismis].onDismissed();
		}
		towTabs[tab_need_show] = null;
		towTabs[tab_need_dismis] = null;
	}

	public int getCurrentTabIndex() {
		return currentTabIndex;
	}

	public Tab getCurrentTab() {
		if (currentTabIndex < 0 || tabList == null || tabList.size() <= 0) {
			return null;
		}
		if (currentTabIndex < tabList.size()) {
			return tabList.get(currentTabIndex);
		}
		return null;
	}

	private List<Tab> tabList = new ArrayList<Tab>();
	private TabTools mTabTools;

	public void initTabContent(List<Class<? extends Tab>> tabClass,
			TabIndicator tabIndicator, TabTools tabTools) {
		mTabIndicator = tabIndicator;
		mTabTools = tabTools;
		if (mTabIndicator != null) {
			mTabIndicator.setTabIndicatorListener(tabIndicatorListener);
		}
		if (this.tabList != null) {
			removeAllViews();
			tabList.clear();
		}
		if (tabClass == null || tabClass.size() <= 0) {
			return;
		}
		try {
			for (Class<? extends Tab> clz : tabClass) {
				Tab tc = clz.newInstance();
				if (mTabListener != null) {
					mTabListener.onTabCreated(tc);
				}
				tc.setTabTools(mTabTools);
				tabList.add(tc);
				tc.onCreate(this, mTabIndicator.getIndicatorParent());
				View child = tc.getTabBody();
				LayoutParams lp = child.getLayoutParams();
				if (lp == null) {
					lp = generateDefaultLayoutParams();
				} else {
					lp.width = LayoutParams.MATCH_PARENT;
				}
				addViewInLayout(child, -1, lp, true);
			}
			tabIndicator.initTabIndicator(tabList);
			scrollTabTo(tabIndicator.getCurrentTab(), false, 0);
			requestLayout();
			invalidate();
		} catch (InstantiationException e) {
			e.printStackTrace();
		} catch (IllegalAccessException e) {
			e.printStackTrace();
		}
	}

	private TabIndicatorListener tabIndicatorListener = new TabIndicatorListener() {

		@Override
		public void onStartScrollIndicator(int targetTabIndex, int duration) {
			scrollTabTo(targetTabIndex, true, duration);
		}

		@Override
		public void onSelected(TabIndicator container, int tabIndex) {
			if (mTabListener != null) {
				mTabListener.onTabSelectChanged(tabIndex);
			}
		}
	};

	public interface TabListener {
		public void onTabSelectChanged(int tabIndex);

		public void onTabCreated(Tab tab);
	}

	private TabListener mTabListener;

	public void setTabListener(TabListener listener) {
		mTabListener = listener;
	}

	@Override
	protected LayoutParams generateDefaultLayoutParams() {
		return new LayoutParams(LayoutParams.MATCH_PARENT,
				LayoutParams.WRAP_CONTENT);
	}

	@Override
	protected void onLayout(boolean changed, int l, int t, int r, int b) {
		int childCount = getChildCount();
		int cl = 0, ct = 0, cr = 0, cb = 0;
		for (int i = 0; i < childCount; i++) {
			View v = getChildAt(i);
			cr += v.getMeasuredWidth();
			cb = v.getMeasuredHeight();
			v.layout(cl, ct, cr, cb);
			cl = cr;
		}
	}

	@Override
	protected void onMeasure(int widthMeasureSpec, int heightMeasureSpec) {
		super.onMeasure(widthMeasureSpec, heightMeasureSpec);
		int childWms = MeasureSpec.makeMeasureSpec(getMeasuredWidth(),
				MeasureSpec.EXACTLY);
		int childCount = getChildCount();
		int spec = MeasureSpec.makeMeasureSpec(getMeasuredHeight(),
				MeasureSpec.EXACTLY);
		for (int i = 0; i < childCount; i++) {
			View c = getChildAt(i);
			c.measure(childWms,
					getChildMeasureSpec(spec, 0, c.getLayoutParams().height));
		}
	}

	public void dispatchActivityResult(int requestCode, int resultCode,
			Intent data) {
		for (Tab tab : tabList) {
			if (tab != null) {
				tab.onActivityResult(requestCode, resultCode, data);
			}
		}
	}

	public void onDestroy() {
		for (Tab tab : tabList) {
			if (tab != null) {
				tab.onDestroy();
			}
		}
	}

	public interface TabTools {
		public void startActivityForResult(Intent intent, int requestCode);

		public void startActivity(Intent intent);
	}
}
