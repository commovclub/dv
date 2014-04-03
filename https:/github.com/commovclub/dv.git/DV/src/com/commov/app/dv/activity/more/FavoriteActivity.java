package com.commov.app.dv.activity.more;

import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.TextView;

import com.commov.app.dv.BaseActivity;
import com.commov.app.dv.R;
import com.commov.app.dv.widget.uitableview.Item;
import com.commov.app.dv.widget.uitableview.UITableView;
import com.commov.app.dv.widget.uitableview.UITableView.ClickListener;

public class FavoriteActivity extends BaseActivity implements OnClickListener {
    private UITableView tableView;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_favorite);
        tableView = (UITableView) findViewById(R.id.tableView);
        this.createList();
        findViewById(R.id.ib_back).setOnClickListener(this);
        TextView title = (TextView) findViewById(R.id.tv_title);
        title.setText(this.getResources().getString(R.string.app_name));
        if (getIntent().getExtras() != null
                && getIntent().getExtras().get("visible_bottombar") != null) {
            findViewById(R.id.rl_bottom).setVisibility(View.VISIBLE);
        }
    }

    private void createList() {
        CustomClickListener listener = new CustomClickListener();
        tableView.setClickListener(listener);
        Item i1 = new Item("我收藏的新闻");
        i1.setDrawable(R.drawable.icon1_selected);
        tableView.addItem(i1);

        Item i2 = new Item("我收藏的活动");
        i2.setDrawable(R.drawable.icon2_selected);
        tableView.addItem(i2);

        Item i3 = new Item("我关注的好友");
        i3.setDrawable(R.drawable.icon3_selected);
        tableView.addItem(i3);

        Item i4 = new Item("关注我的好友");
        i4.setDrawable(R.drawable.icon3_selected);
        tableView.addItem(i4);
        tableView.commit();
    }

    private class CustomClickListener implements ClickListener {

        @Override
        public void onClick(int index) {
            if (index == 0) {

                Intent intent = new Intent(FavoriteActivity.this,
                        FavoriteNewsActivity.class);
                startActivity(intent);
            } else if (index == 1) {

                Intent intent = new Intent(FavoriteActivity.this,
                        FavoriteEventActivity.class);
                startActivity(intent);
            }

            else if (index == 2) {
                Intent intent = new Intent(FavoriteActivity.this,
                        FollowActivity.class);
                intent.putExtra("type", FollowActivity.TYPE_FOLLOWING);
                startActivity(intent);
            } else if (index == 3) {
                Intent intent = new Intent(FavoriteActivity.this,
                        FollowActivity.class);
                intent.putExtra("type", FollowActivity.TYPE_FOLLOWED);
                startActivity(intent);
            }

        }

    }

    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.ib_back:
                finish();
                break;
        }
    }
}
