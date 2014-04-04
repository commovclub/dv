//
//  ContactViewController.m
//  DV
//
//  Created by Zhao Zhicheng on 1/2/14.
//
//

#import "ContactViewController.h"
#import "ContactDetailViewController.h"
#import "HTActivityIndicator.h"
#import "pinyin.h"
#import "MJNIndexView.h"
#import "NSUserDefaults+RMSaveCustomObject.h"

@interface ContactViewController ()<MJNIndexViewDataSource>{
    NSMutableArray *_contactArray;
    int tagIndex;
    IBOutlet UIScrollView *scrollViewImages;
    IBOutlet UIPageControl *pageControl;
    int timeNum;
    BOOL tend;
    NSMutableArray *_imagesArray;
}
@property (strong, nonatomic) IBOutlet UIView *tableHeaderView;
@property (strong, nonatomic) IBOutlet ITTPullTableView *contactTableView;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segmentedControl;

@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) NSMutableArray *sortedArrForArrays;
@property (nonatomic, strong) NSMutableArray *sectionHeadsKeys;
// MJNIndexView
@property (nonatomic, strong) MJNIndexView *indexView;
@end

@implementation ContactViewController

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
    _contactArray = [[NSMutableArray alloc] init];
    _imagesArray = [[NSMutableArray alloc] init];
    NSDictionary *dic = [[NSUserDefaults standardUserDefaults] rm_customObjectForKey:@"CONTACT_CACHE"];
    [self parseNSDictionary:dic];
    [self.contactTableView reloadData];
    
    [self.contactTableView startRefreshing];
    [self.contactTableView setLoadMoreViewHidden:YES];
    self.contactTableView.pullBackgroundColor = [UIColor clearColor];
    self.contactTableView.showsVerticalScrollIndicator = NO;
    // initialise MJNIndexView
    self.indexView = [[MJNIndexView alloc] initWithFrame:self.contactTableView.frame];
    self.indexView.dataSource = self;
    [self fifthAttributesForMJNIndexView];
    [self.view addSubview:self.indexView];
    UIScrollView *scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 20, 320, 30)];
    scroll.contentSize = CGSizeMake(320, 30);
    scroll.showsHorizontalScrollIndicator = YES;
    scroll.pagingEnabled = YES;
    scroll.showsHorizontalScrollIndicator = YES;
    scroll.autoresizingMask = YES;
    scroll.autoresizesSubviews = YES;
    [scroll addSubview:self.segmentedControl];
    [self.view addSubview:scroll];
}

#pragma mark -
- (void)initBanner
{
    NSMutableArray *_SGFocusImageItemArray = [[NSMutableArray alloc] init];
    for (int i=0; i<[_imagesArray count]; i++) {
        Contact *contact =[_imagesArray objectAtIndex:i];
        ITTImageView *imageView =[[ITTImageView alloc] init];
        [imageView loadImage:contact.path placeHolder:[UIImage imageNamed:@"placeholder@2x.png"]];

        SGFocusImageItem *item = [[SGFocusImageItem alloc] initWithTitle:@"" background:imageView  tag:i ];
        item.tag = i;
        [_SGFocusImageItemArray addObject:item];
    }
    SGFocusImageFrame *imageFrame = [[SGFocusImageFrame alloc] initWithFrame:CGRectMake(0, 20, self.view.bounds.size.width, 160)
                                                                    delegate:self
                                                                      images:_SGFocusImageItemArray];
    self.contactTableView.tableHeaderView = imageFrame;
}

#pragma mark -
- (void)foucusImageFrame:(SGFocusImageFrame *)imageFrame didSelectItem:(SGFocusImageItem *)item
{
    NSLog(@"%@ tapped", item.title);
    Contact * contact = [_imagesArray objectAtIndex:item.tag];
    [self imageDidSelected:contact];
}

- (void) setCurrentPage:(NSInteger)secondPage {
    
    for (NSUInteger subviewIndex = 0; subviewIndex < [pageControl.subviews count]; subviewIndex++) {
        UIImageView* subview = [pageControl.subviews objectAtIndex:subviewIndex];
        CGSize size;
        size.height = 8;
        size.width = 8;
        [subview setFrame:CGRectMake(subview.frame.origin.x, subview.frame.origin.y,
                                     size.width,size.height)];
    }
}
#pragma mark - 3秒换图片
- (void) handleTimer: (NSTimer *) timer
{
    if (timeNum % 3 == 0 ) {
        
        if (pageControl.currentPage==(pageControl.numberOfPages-1)) {
            pageControl.currentPage = 0;
            [UIView animateWithDuration:0.1 //速度0.7秒
                             animations:^{//修改坐标
                                 scrollViewImages.contentOffset = CGPointMake(pageControl.currentPage*320,0);
                             }];
        }else{
            pageControl.currentPage++;
            [UIView animateWithDuration:0.7 //速度0.7秒
                             animations:^{//修改坐标
                                 scrollViewImages.contentOffset = CGPointMake(pageControl.currentPage*320,0);
                             }];
        }
        
    }
    timeNum ++;
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
    [[AppDelegate shareAppdelegate].homeTabbarController showTabBarAnimated:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)sendGetContact
{
    if (!self.contactTableView.pullTableIsLoadingMore && !self.contactTableView.pullTableIsRefreshing) {
        [_contactArray removeAllObjects];
        [self.contactTableView reloadData];
    }
    [GetContactListDataRequest requestWithDelegate:self withParameters:nil];
}

- (IBAction)tapOnBackBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)tapOnBanner:(id)sender {
}

- (IBAction)toggleControls:(id)sender {
    tagIndex = [sender selectedSegmentIndex];
    [self initData];
    [self.contactTableView reloadData];
    
}

- (void)requestDidFinishLoad:(ITTBaseDataRequest*)request
{
    if ([request isSuccess]) {
        [self parseNSDictionary:request.resultDic];
        [[NSUserDefaults standardUserDefaults]  rm_setCustomObject:request.resultDic forKey:@"CONTACT_CACHE"];
        [[NSUserDefaults standardUserDefaults]  synchronize];
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
    [_imagesArray removeAllObjects];
    NSMutableArray *bannerTempArray = [dic objectForKey:@"banner"];
    if (bannerTempArray&&[bannerTempArray count]>0) {
        for (int i=0; i<[bannerTempArray count]; i++) {
            NSDictionary *innerDic = bannerTempArray[i];
            Contact *contact = [[Contact alloc] initWithDataDic:innerDic];
            if (!contact.gender) {
                contact.gender = @"";
            } else if ([contact.gender isEqualToString:@"man"]) {
                contact.gender = @"男";
            } else{
                contact.gender = @"女";
            }
            [_imagesArray addObject:contact];
        }
    }
     _contactArray = nArray;
    
    [self initData];
    [self.contactTableView reloadData];
    [self initBanner];
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
        //数字
        if(tagIndex == 1&&([contact.category rangeOfString:@"数字"].location != NSNotFound)){
            [chineseStringsArray addObject:contact];
        }else if(tagIndex == 2&&([contact.category rangeOfString:@"科技"].location != NSNotFound)){
            [chineseStringsArray addObject:contact];
        }else if(tagIndex == 0){
            [chineseStringsArray addObject:contact];
        }
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