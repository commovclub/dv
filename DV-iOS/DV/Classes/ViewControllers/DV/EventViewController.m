//
//  EventViewController.m
//  DV
//
//  Created by Zhao Zhicheng on 1/2/14.
//
//

#import "EventViewController.h"
#import "EventDetailViewController.h"
#import "CONSTS.h"
#import "HTActivityIndicator.h"
#import "NSUserDefaults+RMSaveCustomObject.h"

@interface EventViewController (){
    //事件列表对象
    NSMutableArray *_eventArray;
    //banner 列表对象
    NSMutableArray *_imagesArray;
    IBOutlet UIScrollView *scrollViewImages;
    IBOutlet UIPageControl *pageControl;
}

@property (strong, nonatomic) IBOutlet ITTPullTableView *eventTableView;
@property (strong, nonatomic) IBOutlet UIView *tableHeaderView;

@end

@implementation EventViewController

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
    _eventArray = [[NSMutableArray alloc] init];
    _imagesArray = [[NSMutableArray alloc] init];
    //init by the last updated event list
    NSDictionary *dic = [[NSUserDefaults standardUserDefaults] rm_customObjectForKey:@"EVENT_CACHE"];
    [self parseNSDictionary:dic];
    [self initBanner];
    [self.eventTableView reloadData];
    [self.eventTableView startRefreshing];
    [self.eventTableView setLoadMoreViewHidden:YES];
    self.eventTableView.pullBackgroundColor = [UIColor clearColor];
}

#pragma mark -
- (void)initBanner
{
    NSMutableArray *_SGFocusImageItemArray = [[NSMutableArray alloc] init];
    for (int i=0; i<[_imagesArray count]; i++) {
        Event *event =[_imagesArray objectAtIndex:i];
        ITTImageView *imageView =[[ITTImageView alloc] init];
        [imageView loadImage:event.path placeHolder:[UIImage imageNamed:@"placeholder@2x.png"]];
        SGFocusImageItem *item = [[SGFocusImageItem alloc] initWithTitle:@"" background:imageView tag:i];
        item.tag = i;
        [_SGFocusImageItemArray addObject:item];
    }
    SGFocusImageFrame *imageFrame = [[SGFocusImageFrame alloc] initWithFrame:CGRectMake(0, 20, self.view.bounds.size.width, 160)
                                                                    delegate:self
                                                                      images:_SGFocusImageItemArray];
    self.eventTableView.tableHeaderView = imageFrame;
}

#pragma mark -
- (void)foucusImageFrame:(SGFocusImageFrame *)imageFrame didSelectItem:(SGFocusImageItem *)item
{
    NSLog(@"%@ tapped", item.title);
    Event * event = [_imagesArray objectAtIndex:item.tag];
    [self imageDidSelected:event];
}

- (IBAction)tapOnBanner:(id)sender {
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[AppDelegate shareAppdelegate].homeTabbarController showTabBarAnimated:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)sendGetEvent
{
    if (!self.eventTableView.pullTableIsLoadingMore && !self.eventTableView.pullTableIsRefreshing) {
        [_eventArray removeAllObjects];
        [self.eventTableView reloadData];
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (self.eventTableView.pullTableIsRefreshing) {
        [params setObject:@"1" forKey:@"pageNumber"];
    }else{
        [params setObject:[NSString stringWithFormat:@"%d", [_eventArray count]/LIST_PAGE_COUNT + 1] forKey:@"pageNumber"];
    }
    [params setObject:[NSString stringWithFormat:@"%d", LIST_PAGE_COUNT] forKey:@"pageSize"];
    [GetEventListDataRequest requestWithDelegate:self withParameters:params];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_eventArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"EventCell";
    EventCell *cell = (EventCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"EventCell" owner:self options:nil][0];
    }
    cell.delegate = self;
    Event *event = _eventArray[indexPath.row];
    [cell setEventData:event];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Event *event = _eventArray[indexPath.row];
    [self imageDidSelected:event];
}

- (void)requestDidFinishLoad:(ITTBaseDataRequest*)request
{
    if ([request isSuccess]) {
        [self parseNSDictionary:request.resultDic];
        if ([_eventArray count]<=LIST_PAGE_COUNT) {
            [[NSUserDefaults standardUserDefaults]  rm_setCustomObject:request.resultDic forKey:@"EVENT_CACHE"];
            [[NSUserDefaults standardUserDefaults]  synchronize];
        }
    }else{
        [[HTActivityIndicator currentIndicator] displayMessage:request.result.message];
    }
    [self initBanner];
    [self.eventTableView reloadData];
    self.eventTableView.pullTableIsLoadingMore = NO;
    self.eventTableView.pullTableIsRefreshing = NO;
}

- (void)request:(ITTBaseDataRequest*)request didFailLoadWithError:(NSError*)error
{
    [[HTActivityIndicator currentIndicator] displayMessage:@"网络不佳，请检查网络!"];
    [self initBanner];
    [self.eventTableView reloadData];
    self.eventTableView.pullTableIsLoadingMore = NO;
    self.eventTableView.pullTableIsRefreshing = NO;
}

- (void) parseNSDictionary:(NSDictionary*)dic{
    NSMutableArray *tempArray = [dic objectForKey:@"events"];
    NSMutableArray *nArray = [[NSMutableArray alloc] init];
    for (int i=0; i<[tempArray count]; i++) {
        NSDictionary *innerDic = tempArray[i];
        Event *event = [[Event alloc] initWithDataDic:innerDic];
        [nArray addObject:event];
        event.time = [UIUtil getStringWithDoubleDate:[event.time doubleValue]];
    }
    if ([nArray count] == LIST_PAGE_COUNT) {
        [self.eventTableView setLoadMoreViewHidden:NO];
    }else{
        [self.eventTableView setLoadMoreViewHidden:YES];
    }
    if (self.eventTableView.pullTableIsLoadingMore) {
        [_eventArray addObjectsFromArray:nArray];
    }else{
        _eventArray = nArray;
    }
    if (!self.eventTableView.pullTableIsLoadingMore) {
        [_imagesArray removeAllObjects];
    }
    NSMutableArray *bannerTempArray = [dic objectForKey:@"banner"];
    if (bannerTempArray &&[bannerTempArray count]>0) {
        for (int i=0; i<[bannerTempArray count]; i++) {
            NSDictionary *innerDic = bannerTempArray[i];
            Event *event = [[Event alloc] initWithDataDic:innerDic];
            event.time = [UIUtil getStringWithDoubleDate:[event.time doubleValue]];
            [_imagesArray addObject:event];
        }
    }
}

#pragma mark - ITTPullTableView Delegate
- (void)pullTableViewDidTriggerRefresh:(ITTPullTableView*)pullTableView
{
    [self sendGetEvent];
}

- (void)pullTableViewDidTriggerLoadMore:(ITTPullTableView*)pullTableView
{
    [self sendGetEvent];
}

#pragma mark - EventCellDelegate
- (void)imageDidSelected:(Event *)event{
    EventDetailViewController *newsDetailViewController = [[EventDetailViewController alloc] initWithEvent:event];
    [self.navigationController pushViewController:newsDetailViewController animated:YES];
}

- (void)viewDidUnload {
    [self setEventTableView:nil];
    [super viewDidUnload];
}
@end