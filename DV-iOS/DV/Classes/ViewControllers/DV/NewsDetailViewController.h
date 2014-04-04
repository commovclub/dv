//
//  NewsDetailViewController.h
//  DV
//
//  Created by Zhao Zhicheng on 1/3/14.
//
//

#import <UIKit/UIKit.h>
#import "News.h"
#import "NewsCell.h"
#import "ITTPullTableView.h"
@interface NewsDetailViewController : UIViewController<DataRequestDelegate>

- (id)initWithNews:(NSMutableArray *)newsArray index:(NSInteger)index;
- (id)initWithNews:(News *)news;
- (id)initWithNews:(News *)news favorite:(BOOL)favorite;

@end
