package com.commov.app.dv.fragment;

import android.app.ProgressDialog;
import android.support.v4.app.Fragment;
import android.view.View;
import android.view.WindowManager;

import com.commov.app.dv.R;
import com.commov.app.dv.utils.SharedPreferencesHelper;
import com.commov.app.dv.widget.ProgressWheel;
import com.umeng.analytics.MobclickAgent;

/**
 * Fragment基类
 * 
 * @author skg
 * 
 */
public abstract class BaseFragment extends Fragment {
    protected View rootView;
    private ProgressDialog dialog;
    protected SharedPreferencesHelper sph;
    protected ProgressWheel progressWheel;

    /**
     * 从rootView中findView
     * 
     * @param id
     * @return
     */
    protected View findViewById(int id) {
        if (rootView == null) {
            return null;
        }
        return rootView.findViewById(id);
    }

    protected void showLoadingDialog() {
        if (dialog == null) {
            dialog = new ProgressDialog(this.getActivity());
            dialog.setCancelable(false);
            dialog.setMessage(getString(R.string.comitting));
        }
        if (dialog.isShowing()) {
            return;
        } else {
            dialog.show();
        }
    }

    protected void dismissLoadingDialog() {
        if (dialog == null) {
            return;
        }
        if (dialog.isShowing()) {
            dialog.dismiss();
        }
    }

    public void hideKeyboard() {
        this.getActivity()
                .getWindow()
                .setSoftInputMode(
                        WindowManager.LayoutParams.SOFT_INPUT_STATE_ALWAYS_HIDDEN);

    }

    public void onResume() {
        super.onResume();
        MobclickAgent.onResume(this.getActivity());
    }

    public void onPause() {
        super.onPause();
        MobclickAgent.onPause(this.getActivity());
    }
}
