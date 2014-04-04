

#import <UIKit/UIKit.h>
#import "EventArrangementDetail.h"
#import <QuickLook/QuickLook.h>
#import "DVFile.h"
@protocol InfoCellDelegate <NSObject>

- (void)didSelected:(DVFile *)dvFile;

@end
@interface InfoCell : UITableViewCell<UITableViewDataSource,UITableViewDelegate,QLPreviewControllerDataSource>
{
    UITableView *hortable;
    NSInteger porsection;
    NSMutableArray *arrayOfDocuments;
}
@property (nonatomic, assign)id <InfoCellDelegate> delegate;

- (void)setEventDetailData:(EventArrangementDetail *)eventArrangementDetail type:(NSInteger)type;

@end
