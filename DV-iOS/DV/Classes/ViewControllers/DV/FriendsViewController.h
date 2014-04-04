//
//  FriendsViewController.h
//  DV
//
//  Created by Zhao Zhicheng on 3/6/14.
//
//

#import <UIKit/UIKit.h>
#import "ITTPullTableView.h"
#import "Contact.h"
#import "ContactCell.h"
#import "ITTPullTableView.h"
#import "MJNIndexView.h"

@interface FriendsViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, DataRequestDelegate, ITTPullTableViewDelegate,ContactCellDelegate, MJNIndexViewDataSource>

- (id)initWithType:(int)_type;

@end
