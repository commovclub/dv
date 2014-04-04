//
//  UIAlertView+ITTAdditions.h


#import <UIKit/UIKit.h>

@interface UIAlertView (ITTAdditions)

+ (void) popupAlertByDelegate:(id)delegate title:(NSString *)title message:(NSString *)msg;
+ (void) popupAlertByDelegate:(id)delegate title:(NSString *)title message:(NSString *)msg cancel:(NSString *)cancel others:(NSString *)others, ...;
@end
