//
//  EventFavoriteViewController.m
//  DV
//
//  Created by Zhao Zhicheng on 1/2/14.
//
//

#import "EventFavoriteViewController.h"
#import "EventDetailViewController.h"
#import "CONSTS.h"
#import "HTActivityIndicator.h"
#import "NSUserDefaults+RMSaveCustomObject.h"

@interface EventFavoriteViewController (){
    NSMutableArray *_eventArray;
}

@property (strong, nonatomic) IBOutlet ITTPullTableView *eventTableView;
@property (strong, nonatomic) IBOutlet UILabel *emptyLabel;

@end

@implementation EventFavoriteViewController

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
    [self.eventTableView setLoadMoreViewHidden:YES];
    [self.eventTableView setRefreshViewHidden:YES];
    self.eventTableView.pullBackgroundColor = [UIColor clearColor];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[AppDelegate shareAppdelegate].homeTabbarController hideTabBarAnimated:YES];
    [self.eventTableView deselectRowAtIndexPath:[self.eventTableView indexPathForSelectedRow] animated:YES];
    _eventArray = [Event searchWithWhere:nil orderBy:nil offset:0 count:100];
    if (!_eventArray||[_eventArray count]==0) {
        self.emptyLabel.text = @"您还没有收藏任何活动!";
        self.emptyLabel.hidden = NO;
    }else{
        self.emptyLabel.hidden = YES;
    }
    [self.eventTableView reloadData];
}

- (IBAction)tapOnBackBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - tableView

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
    event.isFavorite = YES;
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