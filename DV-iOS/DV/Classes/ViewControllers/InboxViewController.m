//
//  InboxViewController.m

#import "InboxViewController.h"
#import "MessageManager.h"
#import "ConversationViewController.h"
#import "InboxDetailViewController.h"
#import "NSUserDefaults+RMSaveCustomObject.h"
#import "DVMessage.h"
#import "ConversationViewController.h"
#import "MessageCount.h"

@interface InboxViewController ()
{
    NSMutableArray *_messages;
    NSMutableArray *_replies;
    NSMutableArray *_projects;

}
@property (retain, nonatomic) IBOutlet UIButton *inboxBtn;
@property (retain, nonatomic) IBOutlet UIButton *projectBtn;
@property (retain, nonatomic) IBOutlet UIButton *replyBtn;
@property (retain, nonatomic) IBOutlet UIButton *inboxCountBtn;
@property (retain, nonatomic) IBOutlet UIButton *projectCountBtn;
@property (retain, nonatomic) IBOutlet UIButton *replyCountBtn;
@property (retain, nonatomic) IBOutlet ITTPullTableView *inboxTableView;
@property (retain, nonatomic) IBOutlet UILabel *noContentLabel;
@property (retain, nonatomic) IBOutlet UIView *typeSelectLine;
@end

@implementation InboxViewController

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
    self.navigationController.navigationBarHidden = YES;
    self.inboxTableView.pullBackgroundColor = [UIColor clearColor];
    self.inboxBtn.enabled = NO;
    [self.inboxTableView startRefreshing];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[AppDelegate shareAppdelegate].homeTabbarController showTabBarAnimated:YES];
    [self.inboxTableView deselectRowAtIndexPath:[self.inboxTableView indexPathForSelectedRow] animated:YES];
    [self.inboxTableView startRefreshing];
    [self updateCount];
    [self sendGetMessageCount];
}

-(void)updateCount{
    MessageCount *messageCount =[[NSUserDefaults standardUserDefaults] rm_customObjectForKey:@"MESSAGE_COUNT"];
    int count = ([messageCount.systemCount integerValue]+[messageCount.privateCount integerValue]+[messageCount.leadCount integerValue]);
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:count];
    
    if ([messageCount.systemCount integerValue]>0) {
        self.inboxCountBtn.hidden = NO;
        if ([messageCount.systemCount integerValue]>99) {
            [self.inboxCountBtn setTitle:@"99+" forState:UIControlStateNormal];
        }else{
            [self.inboxCountBtn setTitle:messageCount.systemCount forState:UIControlStateNormal];
        }
    }else{
        self.inboxCountBtn.hidden = YES;
    }
    if ([messageCount.privateCount integerValue]>0) {
        self.replyCountBtn.hidden = NO;
        if ([messageCount.systemCount integerValue]>99) {
            [self.replyCountBtn setTitle:@"99+" forState:UIControlStateNormal];
        }else{
            [self.replyCountBtn setTitle:messageCount.privateCount forState:UIControlStateNormal];
        }
    }else{
        self.replyCountBtn.hidden = YES;
    }
    if ([messageCount.leadCount integerValue]>0) {
        self.projectCountBtn.hidden = NO;
        if ([messageCount.systemCount integerValue]>99) {
            [self.projectCountBtn setTitle:@"99+" forState:UIControlStateNormal];
        }else{
            [self.projectCountBtn setTitle:messageCount.leadCount forState:UIControlStateNormal];
        }
    }else{
        self.projectCountBtn.hidden = YES;
    }
}

- (void)handleNewMessage:(NSNotification *)notification
{
    self.inboxTableView.pullTableIsRefreshing = NO;
    if (notification.userInfo) {
        _messages = [MessageManager sharedMessageManager].messages;
        [self.inboxTableView reloadData];
    }
}

- (void)handleNewReply:(NSNotification *)notification
{
    self.inboxTableView.pullTableIsRefreshing = NO;
    if (notification.userInfo) {
        _replies = [MessageManager sharedMessageManager].replies;
        [self.inboxTableView reloadData];
    }
}

- (IBAction)tapOnInboxBtn:(id)sender {
    self.inboxTableView.pullTableIsRefreshing = NO;
    self.inboxBtn.enabled = NO;
    self.replyBtn.enabled = YES;
    self.projectBtn.enabled = YES;
    self.noContentLabel.hidden = YES;
    [self.inboxTableView startRefreshing];
    [UIView animateWithDuration:0.3
                     animations:^(){
                         self.typeSelectLine.left = 0;
                     }];
}

- (IBAction)tapOnProjectBtn:(id)sender {
    self.inboxTableView.pullTableIsRefreshing = NO;
    self.inboxBtn.enabled = YES;
    self.replyBtn.enabled = YES;
    self.projectBtn.enabled = NO;
    self.noContentLabel.hidden = YES;
    [self.inboxTableView startRefreshing];
    [UIView animateWithDuration:0.3
                     animations:^(){
                         self.typeSelectLine.left = 107;
                     }];
}

- (IBAction)tapOnReplyBtn:(id)sender {
    self.inboxTableView.pullTableIsRefreshing = NO;
    self.replyBtn.enabled = NO;
    self.inboxBtn.enabled = YES;
    self.projectBtn.enabled = YES;
    self.noContentLabel.hidden = YES;
    [self.inboxTableView startRefreshing];
    [UIView animateWithDuration:0.3
                     animations:^(){
                         self.typeSelectLine.left = 215;
                     }];
}

- (void)sendGetMessageCount
{
    NSString *userId=[[NSUserDefaults standardUserDefaults] stringForKey:@"USER_ID"];
    if (userId) {
        [CountOfMessageDataRequest requestWithDelegate:self withParameters:nil withUrl:[REQUEST_DOMAIN stringByAppendingFormat:@"message/count/%@",userId]];
    }
}

- (void)sendGetMessages
{
    if (!self.inboxTableView.pullTableIsLoadingMore && !self.inboxTableView.pullTableIsRefreshing) {
        if (!self.inboxBtn.enabled) {
            [_messages removeAllObjects];
        }else if (!self.projectBtn.enabled) {
            [_projects removeAllObjects];
        }else{
            [_replies removeAllObjects];
        }

        [self.inboxTableView reloadData];
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (self.inboxTableView.pullTableIsRefreshing) {
        [params setObject:@"1" forKey:@"pageNumber"];
    }else{
        [params setObject:[NSString stringWithFormat:@"%d", [_messages count]/LIST_PAGE_COUNT + 1] forKey:@"pageNumber"];
    }
    [params setObject:[NSString stringWithFormat:@"%d", LIST_PAGE_COUNT] forKey:@"pageSize"];
    if (!self.inboxBtn.enabled) {
        [SystemMessageDataRequest requestWithDelegate:self withParameters:params];
    }else if (!self.projectBtn.enabled) {
        [ProjectMessageDataRequest requestWithDelegate:self withParameters:params];
    }else{
        [PrivateMessageDataRequest requestWithDelegate:self withParameters:params];
    }
}

- (void)requestDidFinishLoad:(ITTBaseDataRequest*)request
{
    if ([request isSuccess]) {
        if ([request isKindOfClass:[SystemMessageDataRequest class]]) {
            [self parseNSDictionarySystemMessage:request.resultDic];
            [[NSUserDefaults standardUserDefaults]  rm_setCustomObject:request.resultDic forKey:@"SYSTEM_MESSAGE_CACHE"];
        }else if ([request isKindOfClass:[PrivateMessageDataRequest class]]) {
            [self parseNSDictionaryPrivateMessage:request.resultDic];
            [[NSUserDefaults standardUserDefaults]  rm_setCustomObject:request.resultDic forKey:@"PRIVATE_MESSAGE_CACHE"];
        }else if ([request isKindOfClass:[ProjectMessageDataRequest class]]) {
            [self parseNSDictionaryProjectMessage:request.resultDic];
            [[NSUserDefaults standardUserDefaults]  rm_setCustomObject:request.resultDic forKey:@"PROJECT_MESSAGE_CACHE"];
        }else if([request isKindOfClass:[CountOfMessageDataRequest class]]){
            MessageCount *messageCount =[[MessageCount alloc] initWithDataDic:request.resultDic];
            NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
            [defaults rm_setCustomObject:messageCount forKey:@"MESSAGE_COUNT"];
            [defaults synchronize];

            [self updateCount];
        }

        [[NSUserDefaults standardUserDefaults]  synchronize];
        [[HTActivityIndicator currentIndicator] hide];
    }else{
        [[HTActivityIndicator currentIndicator] displayMessage:request.result.message];
    }
    self.inboxTableView.pullTableIsLoadingMore = NO;
    self.inboxTableView.pullTableIsRefreshing = NO;
}

- (void)request:(ITTBaseDataRequest*)request didFailLoadWithError:(NSError*)error
{
    [[HTActivityIndicator currentIndicator] displayMessage:@"网络不佳，请检查网络!"];
    self.inboxTableView.pullTableIsLoadingMore = NO;
    self.inboxTableView.pullTableIsRefreshing = NO;
}

- (void) parseNSDictionarySystemMessage:(NSDictionary*)dic{
    NSMutableArray *tempArray = [dic objectForKey:@"data"];
    NSMutableArray *nArray = [[NSMutableArray alloc] init];
    for (int i=0; i<[tempArray count]; i++) {
        NSDictionary *innerDic = tempArray[i];
        DVMessage *message = [[DVMessage alloc] initWithDataDic:innerDic];
       [nArray addObject:message];
    }
    
    if ([nArray count] == LIST_PAGE_COUNT) {
        [self.inboxTableView setLoadMoreViewHidden:NO];
    }else{
        [self.inboxTableView setLoadMoreViewHidden:YES];
    }
    if (self.inboxTableView.pullTableIsLoadingMore) {
        [_messages addObjectsFromArray:nArray];
    }else{
        _messages = nArray;
    }

    if (!_messages||[_messages count]==0) {
        self.noContentLabel.text = @"没有任何系统消息";
        self.noContentLabel.hidden = NO;
    }else{
        self.noContentLabel.hidden = YES;
    }
    [self.inboxTableView reloadData];
}

- (void) parseNSDictionaryProjectMessage:(NSDictionary*)dic{
    NSMutableArray *tempArray = [dic objectForKey:@"data"];
    NSMutableArray *nArray = [[NSMutableArray alloc] init];
    for (int i=0; i<[tempArray count]; i++) {
        NSDictionary *innerDic = tempArray[i];
        DVMessage *message = [[DVMessage alloc] initWithDataDic:innerDic];
        [nArray addObject:message];
    }
    
    if ([nArray count] == LIST_PAGE_COUNT) {
        [self.inboxTableView setLoadMoreViewHidden:NO];
    }else{
        [self.inboxTableView setLoadMoreViewHidden:YES];
    }
    if (self.inboxTableView.pullTableIsLoadingMore) {
        [_projects addObjectsFromArray:nArray];
    }else{
        _projects = nArray;
    }
    
    if (!_projects||[_projects count]==0) {
        self.noContentLabel.text = @"没有任何项目消息";
        self.noContentLabel.hidden = NO;
    }else{
        self.noContentLabel.hidden = YES;
    }
    [self.inboxTableView reloadData];
}

- (void) parseNSDictionaryPrivateMessage:(NSDictionary*)dic{
    NSMutableArray *tempArray = [dic objectForKey:@"data"];
    NSMutableArray *nArray = [[NSMutableArray alloc] init];
    for (int i=0; i<[tempArray count]; i++) {
        NSDictionary *innerDic = tempArray[i];
        DVMessage *message = [[DVMessage alloc] initWithDataDic:innerDic];
        [nArray addObject:message];
    }
    if ([nArray count] == LIST_PAGE_COUNT) {
        [self.inboxTableView setLoadMoreViewHidden:NO];
    }else{
        [self.inboxTableView setLoadMoreViewHidden:YES];
    }
    if (self.inboxTableView.pullTableIsLoadingMore) {
        [_replies addObjectsFromArray:nArray];
    }else{
        _replies = nArray;
    }

    if (!_replies||[_replies count]==0) {
        self.noContentLabel.text = @"没有任何私信";
        self.noContentLabel.hidden = NO;
    }else{
        self.noContentLabel.hidden = YES;
    }
    [self.inboxTableView reloadData];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (!self.inboxBtn.enabled) {
        return [_messages count];
    }else if (!self.projectBtn.enabled) {
        return [_projects count];
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
        [cell setMessageData:[_messages objectAtIndex:indexPath.row]];
        
        return cell;
    }else if (!self.projectBtn.enabled) {
        static NSString *CellIdentifierInboxCell = @"InboxCell";
        InboxCell *cell = (InboxCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifierInboxCell];
        if (cell == nil||![cell isKindOfClass:[InboxCell class]]) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"InboxCell" owner:self options:nil][0];
        }
        [cell setMessageData:[_projects objectAtIndex:indexPath.row]];
        
        return cell;
    }
    
    else{
        static NSString *CellIdentifierReplyCell = @"ReplyCell";
        ReplyCell *cell = (ReplyCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifierReplyCell];
        if (cell == nil||![cell isKindOfClass:[ReplyCell class]]) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"ReplyCell" owner:self options:nil][0];
        }
        [cell setReplyData:[_replies objectAtIndex:indexPath.row]];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!self.inboxBtn.enabled) {
        DVMessage *message = [_messages objectAtIndex:indexPath.row];
        InboxDetailViewController *detailViewController = [[InboxDetailViewController alloc] initWithMessage:message];
        [self.navigationController pushViewController:detailViewController animated:YES];
    }else if (!self.projectBtn.enabled) {
        DVMessage *message = [_projects objectAtIndex:indexPath.row];
        InboxDetailViewController *detailViewController = [[InboxDetailViewController alloc] initWithMessage:message];
        [self.navigationController pushViewController:detailViewController animated:YES];
    }
    
    else{
        DVMessage *message = [_replies objectAtIndex:indexPath.row];
        NSString *userId=[[NSUserDefaults standardUserDefaults] stringForKey:@"USER_ID"];
        Contact *contact= [[Contact alloc] init];
        if ([userId isEqualToString:message.fromMemberId]) {
            contact.contactId = message.toMemberId;
            contact.avatar = message.toMemberAvatar;
            contact.name = message.toMemberName;
        }else{
            contact.contactId = message.fromMemberId;
            contact.avatar = message.fromMemberAvatar;
            contact.name = message.fromMemberName;
        }
        ConversationViewController *conversationViewController =[[ConversationViewController alloc] initWithContact:contact];
        [self.navigationController pushViewController:conversationViewController animated:NO];
    }
}

- (void)pullTableViewDidTriggerRefresh:(ITTPullTableView*)pullTableView
{
    if (!self.inboxBtn.enabled) {
        [_messages removeAllObjects];
    }else if (!self.projectBtn.enabled) {
        [_projects removeAllObjects];
    }else{
        [_replies removeAllObjects];
    }
    self.noContentLabel.hidden = YES;
    [self.inboxTableView reloadData];
    [self sendGetMessages];
    [self sendGetMessageCount];
}

- (void)pullTableViewDidTriggerLoadMore:(ITTPullTableView*)pullTableView
{
    [self sendGetMessages];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidUnload {
    [self setInboxTableView:nil];
    [self setNoContentLabel:nil];
    [super viewDidUnload];
}
@end
