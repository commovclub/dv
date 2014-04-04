//
//  NewsFavoriteViewController.m
//  DV
//
//  Created by Zhao Zhicheng on 1/2/14.
//
//

#import "NewsFavoriteViewController.h"
#import "CONSTS.h"
#import "HTActivityIndicator.h"
#import "NewsDetailViewController.h"
#import "ICETutorialController.h"
#import "DVImage.h"
#import "NSUserDefaults+RMSaveCustomObject.h"

@interface NewsFavoriteViewController (){
    NSMutableArray *_newsArray;
    BOOL _favorite;
}
@property (strong, nonatomic) IBOutlet ITTPullTableView *newsTableView;
@property (strong, nonatomic) IBOutlet UILabel *emptyLabel;

@end

@implementation NewsFavoriteViewController

- (id)initWith:(BOOL)favorite{
    self = [super init];
    if (self) {
        _favorite = favorite;
    }
    return self;
}
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
    [self.newsTableView setLoadMoreViewHidden:YES];
    [self.newsTableView setRefreshViewHidden:YES];
    self.newsTableView.pullBackgroundColor = [UIColor clearColor];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[AppDelegate shareAppdelegate].homeTabbarController hideTabBarAnimated:YES];
    [self.newsTableView deselectRowAtIndexPath:[self.newsTableView indexPathForSelectedRow] animated:YES];
    _newsArray = [News searchWithWhere:nil orderBy:nil offset:0 count:100];
    if (!_newsArray||[_newsArray count]==0) {
        self.emptyLabel.text = @"您还没有收藏任何新闻!";
        self.emptyLabel.hidden = NO;
    }else{
        self.emptyLabel.hidden = YES;
    }
    [self.newsTableView reloadData];
}

- (IBAction)tapOnBackBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - tableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_newsArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"NewsCell";
    NewsCell *cell = (NewsCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"NewsCell" owner:self options:nil][0];
    }
    cell.delegate = self;
    News *news = _newsArray[indexPath.row];
    [cell setNewsData:news];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    News *news = _newsArray[indexPath.row];
    if ([news.type isEqualToString:@"0"]) {
        return 105;
    }else if ([news.type isEqualToString:@"1"]) {
        return 85;
    }else if ([news.type isEqualToString:@"3"]) {
        return 155;
    }
    return 105;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    News *news =[_newsArray objectAtIndex:indexPath.row];
    news.isFavorite = YES;
    NewsDetailViewController *newsDetailViewController =[[NewsDetailViewController alloc] initWithNews:news favorite:YES];
    [self.navigationController pushViewController:newsDetailViewController animated:NO];
}


#pragma mark - NewsCellDelegate
- (void)imageDidSelected:(News *)news{
    
}

- (void)viewDidUnload {
    [self setNewsTableView:nil];
    [super viewDidUnload];
}
@end
