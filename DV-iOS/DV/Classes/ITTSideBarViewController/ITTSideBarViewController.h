//
//  ITTSideBarViewController.h
//  ChangBaiShanDemo
//
//  Created by Jack Liu on 13-5-13.
//
//

#import <UIKit/UIKit.h>
#import "ITTLeftSideBarViewController.h"

@interface ITTSideBarViewController : UIViewController<SideBarSelectDelegate, UINavigationControllerDelegate,UIGestureRecognizerDelegate>

@property (strong, nonatomic) IBOutlet UIView *navBackView;
@property (strong, nonatomic) IBOutlet UIView *contentView;

+ (ITTSideBarViewController *)sharedController;
- (id)initWithLeftSideBarViewController:(ITTLeftSideBarViewController *)leftViewController rightSideBarViewController:(UIViewController *)rightViewController;

@end
