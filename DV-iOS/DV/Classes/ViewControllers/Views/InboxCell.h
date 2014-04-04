//
//  InboxCell.h
//  HotWord
//
//  Created by Jack Liu on 13-5-25.
//
//

#import <UIKit/UIKit.h>
#import "ITTImageView.h"
#import "DVMessage.h"

@interface InboxCell : UITableViewCell

- (void)setMessageData:(DVMessage *)message;

@end
