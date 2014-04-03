package com.commov.app.dv.adapter;

import java.io.File;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Locale;

import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.View.OnLongClickListener;
import android.view.ViewGroup;
import android.widget.AdapterView.OnItemLongClickListener;
import android.widget.ImageView;
import android.widget.TextView;

import com.commov.app.dv.PhotoViewActivity;
import com.commov.app.dv.model.Note;
import com.commov.app.dv.utils.ImageUtility;
import com.commov.app.dv.utils.Utils;
import com.commov.app.dv.R;

public class NoteAdapter extends InnerBaseAdapter<Note> {
	private final int target_icon_width = 100;

	@Override
	public View getView(int position, View convertView, ViewGroup parent) {
		ViewHolder vh;
		if (convertView == null) {
			vh = new ViewHolder();
			View v = LayoutInflater.from(parent.getContext()).inflate(
					R.layout.list_item_note, parent, false);
			vh.text = (TextView) v.findViewById(R.id.note_content_text);
			vh.img = (ImageView) v.findViewById(R.id.note_content_img);
			vh.createTime = (TextView) v.findViewById(R.id.note_create_time);
			// vh.delBtn = v.findViewById(R.id.note_delete_btn);
			// vh.delBtn.setOnClickListener(innerOnDelteNoteListener);
			convertView = v;
			convertView.setTag(vh);
			convertView.setOnLongClickListener(innserOnLongClickListener);
		} else {
			vh = (ViewHolder) convertView.getTag();
		}
		convertView.setId(position);
		if (position % 2 == 0) {
			convertView.setBackgroundResource(R.color.suggest_keyword_bg_even);
		} else {
			convertView.setBackgroundResource(R.color.suggest_keyword_bg_odd);
		}
		Note note = getData(position);
		// vh.delBtn.setTag(note);
		vh.img.setOnClickListener(imgOnClickListener);
		vh.img.setTag(getImagePath(note));
		ImageUtility.cancelAqueryLoad(vh.img);
		if (note.getType() == Note.CONTENT_TYPE_IMAGE) {
			Utils.checkViewVisibility(vh.img, View.VISIBLE);
			Utils.checkViewVisibility(vh.text, View.GONE);
			fillImage(note, vh.img);
		} else {
			Utils.checkViewVisibility(vh.text, View.VISIBLE);
			Utils.checkViewVisibility(vh.img, View.GONE);
			vh.text.setText(note.getContent());
		}
		vh.createTime.setText(formatTime(note.getNoteCreateTime()));
		return convertView;
	}

	private OnClickListener imgOnClickListener = new OnClickListener() {

		@Override
		public void onClick(View v) {
			Object obj = v.getTag();
			if (obj instanceof String) {
				ArrayList<String> imgsPath = new ArrayList<String>();
				imgsPath.add((String) obj);
				PhotoViewActivity.start(v.getContext(), imgsPath, 0);
			}
		}
	};
	private SimpleDateFormat formatter = new SimpleDateFormat(
			"yyyy-MM-dd  hh:mm", Locale.getDefault());

	private String formatTime(long time) {
		return formatter.format(new java.util.Date(time));
	}

	private void fillImage(Note note, ImageView img) {
		String imgPath = note.getContent();
		if (imgPath == null) {// 为同步的笔记，没有url path的image
			File file = note.getLocalNoteImageFile();
			if (file == null || !file.exists()) {
				img.setImageResource(R.drawable.ic_launcher);
			} else {
				ImageUtility.loadImage(img, file, target_icon_width);
			}
		} else {
			ImageUtility.loadImage(img, note.getContent(), target_icon_width,
					R.drawable.ic_launcher, false);
		}
	}

	private String getImagePath(Note note) {
		if (note == null) {
			return null;
		}
		String imgPath = note.getContent();
		if (imgPath == null) {// 为同步的笔记，没有url path的image
			File file = note.getLocalNoteImageFile();
			if (file != null) {
				return file.getAbsolutePath();
			} else {
				return null;
			}
		} else {
			return imgPath;
		}
	}

	private OnLongClickListener innserOnLongClickListener = new OnLongClickListener() {

		@Override
		public boolean onLongClick(View v) {
			if (mOnItemLongClickListener != null) {
				return mOnItemLongClickListener.onItemLongClick(null, v,
						v.getId(), 0L);
			}
			return false;
		}
	};

	private OnItemLongClickListener mOnItemLongClickListener;

	public void setOnItemLongClickListener(OnItemLongClickListener l) {
		mOnItemLongClickListener = l;
	}

	class ViewHolder {
		TextView text;
		ImageView img;
		TextView createTime;
		// View delBtn;
	}
}
