//
//  HTImageViewer.m
//  HotWord
//
//  Created by Jack on 13-6-8.
//
//

#import "HTImageViewer.h"
#import "ITTImageZoomableView.h"

@implementation HTImageViewer

+ (void)showImage:(NSString *)imageUrl
{
    if ( !imageUrl || [@"" isEqualToString:imageUrl]) {
        return;
    }
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    ITTImageZoomableView *zoomableView = [[ITTImageZoomableView alloc] initWithFrame:window.frame];
    ITTImageInfo *imageInfo = [[ITTImageInfo alloc] init];
    imageInfo.smallUrl = imageUrl;
    imageInfo.url = [ITTImageInfo getImageUrlWithSourceUrl:imageUrl];
    [zoomableView displayImage:imageInfo];
    zoomableView.tag = 9999;
    [window addSubview:zoomableView];
    zoomableView.alpha = 0;
    [UIView animateWithDuration:0.5
                     animations:^(){
                         zoomableView.alpha = 1;
                     }];
    
}
+ (void)hideImage{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    UIView *view = [window viewWithTag:9999];
    
    [UIView animateWithDuration:0.5
                     animations:^(){
                         view.alpha = 0;
                     }completion:^(BOOL finished){
                         [view removeFromSuperview];
                     }];
}

@end
