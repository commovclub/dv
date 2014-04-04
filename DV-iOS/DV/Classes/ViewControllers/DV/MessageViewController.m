//
//  MessageViewController.m
//  DV
//
//  Created by Zhao Zhicheng on 1/10/14.
//
//

#import "MessageViewController.h"
#import "ITTPullTableView.h"
#import "MessageManager.h"
#import "InboxCell.h"
#import "ReplyCell.h"
#import "Friend.h"

@interface MessageViewController (){
NSMutableArray *_messages;
NSMutableArray *_replies;

}
@property (strong, nonatomic) IBOutlet UIButton *inboxBtn;
@property (strong, nonatomic) IBOutlet UIButton *replyBtn;
@property (strong, nonatomic) IBOutlet ITTPullTableView *inboxTableView;
@property (strong, nonatomic) IBOutlet UIView *messageMarker;
@property (strong, nonatomic) IBOutlet UIView *replyMarker;
@property (strong, nonatomic) IBOutlet UILabel *noContentLabel;
@property (strong, nonatomic) IBOutlet UIView *typeSelectLine;

@end

@implementation MessageViewController

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
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    _messages = [MessageManager sharedMessageManager].messages;
    _replies = [MessageManager sharedMessageManager].replies;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[AppDelegate shareAppdelegate].homeTabbarController showTabBarAnimated:YES];
}
- (IBAction)tapOnInboxBtn:(id)sender {
    self.inboxTableView.pullTableIsRefreshing = NO;
    self.inboxBtn.enabled = NO;
    self.replyBtn.enabled = YES;
    self.noContentLabel.hidden = YES;
    [self.inboxTableView startRefreshing];
    self.noContentLabel.text = @"没有任何私信";
    [UIView animateWithDuration:0.3
                     animations:^(){
                         self.typeSelectLine.left = 0;
                     }];
}

- (IBAction)tapOnReplyBtn:(id)sender {
    self.inboxTableView.pullTableIsRefreshing = NO;
    self.replyBtn.enabled = NO;
    self.inboxBtn.enabled = YES;
    self.noContentLabel.hidden = YES;
    [self.inboxTableView startRefreshing];
    self.noContentLabel.text = @"没有任何通知";
    [UIView animateWithDuration:0.3
                     animations:^(){
                         self.typeSelectLine.left = 160;
                     }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (!self.inboxBtn.enabled) {
        return [_messages count];
    }else{
        return [_replies count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!self.inboxBtn.enabled) {
        static NSString *CellIdentifierInboxCell = @"InboxCell";
        InboxCell *cell = (InboxCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifierInboxCell];
        if (cell == nil||![cell isKindOfClass:[InboxCell class]]) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"InboxCell" owner:self options:nil][0];
        }
        DVMessage *message = [_messages objectAtIndex:indexPath.row];
        [cell setMessageData:message];
        
        return cell;
    }else{
        static NSString *CellIdentifierReplyCell = @"ReplyCell";
        ReplyCell *cell = (ReplyCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifierReplyCell];
        if (cell == nil||![cell isKindOfClass:[ReplyCell class]]) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"ReplyCell" owner:self options:nil][0];
        }
        Reply *reply = [_replies objectAtIndex:indexPath.row];
        [cell setReplyData:reply];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!self.inboxBtn.enabled) {
        
    }else{
        
    }
}

- (void)pullTableViewDidTriggerRefresh:(ITTPullTableView*)pullTableView
{
    if (([_messages count] == 0&&!self.inboxBtn.enabled)||([_replies count] == 0&&!self.replyBtn.enabled)) {
        self.noContentLabel.hidden = NO;
    }else{
        self.noContentLabel.hidden = YES;
    }
    if (!self.inboxBtn.enabled) {
        [self.inboxTableView reloadData];
        [[MessageManager sharedMessageManager] requestNewMessages];
    }else{
        [_replies removeAllObjects];
        [self.inboxTableView reloadData];
        [[MessageManager sharedMessageManager] requestNewReply];
    }
}

- (void)pullTableViewDidTriggerLoadMore:(ITTPullTableView*)pullTableView
{
    
}


- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewDidUnload {
    [self setInboxTableView:nil];
    [self setMessageMarker:nil];
    [self setReplyMarker:nil];
    [self setNoContentLabel:nil];
    [super viewDidUnload];
}


@end
