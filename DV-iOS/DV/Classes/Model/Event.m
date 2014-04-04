//
//  Event.m
//  DV
//
//  Created by Zhao Zhicheng on 1/3/14.
//
//

#import "Event.h"

@implementation Event

- (NSDictionary*)attributeMapDictionary{
	return @{@"title": @"title"
             ,@"time": @"createdAt"
             ,@"subTitle": @"applyNum"
             ,@"time": @"startAt"
             ,@"path": @"image"
             ,@"eventId": @"uuid"
             ,@"content": @"content"
             ,@"hasApplied": @"hasApplied"
             };
}

+ (NSArray *)getDumpData
{
    NSMutableArray *eventArray = [NSMutableArray array];
    for (int i = 0; i < 16; i++) {
        Event *event = [[Event alloc] init];
        event.title = [NSString stringWithFormat:@"Digital Village Opening Party No. %i",i];
        event.subTitle = [NSString stringWithFormat:@"参加人数： %i",i+300];
        event.time = [NSString stringWithFormat:@"2013年%i月15日 14:30",i+1];
        event.content = @"Digital Village 是一个即将改变中国数字科技行业工作模式的新兴俱乐部。在这里，您能结交更多的行业领袖和精英人士。Digital Village 是一个即将改变中国数字科技行业工作模式的新兴俱乐部。在这里，您能结交更多的行业领袖和精英人士。Digital Village 是一个即将改变中国数字科技行业工作模式的新兴俱乐部。在这里，您能结交更多的行业领袖和精英人士。<br><br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Digital Village 是一个即将改变中国数字科技行业   工作模式的新兴俱乐部。在这里，您能结交更多的行业领袖和精英人士。Digital Village 是一个即将改变中国数字科技行业工作模式的新兴俱乐部。在这里，您能结交更多的行业领袖和精英人士。";
        [eventArray addObject:event];
    }
    return eventArray;
}

+(NSDictionary *)getTableMapping
{
    //return nil
    return @{
             @"title": @"title"
             ,@"time": @"time"
             ,@"subTitle": @"subTitle"
             ,@"time": @"time"
             ,@"path": @"path"
             ,@"eventId": @"eventId"
             ,@"content": @"content"
             ,@"hasApplied": @"hasApplied"
             };
}

+(NSString *)getPrimaryKey
{
    return @"eventId";
}

+(NSString *)getTableName
{
    return @"DVEvent";
}

+(int)getTableVersion
{
    return 1;
}
@end