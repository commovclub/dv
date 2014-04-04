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
#import "ITTDataRequest.h"
#import "ITTPullTableView.h"
@interface NewsDetailViewController : UIViewController<UIWebViewDelegate>

- (id)initWithNews:(NSMutableArray *)newsArray index:(NSInteger)index;
- (id)initWithNews:(News *)news;

@end
