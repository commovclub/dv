//
//  EventViewController.h
//  DV
//
//  Created by Zhao Zhicheng on 1/2/14.
//
//

#import <UIKit/UIKit.h>
#import "Event.h"
#import "EventCell.h"
#import "ITTPullTableView.h"
#import "SGFocusImageFrame.h"
#import "SGFocusImageItem.h"
@interface EventViewController  : UIViewController<UITableViewDataSource, UITableViewDelegate, DataRequestDelegate, ITTPullTableViewDelegate,EventCellDelegate,SGFocusImageFrameDelegate>

@property (strong, nonatomic) IBOutlet UIScrollView *scrollViewImages;
@property (strong, nonatomic) IBOutlet UIPageControl *pageControl;
@property (strong,nonatomic)NSMutableArray *slideImages;
@end
