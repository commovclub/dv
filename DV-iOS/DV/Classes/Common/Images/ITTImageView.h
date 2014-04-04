//
//  ITTImageView.h
//
//
#import "ITTImageDataOperation.h"

@class ITTImageView;
@protocol ITTImageViewDelegate <NSObject>
@optional
- (void)imageLoaded:(ITTImageView *)imageView;
- (void)imageClicked:(ITTImageView *)imageView;
@end

@interface ITTImageView : UIImageView <ITTImageDataOperationDelegate, UIGestureRecognizerDelegate>{
	id<ITTImageViewDelegate> __weak _delegate;
    UIActivityIndicatorView *_indicator;
    UIActivityIndicatorViewStyle _indicatorViewStyle;
    NSString *_imageUrl;
    ITTImageDataOperation *_imageDataOperation;    
    //响应Tap方法
    BOOL _enableTapEvent;
}
@property (nonatomic,strong,readonly) NSString *imageUrl;
@property (nonatomic,weak) id<ITTImageViewDelegate> delegate;
@property (nonatomic,assign) BOOL enableTapEvent;
@property (nonatomic,assign) UIActivityIndicatorViewStyle indicatorViewStyle;

- (void)loadImage:(NSString*)url;
- (void)loadImage:(NSString*)url placeHolder:(UIImage *)placeHolderImage;
- (void)setDefaultImage:(UIImage*)defaultImage;
- (void)cancelImageRequest;

@end
