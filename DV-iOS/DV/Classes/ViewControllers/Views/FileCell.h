//
//  FielCell.h
//

#import <UIKit/UIKit.h>
#import "DVFile.h"
#import "ITTImageView.h"


@interface FileCell  : UITableViewCell<ITTImageViewDelegate>

@property (nonatomic, retain) DVFile *dvFile;

- (void)setFileData:(DVFile *)dvFile type:(NSInteger)type;

@end
