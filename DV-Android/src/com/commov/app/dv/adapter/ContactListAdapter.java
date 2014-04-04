package com.commov.app.dv.adapter;

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
import android.view.animation.Animation;
import android.widget.AbsListView;
import android.widget.BaseAdapter;
import android.widget.FrameLayout;
import android.widget.ImageView;
import android.widget.ImageView.ScaleType;
import android.widget.RelativeLayout;
import android.widget.TextView;
import android.widget.ViewFlipper;

import com.androidquery.AQuery;
import com.androidquery.util.Constants;
import com.commov.app.dv.R;
import com.commov.app.dv.activity.profile.ContactActivity;
import com.commov.app.dv.model.Contact;
import com.commov.app.dv.utils.Utils;
import com.commov.app.dv.widget.CirclePageIndicator;

public class ContactListAdapter extends BaseAdapter {

    private Map<String, String> map = new HashMap<String, String>();
    private List<Contact> contacts;
    private Context context;
    private List<Contact> mBannerData;

    public ContactListAdapter(Context context, List<Contact> contacts,
            List<Contact> bannerData, OnClickListener listener,
            Map<String, String> map) {
        this.context = context;
        this.contacts = contacts;
        this.mBannerData = bannerData;
        this.map = map;
    }

    public int getCount() {
        if (mBannerData != null) {
            return contacts == null ? 0 : contacts.size() + 1;
        }
        return contacts.size();
    }

    public Object getItem(int position) {

        Log.d("position", position + "--->" + contacts.get(position));

        if (contacts != null) {
            String string = map.get(contacts.get(position));
            return string;
        }
        return null;
    }

    public long getItemId(int position) {
        return position;
    }

    public View getView(int position, View convertView, ViewGroup parent) {
        final ViewHolder holder = new ViewHolder();

        if (position == 0&&mBannerData != null) {
            convertView = LayoutInflater.from(parent.getContext()).inflate(
                    R.layout.list_item_banner, parent, false);
            holder.indic = (CirclePageIndicator) convertView
                    .findViewById(R.id.viewflowindic);
            holder.viewFlipper = (ViewFlipper) convertView
                    .findViewById(R.id.photos);
            holder.banner = (RelativeLayout) convertView
                    .findViewById(R.id.rl_banner);

        } else {
            convertView = LayoutInflater.from(parent.getContext()).inflate(
                    R.layout.list_item_contact, parent, false);
            holder.firstCharHintTextView = (TextView) convertView
                    .findViewById(R.id.text_first_char_hint);
            holder.nameTextView = (TextView) convertView
                    .findViewById(R.id.tv_name);
            holder.descTextView = (TextView) convertView
                    .findViewById(R.id.tv_desc);
            holder.headerBlock = convertView.findViewById(R.id.header_block);
        }
        convertView.setTag(holder);
        // } else {
        // holder = (ViewHolder) convertView.getTag();
        // }
        if (holder.nameTextView != null) {
            int idx = (mBannerData != null)?(position - 1):position;
            final Contact contact = contacts.get(idx);
            holder.nameTextView.setText(contact.getRealname());
            holder.descTextView.setText(contact.getDescription());
            if (contact.getAvatar() != null && contact.getAvatar().length() > 0) {
                new AQuery(convertView).id(R.id.iv_avatar)
                        .image(contact.getAvatar(), true, true, 0,
                                Constants.INVISIBLE);
            }
            char previewChar = (idx > 0) ? map
                    .get(contacts.get((mBannerData != null)?(idx - 1):idx).getRealname()).toUpperCase()
                    .charAt(0) : ' ';
            char currentChar = map.get(contact.getRealname()).toUpperCase()
                    .charAt(0);
            if (currentChar != previewChar) {
                holder.firstCharHintTextView.setVisibility(View.VISIBLE);
                if ((currentChar >= 'a' && currentChar <= 'z')) {
                    currentChar = (char) (currentChar - 32);
                }
                holder.firstCharHintTextView.setText(String
                        .valueOf(currentChar));
            } else {
                // 实例化一个CurrentView后，会被多次赋值并且只有最后一次赋值的position是正确
                holder.firstCharHintTextView.setVisibility(View.GONE);
            }
            holder.headerBlock.setOnClickListener(new OnClickListener() {

                @Override
                public void onClick(View v) {

                    Intent intent = new Intent(context, ContactActivity.class);
                    intent.putExtra("contact", contact);
                    context.startActivity(intent);
                }

            });
        } else {// banner
            int width = Utils.getScreenWidth(context);
            for (int i = 0; i < mBannerData.size(); i++) {
                final Contact banner = mBannerData.get(i);
                ImageView iv = new ImageView(parent.getContext());
                int tempId = 13466314 + i;
                iv.setId(tempId);
                iv.setScaleType(ScaleType.CENTER_CROP);
                holder.viewFlipper.addView(iv);
                new AQuery(convertView).id(tempId).image(banner.getImage(),
                        true, true, 0, Constants.INVISIBLE);
                FrameLayout.LayoutParams params = new FrameLayout.LayoutParams(
                        width, width / 2);
                iv.setLayoutParams(params);
                iv.setOnClickListener(new OnClickListener() {

                    @Override
                    public void onClick(View v) {

                        Intent intent = new Intent(context,
                                ContactActivity.class);
                        intent.putExtra("contact", banner);
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
            holder.indic.setViewPager(mBannerData.size());
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

        }
        return convertView;
    }

    public final class ViewHolder {
        private TextView firstCharHintTextView;
        private TextView nameTextView;
        private TextView descTextView;
        private ViewFlipper viewFlipper;
        private CirclePageIndicator indic;
        private View headerBlock;
        private RelativeLayout banner;
    }
}