package com.commov.app.dv.activity.about;

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

public class InfoActivity extends BaseActivity implements OnClickListener {
	private UITableView tableView;

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_info);
		tableView = (UITableView) findViewById(R.id.tableView);
		this.createList();
		findViewById(R.id.ib_back).setOnClickListener(this);
		TextView title = (TextView) findViewById(R.id.tv_title);
		title.setText(this.getResources().getString(R.string.app_name));
	}

	private void createList() {
		CustomClickListener listener = new CustomClickListener();
		tableView.setClickListener(listener);
		Item i1 = new Item(this.getResources().getString(R.string.info_title1));
		i1.setDrawable(R.drawable.more_info);

		tableView.addItem(i1);
		Item i2 = new Item(this.getResources().getString(R.string.info_title2));
		i2.setDrawable(R.drawable.more_info);

		tableView.addItem(i2);
		Item i3 = new Item(this.getResources().getString(R.string.info_title3));
		i3.setDrawable(R.drawable.more_info);

		tableView.addItem(i3);
		tableView.commit();

	}

	private class CustomClickListener implements ClickListener {

		@Override
		public void onClick(int index) {

			String title = "";
			if (index == 0) {
				title = getResources().getString(R.string.info_title1);
			} else if (index == 1) {
				title = getResources().getString(R.string.info_title2);
			} else if (index == 2) {
				title = getResources().getString(R.string.info_title3);
			}
			Intent intent = new Intent(InfoActivity.this,
					InfoDetailActivity.class);
			intent.putExtra("index", index);
			intent.putExtra("title", title);
			startActivity(intent);
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
