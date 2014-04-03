package com.commov.app.dv.adapter;

import java.util.List;

import android.database.DataSetObserver;
import android.widget.BaseAdapter;

public abstract class InnerBaseAdapter<Data> extends BaseAdapter {
    private List<Data> mData;
	private List<Data> mBannerData;

	@Override
	public void unregisterDataSetObserver(DataSetObserver observer) {
		if (observer != null) {
			super.unregisterDataSetObserver(observer);
		}
	}

	public void setData(List<Data> data, boolean notifyDataSetChanged) {
		mData = data;
		if (notifyDataSetChanged) {
			notifyDataSetChanged();
		}
	}

	public void setData(List<Data> data, List<Data> bannerData,
			boolean notifyDataSetChanged) {
		mData = data;
		mBannerData = bannerData;
		if (notifyDataSetChanged) {
			notifyDataSetChanged();
		}
	}

	@Override
	public int getCount() {
		if (mData == null) {
			return 0;
		}
		return mData.size();
	}

	@Override
	public Object getItem(int position) {
		return getData(position);
	}

	public Data getData(int position) {
		if (mData != null && position >= 0 && position < mData.size()) {
			return mData.get(position);
		}
		return null;
	}
	
	public List<Data> getData() {
		return mData;
	}
	
	public List<Data> getBannerData() {
		return mBannerData;
	}

	public void setmBannerData(List<Data> mBannerData) {
		this.mBannerData = mBannerData;
	}

	@Override
	public long getItemId(int position) {
		return 0;
	}
}
