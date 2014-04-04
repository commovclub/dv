//
//  InboxViewController.h
//  HotWord
//
//  Created by Jack Liu on 13-5-15.
//
//

#import <UIKit/UIKit.h>
#import "ITTPullTableView.h"
#import "InboxCell.h"
#import "ReplyCell.h"

@interface InboxViewController : UIViewController<ITTPullTableViewDelegate,DataRequestDelegate>

@end
