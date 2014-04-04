//
//  ContactDetailViewController.m
//  DV
//
//  Created by Zhao Zhicheng on 1/7/14.
//
//

#import "ContactDetailViewController.h"
#import "ITTImageView.h"
#import "ITTPullTableView.h"
#import "EditTextFieldViewController.h"
#import "DWTagList.h"
#import "EditTagViewController.h"
#import "EditTextViewViewController.h"
#import "SwitchViewController.h"
#import "SJAvatarBrowser.h"
#import "NSUserDefaults+RMSaveCustomObject.h"
#import "Reachability.h"
#import "ConversationViewController.h"
#import "DVImage.h"
#import "Work.h"
#import "WorkCell.h"

@interface ContactDetailViewController (){
    NSMutableArray *_baseInfoArray;//with array
    NSMutableArray *_baseInfoValueArray;
    NSMutableArray *_baseInfoTitleArray;
    BOOL isEdit;
    BOOL isMyself;
    int type;
}
@property (strong, nonatomic) IBOutlet UIButton *baseButton;
@property (strong, nonatomic) IBOutlet UIButton *featureButton;
@property (strong, nonatomic) IBOutlet UIButton *contactButton;
@property (strong, nonatomic) IBOutlet UIButton *editButton;
@property (strong, nonatomic) IBOutlet UIButton *followButton;
@property (strong, nonatomic) IBOutlet UIButton *privateMessageButton;
@property (strong, nonatomic) IBOutlet UIButton *reportButton;

@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *descLabel;
@property (strong, nonatomic) IBOutlet UILabel *updateAvatarHintLabel;
@property (strong, nonatomic) IBOutlet UILabel *emptyLabel;

@property (strong, nonatomic) IBOutlet ITTImageView *imageView;
//打开别人时
@property (strong, nonatomic) IBOutlet UIView *typeSelectThreeLine;
@property (strong, nonatomic) IBOutlet UIView *threeButtonsView;
//打开自己时
@property (strong, nonatomic) IBOutlet UIView *typeSelectTwoLine;
@property (strong, nonatomic) IBOutlet UIView *twoButtonsView;

@property (strong, nonatomic) IBOutlet ITTPullTableView *detailTableView;
@property (strong, nonatomic) IBOutlet UIView *tableHeader;

@property (strong, nonatomic) Contact *contact;


@end

@implementation ContactDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithContact:(Contact *)contact{
    self = [super init];
    if (self) {
        self.contact = contact;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.imageView.layer.masksToBounds = YES;
    self.imageView.layer.cornerRadius = 40.0f;
    self.imageView.delegate = self;
    self.imageView.enableTapEvent = YES;
    isEdit = NO;
    type = 1;
    self.detailTableView.tableHeaderView = self.tableHeader;
    [self.detailTableView setRefreshViewHidden:YES];
    [self.detailTableView setLoadMoreViewHidden:YES];
    self.detailTableView.pullBackgroundColor = [UIColor clearColor];

    if (!self.contact) {//myself
        self.threeButtonsView.hidden = YES;
        self.twoButtonsView.hidden = NO;
        isMyself = YES;
        Reachability *reachability = [Reachability reachabilityForInternetConnection];
        [reachability startNotifier];
        NetworkStatus status = [reachability currentReachabilityStatus];
        self.followButton.hidden = YES;
        self.privateMessageButton.hidden = YES;
        if(status == NotReachable)
        {
            //No internet
            [[HTActivityIndicator currentIndicator] displayMessage:@"网络不佳，请检查网络!"];
            _contact = [[NSUserDefaults standardUserDefaults] rm_customObjectForKey:@"MYSELF"];
            if (_contact) {
                [self initTable];
            }
        }else
        {
            NSString *userId=[[NSUserDefaults standardUserDefaults] stringForKey:@"USER_ID"];
            [self sendGetContactById:userId];
        }
        self.editButton.hidden = NO;
        self.followButton.hidden = YES;
        self.nameLabel.text = self.contact.name;
        self.descLabel.text = self.contact.desc;
    }else{
        self.threeButtonsView.hidden = NO;
        self.twoButtonsView.hidden = YES;
        self.editButton.hidden = YES;
        self.followButton.hidden = NO;
        self.nameLabel.text = self.contact.name;
        self.descLabel.text = self.contact.desc;
        [self sendGetContact];
        //不能关注自己，给自己发私信
        NSString *userId=[[NSUserDefaults standardUserDefaults] stringForKey:@"USER_ID"];
        if ([self.contact.contactId isEqualToString:userId]) {
            self.followButton.hidden = YES;
            self.privateMessageButton.hidden = YES;
        }
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [[HTActivityIndicator currentIndicator] hide];
}

- (void)sendGetContact
{
    NSString *userId=[[NSUserDefaults standardUserDefaults] stringForKey:@"USER_ID"];
    [GetContactDataRequest requestWithDelegate:self withParameters:nil withUrl:[[REQUEST_DOMAIN stringByAppendingString:@"member/"] stringByAppendingFormat:@"%@/%@",self.contact.contactId,userId]];
    
    [[HTActivityIndicator currentIndicator] displayActivity:@"加载中..."];
}

- (void)sendGetContactById:(NSString*)userId
{
    [GetContactDataRequest requestWithDelegate:self withParameters:nil withUrl:[[REQUEST_DOMAIN stringByAppendingString:@"member/"] stringByAppendingFormat:@"%@/%@",userId,userId]];
    
    [[HTActivityIndicator currentIndicator] displayActivity:@"加载中..."];
}

- (void)sendAddFollowById:(NSString*)followId
{
    NSString *userId=[[NSUserDefaults standardUserDefaults] stringForKey:@"USER_ID"];
    [AddFollowDataRequest requestWithDelegate:self withParameters:nil withUrl:[[REQUEST_DOMAIN stringByAppendingString:@"member/addfollow/"] stringByAppendingFormat:@"%@/%@",userId,followId]];
    self.contact.hasFollowed = @"1";
    [[HTActivityIndicator currentIndicator] displayActivity:@"加载中..."];
}

- (void)sendRemoveFollowById:(NSString*)followId
{
    NSString *userId=[[NSUserDefaults standardUserDefaults] stringForKey:@"USER_ID"];
    [RemoveFollowDataRequest requestWithDelegate:self withParameters:nil withUrl:[[REQUEST_DOMAIN stringByAppendingString:@"member/removefollow/"] stringByAppendingFormat:@"%@/%@",userId,followId]];
    self.contact.hasFollowed = @"0";
    [[HTActivityIndicator currentIndicator] displayActivity:@"加载中..."];
}

- (void)sendGetWorks
{
    if (!self.detailTableView.pullTableIsLoadingMore && !self.detailTableView.pullTableIsRefreshing) {
        [_baseInfoArray removeAllObjects];
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (self.detailTableView.pullTableIsRefreshing) {
        [params setObject:@"1" forKey:@"pageNumber"];
    }else{
        [params setObject:[NSString stringWithFormat:@"%d", [_baseInfoArray count]/LIST_PAGE_COUNT + 1] forKey:@"pageNumber"];
    }
    [params setObject:[NSString stringWithFormat:@"%d", LIST_PAGE_COUNT] forKey:@"pageSize"];
    [WorkListDataRequest requestWithDelegate:self withParameters:nil withUrl:[REQUEST_DOMAIN stringByAppendingFormat:@"portfolio/list/%@",self.contact.contactId]];
}


- (void)requestDidFinishLoad:(ITTBaseDataRequest*)request
{
    if ([request isSuccess]) {
        if ([request isKindOfClass:[GetContactDataRequest class]]) {
            self.contact =[[Contact alloc] initWithDataDic:request.resultDic];
            if (isMyself) {
                NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
                [defaults rm_setCustomObject:self.contact forKey:@"MYSELF"];
                [defaults synchronize];
            }
            [self initTable];
        }else if ([request isKindOfClass:[UploadAvatarDataRequest class]]) {
            [[HTActivityIndicator currentIndicator] displayMessage:@"提交头像成功！"];
        }else if ([request isKindOfClass:[AddFollowDataRequest class]]) {
            self.contact.hasFollowed = @"1";
            [[HTActivityIndicator currentIndicator] displayMessage:@"关注该用户成功!"];
            [self.followButton setTitle:@"取消关注" forState:UIControlStateNormal];
        }else if ([request isKindOfClass:[RemoveFollowDataRequest class]]) {
            self.contact.hasFollowed = @"0";
            
            [[HTActivityIndicator currentIndicator] displayMessage:@"取消关注该用户成功!"];
            [self.followButton setTitle:@"关注" forState:UIControlStateNormal];
        }else if ([request isKindOfClass:[WorkListDataRequest class]]) {
            [self parseNSDictionary:request.resultDic];
            self.detailTableView.pullTableIsLoadingMore = NO;
            self.detailTableView.pullTableIsRefreshing = NO;
        }
        [[HTActivityIndicator currentIndicator] hide];
    }else{
        [[HTActivityIndicator currentIndicator] displayMessage:request.result.message];
    }
}

- (void) parseNSDictionary:(NSDictionary*)dic{
    NSMutableArray *tempArray = [dic objectForKey:@"data"];
    NSMutableArray *nArray = [[NSMutableArray alloc] init];
    for (int i=0; i<[tempArray count]; i++) {
        NSDictionary *innerDic = tempArray[i];
        NSMutableArray *imagesArray = [innerDic objectForKey:@"files"];
        NSMutableArray *images = [[NSMutableArray alloc] init];
        for (int j=0; j<[imagesArray count]; j++) {
            DVImage *image=[[DVImage alloc] initWithDataDic:imagesArray[j]];
            [images addObject:image];
            
        }
        Work *work = [[Work alloc] initWithDataDic:innerDic];
        work.files = images;
        [nArray addObject:work];
    }
    if ([nArray count] == LIST_PAGE_COUNT) {
        [self.detailTableView setLoadMoreViewHidden:NO];
    }else{
        [self.detailTableView setLoadMoreViewHidden:YES];
    }
    if (self.detailTableView.pullTableIsLoadingMore) {
        [_baseInfoArray addObjectsFromArray:nArray];
    }else{
        _baseInfoArray = nArray;
    }
    if (!_baseInfoArray||[_baseInfoArray count]==0) {
        self.emptyLabel.text = @"该用户还没有提交任何作品\n给他发私信提醒他一下吧!";
        self.emptyLabel.hidden = NO;
    }else{
        self.emptyLabel.hidden = YES;
    }
    [self.detailTableView reloadData];
    
}

- (void)request:(ITTBaseDataRequest*)request didFailLoadWithError:(NSError*)error
{
    [[HTActivityIndicator currentIndicator] displayMessage:@"网络不佳，请检查网络!"];
}

- (void) initBaseInfo{
    // the dummy for demo
    _baseInfoArray = [NSMutableArray array];
    _baseInfoTitleArray = [NSMutableArray array];
    _baseInfoValueArray = [NSMutableArray array];
    // group title
    [_baseInfoTitleArray addObject:@"基本信息"];
    //[_baseInfoTitleArray addObject:@"工作经历"];
    [_baseInfoTitleArray addObject:@"标签"];
    [_baseInfoTitleArray addObject:@"一句话简介"];
    // 基本信息
    NSMutableArray *tempArray = [NSMutableArray array];
    [tempArray addObject:@"姓名"];
    [tempArray addObject:@"性别"];
    //[tempArray addObject:@"生日"];
    [tempArray addObject:@"地区"];
    [tempArray addObject:@"职位"];
    [tempArray addObject:@"分类"];
    [_baseInfoArray addObject:tempArray];
    
    tempArray = [NSMutableArray array];
    [tempArray addObject:self.contact.name!=nil?self.contact.name:@""];
    [tempArray addObject:self.contact.gender!=nil?self.contact.gender:@""];
    //[tempArray addObject:self.contact.birthday!=nil?self.contact.birthday:@""];
    [tempArray addObject:self.contact.city!=nil?self.contact.city:@""];
    [tempArray addObject:self.contact.career!=nil?self.contact.career:@""];
    [tempArray addObject:self.contact.category!=nil?self.contact.category:@""];
    [_baseInfoValueArray addObject:tempArray];
    
    // 工作经历
    //    tempArray = [NSMutableArray array];
    //    [tempArray addObject:@"200101-200512 北京京东科技"];
    //    [tempArray addObject:@"200601-201012 北京京西科技"];
    //    [tempArray addObject:@"201101-201312 北京京南科技"];
    //    [tempArray addObject:@"201401-201401 北京京北科技"];
    //    [_baseInfoArray addObject:tempArray];
    
    // 分类
    tempArray = [NSMutableArray array];
    [tempArray addObject:@""];
    [_baseInfoArray addObject:tempArray];
    
    // 标签
    tempArray = [NSMutableArray array];
    [tempArray addObject:@""];
    [_baseInfoArray addObject:tempArray];
    
    //一句话简介
    tempArray = [NSMutableArray array];
    [tempArray addObject:self.contact.desc!=nil?self.contact.desc:@""];
    [_baseInfoArray addObject:tempArray];
    
    [self.detailTableView reloadData];
}

- (void) initContactInfo{
    //the dummy for demo
    _baseInfoArray = [NSMutableArray array];
    _baseInfoTitleArray = [NSMutableArray array];
    
    // QQ
    [_baseInfoTitleArray addObject:@"QQ"];
    NSMutableArray *tempArray = [NSMutableArray array];
    [tempArray addObject:@"1234567"];
    [_baseInfoArray addObject:tempArray];
    
    // 电话
    [_baseInfoTitleArray addObject:@"电话"];
    tempArray = [NSMutableArray array];
    [tempArray addObject:@""];
    [_baseInfoArray addObject:self.contact.tels!=nil?self.contact.tels:tempArray];
    
    // 微信
    [_baseInfoTitleArray addObject:@"微信"];
    tempArray = [NSMutableArray array];
    [tempArray addObject:@"commov"];
    [_baseInfoArray addObject:tempArray];
    [self.detailTableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[AppDelegate shareAppdelegate].homeTabbarController hideTabBarAnimated:YES];
}

- (IBAction)tapOnEditBtn:(id)sender {
    isEdit = !isEdit;
    if (isEdit) {
        [self.editButton setTitle:@"完成" forState:UIControlStateNormal];
        self.updateAvatarHintLabel.hidden = NO;
    }else{
        [self.editButton setTitle:@"编辑" forState:UIControlStateNormal];
        self.updateAvatarHintLabel.hidden = YES;
    }
    [self.detailTableView reloadData];
}

- (IBAction)tapOnFollowBtn:(id)sender {
    NSString *userId=[[NSUserDefaults standardUserDefaults] stringForKey:@"USER_ID"];
    if ([_contact.contactId isEqualToString:userId]) {
        [[HTActivityIndicator currentIndicator] displayMessage:@"不能关注自己!"];
        return;
    }
    
    if (self.contact.hasFollowed&&[self.contact.hasFollowed isEqualToString:@"1"]) {//已关注，点击取消关注
        [self sendRemoveFollowById:self.contact.contactId];
        [[HTActivityIndicator currentIndicator] displayActivity:@"取消关注中..."];
    }else{
        [self sendAddFollowById:self.contact.contactId];
        [[HTActivityIndicator currentIndicator] displayActivity:@"关注中..."];
    }
}

- (IBAction)tapOnReportBtn:(id)sender {
    [[HTActivityIndicator currentIndicator] displayMessage:@"举报成功!"];
}

- (IBAction)tapOnBackBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)tapOnPrivateMessageBtn:(id)sender {
    
    Contact *contact = [[NSUserDefaults standardUserDefaults] rm_customObjectForKey:@"MYSELF"];
    if (!contact||!contact.avatar) {
        [[HTActivityIndicator currentIndicator] displayMessage:@"请先完善您的个人信息。"];
        //return;
    }
    
    ConversationViewController *conversationViewController =[[ConversationViewController alloc] initWithContact:self.contact];
    [self.navigationController pushViewController:conversationViewController animated:NO];
}

- (IBAction)tapOnTypeBtn:(id)sender {
    UIButton *button =(UIButton*)sender;
    type = button.tag;
    [self initTable];
}

- (void)uploadAvatar{
    NSString *userId=[[NSUserDefaults standardUserDefaults] stringForKey:@"USER_ID"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSData* imageData = UIImageJPEGRepresentation(self.imageView.image, 0.8);
    [params setObject:imageData forKey:@"qqfile"];
    [UploadAvatarDataRequest requestWithDelegate:self withParameters:params withUrl:[REQUEST_DOMAIN stringByAppendingString:[NSString stringWithFormat:@"member/%@/updateAvatar", userId]]];
    [[HTActivityIndicator currentIndicator] displayActivity:@"更新用户头像中..."];
}

- (void)initTable{
    if (self.contact.hasFollowed&&[self.contact.hasFollowed isEqualToString:@"1"]) {
        [self.followButton setTitle:@"取消关注" forState:UIControlStateNormal];
    }else{
        [self.followButton setTitle:@"关注" forState:UIControlStateNormal];
    }
    self.contact.tags = [self.contact.tag componentsSeparatedByString:@","];
    if ([self.contact.tags count]<2) {
        self.contact.tags = [self.contact.tag componentsSeparatedByString:@"，"];
    }
    self.contact.tels = [self.contact.phone componentsSeparatedByString:@","];
    if ([self.contact.tels count]<2) {
        self.contact.tels = [self.contact.phone componentsSeparatedByString:@"，"];
    }
    if (self.contact.gender&&[self.contact.gender isEqualToString:@"woman"]) {
        self.contact.gender = @"女";
    }else if (self.contact.gender&&[self.contact.gender isEqualToString:@"man"]) {
        self.contact.gender = @"男";
    }
    self.nameLabel.text = self.contact.name;
    self.descLabel.text = self.contact.desc;
    [self.imageView loadImage:_contact.avatar placeHolder:[UIImage imageNamed:@"head_boy_50.png"]];
    self.emptyLabel.hidden = YES;
    self.reportButton.hidden = YES;
    if (isMyself) {
        if (type==1) {
            [UIView animateWithDuration:0.3
                             animations:^(){
                                 self.typeSelectTwoLine.left = 0;
                             }];
            self.baseButton.enabled = NO;
            self.featureButton.enabled = YES;
            self.contactButton.enabled = YES;
            [self initBaseInfo];
            [self.detailTableView reloadData];
            [self.detailTableView setRefreshViewHidden:YES];
            [self.detailTableView setLoadMoreViewHidden:YES];
        }else if(type==2){
            [UIView animateWithDuration:0.3
                             animations:^(){
                                 self.typeSelectTwoLine.left = 160;
                             }];
            self.baseButton.enabled = YES;
            self.featureButton.enabled = NO;
            self.contactButton.enabled = YES;
            [self initContactInfo];
            [self.detailTableView reloadData];
            [self.detailTableView setRefreshViewHidden:YES];
            [self.detailTableView setLoadMoreViewHidden:YES];
        }
    }else{
        if (type==1) {
            [UIView animateWithDuration:0.3
                             animations:^(){
                                 self.typeSelectThreeLine.left = 0;
                             }];
            self.baseButton.enabled = NO;
            self.featureButton.enabled = YES;
            self.contactButton.enabled = YES;
            [self initBaseInfo];
            [self.detailTableView reloadData];
            [self.detailTableView setRefreshViewHidden:YES];
            [self.detailTableView setLoadMoreViewHidden:YES];
        }else if(type==2){
            [UIView animateWithDuration:0.3
                             animations:^(){
                                 self.typeSelectThreeLine.left = 107;
                             }];
            self.baseButton.enabled = YES;
            self.featureButton.enabled = NO;
            self.contactButton.enabled = YES;
            [self initContactInfo];
            [self.detailTableView reloadData];
            [self.detailTableView setRefreshViewHidden:YES];
            [self.detailTableView setLoadMoreViewHidden:YES];
        }else if(type==3){
            self.reportButton.hidden = NO;
            [UIView animateWithDuration:0.3
                             animations:^(){
                                 self.typeSelectThreeLine.left = 213;
                             }];
            self.baseButton.enabled = YES;
            self.featureButton.enabled = YES;
            self.contactButton.enabled = NO;
            [self sendGetWorks];
            //[self.detailTableView reloadData];
            [self.detailTableView setRefreshViewHidden:NO];
            [self.detailTableView setLoadMoreViewHidden:NO];
        }
    }
    
}

#pragma mark - UITableView DataSource Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (type==3) {
        return [_baseInfoArray count];
    }
    NSMutableArray *tempArray = [_baseInfoArray objectAtIndex:section];
    return [tempArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (type==3) {
        
        static NSString *CellIdentifier = @"WorkCell";
        WorkCell *cell = (WorkCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"WorkCell" owner:self options:nil][0];
        }
        cell.delegate = self;
        Work *work = _baseInfoArray[indexPath.row];
        [cell setWorkData:work otherUser:YES];
        return cell;
    }
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell  *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    if (isEdit) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.detailTextLabel.text=nil;
    NSMutableArray *tempArray = [_baseInfoArray objectAtIndex:indexPath.section];
    if (indexPath.section==1&&type==1) {//标签
        DWTagList *tagList = [[DWTagList alloc] initWithFrame:CGRectMake(15.0f, 3.0f, 290.0f, 280.0f)];
        if (!isMyself) {
            if ([self.contact.tags count]==1&&[[self.contact.tags objectAtIndex:0] length]==0) {
                //do nothing
            }else{
                [tagList setTags:self.contact.tags];
                [cell addSubview:tagList];
            }
        }else{
            [tagList setTags:self.contact.tags];
            [cell addSubview:tagList];
        }
    }
    else if (indexPath.section==2&&type==1) {//一句话简介
        cell.textLabel.text = self.contact.desc;
        cell.textLabel.numberOfLines = 0;
    }
    else if (indexPath.section==1&&type==2) {//电话
        cell.textLabel.text = [tempArray objectAtIndex:indexPath.row];
        cell.textLabel.textColor = [UIColor colorWithRed:9.0/255.0 green:106.0/255.0 blue:217.0/255.0 alpha:1];
    }
    else if (indexPath.section==0&&type==2) {//qq
        cell.textLabel.text = self.contact.qq;
    }
    else if (indexPath.section==2&&type==2) {//weixin
        cell.textLabel.text = self.contact.weixin;
    }
    else{
        if(_baseInfoValueArray&&[_baseInfoValueArray count]>indexPath.section&&type==1){
            NSMutableArray *tempValueArray = [_baseInfoValueArray objectAtIndex:indexPath.section];
            cell.textLabel.text = [NSString stringWithFormat:@"%@：%@",[tempArray objectAtIndex:indexPath.row],[tempValueArray objectAtIndex:indexPath.row]];
        }else{
            cell.textLabel.text = [tempArray objectAtIndex:indexPath.row];
        }
    }
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (type == 3) {
        return 1;
    }
    return [_baseInfoTitleArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (type==3) {
        
        Work *work = _baseInfoArray[indexPath.row];
        
        CGSize maximumLabelSize = CGSizeMake(290, CGFLOAT_MAX);
        CGRect textRect = [work.description boundingRectWithSize:maximumLabelSize
                                                         options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                                      attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]}
                                                         context:nil];
        NSMutableArray *files = work.files;
        if ([files count]==1||([files count]>6&&[files count]<=9)) {
            return 66*3+45+textRect.size.height;
        }else if([files count]<=3){
            return 66+45+textRect.size.height;
        }else if([files count]<=6){
            return 66*2+45+textRect.size.height;
        }
        return 275;
    }
    
    if (indexPath.section==1&&type==1) {//标签高度
        DWTagList *tagList = [[DWTagList alloc] initWithFrame:CGRectMake(15.0f, 5.0f, 290.0f, 280.0f)];
        [tagList setTags:self.contact.tags];
        return [tagList fittedSize].height+5;
    }else if(indexPath.section==2&&type==1){//一句话简介高度
        CGSize maximumLabelSize = CGSizeMake(280, CGFLOAT_MAX);
        CGRect textRect = [self.contact.desc boundingRectWithSize:maximumLabelSize
                                                          options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                                       attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]}
                                                          context:nil];
        return textRect.size.height<45?45:textRect.size.height;
    }else if(type == 3){
        return 120;
    }
    else{
        return 45;
    }
    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (type==3) {
        return @"作品欣赏";
    }
    return [_baseInfoTitleArray objectAtIndex:section];
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


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (isEdit) {
        EditViewController *viewController = nil;
        switch (type) {
            case 1://基本信息
                switch (indexPath.section) {
                    case 0://基本信息 不包含标签
                    {
                        switch (indexPath.row) {
                            case 0:
                                [[HTActivityIndicator currentIndicator] displayMessage:@"姓名不能修改!"];
                                break;
                            case 1:
                                [[HTActivityIndicator currentIndicator] displayMessage:@"性别不能修改!"];
                                break;
                                //                            case 2:
                                //                                viewController = [[EditTextFieldViewController alloc] initWithSelectType:ProfileInfoSelectTypeAge contact:self.contact];
                                //                                break;
                            case 2:
                                viewController = [[EditTextFieldViewController alloc] initWithSelectType:ProfileInfoSelectTypeCity contact:self.contact];
                                break;
                            case 3:
                                viewController = [[EditTextFieldViewController alloc] initWithSelectType:ProfileInfoSelectTypeCareer contact:self.contact];
                                break;
                            case 4:
                                viewController = [[SwitchViewController alloc] initWithSelectType:ProfileInfoSelectTypeFilter contact:self.contact];
                                break;
                            default:
                                break;
                        }
                    }
                        break;
                    case 1: //标签
                    {
                        viewController = [[EditTagViewController alloc] initWithSelectType:ProfileInfoSelectTypeTags contact:self.contact];
                    }
                        break;
                    case 2: //一句话简介
                    {
                        viewController = [[EditTextViewViewController alloc] initWithSelectType:ProfileInfoSelectTypeDesc contact:self.contact];
                    }
                        break;
                    default:
                        break;
                }
                
                break;
            case 2://联系方式
                switch (indexPath.section) {
                    case 0:
                        viewController = [[EditTextFieldViewController alloc] initWithSelectType:ProfileInfoSelectTypeQQ contact:self.contact];
                        
                        break;
                    case 1:
                        viewController = [[EditTagViewController alloc] initWithSelectType:ProfileInfoSelectTypeTel contact:self.contact];
                        
                        break;
                    case 2:
                        viewController = [[EditTextFieldViewController alloc] initWithSelectType:ProfileInfoSelectTypeWeixin contact:self.contact];
                        
                        break;
                    default:
                        break;
                }
                
            default:
                break;
        }
        if (viewController) {
            viewController.delegate = self;
            [self.navigationController pushViewController:viewController animated:YES];
        }
    }else{
        if (type==2&&indexPath.section==1) {//拨打电话
            if ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)) {
                [[HTActivityIndicator currentIndicator] displayMessage:@"您的设备不支持拨打电话功能!"];
            }else{
                NSMutableArray *tempArray = [_baseInfoArray objectAtIndex:indexPath.section];
                NSString *phone = [tempArray objectAtIndex:indexPath.row];
                if (phone) {
                    NSString *telUrl = [NSString stringWithFormat:@"telprompt:%@",phone];
                    NSURL *url = [[NSURL alloc] initWithString:telUrl];
                    [[UIApplication sharedApplication] openURL:url];
                }
            }
        }
    }
}

#pragma mark -
#pragma mark UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)selectedImage editingInfo:(NSDictionary *)editingInfo {
	
	// Create a thumbnail version of the image for the recipe object.
	CGSize size = selectedImage.size;
	CGFloat ratio = 0;
	if (size.width > size.height) {
		ratio = 600.0 / size.width;
	} else {
		ratio = 600.0 / size.height;
	}
	CGRect rect = CGRectMake(0.0, 0.0, ratio * size.width, ratio * size.height);
	
	UIGraphicsBeginImageContext(rect.size);
	[selectedImage drawInRect:rect];
	NSError *writeError = nil;
    NSArray *pathArr = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                           NSUserDomainMask,
                                                           YES);
    
    NSString *path = [[pathArr objectAtIndex:0]
                      stringByAppendingPathComponent:self.contact.name];
    [UIImagePNGRepresentation(UIGraphicsGetImageFromCurrentImageContext()) writeToFile:[path stringByExpandingTildeInPath] options:NSDataWritingAtomic error:&writeError];
    
    self.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [self dismissModalViewControllerAnimated:YES];
    [self uploadAvatar];
}

#pragma mark - ITTPullTableView Delegate
- (void)pullTableViewDidTriggerRefresh:(ITTPullTableView*)pullTableView
{
    self.emptyLabel.hidden = YES;
    [self sendGetWorks];
}

- (void)pullTableViewDidTriggerLoadMore:(ITTPullTableView*)pullTableView
{
    [self sendGetWorks];
}

#pragma mark -
#pragma mark UIActionSheet Delegate Methods
- (void)actionSheet:(UIActionSheet *)actionSheet
didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    
    if (buttonIndex==1) {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        [imagePicker setHidesBottomBarWhenPushed:YES];
        imagePicker.delegate = self;
        imagePicker.allowsEditing = YES;
        [self presentModalViewController:imagePicker animated:YES];
        
    }else if(buttonIndex==0) {
        
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        [imagePicker setHidesBottomBarWhenPushed:YES];
        BOOL isCameraAvaible = NO;
        isCameraAvaible = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
        if (!isCameraAvaible)
        {
            [[HTActivityIndicator currentIndicator] displayMessage:@"该设备不支持拍照!"];
            return;
        }
        
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        NSArray *temp_MediaTypes = [UIImagePickerController availableMediaTypesForSourceType:imagePicker.sourceType];
        imagePicker.mediaTypes = temp_MediaTypes;
        imagePicker.delegate = self;
        imagePicker.allowsEditing = YES;
        
        
        [self presentModalViewController:imagePicker animated:YES];
        
    }
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissModalViewControllerAnimated:YES];
}

- (void)imageClicked:(ITTImageView *)imageView
{
    if (!isEdit) {
        [SJAvatarBrowser showImage:imageView];
    }else{
        
        
        
        UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                      initWithTitle:@"上传头像"
                                      delegate:self
                                      cancelButtonTitle:@"取消"
                                      destructiveButtonTitle:nil
                                      otherButtonTitles: @"拍照", @"本地照片",  nil];
        [actionSheet showInView:self.view];
    }
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

#pragma EditViewControllerDelegate
-(void)contactConfirmed:(Contact *)contact type:(ProfileInfoSelectType)selectType{
    _contact = [[NSUserDefaults standardUserDefaults] rm_customObjectForKey:@"MYSELF"];
    [self initTable];
}
@end
