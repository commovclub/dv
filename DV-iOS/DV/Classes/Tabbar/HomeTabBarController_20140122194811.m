//
//  HomeTabBarController.m
//
//

#import "HomeTabBarController.h"
#import "NewsViewController.h"
#import "EventViewController.h"
#import "ContactViewController.h"
#import "InboxViewController.h"
#import "MoreViewController.h"
#import "CONSTS.h"

@interface HomeTabBarController ()

@end

@implementation HomeTabBarController

static HomeTabBarController * homeTabBarController = nil;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)init
{
    if(self = [super init]){
        homeTabBarController = self;
        self.delegate = self;
        
        NewsViewController *newsViewController = [[NewsViewController alloc] init];
        EventViewController *eventViewController = [[EventViewController alloc] init];
        ContactViewController *contactViewController = [[ContactViewController alloc] init];
        InboxViewController *inboxViewController = [[InboxViewController alloc] init];
        MoreViewController *moreViewController = [[MoreViewController alloc] init];
        UINavigationController *newsNavController = [[UINavigationController alloc] initWithRootViewController:newsViewController];
        UINavigationController *eventNavController = [[UINavigationController alloc] initWithRootViewController:eventViewController];
        UINavigationController *contactNavController = [[UINavigationController alloc] initWithRootViewController:contactViewController];
        UINavigationController *inxboxNavController = [[UINavigationController alloc] initWithRootViewController:inboxViewController];
        UINavigationController *moreNavController = [[UINavigationController alloc] initWithRootViewController:moreViewController];

        [newsNavController setNavigationBarHidden:YES];
        [eventNavController setNavigationBarHidden:YES];
        [contactNavController setNavigationBarHidden:YES];
        [inxboxNavController setNavigationBarHidden:YES];
        [moreNavController setNavigationBarHidden:YES];
        [self setViewControllers:[NSArray arrayWithObjects:newsNavController,eventNavController,contactNavController,inxboxNavController,moreNavController, nil]];
        


        self.tabBar.hidden = YES;
        [self setContentViewHeight];


    }
    
    return self;
}

+ (HomeTabBarController *)sharedHomeTabBarController
{
    return homeTabBarController;
}

- (void)setContentViewHeight
{
    UIView * contentView;
    if([[self.view.subviews objectAtIndex:0] isKindOfClass:[UITabBar class]]){
        contentView = [self.view.subviews objectAtIndex:1];
    }
    else{
        contentView = [self.view.subviews objectAtIndex:0];
    }
    contentView.height = SCREEN_HEIGHT;
}

- (void)selectTabBarAtIndex:(int)index
{
    if(self.selectedIndex!=index){
        self.selectedIndex=index;
    }
//    }else{
        //self.selectedIndex=index;
        //[self.selectedViewController popToRootViewControllerAnimated:YES];
 //   }
}

- (void)hideTabBarAnimated:(BOOL)animated
{
    float animationTime = animated?0.3:0;
    [self.view bringSubviewToFront:self.homeTabBar];
    [UIView animateWithDuration:animationTime animations:^{
        self.homeTabBar.top = self.view.height+2;
    }];
}

- (void)showTabBarAnimated:(BOOL)animated
{
    float animationTime = animated?0.3:0;
    [self.view bringSubviewToFront:self.homeTabBar];
    [UIView animateWithDuration:animationTime animations:^{
        self.homeTabBar.bottom = self.view.height;
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.homeTabBar = [HomeTabBar viewFromNib];
    self.homeTabBar.bottom = SCREEN_HEIGHT;
    self.homeTabBar.delegate = self;
    [self.view addSubview:self.homeTabBar];
    [self selectTabBarAtIndex:0];
}

- (void)homeTabBar:(HomeTabBar *)homeTabBar didSelectTabAtIndex:(int)index
{
    [self selectTabBarAtIndex:index];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end