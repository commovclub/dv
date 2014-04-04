//
//  FavoriteViewController.m
//  DV
//
//  Created by Zhao Zhicheng on 2/10/14.
//
//

#import "FavoriteViewController.h"
#import "ITTPullTableView.h"
#import "NewsFavoriteViewController.h"
#import "EventFavoriteViewController.h"
#import "FriendsViewController.h"

@interface FavoriteViewController (){
    NSMutableArray *_favoriteArray;
    NSMutableArray *_iconsArray;

}
@property (strong, nonatomic) IBOutlet ITTPullTableView *favoriteTableView;

@end


@implementation FavoriteViewController

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
    _favoriteArray = [[NSMutableArray alloc] init];
    [_favoriteArray addObject:@"我收藏的新闻"];
    [_favoriteArray addObject:@"我收藏的活动"];
    [_favoriteArray addObject:@"我关注的好友"];
    [_favoriteArray addObject:@"关注我的好友"];
    _iconsArray =[[NSMutableArray alloc] init];
    [_iconsArray addObject:@"icon1_selected.png"];
    [_iconsArray addObject:@"icon2_selected.png"];
    [_iconsArray addObject:@"more_profile.png"];
    [_iconsArray addObject:@"more_profile.png"];
    [self.favoriteTableView setLoadMoreViewHidden:YES];
    [self.favoriteTableView setRefreshViewHidden:YES];
    self.favoriteTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[AppDelegate shareAppdelegate].homeTabbarController hideTabBarAnimated:YES];
    [self.favoriteTableView deselectRowAtIndexPath:[self.favoriteTableView indexPathForSelectedRow] animated:YES];
}

- (IBAction)tapOnBackBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - tableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_favoriteArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell  *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    int row  = indexPath.row;
    cell.textLabel.text = [_favoriteArray objectAtIndex:row];
    cell.textLabel.textColor = [UIColor whiteColor];
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
    if (row == 0) {
        NewsFavoriteViewController *newsViewController =[[NewsFavoriteViewController alloc] initWith:YES];
        [self.navigationController pushViewController:newsViewController animated:NO];
    }else if (row == 1) {
        EventFavoriteViewController *viewController = [[EventFavoriteViewController alloc] initWithNibName:@"EventFavoriteViewController" bundle:nil];
        [self.navigationController pushViewController:viewController animated:NO];
    }else if (row == 2) {
        FriendsViewController *viewController = [[FriendsViewController alloc] initWithType:1];
        [self.navigationController pushViewController:viewController animated:NO];
    }else if (row == 3) {
        FriendsViewController *viewController = [[FriendsViewController alloc] initWithType:2];
        [self.navigationController pushViewController:viewController animated:NO];
    }else{
        
        [[HTActivityIndicator currentIndicator] displayMessage:@"还没实现"];
    }
}


- (void)viewDidUnload {
    [self setFavoriteTableView:nil];
    [super viewDidUnload];
}
@end
