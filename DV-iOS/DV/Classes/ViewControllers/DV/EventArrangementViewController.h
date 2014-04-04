//
//  EventListViewController.h
//  DV
//
//  Created by Zhao Zhicheng on 1/17/14.
//
//

#import <UIKit/UIKit.h>
#import "Event.h"
#import "EventArrangement.h"
#import "EventArrangementDetail.h"
#import "EventTimeCell.h"

@interface EventArrangementViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, EventTimeCellDelegate, DataRequestDelegate>
- (id)initWithEvent:(Event *)event;
@end
