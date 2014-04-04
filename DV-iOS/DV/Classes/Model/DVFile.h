//
//  DVFile.h
//  DV
//
//  Created by Zhao Zhicheng on 2/23/14.
//
//

#import <Foundation/Foundation.h>
#import "ITTBaseModelObject.h"

@interface DVFile : ITTBaseModelObject

@property (nonatomic, retain)NSString *fileId;
@property (nonatomic, retain)NSString *name;
@property (nonatomic, retain)NSString *path;
@property (nonatomic, retain)NSString *type;//only PDF now

@end
