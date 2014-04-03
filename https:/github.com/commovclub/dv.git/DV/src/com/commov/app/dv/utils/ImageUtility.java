package com.commov.app.dv.utils;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.lang.ref.SoftReference;

import android.content.Context;
import android.content.res.Resources;
import android.graphics.Bitmap;
import android.graphics.Bitmap.CompressFormat;
import android.graphics.Bitmap.Config;
import android.graphics.BitmapFactory;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.Paint;
import android.graphics.Rect;
import android.graphics.Region.Op;
import android.os.Debug;
import android.util.Log;
import android.util.SparseArray;
import android.view.View;
import android.widget.ImageView;

import com.androidquery.AQuery;
import com.androidquery.callback.BitmapAjaxCallback;
import com.commov.app.dv.common.CommonParam;
import com.commov.app.dv.R;

public class ImageUtility {
	public static Bitmap getCachedImage(Context context, String url,
			int targetWidthPx, boolean manualScale) {
		AQuery aq = new AQuery(context);
		if (manualScale)
			targetWidthPx = (targetWidthPx * 3) / 5;
		return aq.getCachedImage(url, targetWidthPx);
	}

	public static boolean loadImage(ImageView img, String url,
			int targetWidthPx, int waitingFaceResId, boolean manualScale) {

		if (manualScale)
			targetWidthPx = (targetWidthPx * 3) / 5;
		if (img == null)
			return false;
		if (url != null && url.length() > 0) {// URL可用
			AQuery aq = new AQuery(img);
			Bitmap bt = aq.getCachedImage(url, targetWidthPx);
			if (bt == null) {// 没有已经缓存的图片，先显示默认图片
				Bitmap presetBt = null;
				if (waitingFaceResId != 0) {
					presetBt = getMemoryCahceBitmap(img.getContext(),
							waitingFaceResId);
				}
				aq.image(url, true, true, targetWidthPx, 0, presetBt,
						AQuery.FADE_IN);
			} else {// 存在缓存图片，直接使用缓存图片,不需要先显示等待或者默认图片
				img.setImageBitmap(bt);
			}
		} else {
			fillOrClearImageView(img, waitingFaceResId);
		}
		return true;
	}

	/**
	 * 不管URL,ImageView是否是有效的,CallBack都会确保被调用
	 * 
	 * @param img
	 * @param url
	 * @param targetWidthPx
	 * @param waitingFaceResId
	 * @param callback
	 */
	public static void loadImage(ImageView img, String url, int targetWidthPx,
			int waitingFaceResId, BitmapAjaxCallback callback,
			boolean manualScale) {
		if (manualScale)
			targetWidthPx = (targetWidthPx * 3) / 5;
		AQuery aq = new AQuery(img);
		aq.image(url, true, true, targetWidthPx, waitingFaceResId, callback);
	}

	/**
	 * 添加一个等待的ProgressBar交给AQuery处理
	 * 
	 * @param img
	 * @param url
	 * @param targetWidthPx
	 * @param waitingFaceResId
	 * @param callback
	 * @param manualScale
	 * @param progress
	 */
	public static void loadImage(ImageView img, String url, int targetWidthPx,
			int waitingFaceResId, BitmapAjaxCallback callback,
			boolean manualScale, View progress) {
		if (manualScale)
			targetWidthPx = (targetWidthPx * 3) / 5;
		AQuery aq = new AQuery(img);
		aq = aq.progress(progress);
		aq.image(url, true, true, targetWidthPx, waitingFaceResId, callback);
	}

	public static void loadImage(ImageView img, String url, boolean memCache,
			boolean fileCache, int targetWidthPx, int waitingFaceResId,
			BitmapAjaxCallback callback, boolean manualScale) {
		if (manualScale)
			targetWidthPx = (targetWidthPx * 3) / 5;
		AQuery aq = new AQuery(img);
		aq.image(url, memCache, fileCache, targetWidthPx, waitingFaceResId,
				callback);
	}

	public static void loadImage(ImageView img, File file, int targetWidthPx) {
		AQuery aq = new AQuery(img);
		aq.image(file, true, targetWidthPx, null);
	}

	/**
	 * @see #cancelAqueryLoad(ImageView, boolean)
	 */
	public static void cancelAqueryLoad(ImageView img) {
		cancelAqueryLoad(img, false);
	}

	/**
	 * 将会清除View中key是AQuery.TAG_URL的Tag
	 * 
	 * @param img
	 * @param clearCurImgData
	 *            是否也把当前View的内容清除(只当View是ImageView的时候有效，clear之后图片将不显示任何东西)
	 */
	public static void cancelAqueryLoad(ImageView img, boolean clearCurImgData) {
		if (img != null) {
			cancelAqueryLoadRelationOnly(img);
			if (clearCurImgData) {
				img.setImageDrawable(null);
			}
		}
	}

	/**
	 * 取消和Aquery的加载关系，并使用指定的默认图片替换
	 * 
	 * @param img
	 * @param replaceResId
	 */
	public static void cancelAqueryLoad(ImageView img, int replaceResId) {
		if (img != null) {
			cancelAqueryLoadRelationOnly(img);
			fillOrClearImageView(img, replaceResId);
		}
	}

	/**
	 * 清除跟Aquery的关系，并不改变view任何特性
	 * 
	 * @param view
	 */
	public static void cancelAqueryLoadRelationOnly(View view) {
		if (view != null) {
			// 这个清除是否真的有效要根据AQuery的实现而定，之所以用下面的方法来清除AQuery加载关联关系，
			// 是因为我们看过源码里的处理逻辑，但是并不代表适合所有AQuery版本
			view.setTag(AQuery.TAG_URL, null);
		}
	}

	private static void fillOrClearImageView(ImageView img, int resId) {
		if (img != null) {
			if (resId == 0) {// 如果没有可以显示的图片，要清空ImageView的现有效果
				img.setImageBitmap(null);
			} else {
				// 如果URL可用，并且缓存没有数据的时候才用等待的图标
				img.setImageResource(resId);
			}
		}
	}

	private static SparseArray<SoftReference<Bitmap>> bitmaps = new SparseArray<SoftReference<Bitmap>>();

	/**
	 * 如果存在则直接返回，否则会尝试跟聚Resource Id读取，并添加到内存，所以要谨慎使用，避免不必要的缓存
	 * 
	 * @param context
	 * @param resId
	 * @return
	 */
	private static Bitmap getMemoryCahceBitmap(Context context, int resId) {
		SoftReference<Bitmap> refer = bitmaps.get(resId);
		if (refer == null || refer.get() == null) {
			Bitmap bt = null;
			bt = BitmapFactory.decodeResource(context.getResources(), resId);
			refer = new SoftReference<Bitmap>(bt);
			bitmaps.put(resId, refer);
		}
		return refer.get();
	}

	public static Bitmap getBitmapFromPool(Context context, PoolList resId) {
		return getMemoryCahceBitmap(context, resId.getResId());
	}

	/**
	 * 项目中经常需要用到的图片缓存，列出来哪些是在缓存池內的(避免不必要的缓存)
	 * 
	 * @author skg
	 * 
	 */
	public enum PoolList {
		bad(0);
		int resId;

		PoolList(int imgResourId) {
			resId = imgResourId;
		}

		int getResId() {
			return resId;
		}
	}

	public static boolean compressNoteFile(File source, File out) {
		if (source == null || !source.exists()) {
			return false;
		}
		return compress(source, out, CommonParam.note_img_max_width,
				CommonParam.note_img_max_height);
	}

	public static boolean compress(File source, File out, int maxW, int maxH) {
		if (source == null || !source.exists() || out == null || maxW <= 0
				|| maxH <= 0) {
			return false;
		}
		BitmapFactory.Options opts = new BitmapFactory.Options();
		opts.inJustDecodeBounds = true;
		BitmapFactory.decodeFile(source.getAbsolutePath(), opts);
		if (opts.outHeight <= maxH && opts.outWidth <= maxW) {
			opts.inSampleSize = 1;
		} else {
			int sw = Math.round(opts.outWidth / (float) maxW);
			int sh = Math.round(opts.outHeight / (float) maxH);
			if (sw > sh) {
				opts.inSampleSize = sw % 2 == 0 ? sw : sw + 1;
			} else {
				opts.inSampleSize = sh % 2 == 0 ? sh : sh + 1;
			}
			// Log.e("ttt", "out w:" + opts.outWidth + " out h:" +
			// opts.outHeight
			// + " sw:" + sw + "  sh:" + sh + " simple size:"
			// + opts.inSampleSize);
		}
		opts.inJustDecodeBounds = false;
		Bitmap bitmap = BitmapFactory
				.decodeFile(source.getAbsolutePath(), opts);
		if (bitmap == null || bitmap.isRecycled()) {
			return false;
		} else {
			boolean result = false;
			try {
				result = bitmap.compress(CompressFormat.JPEG,
						CommonParam.note_img_compress_qulity,
						new FileOutputStream(out));
			} catch (FileNotFoundException e) {
				e.printStackTrace();
				return false;
			} finally {
				if (bitmap != null && !bitmap.isRecycled()) {
					bitmap.recycle();
				}
			}
			return result;
		}
	}

	public static Bitmap decodeSampledBitmapFromResource(Resources res,
			int resId, int reqWidth) {

		// First decode with inJustDecodeBounds=true to check dimensions
		final BitmapFactory.Options options = new BitmapFactory.Options();
		options.inJustDecodeBounds = true;
		BitmapFactory.decodeResource(res, resId, options);

		// Calculate inSampleSize
		options.inSampleSize = calculateInSampleSize(options, reqWidth);

		// Decode bitmap with inSampleSize set
		options.inJustDecodeBounds = false;
		return BitmapFactory.decodeResource(res, resId, options);
	}

	public static Bitmap decodeSampledBitmapFromFile(String path, int reqWidth) {

		// First decode with inJustDecodeBounds=true to check dimensions
		final BitmapFactory.Options options = new BitmapFactory.Options();
		options.inJustDecodeBounds = true;
		BitmapFactory.decodeFile(path, options);

		// Calculate inSampleSize
		options.inSampleSize = calculateInSampleSize(options, reqWidth);

		// Decode bitmap with inSampleSize set
		options.inJustDecodeBounds = false;
		return BitmapFactory.decodeFile(path, options);
	}

	public static int calculateInSampleSize(BitmapFactory.Options options,
			int reqWidth) {
		// Raw height and width of image
		// final int height = options.outHeight;
		final int width = options.outWidth;
		int inSampleSize = 1;
		if (width > reqWidth) {
			inSampleSize = Math.round((float) width / (float) reqWidth);
		}
		return inSampleSize;
	}

	private static Paint defPaint = new Paint();
	{
		defPaint.setAntiAlias(true);
	}

	/**
	 * @see #drawBitmap(View, float, boolean, boolean)
	 */
	public static Bitmap drawBitmap(View view, float scale,
			boolean needWatermark) {
		return drawBitmap(view, scale, needWatermark, false);
	}

	/**
	 * View必须已经正常显示了(经过measure之后的view)，否则返回null
	 * 
	 * @param view
	 * @param needWatermark
	 * @param scale
	 *            在view的尺寸上做缩放(must>0)
	 * @param resoluteDraw
	 *            缩小对内存的预留，在保证不OOM的情况下进最大可能创建Bitmap
	 * @return
	 */
	public static Bitmap drawBitmap(View view, float scale,
			boolean needWatermark, boolean resoluteDraw) {
		if (view == null) {
			return null;
		}
		if (scale <= 0) {
			scale = 1;
		}
		int w = (int) (view.getWidth() * scale);
		int h = (int) (view.getHeight() * scale);
		h = getMemorySafeHeight(w, h, resoluteDraw);
		// 如果是不可接受的高度则不继续操作
		if (!isReceptibleHeight(view, h, scale)) {
			return null;
		}
		if (CommonParam.DEBUG) {
			debugReportMemory("drawBitmap#getMemorySafeHeight", null);
		}
		//
		Bitmap.Config config = Bitmap.Config.ARGB_8888;
		if (w <= 0 || h <= 0) {
			System.gc();
			return null;
		}
		Bitmap bitmap = null;
		try {
			bitmap = Bitmap.createBitmap(w, h, config);
			if (CommonParam.DEBUG) {
				debugReportMemory(
						"drawBitmap#getMemorySafeHeight#createBitmap",
						"after create bitmap and btimap size--> w:" + w + " h:"
								+ h);
			}
			Canvas canvas = new Canvas(bitmap);
			int bgC = Color.WHITE;
			canvas.drawColor(bgC);
			int c_count = canvas.save();
			canvas.scale(scale, scale);
			view.draw(canvas);
			canvas.restoreToCount(c_count);
			// WaterMark
			if (needWatermark) {
				addWatermark(view.getContext(), canvas);
			}
		} catch (OutOfMemoryError e) {
			System.gc();
		} catch (Exception e) {
		}
		return bitmap;
	}

	private static final int framePadding = 0;// px
	private static final int frameColor = 0xFFFFFFFF;
	private static final int water_padding = 6;// px

	public static Bitmap drawBitmapWithDecorate(View view) {
		return drawBitmapWithDecorate(view, 0.6f, true);
	}

	public static Bitmap drawBitmapWithDecorate(View view, float scale,
			boolean needWatermark) {
		if (view == null) {
			return null;
		}
		if (scale <= 0) {
			scale = 1;
		}
		int viewW = view.getWidth();
		int viewH = view.getHeight();
		int safeW;
		int safeH;
		int contentOffsetX;
		int contentOffsetY;
		float headerScale = 1;// 标题的sacle
		int reqW = (int) (viewW * scale) + framePadding * 2;// 两个padding
		int reqH = (int) (viewH * scale) + framePadding;// 一个padding
		//
		Bitmap header = null;
		Bitmap watemark = null;
		Bitmap resultBitmap = null;
		try {
			if (CommonParam.DEBUG) {
				debugReportMemory("drawBitmapWithDecorate",
						"befor drawBitmapWithDecorate");
			}
			header = decodeSampledBitmapFromResource(view.getResources(),
					R.drawable.ic_launcher, reqW);
			if (header == null) {
				return null;
			}
			// Header INIT
			int headerW = header.getWidth();
			int headerH = header.getHeight();
			if (headerW <= 0 || headerH <= 0) {
				return null;
			}
			safeW = reqW;
			headerScale = (float) safeW / headerW;
			contentOffsetX = framePadding;
			contentOffsetY = (int) (headerH * headerScale);
			// WaterMark INIT
			watemark = getMemoryCahceBitmap(view.getContext(),
					R.drawable.ic_launcher);
			int maxWaterW = safeW / 3;
			int waterH = watemark.getHeight();
			int waterW = watemark.getWidth();
			int waterScaledH;
			float waterScale = 1;
			if (waterW > maxWaterW) {// 需要缩小
				waterScale = (float) maxWaterW / waterW;
			}
			if (waterScale <= 0) {
				waterScale = 1;
			}
			waterScaledH = (int) (waterScale * waterH);
			// 根据View的高度Header，frame padding，WaterMark的高度计算总共的高度
			int trH = reqH + headerH + waterScaledH + water_padding * 2;// TotalRequestHeight(trh)
			safeH = getMemorySafeHeight(reqW, trH, false);
			// 如果是不可接受的高度则不继续操作
			if (!isReceptibleHeight(view, safeH, scale)) {
				return null;
			}
			if (safeW <= 0 || safeH <= 0) {
				return null;
			}
			//
			float waterLeft = (water_padding + framePadding) / waterScale;
			float waterTop = ((safeH - water_padding - framePadding)
					/ waterScale - waterH);
			// Draw---start
			Bitmap.Config config = Bitmap.Config.ARGB_8888;
			resultBitmap = Bitmap.createBitmap(safeW, safeH, config);
			Canvas canvas = new Canvas(resultBitmap);
			int bgC = Color.WHITE;
			canvas.drawColor(bgC);
			Rect rect = new Rect();
			int l = framePadding;
			int t = framePadding;
			int r = canvas.getWidth() - framePadding;
			int b = canvas.getHeight() - framePadding;
			rect.set(l, t, r, b);
			int c_count_frame = canvas.save();
			canvas.clipRect(rect, Op.DIFFERENCE);
			int frameC = frameColor;
			canvas.drawColor(frameC);
			canvas.restoreToCount(c_count_frame);
			// draw content view
			int c_count = canvas.save();
			rect.top = contentOffsetY;
			canvas.clipRect(rect, Op.INTERSECT);
			canvas.translate(contentOffsetX, contentOffsetY);
			canvas.scale(scale, scale);
			view.draw(canvas);
			canvas.restoreToCount(c_count);
			// draw WaterMark
			rect.top = (int) (safeH - water_padding * 2 - framePadding - waterH
					* waterScale);
			rect.bottom = safeH - framePadding;
			rect.left = framePadding;
			rect.right = canvas.getWidth() - framePadding;
			int c_count_water = canvas.save();
			canvas.clipRect(rect, Op.INTERSECT);
			int bgc = Color.WHITE;
			canvas.drawColor(bgc);
			canvas.scale(waterScale, waterScale, 0, 0);
			canvas.drawBitmap(watemark, waterLeft, waterTop, defPaint);
			canvas.restoreToCount(c_count_water);
			// draw header
			int c_count_header = canvas.save();
			canvas.scale(headerScale, headerScale);
			canvas.drawBitmap(header, 0, 0, defPaint);
			header.recycle();
			canvas.restoreToCount(c_count_header);
			//
			if (CommonParam.DEBUG) {
				debugReportMemory("drawBitmapWithDecorate",
						"after create Bitmap size--> safeW:" + safeW
								+ " safeH:" + safeH);
			}
		} catch (OutOfMemoryError e) {
		} catch (Exception e) {
			// 释放result bitmap有可能画的有问题
			safeRecycleBitmap(resultBitmap);
			resultBitmap = null;
		} finally {
			safeRecycleBitmap(header);
			header = null;
			System.gc();
		}
		return resultBitmap;
	}

	/**
	 * View截图最小高度系数,每个单位表示view所在的Window窗口的高度(即改窗口的高度，而不是view的高度)<br>
	 * min_height=n* (windown.height-status_bar.height)
	 */
	public static final int VIEW_CUT_MIN_N = 1;
	private final static String TAG = "ImageUtility";

	/**
	 * 判断高度是否在可以接受的高度范围内
	 * 
	 * @param v
	 * @param scaledHeight
	 * @return
	 */
	public static boolean isReceptibleHeight(View v, int scaledHeight,
			float scale) {
		if (scale <= 0) {
			scale = 1;
		}
		if (v == null) {
			return false;
		}
		if (scaledHeight <= 0) {
			return false;
		}
		int viewScaledHeight = (int) (v.getHeight() * scale);
		if (scaledHeight >= viewScaledHeight) {
			// 如果高度大于View的高度表示可以接受
			if (CommonParam.DEBUG) {
				Log.d(TAG, "height is >=viewScaledHeight,checke success:"
						+ scaledHeight + ">=" + viewScaledHeight);
			}
			return true;
		}
		Rect outRect = new Rect();
		v.getWindowVisibleDisplayFrame(outRect);
		int referMinHeight = outRect.height();
		//
		if (scaledHeight >= referMinHeight * VIEW_CUT_MIN_N) {
			// 如果Height小于View的高度，但是大于Window的高度，那么依然可以接受
			if (CommonParam.DEBUG) {
				Log.d(TAG,
						"height is >= view attached window's height,checke success. height:"
								+ scaledHeight + ">=" + referMinHeight);
			}
			return true;
		}
		if (CommonParam.DEBUG) {
			Log.w(TAG,
					"checke failed. hope H:" + scaledHeight + " view H:"
							+ v.getHeight() + " window info:" + outRect
							+ " viewScaledHeight:" + viewScaledHeight);
		}
		return false;
	}

	/**
	 * 添加默认水印
	 * <p>
	 * 建议使用{@link ImageUtility#addWatermark(Context, Canvas)}
	 * </p>
	 * 
	 * @param context
	 * @param watermarkCarrier
	 *            重载水印的图片
	 * @return
	 */
	public static Bitmap addWatermark(Context context, Bitmap watermarkCarrier) {
		if (watermarkCarrier == null || watermarkCarrier.isRecycled()) {
			return null;
		}
		Bitmap bitmap = watermarkCarrier;
		boolean needCopySource = false;
		if (!watermarkCarrier.isMutable()) {// 不可修改的Bitmap要先创建副本
			needCopySource = true;
			int w = watermarkCarrier.getWidth();
			int h = watermarkCarrier.getHeight();
			Config config = watermarkCarrier.getConfig();
			if (w > 0 && h > 0) {
				try {
					bitmap = Bitmap.createBitmap(w, h, config);
				} catch (OutOfMemoryError e) {
					System.gc();
				}
			} else {
				bitmap = null;
			}
		}
		if (bitmap != null && bitmap.isMutable()) {
			Canvas canvas = new Canvas(bitmap);
			if (needCopySource) {
				canvas.drawBitmap(watermarkCarrier, 0, 0, defPaint);
			}
			addWatermark(context, canvas);
		}
		return bitmap;
	}

	/**
	 * 添加默认水印图片
	 * 
	 * @param context
	 * @param watermarkCarrier
	 *            包含要添加水印的bitmap
	 * @return
	 */
	public static Canvas addWatermark(Context context, Canvas watermarkCarrier) {
		int cW;
		int cH;
		if (watermarkCarrier == null) {
			return null;
		}
		cW = watermarkCarrier.getWidth();
		cH = watermarkCarrier.getHeight();
		if (cW <= 0 || cH <= 0) {
			return watermarkCarrier;
		}
		//
		Bitmap watemark = getMemoryCahceBitmap(context, R.drawable.ic_launcher);
		int maxWaterW = cW / 3;
		float scale = 1;
		int waterW = watemark.getWidth();
		if (waterW > maxWaterW) {// 需要缩小
			scale = (float) maxWaterW / waterW;
		}
		if (scale <= 0) {
			scale = 1;
		}
		// cW - watemark.getWidth() - 10;//右下角的left算法
		float left = 10 / scale;
		float top = ((cH - 10) / scale - watemark.getHeight());
		int c_count = watermarkCarrier.save();
		watermarkCarrier.scale(scale, scale, 0, 0);
		watermarkCarrier.drawBitmap(watemark, left, top, defPaint);
		// watemark.recycle();//缓存起来不需要要主动回收
		watermarkCarrier.restoreToCount(c_count);
		return watermarkCarrier;
	}

	/**
	 * 计算内存允许的安全尺寸大小
	 * 
	 * @param expectW
	 * @param expectH
	 * @param resolute
	 */
	public static int getMemorySafeHeight(int expectW, int expectH,
			boolean resolute) {
		int reservedMB = 0;
		long heapReserved = 0;
		long mMaxVmHeap = Runtime.getRuntime().maxMemory();
		long allocedNativeHeap = Debug.getNativeHeapAllocatedSize();
		int double_1024 = 1024 * 1024;
		if (resolute) {// 坚决要画
			heapReserved = 1;
		} else {
			if (mMaxVmHeap >= (long) double_1024 * 40) {
				reservedMB = 4;
			} else if (mMaxVmHeap >= (long) double_1024 * 30) {
				reservedMB = 4;
			} else if (mMaxVmHeap >= (long) double_1024 * 20) {
				reservedMB = 2;
			} else {
				reservedMB = 1;
			}
		}
		heapReserved = double_1024 * reservedMB;
		//
		int w = expectW;
		int h = expectH;
		int pxSize = 4;
		long needSize = w * h * pxSize;
		if (needSize > 0) {
			long maxRequest = mMaxVmHeap - allocedNativeHeap - heapReserved;
			if (needSize > maxRequest) {
				needSize = maxRequest;
				h = (int) (needSize / pxSize / w);
			}
		}
		return h;
	}

	public static Bitmap crateBitmapFromView(View view) {
		if (view == null) {
			return null;
		}
		//
		int viewW = view.getWidth();
		int viewH = view.getHeight();
		if (viewW <= 0) {
			viewW = view.getMeasuredWidth();
		}
		if (viewH <= 0) {
			viewH = view.getMeasuredHeight();
		}
		if (viewW <= 0 || viewH <= 0) {
			return null;
		}
		Bitmap resultBitmap = null;
		try {
			resultBitmap = Bitmap.createBitmap(viewW, viewH, Config.ARGB_8888);
		} catch (Exception e) {
			safeRecycleBitmap(resultBitmap);
			resultBitmap = null;
			e.printStackTrace();
			return null;
		}
		Canvas canvas = new Canvas(resultBitmap);
		view.draw(canvas);
		return resultBitmap;
	}

	public static void safeRecycleBitmap(Bitmap bitmap) {
		if (bitmap == null || bitmap.isRecycled()) {
			return;
		}
		bitmap.recycle();
	}

	/**
	 * 汇报Memory情况
	 */
	public static void debugReportMemory(String actionTag, String desc) {
		String TAG = "MemoryTracker";
		int double1024 = 1024 * 1024;
		// 当前可使用的内存空间
		if (actionTag != null) {
			Log.d(TAG, "=========" + actionTag + "=========");
		}
		if (desc != null) {
			Log.d(TAG, "--->Description:" + desc);
		}
		long mMaxVmHeap = Runtime.getRuntime().maxMemory();
		long allocedNativeHeap = Debug.getNativeHeapAllocatedSize();
		Log.d(TAG, "--->maxMemory:" + mMaxVmHeap + "(" + mMaxVmHeap
				/ double1024 + "/MB)");
		Log.d(TAG, "--->NativeHeapAllocatedSize:" + allocedNativeHeap + "("
				+ allocedNativeHeap / double1024 + "/MB)");
		if (actionTag != null) {
			Log.d(TAG, "=========" + actionTag + "=========");
		}
		Log.d(TAG, "---");
	}
}
