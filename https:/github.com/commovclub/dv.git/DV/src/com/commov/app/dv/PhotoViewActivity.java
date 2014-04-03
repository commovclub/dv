/*******************************************************************************
 * Copyright 2011, 2012 Chris Banes.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *******************************************************************************/
package com.commov.app.dv;

import java.util.ArrayList;
import java.util.List;

import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.support.v4.view.PagerAdapter;
import android.support.v4.view.ViewPager;
import android.support.v4.view.ViewPager.OnPageChangeListener;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.view.ViewGroup.LayoutParams;
import android.view.animation.Animation;
import android.view.animation.AnimationUtils;
import android.widget.ImageButton;
import android.widget.TextView;

import com.commov.app.dv.utils.ImageUtility;
import com.commov.app.dv.widget.photoview.HackyViewPager;
import com.commov.app.dv.widget.photoview.PhotoView;

public class PhotoViewActivity extends BaseActivity implements OnClickListener,
		OnPageChangeListener {

	public final static String KEY_IMAGE_ARRAY = "key_image_array";
	public final static String KEY_IMAGE_START_POSITION = "key_image_start_position";
	private ViewPager mViewPager;
	private TextView imgIndexInfo;
	private ArrayList<String> mImages;
	private ImageButton saveIB;

	@SuppressWarnings("unchecked")
	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);

		setContentView(R.layout.activity_photoview);
		mViewPager = (HackyViewPager) findViewById(R.id.hacky_viewpager);
		imgIndexInfo = (TextView) findViewById(R.id.img_index_info);
		saveIB = (ImageButton) findViewById(R.id.ib_save);
		saveIB.setOnClickListener(new OnClickListener(){

            @Override
            public void onClick(View v) {
                //TODO
                //String imagePath = mImages.get(mViewPager.getCurrentItem());
                //Utils.Toast(PhotoViewActivity.this, "已经保存到相册");
            }
		    
		});
		Bundle bundle = getIntent().getExtras();
		if (bundle == null) {
			finish();
		}
		Object obj = bundle.getSerializable(KEY_IMAGE_ARRAY);
		if (obj instanceof ArrayList == false) {
			finish();
		} else {
			mImages = (ArrayList<String>) obj;
		}
		if (mImages == null || mImages.size() <= 0) {
			finish();
		}
		int position = bundle.getInt(KEY_IMAGE_START_POSITION);
		mViewPager.setOnPageChangeListener(this);
		mViewPager.setAdapter(new SamplePagerAdapter(mImages));
		mViewPager.setCurrentItem(position, false);
		showImgIndexInfo(position, false);
	}

	private void showImgIndexInfo(int index, boolean useAnim) {
		int i = index + 1;
		int total = mImages.size();
		if (i <= 0) {
			i = 1;
		} else if (i > total) {
			i = total;
		}
		imgIndexInfo.setText(i + "/" + total);
		if (useAnim) {
			imgIndexInfo.startAnimation(getImgIndexInfoShowAnim());
		}
	}

	private Animation imgIndexShowAnim;

	private Animation getImgIndexInfoShowAnim() {
		if (imgIndexShowAnim == null) {
			imgIndexShowAnim = AnimationUtils.loadAnimation(this,
					R.anim.img_index_show);
		}
		return imgIndexShowAnim;
	}

	class SamplePagerAdapter extends PagerAdapter {
		private List<String> images;

		public SamplePagerAdapter(List<String> mLStrings) {
			this.images = mLStrings;
		}

		@Override
		public int getCount() {
			if (images == null)
				return 0;
			return images.size();

		}

		@Override
		public View instantiateItem(ViewGroup container, int position) {
			final PhotoView photoView = new PhotoView(container.getContext());
			String imagePath = images.get(position);
			ImageUtility.loadImage(photoView, imagePath, 0,
					R.drawable.placeholder, false);
			// Now just add PhotoView to ViewPager and return it
			container.addView(photoView, LayoutParams.MATCH_PARENT,
					LayoutParams.MATCH_PARENT);
			return photoView;
		}

		@Override
		public void destroyItem(ViewGroup container, int position, Object object) {
			PhotoView view = (PhotoView) object;
			ImageUtility.cancelAqueryLoad(view, true);
			container.removeView(view);
		}

		@Override
		public boolean isViewFromObject(View view, Object object) {
			return view == object;
		}

	}

	@Override
	public void onClick(View v) {
	}

	@Override
	public void onPageScrollStateChanged(int arg0) {

	}

	@Override
	public void onPageScrolled(int arg0, float arg1, int arg2) {

	}

	@Override
	public void onPageSelected(int arg0) {
		showImgIndexInfo(arg0, false);
	}

	public static boolean start(Context context, ArrayList<String> imgsPath,
			int startShowPosition) {
		if (context == null || imgsPath == null) {
			return false;
		}
		Intent intent = new Intent(context, PhotoViewActivity.class);
		intent.putStringArrayListExtra(KEY_IMAGE_ARRAY, imgsPath);
		intent.putExtra(KEY_IMAGE_START_POSITION, startShowPosition);
		context.startActivity(intent);
		return true;
	}
}
