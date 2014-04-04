package com.commov.app.dv.widget;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import android.app.AlertDialog;
import android.app.AlertDialog.Builder;
import android.content.Context;
import android.content.DialogInterface;
import android.content.DialogInterface.OnClickListener;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ListView;
import android.widget.TextView;

import com.commov.app.dv.adapter.InnerBaseAdapter;
import com.commov.app.dv.model.Grammar;
import com.commov.app.dv.model.Note;
import com.commov.app.dv.R;

public class OperatesDialog {

	public static final int op_archive = 0;
	public static final int op_unarchive = 1;
	public static final int op_delete = 2;
	public static final int op_cancle = 3;
	private static final String[] opsMapping = new String[] { "归档", "待复习/答疑",
			"删除", "取消" };
	private static Map<String, Integer> opsNameMapping = new HashMap<String, Integer>();
	static {
		opsNameMapping.put(opsMapping[op_archive], op_archive);
		opsNameMapping.put(opsMapping[op_unarchive], op_unarchive);
		opsNameMapping.put(opsMapping[op_delete], op_delete);
		opsNameMapping.put(opsMapping[op_cancle], op_cancle);
	}
	private List<String> ops = new ArrayList<String>();
	private OperationsAdapter mAdapter = new OperationsAdapter();
	private Grammar lastShowGrammar;
	private Note lastShowNote;

	private Context context;
	private AlertDialog dailog;
	private ListView listView;

	public final static int[] style_need_archive = new int[] { op_archive,
			op_delete, op_cancle };
	public final static int[] style_need_unarchive = new int[] { op_unarchive,
			op_delete, op_cancle };

	private String title;

	public OperatesDialog(Context context, Note note, int... showOpts) {
		lastShowNote = note;
		title = "操作笔记";
		init(context, showOpts);
	}

	public OperatesDialog(Context context, Grammar grammar, int... showOpts) {
		this.context = context;
		lastShowGrammar = grammar;
		if (lastShowGrammar == null) {
			title = "操作";
		} else {
			title = lastShowGrammar.getTitle();
		}
		init(context, showOpts);
	}

	private void init(Context context, int... showOpts) {
		this.context = context;
		for (int i : showOpts) {
			ops.add(opsMapping[i]);
		}
		//
		Builder builder = new Builder(getContext());
		builder.setAdapter(mAdapter, onClickListener);
		builder.setTitle(title);
		builder.setView(listView);
		dailog = builder.create();
	}

	private Context getContext() {
		return context;
	}

	public Note getNote() {
		return lastShowNote;
	}

	public Grammar getGrammar() {
		return lastShowGrammar;
	}

	public void show() {
		if (dailog != null) {
			dailog.show();
		}
	}

	public void dismiss() {
		if (dailog != null && dailog.isShowing()) {
			dailog.dismiss();
		}
	}

	public interface OnOperateClickListener {
		public void onOperateClick(OperatesDialog dialog, int opId);
	}

	private OnOperateClickListener mOnOperateClickListener;

	public void setOnOperateClickListener(OnOperateClickListener l) {
		mOnOperateClickListener = l;
	}

	private OnClickListener onClickListener = new OnClickListener() {

		@Override
		public void onClick(DialogInterface dialog, int which) {
			if (mOnOperateClickListener != null) {
				mOnOperateClickListener.onOperateClick(OperatesDialog.this,
						opsNameMapping.get(mAdapter.getData(which)));
			}
		}
	};

	class OperationsAdapter extends InnerBaseAdapter<String> {
		public OperationsAdapter() {
			setData(ops, false);
		}

		@Override
		public View getView(int position, View convertView, ViewGroup parent) {
			TextView tv;
			if (convertView == null) {
				tv = (TextView) LayoutInflater
						.from(parent.getContext())
						.inflate(R.layout.list_item_grammar_opeart_dialog, null);
				convertView = tv;

			} else {
				tv = (TextView) convertView;
			}
			tv.setText(getData(position));
			return convertView;
		}
	}

}
