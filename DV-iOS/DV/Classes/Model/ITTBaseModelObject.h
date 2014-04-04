//
//  ITTBaseModelObject.h
//
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "DataCacheManager.h"

@interface ITTBaseModelObject :NSObject <NSCoding>
{
}

- (id)initWithDataDic:(NSDictionary*)data;
- (void)setAttributes:(NSDictionary*)dataDic;
- (NSDictionary*)attributeMapDictionary;
- (NSString*)customDescription;
- (NSString*)description;
- (NSData*)getArchivedData;
+ (NSArray *)getDumpData;
@end
