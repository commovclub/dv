package com.commov.app.dv.adapter;

import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentManager;
import android.support.v4.app.FragmentPagerAdapter;
import android.util.SparseArray;

import com.commov.app.dv.fragment.FragmentContact;
import com.commov.app.dv.fragment.FragmentEvent;
import com.commov.app.dv.fragment.FragmentMessage;
import com.commov.app.dv.fragment.FragmentMore;
import com.commov.app.dv.fragment.FragmentNews;

public class TabFragmentAdapter extends FragmentPagerAdapter {
	public static final int INDEX_NEWS = 0;
	public static final int INDEX_EVENT = 1;
	public static final int INDEX_CONTACT = 2;
	public static final int INDEX_MESSAGE = 3;
	public static final int INDEX_SETTINGS = 4;
	private SparseArray<Fragment> fragmentList = new SparseArray<Fragment>();
	private static final SparseArray<Class<? extends Fragment>> fragmentClz = new SparseArray<Class<? extends Fragment>>();
	static {
		fragmentClz.put(INDEX_NEWS, FragmentNews.class);
		fragmentClz.put(INDEX_EVENT, FragmentEvent.class);
		fragmentClz.put(INDEX_CONTACT, FragmentContact.class);
		fragmentClz.put(INDEX_MESSAGE, FragmentMessage.class);
		fragmentClz.put(INDEX_SETTINGS, FragmentMore.class);
	}

	public TabFragmentAdapter(FragmentManager fm) {
		super(fm);
	}

	@Override
	public Fragment getItem(int arg0) {
		Fragment f = fragmentList.get(arg0);
		if (f == null) {
			Class<? extends Fragment> fc = fragmentClz.get(arg0);
			try {
				f = fc.newInstance();
				fragmentList.put(arg0, f);
			} catch (InstantiationException e) {
				e.printStackTrace();
			} catch (IllegalAccessException e) {
				e.printStackTrace();
			}
		}
		return f;
	}

	@Override
	public int getCount() {
		return fragmentClz.size();
	}

}
