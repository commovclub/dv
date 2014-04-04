//
//  About.h
//  DV
//
//  Created by Zhao Zhicheng on 1/11/14.
//
//

#import <Foundation/Foundation.h>
#import "ITTBaseModelObject.h"

@interface About : ITTBaseModelObject
@property (nonatomic, strong)NSString *title;
@property (nonatomic, strong)NSString *url;
@property (nonatomic, strong)NSString *content;

@end
