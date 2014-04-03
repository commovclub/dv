package com.commov.app.dv.wxapi;

import android.app.Activity;
import android.os.Bundle;
import android.widget.Toast;

import com.commov.app.dv.common.CommonParam;
import com.tencent.mm.sdk.openapi.BaseReq;
import com.tencent.mm.sdk.openapi.BaseResp;
import com.tencent.mm.sdk.openapi.IWXAPI;
import com.tencent.mm.sdk.openapi.IWXAPIEventHandler;
import com.tencent.mm.sdk.openapi.WXAPIFactory;

public class WXEntryActivity extends Activity implements IWXAPIEventHandler {
	private IWXAPI api;

	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		api = WXAPIFactory.createWXAPI(this, CommonParam.APP_ID, false);
		api.handleIntent(getIntent(), this);
	}

	@Override
	public void onReq(BaseReq arg0) {
		arg0.getType();
	}

	@Override
	public void onResp(BaseResp resp) {
		  String result = "";
          switch (resp.errCode) {
          case BaseResp.ErrCode.ERR_OK:
                  result = "发送成功";
                  break;
          case BaseResp.ErrCode.ERR_USER_CANCEL:
                  result = "分享取消";
                  break;
          case BaseResp.ErrCode.ERR_AUTH_DENIED:
                  result = "发送失败";
                  break;
          default:
                  result = "出现异常";
                  break;
          }
          Toast.makeText(this, result, Toast.LENGTH_LONG).show();

		// TODO 微信分享 成功之后调用接口
		this.finish();
	}
}
