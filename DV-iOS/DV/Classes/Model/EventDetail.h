//
//  EventDetail.h
//  DV
//
//  Created by Zhao Zhicheng on 2/23/14.
//
//

#import <Foundation/Foundation.h>
#import "ITTBaseModelObject.h"

@interface EventDetail : ITTBaseModelObject
//section1
@property (nonatomic, strong)NSString *content;
//section2 演讲者
@property (nonatomic, strong)NSString *name;
@property (nonatomic, strong)NSString *path;
@property (nonatomic, strong)NSString *desc;
//section3
@property (nonatomic, retain)NSMutableArray *fileArray;
//section4
@property (nonatomic, retain)NSMutableArray *videoArray;
//section5
@property (nonatomic, retain)NSMutableArray *picArray;


@end
