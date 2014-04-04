package com.commov.app.dv.widget;

import android.content.Context;
import android.graphics.drawable.Drawable;
import android.util.AttributeSet;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.widget.FrameLayout;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.commov.app.dv.R;

/**
 * 公用Footer导航
 * 
 * @author skg
 * 
 */
public class CommonHeaderBar extends FrameLayout implements OnClickListener {

	public final static int NAV_BACK = R.drawable.nav_back_norml;
	public final static int NAV_OK = R.drawable.nav_ok_normal;
	//
	private LinearLayout leftBox;
	private LinearLayout rightBox;
	private ViewGroup titleViewBlock;
	private TextView titleView;

	public CommonHeaderBar(Context context, AttributeSet attrs) {
		super(context, attrs);
		init();
	}

	private void init() {
		LayoutInflater.from(getContext()).inflate(R.layout.template_common_bar,
				this, true);
		if (getBackground() == null) {
			setBackgroundResource(R.color.common_header_bar_bg);
		}
		titleViewBlock = (ViewGroup) findViewById(R.id.common_header_title_block);
		titleView = (TextView) findViewById(R.id.common_header_title);
		titleView.setTextColor(R.color.white);
		leftBox = (LinearLayout) findViewById(R.id.common_header_left_box);
		rightBox = (LinearLayout) findViewById(R.id.common_header_right_box);
	}

	@Override
	protected void onLayout(boolean changed, int left, int top, int right,
			int bottom) {
		super.onLayout(changed, left, top, right, bottom);
		int leftOffset = 0;
		int rightOffset = 0;
		View v = findSizeableViewFromEnd(leftBox);
		if (v != null) {
			leftOffset = v.getLeft() + v.getMeasuredWidth();
			v = null;
		}
		v = rightBox.getChildAt(0);
		v = findSizeableViewFromHeader(rightBox);
		if (v != null) {
			rightOffset = getMeasuredWidth() - rightBox.getLeft() - v.getLeft();
		}
		int minOffset = Math.max(leftOffset, rightOffset);
		titleViewBlock.setPadding(minOffset, 0, minOffset, 0);
		titleViewBlock.invalidate();
	}

	private View findSizeableViewFromHeader(ViewGroup vg) {
		int childcount;
		if (vg == null || (childcount = vg.getChildCount()) <= 0) {
			return null;
		}
		for (int i = 0; i < childcount; i++) {
			View v = vg.getChildAt(i);
			if (v.getVisibility() == View.VISIBLE) {
				return v;
			}
		}
		return null;
	}

	private View findSizeableViewFromEnd(ViewGroup vg) {
		int childcount;
		if (vg == null || (childcount = vg.getChildCount()) <= 0) {
			return null;
		}
		for (int i = childcount - 1; i > -1; i--) {
			View v = vg.getChildAt(i);
			if (v.getVisibility() == View.VISIBLE) {
				return v;
			}
		}
		return null;
	}

	public void setTitle(String title) {
		titleView.setText(title);
	}

	public TextView getTitleView() {
		return titleView;
	}

	public void replaceTitleView(View titleView) {
		titleViewBlock.removeAllViews();
		titleViewBlock.addView(titleView);
	}

	public void setTitleTextViewDrawable(Drawable left, Drawable top,
			Drawable right, Drawable bottom) {
		setDrawableBound(left);
		setDrawableBound(top);
		setDrawableBound(right);
		setDrawableBound(bottom);
		titleView.setCompoundDrawables(left, top, right, bottom);
		// 解决低版本sdk不能生效的问题
		titleViewBlock.requestLayout();
		titleViewBlock.invalidate();
	}

	private void setDrawableBound(Drawable d) {
		if (d != null) {
			d.setBounds(0, 0, d.getIntrinsicWidth(), d.getIntrinsicHeight());
		}
	}

	public void setTitle(int titleResId) {
		String titleStr = null;
		try {
			titleStr = getResources().getString(titleResId);
		} catch (Exception e) {
		}
		setTitle(titleStr);
	}

	/**
	 * @see #addFromLeft(int, boolean)
	 */
	public void addFromLeft(int actionId) {
		addFromLeft(actionId, true);
	}

	/**
	 * 从左边开始添加
	 * 
	 * @param actionId
	 * @param defaultShow
	 *            默认是显示还是隐藏
	 */
	public void addFromLeft(int actionId, boolean defaultShow) {
		addFromLeft(actionId, getDefaultVisibleFlag(defaultShow));
	}

	/**
	 * @param actionId
	 * @param visibale
	 *            View的可见属性Gone，Visible，invisible
	 */
	public void addFromLeft(int actionId, int visibale) {
		LayoutInflater inflater = getLayoutInflater();
		View item = createItem(actionId, leftBox, inflater);
		View itemInterval = createItemInterval(leftBox, inflater);
		item.setTag(itemInterval);
		leftBox.addView(item);
		//
		innerChangeNavChildViewVisiable(item, visibale);
		//
		leftBox.addView(itemInterval);
		perItemAdded(item);
	}

	/**
	 * @see #addFromRight(int, boolean)
	 */
	public void addFromRight(int actionId) {
		addFromRight(actionId, true);
	}

	/**
	 * 从右边开始添加
	 * 
	 * @param actionId
	 * @param defaultShow
	 *            默认是显示还是隐藏
	 */
	public void addFromRight(int actionId, boolean defaultShow) {
		addFromRight(actionId, getDefaultVisibleFlag(defaultShow));
	}

	/**
	 * @param actionId
	 * @param visibale
	 *            View的可见属性Gone，Visible，invisible
	 */
	public void addFromRight(int actionId, int visibale) {
		LayoutInflater inflater = getLayoutInflater();
		View item = createItem(actionId, rightBox, inflater);
		View itemInterval = createItemInterval(leftBox, inflater);
		item.setTag(itemInterval);
		//
		innerChangeNavChildViewVisiable(item, visibale);
		rightBox.addView(itemInterval);
		rightBox.addView(item);
		perItemAdded(item);
	}

	private void perItemAdded(View item) {
		// if (item != null) {
		// ViewGroup.LayoutParams lp = item.getLayoutParams();
		// if (lp == null) {
		// lp = new LayoutParams(LayoutParams.WRAP_CONTENT,
		// LayoutParams.MATCH_PARENT);
		// } else {
		// lp.width = LayoutParams.WRAP_CONTENT;
		// lp.height = LayoutParams.WRAP_CONTENT;
		// }
		// item.setBackgroundColor(Color.BLUE);
		// item.setLayoutParams(lp);
		// }
	}

	/**
	 * 修改NAV Item的可见性
	 * 
	 * @param childId
	 * @param show
	 */
	public void changeNavChildVisiable(int childId, boolean show) {
		innerChangeNavChildViewVisiable(findViewById(childId), show);
	}

	public void changeNavChildVisiable(int childId, int visible) {
		innerChangeNavChildViewVisiable(findViewById(childId), visible);
	}

	private void innerChangeNavChildViewVisiable(View v, boolean show) {
		if (v == null) {
			return;
		}
		int targetVisible = getDefaultVisibleFlag(show);
		innerChangeNavChildViewVisiable(v, targetVisible);
	}

	private int getDefaultVisibleFlag(boolean show) {
		return show ? View.VISIBLE : View.INVISIBLE;
	}

	private void innerChangeNavChildViewVisiable(View v, int visible) {
		if (v == null) {
			return;
		}
		checkViewVisible(v, visible);
		if (v.getTag() instanceof View) {
			checkViewVisible((View) v.getTag(), visible);
		}
	}

	private void checkViewVisible(View view, int visibility) {
		if (view != null && view.getVisibility() != visibility) {
			view.setVisibility(visibility);
		}
	}

	/**
	 * 状态监听
	 * 
	 * @author skg
	 * 
	 */
	public interface OnNavgationListener {
		public void onItemClick(View v, int actionId, CommonHeaderBar nav);
	}

	private OnNavgationListener mOnNavigationListener;

	public void setOnNavgationListener(OnNavgationListener listener) {
		mOnNavigationListener = listener;
	}

	public void dismis() {
		if (isShown()) {
			setVisibility(View.GONE);
		}
	}

	public void show() {
		if (!isShown()) {
			setVisibility(View.VISIBLE);
		}
	}

	private View createItem(int actionId, ViewGroup parent,
			LayoutInflater inflater) {
		if (inflater == null) {
			inflater = getLayoutInflater();
		}
		ImageView im = (ImageView) LayoutInflater.from(getContext()).inflate(
				R.layout.template_common_bar_item, parent, false);
		int resId = actionId;
		// im.setImageDrawable(obtainDrawable(actionId));
		im.setImageResource(resId);
		im.setBackgroundResource(R.drawable.btn_bg_color_block_style_1);
		im.setOnClickListener(this);
		im.setId(actionId);
		return im;
	}

	private View createItemInterval(ViewGroup parent, LayoutInflater inflater) {
		if (inflater == null) {
			inflater = getLayoutInflater();
		}
		return inflater.inflate(R.layout.template_common_bar_item_interval,
				parent, false);
	}

	private LayoutInflater getLayoutInflater() {
		return LayoutInflater.from(getContext());
	}

	@Override
	public void onClick(View v) {
		if (mOnNavigationListener != null) {
			mOnNavigationListener.onItemClick(v, v.getId(), this);
		}
	}

	/**
	 * 设置自定义的图片，必须NavItem已经添加成功了才能生效
	 * 
	 * @param navItem
	 * @param faceResId
	 */
	public void setNavItemFace(View navItem, int faceResId) {
		if (navItem instanceof ImageView) {
			((ImageView) navItem).setImageResource(faceResId);
		} else if (navItem != null) {
			navItem.setBackgroundResource(faceResId);
		}
	}

	/**
	 * 设置自定义的图片，必须NavItem已经添加成功了才能生效
	 * 
	 * @param navItemId
	 * @param faceResId
	 */
	public void setNavItemFace(int navItemId, int faceResId) {
		setNavItemFace(findViewById(navItemId), faceResId);
	}

}