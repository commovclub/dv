package com.commov.app.dv.adapter;

import android.content.Context;
import android.content.Intent;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.widget.TextView;

import com.androidquery.AQuery;
import com.androidquery.util.Constants;
import com.commov.app.dv.R;
import com.commov.app.dv.activity.DetailActivity;
import com.commov.app.dv.model.News;
import com.commov.app.dv.widget.RoundedImageView;

public class NewsAdapter extends InnerBaseAdapter<News> {
    private final static String TAG = "NewsAdapter";
    private int showDetailIndex = -1;
    private Context context;

    public NewsAdapter(final Context context) {
        this.context = context;
    }

    @Override
    public View getView(int position, View convertView, ViewGroup parent) {
        ViewHolder holder;
        final News news = getData(position);
        int type = news.getType();
        convertView = LayoutInflater.from(parent.getContext()).inflate(
                type == 0 ? R.layout.list_item_news_pic0
                        : (type == 1 ? R.layout.list_item_news_pic1
                                : R.layout.list_item_news_pic3), parent, false);
        holder = new ViewHolder(convertView);
        convertView.setTag(holder);

        holder.headerBlock.setId(position);
        holder.headerBlock.setOnClickListener(onItemClickListener);
        holder.title.setText(news.getTitle());
        holder.lastEditTime.setText(news.getTime());
        if (holder.image1 != null && news.getPath() != null
                && news.getPath().length() > 0) {
            new AQuery(convertView).id(R.id.iv_pic).image(news.getPath(), true,
                    true, 0, Constants.INVISIBLE);
        }
        if (holder.image2 != null && news.getPath2() != null
                && news.getPath2().length() > 0) {
            new AQuery(convertView).id(R.id.iv_pic2).image(news.getPath2(),
                    true, true, 0, Constants.INVISIBLE);
        }
        if (holder.image3 != null && news.getPath3() != null
                && news.getPath3().length() > 0) {
            new AQuery(convertView).id(R.id.iv_pic3).image(news.getPath3(),
                    true, true, 0, Constants.INVISIBLE);
        }
        if (holder.content != null)
            holder.content.setText(news.getContent());
        convertView.setBackgroundResource(R.color.transparent);
        // holder.content.setText(Html.fromHtml(news.getContent()));
        // recycleImages(holder.imgsViewBox);
        holder.headerBlock.setOnClickListener(new OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent intent = new Intent(context, DetailActivity.class);
                intent.putExtra("news", news);
                context.startActivity(intent);
            }
        });
        return convertView;
    }

    class ViewHolder {
        TextView title;
        TextView lastEditTime;
        TextView content;
        RoundedImageView image1;
        RoundedImageView image2;
        RoundedImageView image3;
        View rootView;
        View headerBlock;

        public ViewHolder(View rootView) {
            this.rootView = rootView;
            title = (TextView) findView(R.id.tv_title);
            lastEditTime = (TextView) findView(R.id.tv_time);
            content = (TextView) findView(R.id.tv_content);
            headerBlock = findView(R.id.header_block);
            image1 = (RoundedImageView) findView(R.id.iv_pic);
            image2 = (RoundedImageView) findView(R.id.iv_pic2);
            image3 = (RoundedImageView) findView(R.id.iv_pic3);
            if (image1 != null) {
                image1.setBorderColor(context.getResources().getColor(
                        R.color.lightgrey));
                image1.setBorderWidth(2);
            }
            if (image2 != null) {
                image2.setBorderColor(context.getResources().getColor(
                        R.color.lightgrey));
                image2.setBorderWidth(2);
            }
            if (image3 != null) {
                image3.setBorderColor(context.getResources().getColor(
                        R.color.lightgrey));
                image3.setBorderWidth(2);
            }

            // int width = Utils.getScreenWidth(context);
            // width = width / 3 - 24;
            // LinearLayout.LayoutParams params = new LayoutParams(0,
            // width * 2 / 3);
            // params.weight=1;
            // params.
            // if (image1 != null)
            // image1.setLayoutParams(params);
            // if (image2 != null)
            // image2.setLayoutParams(params);
            // if (image3 != null)
            // image3.setLayoutParams(params);
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
