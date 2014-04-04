//
//  HomeTabBarController.h
//

#import <UIKit/UIKit.h>
#import "HomeTabBar.h"

@interface HomeTabBarController : UITabBarController<UITabBarControllerDelegate,HomeTabBarDelegate>

@property (strong, nonatomic)HomeTabBar * homeTabBar;

+ (HomeTabBarController *)sharedHomeTabBarController;
- (void)updateUpdateHintView;
- (void)selectTabBarAtIndex:(int)index;
- (void)hideTabBarAnimated:(BOOL)animated;
- (void)showTabBarAnimated:(BOOL)animated;
@end
