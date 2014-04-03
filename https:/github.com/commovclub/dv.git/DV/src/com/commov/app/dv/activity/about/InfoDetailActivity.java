package com.commov.app.dv.activity.about;

import android.os.Bundle;
import android.text.method.ScrollingMovementMethod;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.TextView;

import com.commov.app.dv.BaseActivity;
import com.commov.app.dv.R;

public class InfoDetailActivity extends BaseActivity implements OnClickListener {

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_info_detail);
		findViewById(R.id.ib_back).setOnClickListener(this);
		TextView title = (TextView) findViewById(R.id.tv_title);
		TextView content = (TextView) findViewById(R.id.tv_detail);
		content.setMovementMethod(ScrollingMovementMethod.getInstance());
		if (getIntent().getExtras().get("title") != null) {
			title.setText(getIntent().getExtras().get("title").toString());
			int index = getIntent().getExtras().getInt("index");
			if (index == 0) {
				content.setText("地址：北京市朝阳区高碑店东亿国际传媒产业园C12号楼地下一层\n\n电话：13456785678\n\n联系人：木木");
			} else if (index == 1) {
				content.setText("	“大拿”网站（www.danaaa.com）负责对本站所提供的各种/项信息、服务等拥有最终的解释权和修改权，且前述的权利是不时行使的。\n\n	用户（包括但不限于法人、个人、其他组织等各种法律主体）若使用本站所提供的各种/项信息、服务等，必须不加修改地同意本站所载明的全部条款、声明及不时发布的各项通告等。\n\n	同时，用户须确认：\n\n1.	上述全部条款及内容等是处理双方权利义务的唯一依据和契约，始终合法有效，法律或行政法规另有强制性规定或双方另有特别约定的除外。\n\n2.	任何情形下，用户必须是具有中华人民共和国法律意义上的完全行为能力人，具有单独的对外行使民法权利、承担民事责任的能力；若用户不符合前述要求，则用户必须确认在其监护人的参与下方可使用本站所提供的各种/项信息、服务等。\n\n3.	用户使用本站所提供的各种/项信息过程中，向本站提供的各项用户信息及/或资料等必须是真实、完整、合法有效的，且前述信息及/或资料等有任何变更，必须及时更新。4.	用户必须承诺同意下述内容：\n（1）不得传输或发表：煽动抗拒、破坏宪法和法律、行政法规实施的言论，煽动颠覆国家政权，推翻社会主义制度的言论，煽动分裂国家、破坏国家统一的的言论，煽动民族仇恨、民族歧视、破坏民族团结的言论；\n   (2）从中国大陆向境外传输资料信息时必须符合中国有关法规；\n（3）不得利用本站从事洗钱、窃取商业秘密、窃取个人信息等违法犯罪活动；\n（4）不得干扰本站的正常运转，不得侵入本站及国家计算机信息系统；\n（5）不得传输或发表任何违法犯罪的、骚扰性的、中伤他人的、辱骂性的、恐吓性的、伤害性的、庸俗的、淫秽的、不文明的等信息资料；\n（6）不得传输或发表损害国家社会公共利益和涉及国家安全的信息资料或言论；\n（7）不得教唆他人从事本条所禁止的行为；\n（8）不得发布任何侵犯他人著作权、商标权等知识产权或合法权利的内容；\n（9）用户若有违反上述承诺的行为，本站拥有随时单方删除站内各类不符合上述规定的信息内容而无须通知用户的权利、采取暂停或关闭用户帐号等措施的权利、追究该用户有关法律责任的权利。\n\n5.	用户因使用所提供的各种/项信息、服务等而产生的任何争议、纠纷等，应当尽量友好协商解决，协商不成的应当至北京市朝阳区人民法院诉讼解决。\n");
			} else if (index == 2) {
				content.setText("	本站中关于用户的所有信息及其专长、服务范围和内容等，均由用户自行提供，用户依法应对其提供的任何信息承担全部责任。本站对前述信息的真实性、完整性、合法性等均不承担任何责任，亦而不带有任何保证，无论是明示、默示或法定的。\n\n	本站对任何使用或提供本站信息对外链接、商业活动及其风险不承担任何责任。\n\n	本站范围内的任何用户或使用者的留言评论、建议等，仅代表个人观点，本站对此不承担任何责任。\n\n	用户不应将其帐号、密码及自身资料或信息等转让、出借、透露予他人使用或知晓。如用户发现其帐号遭他人非法使用，应立即通知本站 support@danaaa.com。因黑客行为或用户的保管疏忽导致帐号、密码遭他人非法使用，本公司不承担任何责任。\n\n	关于以下事由造成的用户各项损失，本站不承担任何责任：\n（1）战争、事变、政府原因等不可抗力造成的意外情况；\n（2）使用者故意或过失所造成损害；\n（3）因通信服务提供业者方面造成之通信障碍；\n（4）游戏开发业者、游戏服务业者提供不良服务者或游戏开发运营者与游戏用户纠纷；\n（5）用户身份之真实性、民事权利能力民事行为能力之适当性、用户信用程度之可靠性；\n（6）交易物品来源真实性、合法性、权利归属或纠纷、数量、质量或性能等各种事项；\n（7）其他非本站所能控制或掌握之事项。 \n");
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
