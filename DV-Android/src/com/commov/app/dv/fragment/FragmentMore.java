package com.commov.app.dv.fragment;

import android.content.Intent;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import com.commov.app.dv.R;
import com.commov.app.dv.activity.about.InfoActivity;
import com.commov.app.dv.activity.about.IntroActivity;
import com.commov.app.dv.activity.more.FavoriteActivity;
import com.commov.app.dv.activity.profile.ContactActivity;
import com.commov.app.dv.activity.work.WorksActivity;
import com.commov.app.dv.utils.SharedPreferencesHelper;
import com.commov.app.dv.widget.TabContainer.TabTools;
import com.commov.app.dv.widget.uitableview.Item;
import com.commov.app.dv.widget.uitableview.UITableView;
import com.commov.app.dv.widget.uitableview.UITableView.ClickListener;

/**
 * more Fragment
 * 
 * 
 */
public class FragmentMore extends BaseFragment implements TabTools {
    private UITableView tableView;

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
            Bundle savedInstanceState) {
        rootView = inflater.inflate(R.layout.fragment_more, null);

        tableView = (UITableView) findViewById(R.id.tableView);
        this.createList();
        return rootView;
    }

    private void createList() {
        CustomClickListener listener = new CustomClickListener();
        tableView.setClickListener(listener);
        Item i0 = new Item(this.getResources().getString(R.string.more_title0));
        i0.setDrawable(R.drawable.more_profile);
        tableView.addItem(i0);
        Item i1 = new Item(this.getResources().getString(R.string.more_title1));
        i1.setDrawable(R.drawable.more_setting);
        tableView.addItem(i1);
        Item i2 = new Item(this.getResources().getString(R.string.more_title2));
        i2.setDrawable(R.drawable.more_info);
        tableView.addItem(i2);
        Item i3 = new Item(this.getResources().getString(R.string.more_title3));
        i3.setDrawable(R.drawable.more_favorite);
        tableView.addItem(i3);
        Item i4 = new Item(this.getResources().getString(R.string.more_title4));
        i4.setDrawable(R.drawable.more_logout);
        tableView.addItem(i4);
        tableView.commit();
    }

    private class CustomClickListener implements ClickListener {

        @Override
        public void onClick(int index) {

            String title = "";
            if (index == 0) {
                title = getResources().getString(R.string.more_title0);
                Intent intent = new Intent(FragmentMore.this.getActivity(),
                        ContactActivity.class);
                FragmentMore.this.getActivity().startActivity(intent);
            } else if (index == 1) {
                title = getResources().getString(R.string.more_title1);
                Intent intent = new Intent(FragmentMore.this.getActivity(),
                        WorksActivity.class);
                startActivity(intent);
            } else if (index == 2) {
                title = getResources().getString(R.string.more_title2);
                Intent intent = new Intent(FragmentMore.this.getActivity(),
                        InfoActivity.class);
                startActivity(intent);
            } else if (index == 3) {
                title = getResources().getString(R.string.more_title3);
                Intent intent = new Intent(FragmentMore.this.getActivity(),
                        FavoriteActivity.class);
                startActivity(intent);
            } else if (index == 4) {
                SharedPreferencesHelper sph = new SharedPreferencesHelper(FragmentMore.this.getActivity());
                sph.putValue(SharedPreferencesHelper.USERID, null);
                sph.commit();
                FragmentMore.this.getActivity().finish();
                title = getResources().getString(R.string.more_title4);
                Intent intent = new Intent(FragmentMore.this.getActivity(),
                        IntroActivity.class);
                intent.setFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP);
                startActivity(intent);
            }
        }
    }

    @Override
    public void onPause() {
        super.onPause();
    }

    @Override
    public void onResume() {
        super.onResume();

    }
}
