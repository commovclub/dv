//
//  DVImage.h
//  DV
//
//  Created by Zhao Zhicheng on 2/24/14.
//
//

#import <Foundation/Foundation.h>
#import "ITTBaseModelObject.h"
#import "NSObject+RMArchivable.h"

@interface DVImage : ITTBaseModelObject
@property (nonatomic, strong)NSString *imageId;
@property (nonatomic, strong)NSString *objectId;//newId,eventId
@property (nonatomic, strong)NSString *portfolioId;
@property (nonatomic, strong)NSString *filePath;


@end
