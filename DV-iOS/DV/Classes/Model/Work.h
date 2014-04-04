//
//  Work.h
//  DV
//
//  Created by Zhao Zhicheng on 3/8/14.
//
//
#import <Foundation/Foundation.h>
#import "ITTBaseModelObject.h"
#import "NSObject+RMArchivable.h"
#import "LKDBHelper.h"

@interface Work : ITTBaseModelObject
@property (nonatomic, strong)NSString *title;
@property (nonatomic, strong)NSString *uuid;
@property (nonatomic, strong)NSString *memberId;
@property (nonatomic, strong)NSString *description;
@property (nonatomic, strong)NSString *createdAt;
@property (nonatomic, strong)NSMutableArray *files;

@end
