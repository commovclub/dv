//
//  ITSActivityIndicator.h
#import <Foundation/Foundation.h>


@interface HTActivityIndicator : UIView {
    
	UILabel *centerMessageLabel;
	UILabel *subMessageLabel;
	
	UIActivityIndicatorView *spinner;
}

@property (nonatomic, strong) UILabel *centerMessageLabel;
@property (nonatomic, strong) UILabel *subMessageLabel;

@property (nonatomic, strong) UIActivityIndicatorView *spinner;


+ (HTActivityIndicator *)currentIndicator;
+ (void)isTopDisplay:(BOOL)ifTopDisPlay;

- (void)show;
- (void)hideAfterDelay:(CGFloat)delayTime;
- (void)hide;
- (void)hidden;
- (void)displayMessage:(NSString *)m;
- (void)displayMessage:(NSString *)m afterDelay:(CGFloat)delayTime;
- (void)displayActivity:(NSString *)m;
- (void)displayCompleted:(NSString *)m;
- (void)displayFailed:(NSString *)m;
- (void)setCenterMessage:(NSString *)message;
- (void)setSubMessage:(NSString *)message;
- (void)showSpinner;
- (void)setProperRotation;
- (void)setProperRotation:(BOOL)animated;

@end
