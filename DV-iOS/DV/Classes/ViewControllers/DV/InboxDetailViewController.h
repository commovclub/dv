//
//  InboxDetailViewController.h
//  DV
//
//  Created by Zhao Zhicheng on 2/19/14.
//
//

#import <UIKit/UIKit.h>
#import "DVMessage.h"

@interface InboxDetailViewController : UIViewController<DataRequestDelegate>
    
- (id)initWithMessage:(DVMessage *)message;
    
@end
