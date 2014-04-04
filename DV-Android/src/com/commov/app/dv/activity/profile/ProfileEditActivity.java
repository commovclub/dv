package com.commov.app.dv.activity.profile;

import java.util.ArrayList;
import java.util.List;

import org.apache.http.NameValuePair;
import org.apache.http.message.BasicNameValuePair;

import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.Canvas;
import android.os.Bundle;
import android.text.Editable;
import android.text.Selection;
import android.text.Spannable;
import android.text.SpannableString;
import android.text.Spanned;
import android.text.TextWatcher;
import android.text.style.ImageSpan;
import android.view.Gravity;
import android.view.View;
import android.view.View.MeasureSpec;
import android.view.View.OnClickListener;
import android.view.WindowManager;
import android.widget.CheckBox;
import android.widget.EditText;
import android.widget.TextView;

import com.commov.app.dv.BaseActivity;
import com.commov.app.dv.R;
import com.commov.app.dv.common.ServerAPI;
import com.commov.app.dv.conn.ConnectionHelper;
import com.commov.app.dv.conn.ConnectionHelper.RequestReceiver;
import com.commov.app.dv.model.Contact;
import com.commov.app.dv.utils.SharedPreferencesHelper;
import com.commov.app.dv.utils.Utils;

public class ProfileEditActivity extends BaseActivity implements
        OnClickListener {

    private TextView titleTextView;
    private EditText editText;
    private CheckBox digitalCB, scienceCB;
    private Contact contact;
    private String value;
    public static final int CAREER = 1;
    public static final int CATEGORY = 2;
    public static final int LOCATION = 3;
    public static final int TAG = 4;
    public static final int DESC = 5;
    public static final int QQ = 6;
    public static final int TELPHONE = 7;
    public static final int WEIXIN = 8;
    private int type;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_profile_edit);
        findViewById(R.id.ib_back).setOnClickListener(this);
        findViewById(R.id.b_confirm).setOnClickListener(this);
        titleTextView = (TextView) this.findViewById(R.id.tv_title);
        editText = (EditText) this.findViewById(R.id.et_profile);
        digitalCB = (CheckBox) this.findViewById(R.id.cb_digital);
        scienceCB = (CheckBox) this.findViewById(R.id.cb_science);
        if (getIntent().getExtras() != null
                && getIntent().getExtras().get("contact") != null) {
            contact = (Contact) getIntent().getExtras().get("contact");
        }
        if (getIntent().getExtras() != null
                && getIntent().getExtras().get("title") != null) {
            String title = (String) getIntent().getExtras().get("title");
            titleTextView.setText(title);
            editText.setHint("请输入" + title);
        }
        if (getIntent().getExtras() != null
                && getIntent().getExtras().get("type") != null) {
            type = getIntent().getIntExtra("type", 0);
        }
        if (getIntent().getExtras() != null
                && getIntent().getExtras().get("value") != null) {
            value = (String) getIntent().getExtras().get("value");
            if (type == CATEGORY) {
                String category = contact.getCategory();
                if (category != null && category.indexOf("数字") > -1) {
                    digitalCB.setChecked(true);
                }
                if (category != null && category.indexOf("科技") > -1) {
                    scienceCB.setChecked(true);
                }
                digitalCB.setVisibility(View.VISIBLE);
                scienceCB.setVisibility(View.VISIBLE);
                editText.setVisibility(View.GONE);
                //this.findViewById(R.id.rl_root).setBackgroundColor(
                //        R.color.lightlightgrey);
            } else if (type != TELPHONE && type != TAG) {
                editText.setText(value);
            }
            // 设置光标位置到末尾
            CharSequence text = editText.getText();
            if (text instanceof Spannable) {
                Spannable spanText = (Spannable) text;
                Selection.setSelection(spanText, text.length());
            }
        }
        if (type == TELPHONE || type == TAG) {
            editText.setHint("输入空格确认标签输入");
            editText.addTextChangedListener(watcher);
            if (value != null)
                value = value.replace(",", " ");
//            String[] ss = value.split(" ");
//            fo
//            setCharSequence(ss[ss.length - 1] + " ", "1");
//            editText.setText(value);
        }

        if (getIntent().getExtras() != null
                && getIntent().getExtras().get("lines") != null) {
            int lines = getIntent().getIntExtra("lines", 1);
            editText.setLines(lines);
        }
        if(type!=CATEGORY){
            this.getWindow().setSoftInputMode(
                    WindowManager.LayoutParams.SOFT_INPUT_STATE_VISIBLE); 
        }
    }

    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.ib_back:
                finish();
                break;
            case R.id.b_confirm:
                if (type != CATEGORY) {
                    hideKeyboard();
                }
                sendProfile();
                break;
        }
    }

    private void sendProfile() {
        showLoadingDialog();
        String urlEnd = "";
        String parameterName = "";
        String value = editText.getText().toString();
        switch (type) {
            case CAREER:
                urlEnd = "updateTitle";
                parameterName = "title";
                contact.setTitle(value);
                break;
            case CATEGORY:
                urlEnd = "updateCategory"; // divider by ,
                StringBuffer sb = new StringBuffer();
                if (digitalCB.isChecked()) {
                    sb.append("数字");
                }
                if (scienceCB.isChecked()) {
                    if (sb.length() > 0) {
                        sb.append(",");
                    }
                    sb.append("科技");
                }
                parameterName = "category";
                value = sb.toString();
                contact.setCategory(value);
                break;
            case LOCATION:
                urlEnd = "updateCity";
                parameterName = "city";
                contact.setCity(value);
                break;
            case TAG:
                urlEnd = "updateTags";// divider by ,
                value = value.trim();
                value = value.replace(" ", ",");
                parameterName = "tags";
                contact.setTags(value);
                break;
            case DESC:
                urlEnd = "updateDescription";
                parameterName = "description";
                contact.setDescription(value);
                break;
            case QQ:
                urlEnd = "updateQQ";
                parameterName = "qq";
                contact.setQq(value);
                break;
            case TELPHONE:
                urlEnd = "updatePhone";// divider by ,
                value = value.replace(" ", ",");
                parameterName = "phone";
                contact.setPhone(value);
                break;
            case WEIXIN:
                urlEnd = "updateWeixin";
                parameterName = "weixin";
                contact.setWeixin(value);
                break;
        }
        String url = ServerAPI.prefix + "member/"
                + sph.getValue(SharedPreferencesHelper.USERID) + "/" + urlEnd;
        ConnectionHelper conn = ConnectionHelper.obtainInstance();
        List<NameValuePair> nvp = new ArrayList<NameValuePair>();
        nvp.add(new BasicNameValuePair(parameterName, value));
        conn.httpPost(url, 0, nvp, requestReceiver);
    }

    private RequestReceiver requestReceiver = new RequestReceiver() {

        @Override
        public void onResult(int resultCode, int requestId, String rawResponses) {
            dismissLoadingDialog();
            if (requestId == 0 && resultCode == RESULT_STATE_OK) {
                if (rawResponses != null && rawResponses.length() > 0) {
                    Utils.Toast(ProfileEditActivity.this, "提交成功！");
                    Intent intent = new Intent();
                    intent.putExtra("contact", contact);
                    ProfileEditActivity.this.setResult(RESULT_OK, intent);
                    finish();
                    return;
                }
            }
            Utils.simpleNetBadNotify(ProfileEditActivity.this);
        }
    };

    // tag methods
    //Map<String, CharSequence> mapChar;
    List<String> tagList=new ArrayList<String>();
    List<CharSequence> charList=new ArrayList<CharSequence>();

    private TextWatcher watcher = new TextWatcher() {
        @Override
        public void onTextChanged(CharSequence s, int start, int before,
                int count) {
            String txt = s.toString();
            String t = txt.substring(start);

            editText.setSelection(txt.length());
            if (t.equals(" ")) {
                String[] ss = txt.split(" ");
                setCharSequence(ss[ss.length - 1] + " ", "1");
                editText.setText("");
                for(int i=0;i<charList.size();i++){
                    editText.append(charList.get(i));
                }
            }
        }

        @Override
        public void beforeTextChanged(CharSequence s, int start, int count,
                int after) {
            if (count == 1) {
                String txt = s.toString();
                String[] ss = txt.split(" ");
                for(int i=0;i<tagList.size();i++){
                    if(tagList.get(i).equals(ss[ss.length - 1] + " ")){
                        tagList.remove(i);
                        charList.remove(i);
                        break;
                    }
                }
            }
        }

        @Override
        public void afterTextChanged(Editable s) {
        }
    };

    private View addTag(String txt) {

        TextView tv = new TextView(this);
        tv.setText(txt);
        tv.setGravity(Gravity.CENTER);
        tv.setBackgroundResource(R.drawable.tag_bg);
        return tv;
    }

    private CharSequence setCharSequence(String text, String type) {
        Bitmap bitmap = getViewBitmap(addTag(text));
        ImageSpan localImageSpan = new ImageSpan(this, bitmap,
                ImageSpan.ALIGN_BASELINE);
        SpannableString value = SpannableString.valueOf(text);
        value.setSpan(localImageSpan, 0, text.length() - 1,
                Spanned.SPAN_EXCLUSIVE_EXCLUSIVE);
        //mapChar.put(text, value);
        tagList.add(text);
        charList.add(value);
        return value;
    }

    private static Bitmap getViewBitmap(View view) {
        int spec = MeasureSpec.makeMeasureSpec(0, MeasureSpec.UNSPECIFIED);
        view.measure(spec, spec);
        view.layout(0, 0, view.getMeasuredWidth(), view.getMeasuredHeight());
        Bitmap b = Bitmap.createBitmap(view.getWidth(), view.getHeight(),
                Bitmap.Config.ARGB_8888);
        Canvas c = new Canvas(b);
        c.translate(-view.getScrollX(), -view.getScrollY());
        view.draw(c);
        view.setDrawingCacheEnabled(true);
        Bitmap cacheBmp = view.getDrawingCache();
        Bitmap viewBmp = cacheBmp.copy(Bitmap.Config.ARGB_8888, true);
        view.destroyDrawingCache();
        return viewBmp;
    }
}