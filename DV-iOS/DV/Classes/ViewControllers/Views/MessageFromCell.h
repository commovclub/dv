//
//  MessageFromCell.h
//  HotWord
//
//  Created by Jack Liu on 8/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ITTImageView.h"
#import "DVMessage.h"
#import <QuartzCore/CALayer.h>

@interface MessageFromCell : UITableViewCell

- (void)setMessage:(DVMessage *)message;

+ (CGFloat)getCellHeightByContent:(NSString *)content;

@end
