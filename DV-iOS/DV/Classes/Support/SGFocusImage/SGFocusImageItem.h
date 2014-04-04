//
//  SGFocusImageItem.h
//  SGFocusImageFrame
//
//  Created by Shane Gao on 17/6/12.
//  Copyright (c) 2012 Shane Gao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ITTImageView.h"

@interface SGFocusImageItem : NSObject

@property (nonatomic, retain)  NSString     *title;
@property (nonatomic, retain)  UIImage      *image;
@property (nonatomic, retain)  ITTImageView  *background;
@property (nonatomic, assign)  NSInteger     tag;
@property (nonatomic, assign)  NSString     *url;

- (id)initWithTitle:(NSString *)title background:(ITTImageView *)background tag:(NSInteger)tag;
- (id)initWithTitle:(NSString *)title image:(UIImage *)image tag:(NSInteger)tag  background:(UIImageView *)background url:(NSString *)url;
@end