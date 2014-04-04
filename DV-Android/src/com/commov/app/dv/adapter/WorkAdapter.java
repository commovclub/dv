package com.commov.app.dv.adapter;

import java.util.ArrayList;

import android.app.AlertDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.androidquery.AQuery;
import com.androidquery.util.Constants;
import com.commov.app.dv.PhotoViewActivity;
import com.commov.app.dv.R;
import com.commov.app.dv.activity.work.WorksActivity;
import com.commov.app.dv.model.DVImage;
import com.commov.app.dv.model.Work;
import com.commov.app.dv.utils.Utils;

public class WorkAdapter extends InnerBaseAdapter<Work> {
    private WorksActivity worksActivity;
    private ArrayList<String> pictures = new ArrayList<String>();
    private Context context;
    public WorkAdapter(final WorksActivity worksActivity) {
        this.worksActivity = worksActivity;
    }
    public WorkAdapter(final Context context) {
        this.context = context;
    }
    @Override
    public View getView(int position, View convertView, ViewGroup parent) {
        final Work work = getData(position);
        pictures = new ArrayList<String>();
        for (int i = 0; i < work.getFiles().size(); i++) {
            DVImage file = work.getFiles().get(i);
            pictures.add(file.getFilePath());
        }
        ViewHolder holder;
        if (convertView == null) {
            convertView = LayoutInflater.from(parent.getContext()).inflate(
                    R.layout.list_item_work, parent, false);
            holder = new ViewHolder(convertView);
            convertView.setTag(holder);
        } else {
            holder = (ViewHolder) convertView.getTag();
        }
        holder.descTV.setText(work.getDescription());
        holder.timeTV.setText(Utils.getLongDateToShortString(work
                .getCreatedAt()));
        if(worksActivity==null){
            holder.moreButton.setVisibility(View.INVISIBLE);
        }
        holder.moreButton.setOnClickListener(new OnClickListener() {
            @Override
            public void onClick(View v) {
                // delete this work
                AlertDialog.Builder builder = new AlertDialog.Builder(
                        worksActivity);
                builder.setMessage("是否删除该作品")
                        .setCancelable(true)
                        .setPositiveButton("确定",
                                new DialogInterface.OnClickListener() {
                                    @Override
                                    public void onClick(DialogInterface dialog,
                                            int which) {
                                        worksActivity.deleteWork(work);
                                    }
                                }).setNegativeButton("取消", null);
                builder.create().show();
            }
        });
        int width = Utils.getScreenWidth(worksActivity!=null?worksActivity:context);
        width = width - 30;
        int height = width * 2 / 3;
        LinearLayout.LayoutParams params = new LinearLayout.LayoutParams(
                width / 3, height / 3);
        holder.iv1.setLayoutParams(params);
        holder.iv2.setLayoutParams(params);
        holder.iv3.setLayoutParams(params);
        holder.iv4.setLayoutParams(params);
        holder.iv5.setLayoutParams(params);
        holder.iv6.setLayoutParams(params);
        holder.iv7.setLayoutParams(params);
        holder.iv8.setLayoutParams(params);
        holder.iv9.setLayoutParams(params);
        // for viewed all the pictures
        holder.iv1.setOnClickListener(onImageClickListener);
        holder.iv2.setOnClickListener(onImageClickListener);
        holder.iv3.setOnClickListener(onImageClickListener);
        holder.iv4.setOnClickListener(onImageClickListener);
        holder.iv5.setOnClickListener(onImageClickListener);
        holder.iv6.setOnClickListener(onImageClickListener);
        holder.iv7.setOnClickListener(onImageClickListener);
        holder.iv8.setOnClickListener(onImageClickListener);
        holder.iv9.setOnClickListener(onImageClickListener);
        holder.iv1.setTag(pictures);
        holder.iv2.setTag(pictures);
        holder.iv3.setTag(pictures);
        holder.iv4.setTag(pictures);
        holder.iv5.setTag(pictures);
        holder.iv6.setTag(pictures);
        holder.iv7.setTag(pictures);
        holder.iv8.setTag(pictures);
        holder.iv9.setTag(pictures);
        holder.viewL1.setVisibility(View.VISIBLE);
        holder.viewL2.setVisibility(View.VISIBLE);
        holder.viewL3.setVisibility(View.VISIBLE);
        if (work.getFiles().size() == 1) {
            holder.viewL2.setVisibility(View.GONE);
            holder.viewL3.setVisibility(View.GONE);
            holder.iv2.setVisibility(View.GONE);
            holder.iv3.setVisibility(View.GONE);
            LinearLayout.LayoutParams paramsTemp = new LinearLayout.LayoutParams(
                    width, height);
            holder.iv1.setLayoutParams(paramsTemp);
            new AQuery(convertView).id(R.id.iv_1).image(
                    work.getFiles().get(0).getFilePath(), true, true, 0,
                    Constants.INVISIBLE);
        } else if (work.getFiles().size() <= 3) {
            holder.viewL2.setVisibility(View.GONE);
            holder.viewL3.setVisibility(View.GONE);
            new AQuery(convertView).id(R.id.iv_1).image(
                    work.getFiles().get(0).getFilePath(), true, true, 0,
                    Constants.INVISIBLE);
            new AQuery(convertView).id(R.id.iv_2).image(
                    work.getFiles().get(1).getFilePath(), true, true, 0,
                    Constants.INVISIBLE);
            if (work.getFiles().size() == 2) {
                holder.iv3.setVisibility(View.GONE);
            } else {
                new AQuery(convertView).id(R.id.iv_3).image(
                        work.getFiles().get(2).getFilePath(), true, true, 0,
                        Constants.INVISIBLE);
            }
        } else if (work.getFiles().size() <= 6) {
            holder.viewL3.setVisibility(View.GONE);
            new AQuery(convertView).id(R.id.iv_1).image(
                    work.getFiles().get(0).getFilePath(), true, true, 0,
                    Constants.INVISIBLE);
            new AQuery(convertView).id(R.id.iv_2).image(
                    work.getFiles().get(1).getFilePath(), true, true, 0,
                    Constants.INVISIBLE);
            new AQuery(convertView).id(R.id.iv_3).image(
                    work.getFiles().get(2).getFilePath(), true, true, 0,
                    Constants.INVISIBLE);
            if (work.getFiles().size() == 4) {
                new AQuery(convertView).id(R.id.iv_4).image(
                        work.getFiles().get(3).getFilePath(), true, true, 0,
                        Constants.INVISIBLE);
                holder.iv5.setVisibility(View.GONE);
                holder.iv6.setVisibility(View.GONE);
            } else if (work.getFiles().size() == 5) {
                new AQuery(convertView).id(R.id.iv_4).image(
                        work.getFiles().get(3).getFilePath(), true, true, 0,
                        Constants.INVISIBLE);
                new AQuery(convertView).id(R.id.iv_5).image(
                        work.getFiles().get(4).getFilePath(), true, true, 0,
                        Constants.INVISIBLE);
                holder.iv6.setVisibility(View.GONE);
            } else {
                new AQuery(convertView).id(R.id.iv_4).image(
                        work.getFiles().get(3).getFilePath(), true, true, 0,
                        Constants.INVISIBLE);
                new AQuery(convertView).id(R.id.iv_5).image(
                        work.getFiles().get(4).getFilePath(), true, true, 0,
                        Constants.INVISIBLE);
                new AQuery(convertView).id(R.id.iv_6).image(
                        work.getFiles().get(5).getFilePath(), true, true, 0,
                        Constants.INVISIBLE);
            }
        } else {
            new AQuery(convertView).id(R.id.iv_1).image(
                    work.getFiles().get(0).getFilePath(), true, true, 0,
                    Constants.INVISIBLE);
            new AQuery(convertView).id(R.id.iv_2).image(
                    work.getFiles().get(1).getFilePath(), true, true, 0,
                    Constants.INVISIBLE);
            new AQuery(convertView).id(R.id.iv_3).image(
                    work.getFiles().get(2).getFilePath(), true, true, 0,
                    Constants.INVISIBLE);
            new AQuery(convertView).id(R.id.iv_4).image(
                    work.getFiles().get(3).getFilePath(), true, true, 0,
                    Constants.INVISIBLE);
            new AQuery(convertView).id(R.id.iv_5).image(
                    work.getFiles().get(4).getFilePath(), true, true, 0,
                    Constants.INVISIBLE);
            new AQuery(convertView).id(R.id.iv_6).image(
                    work.getFiles().get(5).getFilePath(), true, true, 0,
                    Constants.INVISIBLE);
            if (work.getFiles().size() == 7) {
                holder.iv8.setVisibility(View.GONE);
                holder.iv9.setVisibility(View.GONE);
                new AQuery(convertView).id(R.id.iv_7).image(
                        work.getFiles().get(6).getFilePath(), true, true, 0,
                        Constants.INVISIBLE);
            } else if (work.getFiles().size() == 8) {
                holder.iv9.setVisibility(View.GONE);
                new AQuery(convertView).id(R.id.iv_7).image(
                        work.getFiles().get(6).getFilePath(), true, true, 0,
                        Constants.INVISIBLE);
                new AQuery(convertView).id(R.id.iv_8).image(
                        work.getFiles().get(7).getFilePath(), true, true, 0,
                        Constants.INVISIBLE);
            } else {
                new AQuery(convertView).id(R.id.iv_7).image(
                        work.getFiles().get(6).getFilePath(), true, true, 0,
                        Constants.INVISIBLE);
                new AQuery(convertView).id(R.id.iv_8).image(
                        work.getFiles().get(7).getFilePath(), true, true, 0,
                        Constants.INVISIBLE);
                new AQuery(convertView).id(R.id.iv_9).image(
                        work.getFiles().get(8).getFilePath(), true, true, 0,
                        Constants.INVISIBLE);
            }
        }

        convertView.setBackgroundResource(R.color.transparent);
        return convertView;
    }

    class ViewHolder {
        LinearLayout viewL1;
        LinearLayout viewL2;
        LinearLayout viewL3;
        ImageView iv1;
        ImageView iv2;
        ImageView iv3;
        ImageView iv4;
        ImageView iv5;
        ImageView iv6;
        ImageView iv7;
        ImageView iv8;
        ImageView iv9;
        TextView descTV;
        TextView timeTV;
        View rootView;
        Button moreButton;

        public ViewHolder(View rootView) {
            this.rootView = rootView;
            this.init();
        }

        private void init() {
            if (rootView != null) {
                descTV = (TextView) findView(R.id.tv_desc);
                timeTV = (TextView) findView(R.id.tv_time);
                viewL1 = (LinearLayout) findView(R.id.ll_line1);
                viewL2 = (LinearLayout) findView(R.id.ll_line2);
                viewL3 = (LinearLayout) findView(R.id.ll_line3);
                iv1 = (ImageView) findView(R.id.iv_1);
                iv2 = (ImageView) findView(R.id.iv_2);
                iv3 = (ImageView) findView(R.id.iv_3);
                iv4 = (ImageView) findView(R.id.iv_4);
                iv5 = (ImageView) findView(R.id.iv_5);
                iv6 = (ImageView) findView(R.id.iv_6);
                iv7 = (ImageView) findView(R.id.iv_7);
                iv8 = (ImageView) findView(R.id.iv_8);
                iv9 = (ImageView) findView(R.id.iv_9);
                moreButton = (Button) findView(R.id.b_more);
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

    private OnClickListener onImageClickListener = new OnClickListener() {

        @Override
        public void onClick(View v) {
            Object obj = v.getTag();
            if (obj instanceof ArrayList) {
                ArrayList<String> imgsPath = (ArrayList<String>) obj;
                int index = 0;
                switch (v.getId()) {
                    case R.id.iv_1:
                        index = 0;
                        break;
                    case R.id.iv_2:
                        index = 1;
                        break;
                    case R.id.iv_3:
                        index = 2;
                        break;
                    case R.id.iv_4:
                        index = 3;
                        break;
                    case R.id.iv_5:
                        index = 4;
                        break;
                    case R.id.iv_6:
                        index = 5;
                        break;
                    case R.id.iv_7:
                        index = 6;
                        break;
                    case R.id.iv_8:
                        index = 7;
                        break;
                    case R.id.iv_9:
                        index = 8;
                        break;
                }
                PhotoViewActivity.start(v.getContext(), imgsPath, index);
            }
        }
    };

}
