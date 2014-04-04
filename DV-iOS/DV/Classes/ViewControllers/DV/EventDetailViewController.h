//
//  EventDetailViewController.h
//  DV
//
//  Created by Zhao Zhicheng on 1/13/14.
//
//

#import <UIKit/UIKit.h>
#import "Event.h"

@interface EventDetailViewController : UIViewController<UIWebViewDelegate,UIActionSheetDelegate,DataRequestDelegate>
- (id)initWithEvent:(Event *)event;
@end
