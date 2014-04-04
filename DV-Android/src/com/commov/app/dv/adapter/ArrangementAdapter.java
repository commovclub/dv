package com.commov.app.dv.adapter;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import android.content.Context;
import android.content.Intent;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.Button;
import android.widget.TextView;

import com.commov.app.dv.R;
import com.commov.app.dv.activity.event.EventArrangementDetailActivity;
import com.commov.app.dv.model.event.Arrangement;
import com.commov.app.dv.model.event.ArrangementList;

public class ArrangementAdapter extends BaseAdapter {
	private final static String TAG = "ArrangementAdapter";
	private int showDetailIndex = -1;
	private Context context;
	private List<ArrangementList> arrangementList;
	private List<Arrangement> arrangements = new ArrayList<Arrangement>();
	private Map<Integer, ArrangementList> headerMap = new HashMap<Integer, ArrangementList>();
	private Map<Integer, ArrangementList> bottomMap = new HashMap<Integer, ArrangementList>();

	public ArrangementAdapter(final Context context,
			final List<ArrangementList> arrangementList) {
		this.context = context;
		this.arrangementList = arrangementList;
		for (int i = 0; i < this.arrangementList.size(); i++) {
			ArrangementList arrangementListTemp = this.arrangementList.get(i);
			headerMap.put(arrangements.size(), arrangementListTemp);
			arrangements
					.addAll(arrangementListTemp.getArrangementList());
			bottomMap.put(arrangements.size() - 1, arrangementListTemp);
		}

	}

	public int getCount() {
		return arrangements.size();
	}

	public Object getItem(int position) {

		return arrangements.get(position);
	}

	public long getItemId(int position) {
		return position;
	}

	@Override
	public View getView(int position, View convertView, ViewGroup parent) {
		ViewHolder holder;
		final Arrangement arrangement = arrangements.get(position);
//		if (convertView == null) {
			convertView = LayoutInflater.from(parent.getContext()).inflate(
					R.layout.list_item_arrangement, parent, false);
			holder = new ViewHolder(convertView);
			convertView.setTag(holder);
//		} else {
//			holder = (ViewHolder) convertView.getTag();
//		}
		if(headerMap.containsKey(position)){
			ArrangementList arrangementList = headerMap.get(position);
			holder.topTitle.setVisibility(View.VISIBLE);
			holder.topTitle.setText(arrangementList.getTopTitle());
		}else if(bottomMap.containsKey(position)){
			ArrangementList arrangementList = bottomMap.get(position);
			if(arrangementList.getBottomTitle()!=null&&arrangementList.getBottomTitle().length()>0){
				holder.bottomTitle.setVisibility(View.VISIBLE);
				holder.bottomTitle.setText(arrangementList.getBottomTitle());
			}
		}
		
		holder.headerBlock.setId(position);
		holder.headerBlock.setOnClickListener(onItemClickListener);
		holder.title.setText(arrangement.getTitle());
		holder.time.setText(arrangement.getTime());
		holder.desc.setText(arrangement.getSubTitle());
		switch (position % 4) {
		case 0:
			holder.leftBoder.setBackgroundResource(R.color.arrangement_1);
			break;
		case 1:
			holder.leftBoder.setBackgroundResource(R.color.arrangement_2);
			break;
		case 2:
			holder.leftBoder.setBackgroundResource(R.color.arrangement_3);
			break;
		case 3:
			holder.leftBoder.setBackgroundResource(R.color.arrangement_4);
			break;
		}
		if (arrangement.getSpeaker() != null
				&& arrangement.getSpeaker().length() > 0) {
			holder.enclosureButton.setVisibility(View.VISIBLE);
			holder.enclosureButton.setOnClickListener(new OnClickListener() {

				@Override
				public void onClick(View v) {
					Intent intent = new Intent(context, EventArrangementDetailActivity.class);
					intent.putExtra("arrangement", arrangement);
					context.startActivity(intent);
				}
			});

		} else {
			holder.enclosureButton.setVisibility(View.GONE);

		}
		//convertView.setBackgroundResource(R.color.transparent);
		return convertView;
	}

	class ViewHolder {
		View leftBoder;

		TextView title;
		TextView time;
		TextView desc;
		TextView topTitle;
		TextView bottomTitle;
		Button enclosureButton;
		View rootView;
		View headerBlock;

		public ViewHolder(View rootView) {
			this.rootView = rootView;
			title = (TextView) findView(R.id.tv_title);
			time = (TextView) findView(R.id.tv_time);
			desc = (TextView) findView(R.id.tv_desc);
			headerBlock = findView(R.id.list_item_parent_layout);
			topTitle = (TextView) findView(R.id.tv_top_title);
			bottomTitle = (TextView) findView(R.id.tv_bottom_title);
			leftBoder = (View) findView(R.id.iv_left_border);
			enclosureButton = (Button) findView(R.id.b_enclosure);
		}

		public View findView(int id) {
			return rootView.findViewById(id);
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
}
