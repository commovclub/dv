//
//  FriendsViewController.m
//  DV
//
//  Created by Zhao Zhicheng on 3/6/14.
//
//

#import "FriendsViewController.h"
#import "HTActivityIndicator.h"
#import "pinyin.h"
#import "MJNIndexView.h"
#import "ContactDetailViewController.h"

@interface FriendsViewController (){
    NSMutableArray *_contactArray;
    int type;//2 关注我的，  1 我关注的
}
@property (strong, nonatomic) IBOutlet ITTPullTableView *contactTableView;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *emptyLabel;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) NSMutableArray *sortedArrForArrays;
@property (nonatomic, strong) NSMutableArray *sectionHeadsKeys;
// MJNIndexView
@property (nonatomic, strong) MJNIndexView *indexView;
@end


@implementation FriendsViewController

- (id)initWithType:(int)_type{
    self = [super init];
    if (self) {
        type = _type;
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
    if (type==1) {
        self.titleLabel.text = @"我关注的好友";
    }else{
        self.titleLabel.text = @"关注我的好友";
    }
    _contactArray = [[NSMutableArray alloc] init];
    [self.contactTableView setLoadMoreViewHidden:YES];
    self.contactTableView.pullBackgroundColor = [UIColor clearColor];
    self.contactTableView.showsVerticalScrollIndicator = NO;
    // initialise MJNIndexView
    self.indexView = [[MJNIndexView alloc] initWithFrame:self.contactTableView.frame];
    self.indexView.dataSource = self;
    [self fifthAttributesForMJNIndexView];
    [self.view addSubview:self.indexView];
}

- (void)fifthAttributesForMJNIndexView
{
    self.indexView.getSelectedItemsAfterPanGestureIsFinished = NO;
    self.indexView.font = [UIFont fontWithName:@"HelveticaNeue" size:12.0];
    self.indexView.backgroundColor = [UIColor clearColor];
    self.indexView.curtainColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0];
    self.indexView.curtainFade = 0.0;
    self.indexView.curtainStays = YES;
    self.indexView.curtainMoves = YES;
    self.indexView.curtainMargins = YES;
    self.indexView.ergonomicHeight = NO;
    self.indexView.upperMargin = 10.0;
    self.indexView.lowerMargin = is4InchScreen()?25.0:90.0;
    self.indexView.rightMargin = 0.0;
    self.indexView.itemsAligment = NSTextAlignmentLeft;
    self.indexView.maxItemDeflection = 140.0;
    self.indexView.rangeOfDeflection = 2;
    self.indexView.fontColor = [UIColor lightGrayColor];;
    self.indexView.selectedItemFontColor = [UIColor whiteColor];
    self.indexView.darkening = NO;
    self.indexView.fading = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[AppDelegate shareAppdelegate].homeTabbarController hideTabBarAnimated:YES];
    [self.contactTableView startRefreshing];
}

- (void)sendGetContact
{
    self.emptyLabel.hidden = YES;
    if (!self.contactTableView.pullTableIsLoadingMore && !self.contactTableView.pullTableIsRefreshing) {
        [_contactArray removeAllObjects];
        [self.contactTableView reloadData];
    }
    NSString *userId=[[NSUserDefaults standardUserDefaults] stringForKey:@"USER_ID"];
    if (type == 1) {
        [FollowingDataRequest requestWithDelegate:self withParameters:nil withUrl:[[REQUEST_DOMAIN stringByAppendingString:@"member/following/"] stringByAppendingFormat:@"%@",userId]];
    }else if (type == 2){
        [FollowedDataRequest requestWithDelegate:self withParameters:nil withUrl:[[REQUEST_DOMAIN stringByAppendingString:@"member/followed/"] stringByAppendingFormat:@"%@",userId]];
    }
}

- (IBAction)tapOnBackBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)requestDidFinishLoad:(ITTBaseDataRequest*)request
{
    if ([request isSuccess]) {
        [self parseNSDictionary:request.resultDic];
        [[HTActivityIndicator currentIndicator] hide];
    }else{
        [[HTActivityIndicator currentIndicator] displayMessage:request.result.message];
    }
    self.contactTableView.pullTableIsLoadingMore = NO;
    self.contactTableView.pullTableIsRefreshing = NO;
}

- (void)request:(ITTBaseDataRequest*)request didFailLoadWithError:(NSError*)error
{
    [[HTActivityIndicator currentIndicator] displayMessage:@"网络不佳，请检查网络!"];
    self.contactTableView.pullTableIsLoadingMore = NO;
    self.contactTableView.pullTableIsRefreshing = NO;
}

- (void) parseNSDictionary:(NSDictionary*)dic{
    NSMutableArray *tempArray = [dic objectForKey:@"members"];
    NSMutableArray *nArray = [[NSMutableArray alloc] init];
    for (int i=0; i<[tempArray count]; i++) {
        NSDictionary *innerDic = tempArray[i];
        
        Contact *contact = [[Contact alloc] initWithDataDic:innerDic];
        if (!contact.gender) {
            contact.gender = @"";
        } else if ([contact.gender isEqualToString:@"man"]) {
            contact.gender = @"男";
        } else{
            contact.gender = @"女";
        }
        [nArray addObject:contact];
    }
    _contactArray = nArray;
    if (!_contactArray||[_contactArray count]==0) {
        if (type == 1) {
            self.emptyLabel.text = @"您还没有关注任何好友!";
        }else{
            self.emptyLabel.text = @"还没有任何好友关注您!";
        }
        self.emptyLabel.hidden = NO;
    }else {
        if ([_contactArray count]<10) {
            self.indexView.hidden = YES;
        }else{
            self.indexView.hidden = NO;
        }
        self.emptyLabel.hidden = YES;
    }
    [self initData];
    [self.contactTableView reloadData];
}


#pragma mark - ITTPullTableView Delegate
- (void)pullTableViewDidTriggerRefresh:(ITTPullTableView*)pullTableView
{
    [self sendGetContact];
}

- (void)pullTableViewDidTriggerLoadMore:(ITTPullTableView*)pullTableView
{
    [self sendGetContact];
}

#pragma mark - ContactCellDelegate
- (void)imageDidSelected:(Contact *)contact{
    ContactDetailViewController *contactDetailViewController =[[ContactDetailViewController alloc] initWithContact:contact];
    [self.navigationController pushViewController:contactDetailViewController animated:NO];
}

- (void)viewDidUnload {
    [self setContactTableView:nil];
    [super viewDidUnload];
}



#pragma mark -
#pragma mark create method

- (void)initData {
    //init
    _dataArr = [[NSMutableArray alloc] init];
    _sortedArrForArrays = [[NSMutableArray alloc] init];
    _sectionHeadsKeys = [[NSMutableArray alloc] init];
    [self.sortedArrForArrays removeAllObjects];
    //initialize a array to hold keys like A,B,C ...
    self.sortedArrForArrays =[self getChineseStringArr:_contactArray];
    [self.indexView refreshIndexItems];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *arr = [self.sortedArrForArrays objectAtIndex:indexPath.section];
    Contact *contact = (Contact *) [arr objectAtIndex:indexPath.row];
    [self imageDidSelected:contact];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return  [[self.sortedArrForArrays objectAtIndex:section] count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.sortedArrForArrays count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [_sectionHeadsKeys objectAtIndex:section];
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
    static NSString *CellIdentifier = @"ContactCell";
    ContactCell *cell = (ContactCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"ContactCell" owner:self options:nil][0];
    }
    Contact *contact = [[Contact alloc] init];
    
    if ([self.sortedArrForArrays count] > indexPath.section) {
        NSArray *arr = [self.sortedArrForArrays objectAtIndex:indexPath.section];
        if ([arr count] > indexPath.row) {
            contact = (Contact *) [arr objectAtIndex:indexPath.row];
            
        } else {
            NSLog(@"arr out of range");
        }
        //[_contactArray addObject:contact];
    } else {
        NSLog(@"sortedArrForArrays out of range");
    }
    cell.delegate = self;
    [cell setContactData:contact];
    return cell;
}

- (NSMutableArray *)getChineseStringArr:(NSMutableArray *)arrToSort {
    NSMutableArray *chineseStringsArray = [NSMutableArray array];
    for(int i = 0; i < [arrToSort count]; i++) {
        Contact *contact =[arrToSort objectAtIndex:i];
        if(contact.name==nil){
            contact.name=@"";
        }
        
        if(![contact.name isEqualToString:@""]){
            //join the pinYin
            NSString *pinYinResult = [NSString string];
            for(int j = 0;j < contact.name.length; j++) {
                NSString *singlePinyinLetter = [[NSString stringWithFormat:@"%c",
                                                 pinyinFirstLetter([contact.name characterAtIndex:j])]uppercaseString];
                
                pinYinResult = [pinYinResult stringByAppendingString:singlePinyinLetter];
            }
            contact.pinYin = pinYinResult;
        } else {
            contact.pinYin = @"";
        }
        [chineseStringsArray addObject:contact];
    }
    
    //sort the ChineseStringArr by pinYin
    NSArray *sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"pinYin" ascending:YES]];
    [chineseStringsArray sortUsingDescriptors:sortDescriptors];
    
    NSMutableArray *arrayForArrays = [NSMutableArray array];
    BOOL checkValueAtIndex= NO;  //flag to check
    NSMutableArray *TempArrForGrouping = nil;
    
    for(int index = 0; index < [chineseStringsArray count]; index++)
    {
        Contact *chineseStr = (Contact *)[chineseStringsArray objectAtIndex:index];
        NSMutableString *strchar= [NSMutableString stringWithString:chineseStr.pinYin];
        NSString *sr = (strchar&&[strchar length]>0)?[strchar substringToIndex:1]:@"";
        if(![_sectionHeadsKeys containsObject:[sr uppercaseString]])//here I'm checking whether the character already in the selection header keys or not
        {
            [_sectionHeadsKeys addObject:[sr uppercaseString]];
            TempArrForGrouping = [[NSMutableArray alloc] initWithObjects:nil];
            checkValueAtIndex = NO;
        }
        if([_sectionHeadsKeys containsObject:[sr uppercaseString]])
        {
            [TempArrForGrouping addObject:[chineseStringsArray objectAtIndex:index]];
            if(checkValueAtIndex == NO)
            {
                [arrayForArrays addObject:TempArrForGrouping];
                checkValueAtIndex = YES;
            }
        }
    }
    return arrayForArrays;
}

#pragma mark MJMIndexForTableView datasource methods
- (NSArray *)sectionIndexTitlesForMJNIndexView:(MJNIndexView *)indexView
{
    return self.sectionHeadsKeys;
}


- (void)sectionForSectionMJNIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    [self.contactTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:index] atScrollPosition: UITableViewScrollPositionTop animated:NO];
}

@end
