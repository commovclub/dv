package com.commov.app.dv.adapter;

import android.content.Context;
import android.content.Intent;
import android.util.Log;
import android.view.GestureDetector;
import android.view.GestureDetector.OnGestureListener;
import android.view.LayoutInflater;
import android.view.MotionEvent;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.view.animation.Animation;
import android.view.animation.AnimationUtils;
import android.widget.AbsListView;
import android.widget.FrameLayout;
import android.widget.ImageView;
import android.widget.ImageView.ScaleType;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.TextView;
import android.widget.ViewFlipper;

import com.androidquery.AQuery;
import com.androidquery.util.Constants;
import com.commov.app.dv.R;
import com.commov.app.dv.activity.DetailActivity;
import com.commov.app.dv.model.event.Event;
import com.commov.app.dv.utils.Utils;
import com.commov.app.dv.widget.CirclePageIndicator;
import com.commov.app.dv.widget.RoundedImageView;

public class EventAdapter extends InnerBaseAdapter<Event> implements OnGestureListener {
	private final static String TAG = "EventAdapter";
	private int showDetailIndex = -1;
	private Context context;
	private static final int FLING_MIN_DISTANCE = 100;  
    private ViewFlipper flipper;  
    private GestureDetector detector;  
	public EventAdapter(final Context context) {
		this.context = context;
        /*
         * 注册一个GestureDetector
         */
	}

	@Override
	public Object getItem(int position) {
		if (this.getBannerData()!=null&&position == 0) {
			return this.getBannerData();
		} else {
			return getData(position);
		}
	}

	@Override
	public int getCount() {
		if (this.getData() == null) {
			return 0;
		}
		return this.getBannerData()!=null?(this.getData().size() + 1):this.getData().size();
	}

	@Override
	public View getView(int position, View convertView, ViewGroup parent) {
		final ViewHolder holder = new ViewHolder(convertView);
		// if (convertView == null) {
		if (this.getBannerData()!=null&&position == 0) {
			convertView = LayoutInflater.from(parent.getContext()).inflate(
					R.layout.list_item_banner, parent, false);
			holder.setRootView(convertView);
			holder.indic = (CirclePageIndicator) convertView
					.findViewById(R.id.viewflowindic);
			holder.viewFlipper = (ViewFlipper) convertView
					.findViewById(R.id.photos);
			holder.banner = (RelativeLayout) convertView
					.findViewById(R.id.rl_banner);
		} else {
			convertView = LayoutInflater.from(parent.getContext()).inflate(
					R.layout.list_item_event, parent, false);
			holder.setRootView(convertView);
		}
		convertView.setTag(holder);

		if (holder.headerBlock == null) {
			int width = Utils.getScreenWidth(context);
			for (int i = 0; i < this.getBannerData().size(); i++) {
				final Event banner = this.getBannerData().get(i);
				ImageView iv = new ImageView(parent.getContext());
				int tempId=134663141+i;
				iv.setId(tempId);
				iv.setScaleType(ScaleType.CENTER_CROP);
				holder.viewFlipper.addView(iv);
				new AQuery(convertView).id(tempId).image(
						banner.getPath(), true, true, 0, Constants.INVISIBLE);
				FrameLayout.LayoutParams params = new FrameLayout.LayoutParams(
						width, width / 2);
				iv.setLayoutParams(params);
				iv.setOnClickListener(new OnClickListener() {
					@Override
					public void onClick(View v) {
						Intent intent = new Intent(context, DetailActivity.class);
						intent.putExtra("event", banner);
						context.startActivity(intent);
					}
				});
			}
			RelativeLayout.LayoutParams params = new RelativeLayout.LayoutParams(
					width, width / 2);
			params.setMargins(0, 0, 0, 9);
			holder.viewFlipper.setLayoutParams(params);
			AbsListView.LayoutParams params2 = new AbsListView.LayoutParams(
					width, width / 2);

			holder.banner.setLayoutParams(params2);
			holder.indic.setViewPager(this.getBannerData().size());
			holder.indic.setCurrentItem(0);
			holder.viewFlipper.setAutoStart(true);
			holder.viewFlipper.setFlipInterval(3 * 1000);
			holder.viewFlipper.startFlipping();
			holder.viewFlipper.getInAnimation().setAnimationListener(
					new Animation.AnimationListener() {
						public void onAnimationStart(Animation animation) {
						}

						public void onAnimationRepeat(Animation animation) {
						}

						public void onAnimationEnd(Animation animation) {
							int displayedChild = holder.viewFlipper
									.getDisplayedChild();
							holder.indic.setCurrentItem(displayedChild);
						}
					});
		} else if (holder.headerBlock != null) {
			final Event event = getData(this.getBannerData()!=null?(position - 1):position);
			holder.headerBlock.setId(position);
			holder.headerBlock.setOnClickListener(onItemClickListener);
			holder.title.setText(event.getTitle());
			holder.lastEditTime.setText(event.getTime());
			holder.count.setText("参加人数：" + event.getApplyNum());
			int width = Utils.getScreenWidth(context);
			width = width / 4;
			LinearLayout.LayoutParams params = new LinearLayout.LayoutParams(
					width, width * 3 / 4);
			params.setMargins(9, 9, 9, 9);
			holder.imageView.setScaleType(ScaleType.CENTER_CROP);
			holder.imageView.setLayoutParams(params);
			if (event.getImage() != null && event.getImage().length() > 0) {
				new AQuery(convertView).id(R.id.iv_avatar).image(
						event.getImage(), true, true, 0, Constants.INVISIBLE);
			}
			holder.headerBlock.setOnClickListener(new OnClickListener() {
				@Override
				public void onClick(View v) {

					Intent intent = new Intent(context, DetailActivity.class);
					intent.putExtra("event", event);
					context.startActivity(intent);
				}
			});

		}
		convertView.setBackgroundResource(R.color.transparent);
		return convertView;
	}
	
	class ViewHolder {
		TextView title;
		TextView lastEditTime;
		TextView count;
		RoundedImageView imageView;
		View rootView;
		View headerBlock;
		ViewFlipper viewFlipper;
		CirclePageIndicator indic;
		RelativeLayout banner;

		public ViewHolder(View rootView) {
			this.rootView = rootView;
			this.init();
		}

		private void init() {
			if (rootView != null) {
				title = (TextView) findView(R.id.tv_title);
				lastEditTime = (TextView) findView(R.id.tv_time);
				count = (TextView) findView(R.id.tv_count);
				headerBlock = findView(R.id.header_block);
				imageView = (RoundedImageView) findView(R.id.iv_avatar);
				if (imageView != null) {
					imageView.setBorderColor(context.getResources().getColor(
							R.color.lightgrey));
					imageView.setBorderWidth(2);
				}
			}
		}

		public View findView(int id) {
			return rootView.findViewById(id);
		}

		public View getRootView() {
			return rootView;
		}

		public void setRootView(View rootView) {
			this.rootView = rootView;
			this.init();
		}

	}
	
	private OnClickListener onItemClickListener = new OnClickListener() {

		@Override
		public void onClick(View v) {
			int targetShowPosition = v.getId();
			if (targetShowPosition == showDetailIndex) {
				showDetailIndex = -1;
			} else {
				showDetailIndex = targetShowPosition;
			}
			notifyDataSetChanged();
		}
	};

	void log(String msg) {
		Log.d(TAG, "" + msg);
	}

	 public boolean onTouchEvent(MotionEvent event) 
	    {  
	        /* 
	         *  将触屏事件交给手势识别类处理  
	         */ 
	        return this.detector.onTouchEvent(event);  
	    }  
	  
	    public boolean onDown(MotionEvent e) {  
	        return false;  
	    }  
	  
	    public void onShowPress(MotionEvent e) {  
	    }  
	  
	    public boolean onSingleTapUp(MotionEvent e) {  
	        return false;  
	    }  
	  
	    public boolean onScroll(MotionEvent e1, MotionEvent e2, float distanceX,  float distanceY) {  
	        return false;  
	    }  
	  
	    public void onLongPress(MotionEvent e) {  
	    }  
	  
	    /* 
	     * 
	     */ 
	    public boolean onFling(MotionEvent e1, MotionEvent e2, float velocityX, float velocityY) 
	    {  
	        boolean is_fling = false; 
	        if (e1.getX() - e2.getX() > FLING_MIN_DISTANCE) 
	        {  
	            /* 
	             * 设置View进入和退出的动画效果  
	             */ 
	            this.flipper.setInAnimation(AnimationUtils.loadAnimation(context,  android.R.anim.fade_in));  
	            this.flipper.setOutAnimation(AnimationUtils.loadAnimation(context,  android.R.anim.fade_out));  
	            this.flipper.showNext();  
	            is_fling = true;  
	        }  
	        if (e1.getX() - e2.getX() < -FLING_MIN_DISTANCE) 
	        {  
	            this.flipper.setInAnimation(AnimationUtils.loadAnimation(context,  android.R.anim.fade_in));  
	            this.flipper.setOutAnimation(AnimationUtils.loadAnimation(context,  android.R.anim.fade_out));  
	            this.flipper.showPrevious();  
	            is_fling = true;  
	        }  
	        return is_fling;  
	    } 

}
