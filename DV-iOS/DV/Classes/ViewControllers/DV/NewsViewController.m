//
//  NewsViewController.m
//  DV
//
//  Created by Zhao Zhicheng on 1/2/14.
//
//

#import "NewsViewController.h"
#import "CONSTS.h"
#import "HTActivityIndicator.h"
#import "NewsDetailViewController.h"
#import "ICETutorialController.h"
#import "DVImage.h"
#import "NSUserDefaults+RMSaveCustomObject.h"

@interface NewsViewController (){
    NSMutableArray *_newsArray;
}
@property (strong, nonatomic) IBOutlet ITTPullTableView *newsTableView;

@end

@implementation NewsViewController

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
    _newsArray = [[NSMutableArray alloc] init];
    //init by the last updated news list
    NSDictionary *dic = [[NSUserDefaults standardUserDefaults] rm_customObjectForKey:@"NEWS_CACHE"];
    [self parseNSDictionary:dic];
    [self.newsTableView reloadData];
    self.newsTableView.pullBackgroundColor = [UIColor clearColor];
    NSString *userId=[[NSUserDefaults standardUserDefaults] stringForKey:@"USER_ID"];
    //如果登陆，先登陆
    if (userId&&[userId length]) {
        [self.newsTableView startRefreshing];
    }else{
        ICETutorialController *viewController = [[ICETutorialController alloc] initWithNibName:@"ICETutorialController_iPhone"
                                                                                        bundle:nil
                                                                                      andPages:nil];
        
        [self.navigationController pushViewController:viewController animated:NO];
        [self.newsTableView startRefreshing];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[AppDelegate shareAppdelegate].homeTabbarController showTabBarAnimated:YES];
    [self.newsTableView deselectRowAtIndexPath:[self.newsTableView indexPathForSelectedRow] animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)sendGetNews
{
    if (!self.newsTableView.pullTableIsLoadingMore && !self.newsTableView.pullTableIsRefreshing) {
        [_newsArray removeAllObjects];
        [self.newsTableView reloadData];
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (self.newsTableView.pullTableIsRefreshing) {
        [params setObject:@"1" forKey:@"pageNumber"];
    }else{
        [params setObject:[NSString stringWithFormat:@"%d", [_newsArray count]/LIST_PAGE_COUNT + 1] forKey:@"pageNumber"];
    }
    [params setObject:[NSString stringWithFormat:@"%d", LIST_PAGE_COUNT] forKey:@"pageSize"];
    [GetNewsListDataRequest requestWithDelegate:self withParameters:params];
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
    //根据不同的新闻类型显示不同的高度
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
    NewsDetailViewController *newsDetailViewController =[[NewsDetailViewController alloc] initWithNews:_newsArray index:indexPath.row];
    [self.navigationController pushViewController:newsDetailViewController animated:NO];
}

- (void)requestDidFinishLoad:(ITTBaseDataRequest*)request
{
    if ([request isSuccess]) {
        [self parseNSDictionary:request.resultDic];
        if ([_newsArray count]<=LIST_PAGE_COUNT) {//保存第一页
            [[NSUserDefaults standardUserDefaults]  rm_setCustomObject:request.resultDic forKey:@"NEWS_CACHE"];
            [[NSUserDefaults standardUserDefaults]  synchronize];
        }
    }else{
        [[HTActivityIndicator currentIndicator] displayMessage:request.result.message];
    }
    [self.newsTableView reloadData];
    self.newsTableView.pullTableIsLoadingMore = NO;
    self.newsTableView.pullTableIsRefreshing = NO;
}

- (void) parseNSDictionary:(NSDictionary*)dic{
    NSMutableArray *tempArray = [dic objectForKey:@"data"];
    NSMutableArray *nArray = [[NSMutableArray alloc] init];
    for (int i=0; i<[tempArray count]; i++) {
        NSDictionary *innerDic = tempArray[i];
        NSMutableArray *imagesArray = [innerDic objectForKey:@"images"];
        NSMutableArray *images = [[NSMutableArray alloc] init];
        for (int j=0; j<[imagesArray count]; j++) {
            DVImage *image=[[DVImage alloc] initWithDataDic:imagesArray[j]];
            [images addObject:image];
            
        }
        News *news = [[News alloc] initWithDataDic:innerDic];
        news.time = [UIUtil getStringWithDoubleDate:[news.time doubleValue]];
        news.images = images;
        if (!news.images ||[news.images count]==0) {
            news.type = @"0";
        }else if ([news.images count]<=2) {
            news.type = @"1";
        }else{
            news.type = @"3";
        }
        [nArray addObject:news];
    }
    if ([nArray count] == LIST_PAGE_COUNT) {
        [self.newsTableView setLoadMoreViewHidden:NO];
    }else{
        [self.newsTableView setLoadMoreViewHidden:YES];
    }
    if (self.newsTableView.pullTableIsLoadingMore) {
        [_newsArray addObjectsFromArray:nArray];
    }else{
        _newsArray = nArray;
    }
}

- (void)request:(ITTBaseDataRequest*)request didFailLoadWithError:(NSError*)error
{
    [[HTActivityIndicator currentIndicator] displayMessage:@"网络不佳，请检查网络!"];
    self.newsTableView.pullTableIsLoadingMore = NO;
    self.newsTableView.pullTableIsRefreshing = NO;
}

#pragma mark - ITTPullTableView Delegate
- (void)pullTableViewDidTriggerRefresh:(ITTPullTableView*)pullTableView
{
    [self sendGetNews];
}

- (void)pullTableViewDidTriggerLoadMore:(ITTPullTableView*)pullTableView
{
    [self sendGetNews];
}

#pragma mark - NewsCellDelegate
- (void)imageDidSelected:(News *)news{
    
}


- (void)viewDidUnload {
    [self setNewsTableView:nil];
    [super viewDidUnload];
}
@end
