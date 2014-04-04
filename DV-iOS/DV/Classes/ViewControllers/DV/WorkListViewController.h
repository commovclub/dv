//
//  WorkListViewController.h
//  DV
//
//  Created by Zhao Zhicheng on 3/7/14.
//
//

#import <UIKit/UIKit.h>
#import "ITTPullTableView.h"
#import "Work.h"
#import "WorkCell.h"

@interface WorkListViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, DataRequestDelegate, ITTPullTableViewDelegate,WorkCellDelegate,UIActionSheetDelegate>


@end
