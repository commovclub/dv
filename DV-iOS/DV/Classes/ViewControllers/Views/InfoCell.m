
#import "InfoCell.h"
#import "FileCell.h"
#import "SJAvatarBrowser.h"
#import "EventArrangementDetail.h"
@interface InfoCell()

@property (nonatomic, retain) NSMutableArray   *dataArray1;
@property (strong, nonatomic) EventArrangementDetail *eventDetail;
@property ( nonatomic) NSInteger type;

@end

@implementation InfoCell
@synthesize dataArray1 = _dataArray1;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
}

- (void)setEventDetailData:(EventArrangementDetail *)eventArrangementDetail type:(NSInteger)type{
    self.eventDetail = eventArrangementDetail;
    
    self.type = type;
    hortable = [[UITableView alloc]initWithFrame:CGRectMake(100, -90, 140, 320) style:UITableViewStylePlain];
    hortable.delegate = self;
    hortable.dataSource = self;
    hortable.transform = CGAffineTransformMakeRotation(M_PI / 2 *3);
    [self addSubview:hortable];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (self.type) {
        case 1://pdf
           return  [self.eventDetail.fileArray count];
        case 2://video
           return  [self.eventDetail.videoArray count];
        case 3://pic
           return  [self.eventDetail.picArray count];
    }
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = [NSString stringWithFormat:@"cell%d",indexPath.row];
    FileCell *cell = (FileCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"FileCell" owner:self options:nil][0];
    }
    cell.transform = CGAffineTransformMakeRotation(M_PI/2);
    if (self.type == 1) {
        DVFile *file =[self.eventDetail.fileArray objectAtIndex:indexPath.row];
        [cell setFileData:file type:self.type];
    }else if(self.type == 2){
        DVFile *file =[self.eventDetail.videoArray objectAtIndex:indexPath.row];
        [cell setFileData:file type:self.type];
    }else if(self.type == 3){
        DVFile *file =[self.eventDetail.picArray objectAtIndex:indexPath.row];
        [cell setFileData:file type:self.type];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 110;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   if(self.type == 1){
       DVFile *file =[self.eventDetail.fileArray objectAtIndex:indexPath.row];
       if([self.delegate respondsToSelector:@selector(didSelected:)]) {
           [self.delegate didSelected:file];
       }
   }
}

@end
