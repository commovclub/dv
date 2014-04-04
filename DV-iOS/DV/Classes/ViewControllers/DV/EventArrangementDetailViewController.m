//
//  EventArrangementDetailViewController.m
//  DV
//
//  Created by Zhao Zhicheng on 2/21/14.
//
//

#import "EventArrangementDetailViewController.h"
#import "FileCell.h"
#import "EventDetail.h"
#import "ITTImageView.h"
#import "SJAvatarBrowser.h"
#import "EventFileViewController.h"

@interface EventArrangementDetailViewController (){
    NSMutableArray *_groupArray;

}
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;

@property (strong, nonatomic) IBOutlet UIView *tableHeader;

@property (strong, nonatomic) IBOutlet UITableViewCell *detailTableCell;
@property (strong, nonatomic) IBOutlet UILabel *contentLabel;

@property (strong, nonatomic) IBOutlet UITableViewCell *profileTableCell;
@property (strong, nonatomic) IBOutlet UILabel *speechNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *speechDescLabel;
@property (strong, nonatomic) IBOutlet ITTImageView *speechAvatar;

@property (strong, nonatomic) EventArrangementDetail *eventArrangementDetail;
@property (strong, nonatomic) EventArrangement *eventArrangement;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation EventArrangementDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (id)initWithEvent:(EventArrangement *)eventArrangement detail:(EventArrangementDetail *)eventArrangementDetail{
    self = [super init];
    if (self) {
        self.eventArrangementDetail = eventArrangementDetail;
        self.eventArrangement = eventArrangement;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.titleLabel.text = self.eventArrangementDetail.title;
    self.timeLabel.text = [NSString stringWithFormat:@"%@ %@",self.eventArrangementDetail.date,self.eventArrangementDetail.time] ;
    self.tableView.tableHeaderView = self.tableHeader;
    self.speechAvatar.layer.masksToBounds = YES;
    self.speechAvatar.layer.cornerRadius = 30.0f;
    self.speechAvatar.delegate = self;
    self.speechAvatar.enableTapEvent = YES;
    [self sendGetArrangementDetail];
}

- (void)viewWillDisappear:(BOOL)animated{
    [[HTActivityIndicator currentIndicator] hide];
}

- (void)updateUI{
    _groupArray = [[NSMutableArray alloc] init];
    [_groupArray addObject:@""];
    [_groupArray addObject:@"演讲人"];
    //[_groupArray addObject:@"内容标签"];
    [_groupArray addObject:@"资料"];//下载"];
    //[_groupArray addObject:@"受邀嘉宾"];
    //[_groupArray addObject:@"活动视频欣赏"];
    //[_groupArray addObject:@"活动图片欣赏"];
    [self.speechAvatar loadImage:self.eventArrangementDetail.image placeHolder:[UIImage imageNamed:@"head_boy_50.png"]];
    [self.tableView reloadData];
}

- (void)sendGetArrangementDetail
{
    [EventArrangementDetailDataRequest requestWithDelegate:self withParameters:nil withUrl:[[REQUEST_DOMAIN stringByAppendingString:@"event/schedule/"] stringByAppendingString:self.eventArrangementDetail.eventArrangementDetailId]];
    
    [[HTActivityIndicator currentIndicator] displayActivity:@"加载中..."];
}

- (void)requestDidFinishLoad:(ITTBaseDataRequest*)request
{
    if ([request isSuccess]) {
        self.eventArrangementDetail =[[EventArrangementDetail alloc] initWithDataDic:request.resultDic];
        NSMutableArray *filesArray = [request.resultDic objectForKey:@"files"];
        NSMutableArray *files = [[NSMutableArray alloc] init];
        for (int j=0; j<[filesArray count]; j++) {
            DVFile *file=[[DVFile alloc] initWithDataDic:filesArray[j]];
            [files addObject:file];
        }
        self.eventArrangementDetail.fileArray = files;
        [self updateUI];
        [[HTActivityIndicator currentIndicator] hide];
    }else{
        [[HTActivityIndicator currentIndicator] displayMessage:request.result.message];
    }
}


- (void)request:(ITTBaseDataRequest*)request didFailLoadWithError:(NSError*)error
{
    [[HTActivityIndicator currentIndicator] displayMessage:@"网络不佳，请检查网络!"];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[AppDelegate shareAppdelegate].homeTabbarController hideTabBarAnimated:YES];
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
}

- (IBAction)tapOnBackBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - tableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section ==0) {
        CGSize maximumLabelSize = CGSizeMake(300, CGFLOAT_MAX);
        CGRect textRect = [self.eventArrangementDetail.description boundingRectWithSize:maximumLabelSize
                                                 options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                              attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]}
                                                 context:nil];
       self.contentLabel.text = self.eventArrangementDetail.description;
       self.contentLabel.frame = (CGRect){ { self.contentLabel.frame.origin.x, self.contentLabel.frame.origin.y }, textRect.size};;

        return  self.detailTableCell;
    }else if (indexPath.section==1) {
        CGSize maximumLabelSize = CGSizeMake(220, CGFLOAT_MAX);
        CGRect textRect = [self.eventArrangementDetail.speakerIntro boundingRectWithSize:maximumLabelSize
                                                                 options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                                              attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]}
                                                                 context:nil];
        self.speechDescLabel.text = self.eventArrangementDetail.speakerIntro;
        self.speechDescLabel.frame = (CGRect){ { self.speechDescLabel.frame.origin.x, self.speechDescLabel.frame.origin.y }, textRect.size};;
        self.speechNameLabel.text = self.eventArrangementDetail.speaker;
        return self.profileTableCell;
    }else{
        NSString *cellname = [NSString stringWithFormat:@"InfoCell%i",indexPath.section];
        InfoCell *cell = (InfoCell *)[tableView dequeueReusableCellWithIdentifier:cellname];
        if (cell == nil){
            cell = [[InfoCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellname];
        }
        cell.delegate = self;
        [cell setEventDetailData:self.eventArrangementDetail type:(indexPath.section-1)];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    int count=[_groupArray count];
    return count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        CGSize maximumLabelSize = CGSizeMake(300, CGFLOAT_MAX);
        CGRect textRect = [self.eventArrangementDetail.description boundingRectWithSize:maximumLabelSize
                                                                 options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                                              attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]}
                                                                 context:nil];
        return textRect.size.height<20?0:(textRect.size.height+26);
    }else if (indexPath.section==1) {
        CGSize maximumLabelSize = CGSizeMake(220, CGFLOAT_MAX);
        CGRect textRect = [self.eventArrangementDetail.speakerIntro boundingRectWithSize:maximumLabelSize
                                                                 options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                                              attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]}
                                                                 context:nil];
        return textRect.size.height<50?90:textRect.size.height+44;
    }
    if (indexPath.section==2&&[self.eventArrangementDetail.fileArray count]==0) {//如果没有资料高度是0
        return 0;
    }
    return 90;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    int row = indexPath.row;
    switch (row) {
        case 0:
       
            break;
        default:
            break;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [_groupArray objectAtIndex:section];
}

- (void)viewDidUnload {
    [self setTableView:nil];
    [super viewDidUnload];
}

- (void)imageClicked:(ITTImageView *)imageView
{
    [SJAvatarBrowser showImage:imageView];
}

#pragma InfoCellDelegate
- (void)didSelected:(DVFile *)dvFile{
    EventFileViewController *eventFileViewController = [[EventFileViewController alloc] initWithFile:dvFile];
    [self.navigationController pushViewController:eventFileViewController animated:YES];
}

@end
