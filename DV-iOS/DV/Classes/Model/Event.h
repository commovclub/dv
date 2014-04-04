//
//  Event.h
//  DV
//
//  Created by Zhao Zhicheng on 1/3/14.
//
//

#import <Foundation/Foundation.h>
#import "ITTBaseModelObject.h"
#import "NSObject+RMArchivable.h"
#import "LKDBHelper.h"

@interface Event : ITTBaseModelObject
@property (nonatomic, strong)NSString *title;
@property (nonatomic, strong)NSString *subTitle;
@property (nonatomic, strong)NSString *time;
@property (nonatomic, strong)NSString *content;
@property (nonatomic, strong)NSString *path;
@property (nonatomic, strong)NSString *type;
@property (nonatomic, strong)NSString *eventId;
@property (nonatomic, strong)NSString *hasApplied;
@property (nonatomic)BOOL isFavorite;
@property (nonatomic)BOOL isApply;
@end
