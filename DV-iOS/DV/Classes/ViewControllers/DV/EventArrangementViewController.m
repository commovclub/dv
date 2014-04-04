//
//  EventListViewController.m
//  DV
//
//  Created by Zhao Zhicheng on 1/17/14.
//
//

#import "EventArrangementViewController.h"
#import "ITTPullTableView.h"
#import "Event.h"
#import "EventTimeCell.h"
#import "EventArrangementDetailViewController.h"
@interface EventArrangementViewController (){
    NSMutableArray *_eventArrangementArray;
}

@property (strong, nonatomic) IBOutlet ITTPullTableView *eventArrangementTableView;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) Event *event;

@end

@implementation EventArrangementViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (id)initWithEvent:(Event *)event{
    self = [super init];
    if (self) {
        self.event = event;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.eventArrangementTableView setLoadMoreViewHidden:YES];
    [self.eventArrangementTableView setRefreshViewHidden:YES];
    self.titleLabel.text = self.event.title;
    [self sendGetArrangement];
}

- (void)viewWillDisappear:(BOOL)animated{
    [[HTActivityIndicator currentIndicator] hide];
}

- (void)sendGetArrangement
{
    [GetEventDataRequest requestWithDelegate:self withParameters:nil withUrl:[[REQUEST_DOMAIN stringByAppendingString:@"event/"] stringByAppendingFormat:@"%@/schedule",self.event.eventId]];
    
    [[HTActivityIndicator currentIndicator] displayActivity:@"加载中..."];
}

- (void)requestDidFinishLoad:(ITTBaseDataRequest*)request
{
    if ([request isSuccess]) {
        NSMutableArray *tempArray = [request.resultDic objectForKey:@"data"];
        NSMutableArray *nArray = [[NSMutableArray alloc] init];
        for (int i=0; i<[tempArray count]; i++) {
            NSDictionary *innerDic = tempArray[i];
            
            NSMutableArray *scheduleArray = [innerDic objectForKey:@"schedule"];
            NSMutableArray *schedules = [[NSMutableArray alloc] init];
            for (int j=0; j<[scheduleArray count]; j++) {
                EventArrangementDetail *eventArrangementDetail=[[EventArrangementDetail alloc] initWithDataDic:scheduleArray[j]];
                [schedules addObject:eventArrangementDetail];
            }
            EventArrangement *eventArrangement = [[EventArrangement alloc] initWithDataDic:innerDic];
            eventArrangement.eventArrangemntDetailArray = schedules;
            [nArray addObject:eventArrangement];
        }
        
        if ([nArray count] == LIST_PAGE_COUNT) {
            [self.eventArrangementTableView setLoadMoreViewHidden:NO];
        }else{
            [self.eventArrangementTableView setLoadMoreViewHidden:YES];
            
        }
        if (self.eventArrangementTableView.pullTableIsLoadingMore) {
            [_eventArrangementArray addObjectsFromArray:nArray];
        }else{
            _eventArrangementArray = nArray;
        }
        
        [self.eventArrangementTableView reloadData];
        [[HTActivityIndicator currentIndicator] hide];
    }else{
        [[HTActivityIndicator currentIndicator] displayMessage:request.result.message];
    }
    
}


- (void)request:(ITTBaseDataRequest*)request didFailLoadWithError:(NSError*)error
{
    [[HTActivityIndicator currentIndicator] displayMessage:@"网络不佳，请检查网络!"];
}


- (IBAction)tapOnBackBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   //
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    EventArrangement *eventArrangement = [_eventArrangementArray objectAtIndex:section];
    return  [eventArrangement.eventArrangemntDetailArray count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [_eventArrangementArray count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    EventArrangement *eventArrangement =[_eventArrangementArray objectAtIndex:section];
    return eventArrangement.topText;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section{
    EventArrangement *eventArrangement =[_eventArrangementArray objectAtIndex:section];
    return eventArrangement.bottomText;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UILabel *myLabel = [[UILabel alloc] init];
    myLabel.frame = CGRectMake(10, 0, 320, 20);
    myLabel.font = [UIFont systemFontOfSize:14];
    myLabel.textColor = [UIColor whiteColor];
    myLabel.backgroundColor = [UIColor clearColor];
    myLabel.text = [self tableView:tableView titleForHeaderInSection:section];
    
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = [UIColor colorWithRed:66.0/255.0 green:86.0/255.0 blue:100.0/255.0 alpha:0.75];
    [headerView addSubview:myLabel];
    
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"EventTimeCell";
    EventTimeCell *cell = (EventTimeCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"EventTimeCell" owner:self options:nil][0];
    }
    EventArrangementDetail *eventArrangementDetail = [[EventArrangementDetail alloc] init];
    
    if ([_eventArrangementArray count] > indexPath.section) {
        EventArrangement *eventArrangement = [_eventArrangementArray objectAtIndex:indexPath.section];
        eventArrangementDetail = (EventArrangementDetail *) [eventArrangement.eventArrangemntDetailArray objectAtIndex:indexPath.row];
        eventArrangementDetail.date = eventArrangement.topText;

    } else {
        NSLog(@"sortedArrForArrays out of range");
    }
    [cell setEventData:eventArrangementDetail index:indexPath.row];
    cell.delegate = self;
    return cell;
}

- (void)moreDidSelected:(EventArrangementDetail *)eventArrangementDetail{
    //打开演讲稿
    EventArrangementDetailViewController *eventEnclosureViewController = [[EventArrangementDetailViewController alloc] initWithEvent:nil detail:eventArrangementDetail];
    [self.navigationController pushViewController:eventEnclosureViewController animated:YES];
}

@end
