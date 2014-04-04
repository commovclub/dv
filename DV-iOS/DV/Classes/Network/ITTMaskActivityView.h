//
//  ITTMaskActivityView.h

#import "ITTXibView.h"

@class ITTBaseDataRequest;
@protocol ITTMaskActivityViewDelegate;

@interface ITTMaskActivityView : ITTXibView
{
    void (^_onRequestCanceled)(ITTMaskActivityView *);
}

@property (weak, nonatomic) id<ITTMaskActivityViewDelegate>delegate;


- (void)showInView:(UIView*)view;
- (void)showInView:(UIView *)view withHintMessage:(NSString *)message;
- (void)showInView:(UIView *)view withHintMessage:(NSString *)message
   onCancleRequest:(void(^)(ITTMaskActivityView *view))onCanceledBlock;

- (void)hide;

@end

@protocol ITTMaskActivityViewDelegate <NSObject>

- (void)maskActivityViewCancleRequest:(ITTMaskActivityView*)maskActivityView;

@end