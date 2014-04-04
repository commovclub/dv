//
//  EventFavoriteViewController.h
//  DV
//
//  Created by Zhao Zhicheng on 3/4/14.
//
//

#import <UIKit/UIKit.h>
#import "Event.h"
#import "EventCell.h"
#import "ITTPullTableView.h"

@interface EventFavoriteViewController  : UIViewController<UITableViewDataSource, UITableViewDelegate, ITTPullTableViewDelegate,EventCellDelegate>

@end
