//
//  MoreViewController.m
//  DV
//
//  Created by Zhao Zhicheng on 1/11/14.
//
//

#import "MoreViewController.h"
#import "AboutViewController.h"
#import "ContactDetailViewController.h"
#import "FavoriteViewController.h"
#import "ITTPullTableView.h"
#import "ICETutorialController.h"
#import "WorkListViewController.h"
#import "News.h"
#import "event.h"
#import "LKDBHelper.h"

@interface MoreViewController (){
    NSMutableArray *_moreArray;
    NSMutableArray *_iconsArray;
}
@property (strong, nonatomic) IBOutlet ITTPullTableView *moreTableView;

@end

@implementation MoreViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _moreArray = [[NSMutableArray alloc] init];
    _iconsArray =[[NSMutableArray alloc] init];
    [_moreArray addObject:@"个人空间"];
    [_moreArray addObject:@"我的作品"];
    [_moreArray addObject:@"俱乐部声明"];
    [_moreArray addObject:@"收藏夹"];
    [_moreArray addObject:@"退出"];
    [_iconsArray addObject:@"more_profile.png"];
    [_iconsArray addObject:@"more_setting.png"];
    [_iconsArray addObject:@"more_info.png"];
    [_iconsArray addObject:@"more_favorite.png"];
    [_iconsArray addObject:@"more_logout.png"];
    [self.moreTableView setLoadMoreViewHidden:YES];
    [self.moreTableView setRefreshViewHidden:YES];
    self.moreTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[AppDelegate shareAppdelegate].homeTabbarController showTabBarAnimated:YES];
    [self.moreTableView deselectRowAtIndexPath:[self.moreTableView indexPathForSelectedRow] animated:YES];
}

- (IBAction)tapOnAboutBtn:(id)sender {
    AboutViewController *viewController = [[AboutViewController alloc] initWithNibName:@"AboutViewController" bundle:nil];
    [self.navigationController pushViewController:viewController animated:NO];
}

- (IBAction)tapOnWorkBtn:(id)sender {
    WorkListViewController *viewController = [[WorkListViewController alloc] initWithNibName:@"WorkListViewController" bundle:nil];
    [self.navigationController pushViewController:viewController animated:NO];}

- (IBAction)tapOnProfileBtn:(id)sender {
    ContactDetailViewController *viewController = [[ContactDetailViewController alloc] initWithNibName:@"ContactDetailViewController" bundle:nil];
    [self.navigationController pushViewController:viewController animated:NO];
}

- (IBAction)tapOnFavoriteBtn:(id)sender {
    FavoriteViewController *viewController = [[FavoriteViewController alloc] initWithNibName:@"FavoriteViewController" bundle:nil];
    [self.navigationController pushViewController:viewController animated:NO];
}

- (IBAction)tapOnLogoutBtn:(id)sender {
    ICETutorialController *viewController = [[ICETutorialController alloc] initWithNibName:@"ICETutorialController_iPhone"
                                                                                    bundle:nil
                                                                                  andPages:nil];
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"APNS_TOKEN"];
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"USER_ID"];
    [[NSUserDefaults standardUserDefaults] rm_setCustomObject:[[Contact alloc] init] forKey:@"MYSELF"];
	[[NSUserDefaults standardUserDefaults] synchronize];
    [LKDBHelper clearTableData:[News class]];
    [LKDBHelper clearTableData:[Event class]];
    [self.navigationController pushViewController:viewController animated:NO];
}

#pragma mark - tableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_moreArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell  *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    int row  = indexPath.row;
    cell.textLabel.text = [_moreArray objectAtIndex:row];
//    if (row<3) {
    cell.textLabel.textColor = [UIColor whiteColor];
//    }else{
//        cell.textLabel.textColor = [UIColor redColor];
//    }
    cell.textLabel.font = [UIFont systemFontOfSize:16];
    cell.imageView.contentMode = UIViewContentModeCenter;
    cell.imageView.image = [UIImage imageNamed:[_iconsArray objectAtIndex:row]];
    cell.backgroundColor = [UIColor colorWithRed:61.0/255.0 green:82.0/255.0 blue:100.0/255.0 alpha:1];
    UIView *uiView = [[UIView alloc] init];
    uiView.backgroundColor = [UIColor darkGrayColor];
    uiView.frame = CGRectMake(0, 49, 320, 1);
    [cell.contentView addSubview:uiView];
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    int row = indexPath.row;
    switch (row) {
        case 0:
            [self tapOnProfileBtn:nil];
            break;
        case 1:
            [self tapOnWorkBtn:nil];
            break;
        case 2:
            [self tapOnAboutBtn:nil];
            break;
        case 3:
            [self tapOnFavoriteBtn:nil];
            break;
        case 4:
            [self tapOnLogoutBtn:nil];
            break;
        default:
            break;
    }
}

- (void)viewDidUnload {
    [self setMoreTableView:nil];
    [super viewDidUnload];
}
@end
