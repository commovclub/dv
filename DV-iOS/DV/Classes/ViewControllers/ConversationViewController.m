//
//  ConversationViewController.m
//  HotWord
//
//  Created by Jack Liu on 13-5-25.
//
//

#import "ConversationViewController.h"
#import "MessageManager.h"
#import "NSUserDefaults+RMSaveCustomObject.h"

@interface ConversationViewController ()
{
    Contact *_contact;
    NSMutableArray *_messages;
    BOOL _isMessageLoaded;
    DVMessage *_sendingMessage;
    Contact *currentUser;
}

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet ITTPullTableView *messageTableView;
@property (strong, nonatomic) IBOutlet UITextField *messageTextField;
@property (strong, nonatomic) IBOutlet UIView *messageSendToolBar;
@property (strong, nonatomic) IBOutlet UILabel *noContentLabel;
@end

@implementation ConversationViewController

- (id)initWithContact:(Contact *)contact
{
    self = [super init];
    if (self) {
        _contact = contact;
        _messages = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification object:nil];

    
    [self.messageTableView setLoadMoreViewHidden:YES];
    [self.messageTableView setRefreshViewHidden:NO];
    [self.messageTableView setRefreshToLoadMore];
    self.messageTableView.pullBackgroundColor = [UIColor clearColor];
    self.titleLabel.text = [NSString stringWithFormat:@"给 %@ 发私信",_contact.name];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[AppDelegate shareAppdelegate].homeTabbarController hideTabBarAnimated:YES];
    currentUser = [[NSUserDefaults standardUserDefaults] rm_customObjectForKey:@"MYSELF"];
    if (!currentUser||!currentUser.contactId) {
        NSString *userId=[[NSUserDefaults standardUserDefaults] stringForKey:@"USER_ID"];
        [GetContactDataRequest requestWithDelegate:self withParameters:nil withUrl:[[REQUEST_DOMAIN stringByAppendingString:@"member/"] stringByAppendingFormat:@"%@/%@",userId,userId]];
        [[HTActivityIndicator currentIndicator] displayActivity:@"加载中..."];
    }else{
        [self sendGetAllMessage];
    }
}

- (void)sendGetAllMessage{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (!_messages||[_messages count]==0) {
        [params setObject:@"1" forKey:@"pageNumber"];
    }else{
        [params setObject:[NSString stringWithFormat:@"%d", [_messages count]/LIST_PAGE_COUNT + 1] forKey:@"pageNumber"];
    }
    [params setObject:[NSString stringWithFormat:@"%d", LIST_PAGE_COUNT] forKey:@"pageSize"];
    [PrivateMessageDataRequest requestWithDelegate:self withParameters:params withUrl:[REQUEST_DOMAIN stringByAppendingFormat:@"message/%@/%@?",currentUser.contactId,_contact.contactId]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)tapOnBackBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)tapOnSendBtn:(id)sender {
    [self sendMessage];
}

- (IBAction)tapOnRefreshBtn:(id)sender {
    [[HTActivityIndicator currentIndicator] displayActivity:@"加载中..."];
    [self pullTableViewDidTriggerRefresh:self.messageTableView];
}

- (void)sendMessage
{
    if (![@"" isEqualToString:self.messageTextField.text]) {
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setObject:self.messageTextField.text forKey:@"message"];
        [SendMessageDataRequest requestWithDelegate:self withParameters:params withUrl:[[REQUEST_DOMAIN stringByAppendingString:@"message/send/"] stringByAppendingFormat:@"%@/%@?",currentUser.contactId,_contact.contactId]];

        DVMessage *message = [[DVMessage alloc] init];
        message.fromMemberId = currentUser.contactId;
        message.fromMemberName = currentUser.name;
        message.fromMemberAvatar = currentUser.avatar;
        
        message.toMemberId = _contact.contactId;
        message.toMemberName = _contact.name;
        message.toMemberAvatar = _contact.avatar;
        message.message = self.messageTextField.text;
        message.createdAt = [NSString stringWithFormat:@"%f", [[NSDate date] timeIntervalSince1970] * 1000];
        message.isSending = YES;
        [_messages addObject:message];
        [self.messageTableView reloadData];
        if ([_messages count] > 0) {
            [self.messageTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[_messages count] -1 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
        }
        [self.messageTextField resignFirstResponder];
        self.messageTextField.text = @"";
        
        _sendingMessage = message;
        self.noContentLabel.hidden = YES;
    }else{
        [[HTActivityIndicator currentIndicator] displayMessage:@"发送消息不能为空！"];
    }
}

- (void)pullTableViewDidTriggerRefresh:(ITTPullTableView*)pullTableView
{
    _isMessageLoaded = NO;
    [self sendGetAllMessage];
}

- (void)pullTableViewDidTriggerLoadMore:(ITTPullTableView*)pullTableView
{
    [self sendGetAllMessage];
}

- (void)keyboardWasShown:(NSNotification*)aNotification {
    
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [info[UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    self.messageTableView.height = self.view.height - self.messageSendToolBar.height - kbSize.height - 70;
    [UIView animateWithDuration:0.05
                     animations:^{
                         self.messageSendToolBar.top = self.view.height - self.messageSendToolBar.height - kbSize.height;
                     }];
    if ([_messages count] > 0) {
        [self.messageTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[_messages count] -1 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
}

- (void)keyboardWillHide:(NSNotification*)aNotification{
    [UIView animateWithDuration:0.05
                     animations:^{
                         self.messageSendToolBar.top = self.view.height - self.messageSendToolBar.height;
                     }];
    self.messageTableView.height = self.view.height - self.messageSendToolBar.height - 70;
    if ([_messages count] > 0) {
        [self.messageTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[_messages count] -1 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    DVMessage *message = [_messages objectAtIndex:indexPath.row];
    if ([message.fromMemberId isEqualToString:currentUser.contactId]) {
        
        static NSString *CellIdentifier = @"MessageToCell";
        
        MessageToCell *cell = (MessageToCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"MessageToCell" owner:self options:nil] objectAtIndex:0];
        }
        cell.delegate = self;
        [cell setMessage:message];
        return cell;
    }
    else {
        static NSString *CellIdentifier = @"MessageFromCell";
        
        MessageFromCell *cell = (MessageFromCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"MessageFromCell" owner:self options:nil] objectAtIndex:0];
        }
        [cell setMessage:message];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    DVMessage *message = [_messages objectAtIndex:indexPath.row];
    return [MessageToCell getCellHeightByContent:message.message] + 20;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_messages count];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.messageTextField resignFirstResponder];
}

- (void)handleNewMessage:(NSNotification *)notification
{
    NSDictionary *userInfo = notification.userInfo;
    NSArray *newMesssages = [userInfo objectForKey:@"newMessages"];
    for (DVMessage *newMessage in newMesssages) {
//        if ([_friend.userId isEqualToString:newMessage.senderId]) {
//            NSMutableDictionary *params = [NSMutableDictionary dictionary];
//            [params setObject:DATA_ENV.currentUser.userId forKey:@"id"];
//            [params setObject:_friend.userId forKey:@"toid"];
//            [params setObject:[NSString stringWithFormat:@"%d", LIST_PAGE_COUNT] forKey:@"count"];
//            //[HTGetChatRecordsDataRequest requestWithDelegate:self withParameters:params];
//            _isMessageLoaded = NO;
//            break;
//        }
    }
}

- (void)requestDidFinishLoad:(ITTBaseDataRequest*)request
{
    if ([request isSuccess]) {
        if ([request isKindOfClass:[SendMessageDataRequest class]]) {
            _sendingMessage.isSending = NO;
        }else if ([request isKindOfClass:[GetContactDataRequest class]]) {
            currentUser =[[Contact alloc] initWithDataDic:request.resultDic];
            NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
            [defaults rm_setCustomObject:currentUser forKey:@"MYSELF"];
            [defaults synchronize];
            [self sendGetAllMessage];
        }else if([request isKindOfClass:[PrivateMessageDataRequest class]]){
            NSMutableArray *newMessages = [request.resultDic objectForKey:@"data"];
            if ([newMessages count] == LIST_PAGE_COUNT) {
                [self.messageTableView setRefreshViewHidden:NO];
            }else{
                [self.messageTableView setRefreshViewHidden:YES];
            }
            if (self.messageTableView.pullTableIsRefreshing) {  //下拉加载更多
                for (int i=0; i<[newMessages count]; i++) {
                    NSDictionary *innerDic = newMessages[i];
                    DVMessage *message = [[DVMessage alloc] initWithDataDic:innerDic];
                    [_messages insertObject:message atIndex:0];
                }
                if (!newMessages||[newMessages count]==0) {
                    [[HTActivityIndicator currentIndicator] displayMessage:@"已经全部加载"];
                }
            }else{
                if (!_isMessageLoaded) {
                    NSMutableArray *sortedMessages = [NSMutableArray array];
                    for (int i=0; i<[newMessages count]; i++) {
                        NSDictionary *innerDic = newMessages[i];
                        DVMessage *message = [[DVMessage alloc] initWithDataDic:innerDic];
                        [sortedMessages insertObject:message atIndex:0];
                    }
                    _messages = sortedMessages;
                    //第一次获取聊天信息
                    _isMessageLoaded = YES;
                }
            }
        }
        [self.messageTableView reloadData];
        if ([_messages count] > 0 && !self.messageTableView.pullTableIsRefreshing) {
            [self.messageTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[_messages count] -1 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
        }
        if ([_messages count] > 0) {
            self.noContentLabel.hidden = YES;
        }else{
            
            self.noContentLabel.hidden = NO;
        }
        [[HTActivityIndicator currentIndicator] hide];
        if (_messages&&[_messages count]>0) {
            DVMessage *message = [_messages objectAtIndex:([_messages count]-1)];
            if ([message.status isEqualToString:@"new"]) {
                [ReadMessageDataRequest requestWithDelegate:nil withParameters:nil withUrl:[[REQUEST_DOMAIN stringByAppendingString:@"message/read/"] stringByAppendingFormat:@"%@",message.uuid]];
            }
        }
        
    }else{
        if ([request isKindOfClass:[PrivateMessageDataRequest class]]) {
            _sendingMessage.isSending = NO;
            _sendingMessage.isSentFailed = YES;
            [self.messageTableView reloadData];
            if ([_messages count] > 0) {
                [self.messageTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[_messages count] -1 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
            }
        }
        [[HTActivityIndicator currentIndicator] displayMessage:request.result.message];
    }
    self.messageTableView.pullTableIsRefreshing = NO;

}


- (void)request:(ITTBaseDataRequest*)request didFailLoadWithError:(NSError*)error
{
    _sendingMessage.isSending = NO;
    if (![request isSuccess]) {
        _sendingMessage.isSentFailed = YES;
        [self.messageTableView reloadData];
        if ([_messages count] > 0) {
            [self.messageTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[_messages count] -1 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
        }
    }

    self.messageTableView.pullTableIsRefreshing = NO;
}

-(BOOL)textFieldShouldReturn:(UITextField*)textField
{
    [self sendMessage];
    return YES;
}

- (void)resendMessage:(Message *)message
{
    _sendingMessage.isSentFailed = NO;
    _sendingMessage.isSending = YES;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:currentUser.contactId forKey:@"id"];
    //[params setObject:_friend.userId forKey:@"toid"];
    //[params setObject:_sendingMessage.content forKey:@"text"];
    [self.messageTableView reloadData];
    //[HTSendChatMessageDataRequest requestWithDelegate:self withParameters:params];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewDidUnload {
    [self setTitleLabel:nil];
    [self setMessageTableView:nil];
    [self setMessageTextField:nil];
    [self setMessageSendToolBar:nil];
    [self setNoContentLabel:nil];
    [super viewDidUnload];
}
@end
