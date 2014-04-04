//
//  UIDevice+ITTAdditions.h

#import <UIKit/UIKit.h>

@interface UIDevice (ITTAdditions)

+ (BOOL)isHighResolutionDevice;
+ (UIInterfaceOrientation)currentOrientation;
- (NSString *)getMacAddress;
@end
