//
//  DVImage.m
//  DV
//
//  Created by Zhao Zhicheng on 2/24/14.
//
//

#import "DVImage.h"

@implementation DVImage

- (NSDictionary*)attributeMapDictionary{
	return @{ @"imageId": @"id"
              ,@"objectId": @"infoId"
              ,@"filePath": @"filePath"
              };
}
@end
