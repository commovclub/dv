package com.commov.app.dv.adapter;

import android.content.Context;
import android.content.Intent;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.widget.TextView;

import com.commov.app.dv.R;
import com.commov.app.dv.activity.DetailActivity;
import com.commov.app.dv.model.Message;
import com.commov.app.dv.utils.Utils;

public class MessageAdapter extends InnerBaseAdapter<Message> {
    private final static String TAG = "NewsAdapter";
    private int showDetailIndex = -1;
    private Context context;

    public MessageAdapter(final Context context) {
        this.context = context;
    }

    @Override
    public View getView(int position, View convertView, ViewGroup parent) {
        ViewHolder holder;
        final Message message = getData(position);
        if (convertView == null) {
            convertView = LayoutInflater.from(parent.getContext()).inflate(
                    R.layout.list_item_message, parent, false);
            holder = new ViewHolder(convertView);
            convertView.setTag(holder);
        } else {
            holder = (ViewHolder) convertView.getTag();
        }

        holder.title.setText(message.getMessage());
        holder.lastEditTime.setText(Utils.getLongDateToString(message
                .getCreatedAt()));
        if (message.getStatus().equals("new")) {
            holder.newLabel.setVisibility(View.VISIBLE);
        } else {
            holder.newLabel.setVisibility(View.GONE);

        }

        convertView.setBackgroundResource(R.color.transparent);
        holder.headerBlock.setOnClickListener(new OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent intent = new Intent(context, DetailActivity.class);
                intent.putExtra("message", message);
                context.startActivity(intent);
            }
        });
        return convertView;
    }

    class ViewHolder {
        TextView title;
        TextView lastEditTime;
        TextView newLabel;
        View rootView;
        View headerBlock;

        public ViewHolder(View rootView) {
            this.rootView = rootView;
            title = (TextView) findView(R.id.tv_title);
            lastEditTime = (TextView) findView(R.id.tv_time);
            newLabel = (TextView) findView(R.id.tv_new);
            headerBlock = findView(R.id.header_block);
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
