//
//  AppDelegate.h

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "ITTDataRequest.h"
#import "HomeTabBarController.h"


@class ICETutorialController;
@interface AppDelegate : UIResponder <UIApplicationDelegate, CLLocationManagerDelegate, DataRequestDelegate>
{
    CLLocationManager *_localtionManager;
    NSDictionary *_updateDic;
    NSDictionary *_recommandAppDic;
}
+(AppDelegate*)shareAppdelegate;
@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, retain) HomeTabBarController *homeTabbarController;
@property (strong, nonatomic) ICETutorialController *viewController;
@property NSString *appId;
@property NSString *channelId;
@property NSString *userId;

@end
