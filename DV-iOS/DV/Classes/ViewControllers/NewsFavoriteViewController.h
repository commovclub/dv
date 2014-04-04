//
//  NewsFavoriteViewController.h
//  DV
//
//  Created by Zhao Zhicheng on 3/4/14.
//
//

#import <UIKit/UIKit.h>
#import "News.h"
#import "NewsCell.h"
#import "ITTDataRequest.h"
#import "ITTPullTableView.h"

@interface NewsFavoriteViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, ITTPullTableViewDelegate,NewsCellDelegate>

- (id)initWith:(BOOL)favorite;

@end
