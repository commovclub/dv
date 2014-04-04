//
//  DVFile.m
//  DV
//
//  Created by Zhao Zhicheng on 2/23/14.
//
//

#import "DVFile.h"

@implementation DVFile
//TODO
- (NSDictionary*)attributeMapDictionary{
	return @{@"type": @"fileType"
             ,@"path": @"filePath"
             ,@"name": @"fileTitle"
             };
}

@end
