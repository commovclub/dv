//
//  MessageToCell.h
//  HotWord
//
//  Created by Jack Liu on 8/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ITTImageView.h"
#import "DVMessage.h"
#import <QuartzCore/CALayer.h>

@protocol MessageToCellDelegate;

@interface MessageToCell : UITableViewCell

@property (weak, nonatomic) id<MessageToCellDelegate> delegate;

- (void)setMessage:(DVMessage *)message;
+ (CGFloat)getCellHeightByContent:(NSString *)content;

@end

@protocol MessageToCellDelegate <NSObject>

- (void)resendMessage:(DVMessage *)message;

@end
