//
//  WorkListViewController.m
//  DV
//
//  Created by Zhao Zhicheng on 3/7/14.
//
//

#import "WorkListViewController.h"
#import "UploadWorkViewController.h"
#import "DVImage.h"

@interface WorkListViewController (){

    NSMutableArray *_worksArray;
    Work *willDeleteWork;
}
@property (strong, nonatomic) IBOutlet ITTPullTableView *worksTableView;
@property (strong, nonatomic) IBOutlet UILabel *emptyLabel;

@end

@implementation WorkListViewController

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
    _worksArray = [[NSMutableArray alloc] init];
    [self.worksTableView setLoadMoreViewHidden:NO];
    [self.worksTableView setRefreshViewHidden:NO];
    self.worksTableView.pullBackgroundColor = [UIColor clearColor];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[AppDelegate shareAppdelegate].homeTabbarController hideTabBarAnimated:YES];
    [self.worksTableView deselectRowAtIndexPath:[self.worksTableView indexPathForSelectedRow] animated:YES];
    [self.worksTableView startRefreshing];
}

- (void)sendGetWorks
{
    if (!self.worksTableView.pullTableIsLoadingMore && !self.worksTableView.pullTableIsRefreshing) {
        [_worksArray removeAllObjects];
        [self.worksTableView reloadData];
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (self.worksTableView.pullTableIsRefreshing) {
        [params setObject:@"1" forKey:@"pageNumber"];
    }else{
        [params setObject:[NSString stringWithFormat:@"%d", [_worksArray count]/LIST_PAGE_COUNT + 1] forKey:@"pageNumber"];
    }
    [params setObject:[NSString stringWithFormat:@"%d", LIST_PAGE_COUNT] forKey:@"pageSize"];
    
    [WorkListDataRequest requestWithDelegate:self withParameters:params];
}

- (void)sendDeleteWork
{
    [DeleteWorkDataRequest requestWithDelegate:self withParameters:nil withUrl:[REQUEST_DOMAIN stringByAppendingFormat:@"portfolio/delete/%@", willDeleteWork.uuid]];
    [[HTActivityIndicator currentIndicator] displayActivity:@"正在删除该作品..."];
}

- (void)requestDidFinishLoad:(ITTBaseDataRequest*)request
{
    if ([request isSuccess]) {
        if ([request isKindOfClass:[WorkListDataRequest class]]) {
            [self parseNSDictionary:request.resultDic];
            self.worksTableView.pullTableIsLoadingMore = NO;
            self.worksTableView.pullTableIsRefreshing = NO;
        }else if ([request isKindOfClass:[DeleteWorkDataRequest class]]) {
            if ([_worksArray containsObject:willDeleteWork]) {
                [_worksArray removeObject:willDeleteWork];
                [self.worksTableView reloadData];
                if ([_worksArray count]>0) {
                    [self.worksTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionTop];
                }else{
                    self.emptyLabel.text = @"您还没有提交任何作品\n提交作品请点击右下角的\n'上传作品'按钮!";
                    self.emptyLabel.hidden = NO;
                }
            }
        }
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
        [self.worksTableView setLoadMoreViewHidden:NO];
    }else{
        [self.worksTableView setLoadMoreViewHidden:YES];
    }
    if (self.worksTableView.pullTableIsLoadingMore) {
        [_worksArray addObjectsFromArray:nArray];
    }else{
        _worksArray = nArray;
    }
    if (!_worksArray||[_worksArray count]==0) {
        self.emptyLabel.text = @"您还没有提交任何作品\n提交作品请点击右下角的\n'上传作品'按钮!";
        self.emptyLabel.hidden = NO;
    }else{
        self.emptyLabel.hidden = YES;
    }
    [self.worksTableView reloadData];

}

- (void)request:(ITTBaseDataRequest*)request didFailLoadWithError:(NSError*)error
{
    [[HTActivityIndicator currentIndicator] displayMessage:@"网络不佳，请检查网络!"];
    self.worksTableView.pullTableIsLoadingMore = NO;
    self.worksTableView.pullTableIsRefreshing = NO;
}

- (IBAction)tapOnBackBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)tapOnUploadWorkBtn:(id)sender {
    UploadWorkViewController *viewController = [[UploadWorkViewController alloc] initWithNibName:@"UploadWorkViewController" bundle:nil];
    [self.navigationController pushViewController:viewController animated:NO];
}

#pragma mark - tableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_worksArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"WorkCell";
    WorkCell *cell = (WorkCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"WorkCell" owner:self options:nil][0];
    }
    cell.delegate = self;
    Work *work = _worksArray[indexPath.row];
    [cell setWorkData:work];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Work *work = _worksArray[indexPath.row];

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

#pragma mark - ITTPullTableView Delegate
- (void)pullTableViewDidTriggerRefresh:(ITTPullTableView*)pullTableView
{
    [self sendGetWorks];
}

- (void)pullTableViewDidTriggerLoadMore:(ITTPullTableView*)pullTableView
{
    [self sendGetWorks];
}

- (void)viewDidUnload {
    [self setWorksTableView:nil];
    [super viewDidUnload];
}

#pragma WorkCellDelegate
- (void)deleteWork:(Work *)work{
    if (!work) {
        [[HTActivityIndicator currentIndicator] displayMessage:@"数据错误!"];
    }
    UIActionSheet *actionSheet=[[UIActionSheet alloc] initWithTitle:@"删除该作品" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"删除" otherButtonTitles: nil];
    [actionSheet showInView:self.view.superview];
    willDeleteWork = work;
}

#pragma mark- UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0) {
        //删除作品
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self sendDeleteWork];
            
        });
    }
}
@end
