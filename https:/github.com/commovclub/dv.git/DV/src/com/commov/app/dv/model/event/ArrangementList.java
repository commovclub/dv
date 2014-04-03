package com.commov.app.dv.model.event;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

public class ArrangementList implements Serializable {
	private static final long serialVersionUID = 1L;
	private String header;

	private String footer;
	private List<Arrangement> schedule;

	public String getTopTitle() {
		return header;
	}

	public void setTopTitle(String topTitle) {
		this.header = topTitle;
	}

	public String getBottomTitle() {
		return footer;
	}

	public void setBottomTitle(String bottomTitle) {
		this.footer = bottomTitle;
	}

	public List<Arrangement> getArrangementList() {
		return schedule;
	}

	public void setArrangementList(List<Arrangement> arrangementList) {
		this.schedule = arrangementList;
	}

	public static List<ArrangementList> getDummyList() {
		List<ArrangementList> arrangements = new ArrayList<ArrangementList>();
		for (int i = 1; i <= 5; i++) {
			ArrangementList arrangementList = new ArrangementList();
			List<Arrangement> tempArrangement = new ArrayList<Arrangement>();
			for (int j = 1; j < 6; j++) {
				Arrangement arrangement = new Arrangement();
				arrangement.setTitle("董事长致辞");
				arrangement.setSubTitle("演讲人： 张玮,这里可以显示两行的内容，长一些的内容。。。。其他的会被截取的");
				arrangement.setTime(j+":00PM");
				tempArrangement.add(arrangement);
			}
			arrangementList.setArrangementList(tempArrangement);
			arrangementList.setTopTitle("2014年1月1"+i+"日 活动日程安排");
			arrangementList.setBottomTitle("按时到达，自备酒水");
			arrangements.add(arrangementList);
		}
		return arrangements;
	}
}
