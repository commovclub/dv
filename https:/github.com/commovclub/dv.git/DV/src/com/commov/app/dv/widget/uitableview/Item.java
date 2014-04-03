package com.commov.app.dv.widget.uitableview;

public class Item {

	private int drawable = -1;
	private String title;
	private String summary;
	private boolean hightlight = false;

	public Item(String _title) {
		this.title = _title;
	}

	public Item(String _title, boolean _highLight) {
		this.title = _title;
		this.hightlight = _highLight;
	}

	public Item(String _title, String _summary) {
		this.title = _title;
		this.summary = _summary;
	}

	public Item(int _drawable, String _title, String _summary) {
		this.drawable = _drawable;
		this.title = _title;
		this.summary = _summary;
	}

	public Item(int _drawable, String _title, String _summary,
			boolean _highLight) {
		this.drawable = _drawable;
		this.title = _title;
		this.summary = _summary;
		this.hightlight = _highLight;
	}

	public int getDrawable() {
		return drawable;
	}

	public void setDrawable(int drawable) {
		this.drawable = drawable;
	}

	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
	}

	public String getSummary() {
		return summary;
	}

	public void setSummary(String summary) {
		this.summary = summary;
	}

	public boolean isHightlight() {
		return hightlight;
	}

	public void setHightlight(boolean hightlight) {
		this.hightlight = hightlight;
	}

}
