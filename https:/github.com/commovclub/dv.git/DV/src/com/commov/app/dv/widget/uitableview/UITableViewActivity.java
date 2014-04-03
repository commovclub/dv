package com.commov.app.dv.widget.uitableview;


import android.app.Activity;
import android.os.Bundle;

import com.commov.app.dv.R;


public abstract class UITableViewActivity extends Activity {

	private UITableView mTableView;
	
	@Override
    public void onCreate(Bundle savedInstanceState) {
		 super.onCreate(savedInstanceState);
	     setContentView(R.layout.uitableview_activity);
	     mTableView = (UITableView) findViewById(R.id.tableView);
	     populateList();
	     mTableView.commit();
	}
	
	protected UITableView getUITableView() {
		return mTableView;
	}
	
	protected abstract void populateList();
	
}
