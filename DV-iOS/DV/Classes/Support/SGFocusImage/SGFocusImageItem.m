//
//  SGFocusImageItem.m
//  SGFocusImageFrame
//
//  Created by Shane Gao on 17/6/12.
//  Copyright (c) 2012 Shane Gao. All rights reserved.
//

#import "SGFocusImageItem.h"

@implementation SGFocusImageItem
@synthesize title =  _title;
@synthesize image =  _image;
@synthesize background =  _background;
@synthesize tag =  _tag;
@synthesize url= _url;

- (void)dealloc
{
    [_title release];
    [_image release];
    [super dealloc];
}

- (id)initWithTitle:(NSString *)title background:(ITTImageView *)background tag:(NSInteger)tag
{
    self = [super init];
    if (self) {
        self.title = title;
        self.background = background;
        self.tag = tag;
    }
    
    return self;
}

- (id)initWithTitle:(NSString *)title image:(UIImage *)image tag:(NSInteger)tag background:(ITTImageView *)background  url:(NSString *)url
{
    self = [super init];
    if (self) {
        self.title = title;
        self.image = image;
        self.background = background;
        self.tag = tag;
        self.url = url;
    }
    
    return self;
}

@end
