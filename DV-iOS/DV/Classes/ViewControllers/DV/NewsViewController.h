//
//  NewsViewController.h
//  DV
//
//  Created by Zhao Zhicheng on 1/2/14.
//
//

#import <UIKit/UIKit.h>
#import "News.h"
#import "NewsCell.h"
#import "ITTDataRequest.h"
#import "ITTPullTableView.h"

@interface NewsViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, DataRequestDelegate, ITTPullTableViewDelegate,NewsCellDelegate>

@end
