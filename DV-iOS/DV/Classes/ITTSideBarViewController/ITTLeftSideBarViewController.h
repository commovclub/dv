//
//  ITTLeftSideBarViewController.h
//  ChangBaiShanDemo
//
//  Created by Jack Liu on 13-5-13.
//
//

#import <UIKit/UIKit.h>
@protocol SideBarSelectDelegate ;

typedef enum
{
    SideBarShowDirectionNone = 0,
    SideBarShowDirectionLeft = 1,
    SideBarShowDirectionRight = 2
}SideBarShowDirection;

@interface ITTLeftSideBarViewController : UIViewController

@property (weak,nonatomic)id<SideBarSelectDelegate> delegate;

@end



@protocol SideBarSelectDelegate<NSObject>

- (void)leftSideBarSelectWithController:(UIViewController *)controller;
- (void)rightSideBarSelectWithController:(UIViewController *)controller;
- (void)showSideBarControllerWithDirection:(SideBarShowDirection)direction;

@end