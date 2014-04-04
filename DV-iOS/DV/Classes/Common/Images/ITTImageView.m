//
//  ITTImageManager.m
//

#import "ITTImageView.h"
#import "UIUtil.h"
#import "DataEnvironment.h"
#import "ITTImageCacheManager.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface ITTImageView()
{
    UITapGestureRecognizer *_tapGestureRecognizer;
}
-(void)showLoading;
-(void)hideLoading;
-(void)handleTapGesture:(UITapGestureRecognizer *)recognizer;
@end

@implementation ITTImageView

- (void)dealloc{
    [self cancelImageRequest];
    _imageDataOperation.delegate = nil;

    _delegate = nil;

}

- (id)init{
    self = [super init];
	if (self) {
        self.indicatorViewStyle = UIActivityIndicatorViewStyleGray;
    }
	return self;
}

- (void)setDefaultImage:(UIImage*)defaultImage{
	self.image = defaultImage;
}

- (void)cancelImageRequest{
    if (_imageDataOperation && ([_imageDataOperation isExecuting] || [_imageDataOperation isReady])) {
        [_imageDataOperation cancel];
        ITTDINFO(@"image request is canceled,url:%@", _imageUrl);
    }
    [self hideLoading];
}

- (void)loadImage:(NSString*)url{
    [self loadImage:url placeHolder:nil];
}


- (void)loadImage:(NSString*)url placeHolder:(UIImage *)placeHolderImage
{
    //Used SDWebImage
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOffset = CGSizeMake(0, 1);
    self.layer.shadowOpacity = 0.5;
    self.layer.shadowRadius = 2.0;

    [self setImageWithURL:[NSURL URLWithString:url]
                         placeholderImage:placeHolderImage];
    
    /*
   	if( url==nil || [url isEqualToString:@""] ){
        if (placeHolderImage) {
            self.image = placeHolderImage;
        }
		return;
    }
    _imageUrl = url;
    [self cancelImageRequest];
    
    if ([[ITTImageCacheManager sharedManager] isImageInMemoryCacheWithUrl:_imageUrl]) {
        self.image = [[ITTImageCacheManager sharedManager] getImageFromCacheWithUrl:_imageUrl];
        [self hideLoading];
    }else{
        self.image = placeHolderImage;
        BOOL showShowLoading = YES;
        if (self.image) {
            showShowLoading = NO;
        }
        if (showShowLoading) {
            [self showLoading];
        }
        _imageDataOperation = [[ITTImageDataOperation alloc] initWithURL:_imageUrl delegate:self];
        
        [[ITTImageCacheManager sharedManager].imageQueue addOperation:_imageDataOperation];
    }
     */
}

-(void)setEnableTapEvent:(BOOL)enableTapEvent
{
    _enableTapEvent = enableTapEvent;
    if (_enableTapEvent) {
        [self setUserInteractionEnabled:YES];
        if (!_tapGestureRecognizer) {
            _tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
            _tapGestureRecognizer.cancelsTouchesInView = NO;
            [self addGestureRecognizer:_tapGestureRecognizer];
        }
    }else{
        if (_tapGestureRecognizer) {
            [self removeGestureRecognizer:_tapGestureRecognizer];
            _tapGestureRecognizer = nil;
        }
    }
}

-(void)setIndicatorViewStyle:(UIActivityIndicatorViewStyle)style{
    _indicatorViewStyle = style;
    [_indicator setActivityIndicatorViewStyle:style];
}

-(void)showLoading{
    if (!_indicator) {
        _indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:_indicatorViewStyle];
        _indicator.center = CGRectGetCenter(self.bounds);
        [_indicator setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleTopMargin];
    }
    _indicator.hidden = NO;
    if(!_indicator.superview){
        [self addSubview:_indicator];
    }
    [_indicator startAnimating];
}
-(void)hideLoading{
    if (_indicator) {
        [_indicator stopAnimating];
        _indicator.hidden = YES;
    }
}

- (void)handleTapGesture:(UITapGestureRecognizer *)recognizer{
    if (_delegate && [_delegate respondsToSelector:@selector(imageClicked:)]) {
        [_delegate imageClicked:self];
	}
}

#pragma mark - ITTImageDataOperationDelegate

-(void)imageDataOperation:(ITTImageDataOperation*)operation loadedWithUrl:(NSString*)url withImage:(UIImage *)image{
    if (operation.imageUrl == _imageUrl) {
        [self performSelectorOnMainThread:@selector(imageLoaded:) withObject:image waitUntilDone:YES];
    }
}

- (void)imageLoaded:(UIImage *)image{
    [self hideLoading];
    self.image = image;
	if (_delegate && [_delegate respondsToSelector:@selector(imageLoaded:)]) {
        [_delegate imageLoaded:self];
	}
}
@end

