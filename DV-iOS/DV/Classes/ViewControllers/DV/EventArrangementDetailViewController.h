//
//  EventArrangementDetailViewController.h
//  DV
//
//  Created by Zhao Zhicheng on 2/21/14.
//
//

#import <UIKit/UIKit.h>
#import "EventArrangementDetail.h"
#import "EventArrangement.h"
#import "ITTImageView.H"
#import <QuickLook/QuickLook.h>
#import "InfoCell.h"

@interface EventArrangementDetailViewController : UIViewController<DataRequestDelegate,ITTImageViewDelegate,QLPreviewControllerDataSource,InfoCellDelegate>
- (id)initWithEvent:(EventArrangement *)eventArrangement detail:(EventArrangementDetail *)eventArrangementDetail;

@end
