package com.commov.app.dv.widget;

import java.util.List;

import android.content.Context;
import android.content.res.TypedArray;
import android.graphics.drawable.Drawable;
import android.util.AttributeSet;
import android.view.View;
import android.view.ViewGroup;
import android.view.animation.AccelerateDecelerateInterpolator;
import android.widget.LinearLayout;
import android.widget.Scroller;

import com.commov.app.dv.R;

/**
 * Tab指示器
 * 
 * @author skg
 * 
 */
public class TabIndicator extends LinearLayout {
	private TabBox tabBox;
	private View indexBox;
	private View indexView;
	private Scroller mScroller;
	private int tabCount;
	private int tabWidth;
	private Drawable dividerDrawable;
	private int dividerWidth;

	public TabIndicator(Context context, AttributeSet attrs) {
		super(context, attrs);
		TypedArray a = context.obtainStyledAttributes(attrs,
				R.styleable.TabIndicator);
		Drawable d = a.getDrawable(R.styleable.TabIndicator_tabDivider);
		dividerWidth = a.getDimensionPixelSize(
				R.styleable.TabIndicator_tabDividerWidth, -1);
		a.recycle();
		setTabDividerDrawable(d);
		//
		init();
	}

	public TabIndicator(Context context) {
		super(context);
		init();
	}

	private void init() {
		setOrientation(VERTICAL);
		mScroller = new Scroller(getContext(),
				new AccelerateDecelerateInterpolator());
		tabBox = new TabBox(getContext());
		LayoutParams lp = new LayoutParams(LayoutParams.MATCH_PARENT,
				LayoutParams.WRAP_CONTENT);
		int tabBoxIndex = 0;
		if (indexBox != null) {
			int tempIndex = indexOfChild(indexBox);
			if (tempIndex > -1) {
				tabBoxIndex = tempIndex - 1;
			}
		}
		addView(tabBox, tabBoxIndex, lp);
	}

	protected ViewGroup getIndicatorParent() {
		return tabBox;
	}

	@Override
	protected void onFinishInflate() {
		super.onFinishInflate();
		indexBox = findViewById(R.id.tab_container_scroll_box);
		indexView = findViewById(R.id.tab_container_index_view);
	}

	public final int DividerViewID = -1000;

	@SuppressWarnings("deprecation")
	private View createDivider() {
		View v = new View(getContext());
		ViewGroup.LayoutParams params = new LayoutParams(getDividerWidth(),
				LayoutParams.MATCH_PARENT);
		v.setLayoutParams(params);
		v.setBackgroundDrawable(dividerDrawable);
		v.setId(DividerViewID);
		return v;
	}

	private int getDividerWidth() {
		if (dividerWidth >= 0) {// 如果xml没有这事那么默认是-1，如果真的设置为0，也是有效的
			return dividerWidth;
		}
		if (dividerDrawable == null) {
			return 0;
		} else {
			return dividerDrawable.getBounds().width();
		}
	}

	public Drawable getTabDividerDrawable() {
		return dividerDrawable;
	}

	@SuppressWarnings("deprecation")
	public void setTabDividerDrawable(Drawable divider) {
		dividerDrawable = divider;
		if (dividerDrawable != null) {
			dividerDrawable.setBounds(0, 0,
					dividerDrawable.getIntrinsicWidth(),
					dividerDrawable.getIntrinsicHeight());
		}
		if (tabBox != null) {
			int childCount = tabBox.getChildCount();
			for (int i = 0; i < childCount; i++) {
				View v = tabBox.getChildAt(i);
				if (v.getId() == DividerViewID) {
					v.setBackgroundDrawable(dividerDrawable);
				}
			}
		}
	}

	@Override
	protected void onMeasure(int widthMeasureSpec, int heightMeasureSpec) {
		super.onMeasure(widthMeasureSpec, heightMeasureSpec);
		configIndexViewSize(tabBox.getMeasuredWidth());
	}

	private void configIndexViewSize(int parentMaxWidth) {
		if (indexView == null) {
			return;
		}
		ViewGroup.LayoutParams lp = indexView.getLayoutParams();
		if (lp == null) {
			return;
		}
		//
		int indexViewWidth = computeTabWitdh(parentMaxWidth);
		tabWidth = indexViewWidth;
		lp.width = indexViewWidth;
		indexView.forceLayout();
		indexView.measure(MeasureSpec.makeMeasureSpec(indexViewWidth,
				MeasureSpec.EXACTLY), MeasureSpec.makeMeasureSpec(
				indexView.getMeasuredHeight(), MeasureSpec.EXACTLY));
		// Log.e("ttt", "on measure:" + indexViewWidth
		// + "  indexView measure width:" + indexView.getMeasuredWidth());
	}

	private static final int scroll_duration = 300;
	private int mSelected;
	private View mSelectedView;

	/**
	 * @param tabIndex
	 */
	public void setCurrentTab(int tabIndex) {
		if (mSelected == tabIndex) {
			return;
		}
		if (tabBox == null) {
			mSelected = tabIndex;
			return;
		}
		int childCount = tabBox.getChildCount();
		if (childCount <= 0) {
			return;
		}
		if (tabIndex < 0) {
			tabIndex = 0;
		} else if (tabIndex >= childCount) {
			tabIndex = childCount - 1;
		}
		if (mSelectedView != null) {
			mSelectedView.setSelected(false);
		}
		mSelectedView = tabBox.getChildAt(tabIndex * 2);
		mSelected = tabIndex;
		mSelectedView.setSelected(true);
		int scrollTargetX = -(tabWidth + getDividerWidth()) * mSelected;
		// Log.e("ttt", "scrollTargetX:" + scrollTargetX + " mSelected:"
		// + mSelected);
		int startScrollX = indexBox.getScrollX();
		mScroller.startScroll(startScrollX, 0, scrollTargetX - startScrollX, 0,
				scroll_duration);
		post(scrollRunnable);
		if (indicatorListener != null) {
			indicatorListener.onStartScrollIndicator(tabIndex, scroll_duration);
		}
	}

	public int getCurrentTab() {
		return mSelected;
	}

	public final static int fps = 1000 / 60;
	private Runnable scrollRunnable = new Runnable() {

		@Override
		public void run() {
			if (mScroller.isFinished()) {
				return;
			}
			mScroller.computeScrollOffset();
			indexBox.scrollTo(mScroller.getCurrX(), indexBox.getScrollY());
			postDelayed(this, fps);
		}
	};

	public interface TabIndicatorListener {
		public void onStartScrollIndicator(int targetTabIndex, int duration);

		public void onSelected(TabIndicator container, int tabIndex);
	}

	private TabIndicatorListener indicatorListener;

	protected void setTabIndicatorListener(TabIndicatorListener l) {
		indicatorListener = l;
	}

	private void configTabItemListener(ViewGroup vg) {
		if (vg == null) {
			return;
		}
		int childCount = vg.getChildCount();
		for (int i = 0; i < childCount; i++) {
			View v = vg.getChildAt(i);
			if (v.getId() != DividerViewID) {
				v.setOnClickListener(new TabClickListener(i));
			}
		}
	}

	private class TabClickListener implements OnClickListener {
		private final int index;

		TabClickListener(int index) {
			this.index = index;
		}

		@Override
		public void onClick(View v) {
			if (indicatorListener != null) {
				indicatorListener.onSelected(TabIndicator.this, index);
			}
			setCurrentTab(index);
		}
	}

	protected void initTabIndicator(List<Tab> tabs) {
		tabBox.initTabIndicator(tabs);
	}

	class TabBox extends LinearLayout {

		public TabBox(Context context, AttributeSet attrs) {
			super(context, attrs);
			init();
		}

		public TabBox(Context context) {
			super(context);
			init();
		}

		private void init() {
			setOrientation(HORIZONTAL);
		}

		protected void initTabIndicator(List<Tab> tabs) {
			if (tabs != null) {
				for (Tab t : tabs) {
					View v = t.getTabIndicator();
					ViewGroup.LayoutParams tempLp = v.getLayoutParams();
					LayoutParams lp;
					if (!(tempLp instanceof LayoutParams)) {
						lp = generateDefaultLayoutParams();
						v.setLayoutParams(lp);
					} else {
						lp = (LayoutParams) tempLp;
					}
					addViewInLayout(v, -1, lp, true);
				}
				configTabItemListener(tabBox);
				// 添加diver
				tabCount = 0;
				if (tabBox != null) {
					tabCount = tabBox.getChildCount();
					int end = tabCount - 1;
					int offset = 0;
					for (int i = 0; i < end; i++) {
						tabBox.addView(createDivider(), offset + i + 1);
						offset++;
					}
				}
				requestLayout();
				invalidate();
			}
		}

		@Override
		protected void onMeasure(int widthMeasureSpec, int heightMeasureSpec) {
			// 设置好每个view的size
			int childCount = getChildCount();
			if (childCount > 0) {
				int dividerWidth = getDividerWidth();
				int maxWidth = MeasureSpec.getSize(widthMeasureSpec);
				int tabWidth = computeTabWitdh(maxWidth);
				//
				for (int i = 0; i < childCount; i++) {
					View v = getChildAt(i);
					ViewGroup.LayoutParams lp = v.getLayoutParams();
					if (v.getId() == DividerViewID) {
						lp.width = dividerWidth;
					} else {
						lp.width = tabWidth;
					}
				}
			}
			super.onMeasure(widthMeasureSpec, heightMeasureSpec);
		}
	}

	private int computeTabWitdh(int parentMaxWidth) {
		if (tabBox == null) {
			return 0;
		}
		int childCount = tabBox.getChildCount();
		int dividerWidth = getDividerWidth();
		int tabCount = (childCount + 1) / 2;
		int dividerCount = tabCount - 1;
		return (parentMaxWidth - dividerCount * dividerWidth) / tabCount;
	}

}
