//
//  EventDetail.m
//  DV
//
//  Created by Zhao Zhicheng on 2/23/14.
//
//

#import "EventDetail.h"
#import "DVFile.h"
@implementation EventDetail
//TODO
- (NSDictionary*)attributeMapDictionary{
	return @{@"title": @"title"
             ,@"time": @"time"};
}

+ (EventDetail *)getDumpData
{
    
    EventDetail *eventDetail = [[EventDetail alloc] init];
    eventDetail.content = @"       Digital Village 是一个即将改变中国数字科技行业工作模式的新兴俱乐部。在这里，您能结交更多的行业领袖和精英人士。Digital Village 是一个即将改变中国数字科技行业工作模式的新兴俱乐部。在这里，您能结交更多的行业领袖和精英人士。Digital Village 是一个即将改变中国数字科技行业工作模式的新兴俱乐部。在这里，您能结交更多的行业领袖和精英人士。Digital Village 是一个即将改变中国数字科技行业\n       工作模式的新兴俱乐部。在这里，您能结交更多的行业领袖和精英人士。Digital Village 是一个即将改变中国数字科技行业工作模式的新兴俱乐部。在这里，您能结交更多的行业领袖和精英人士。\n       工作模式的新兴俱乐部。在这里，您能结交更多的行业领袖和精英人士。Digital Village 是一个即将改变中国数字科技行业工作模式的新兴俱乐部。在这里，您能结交更多的行业领袖和精英人士。";
    eventDetail.name = @"David Zhang";
    //eventDetail.path = @"张玮";
    eventDetail.desc = @"David is the CEO of Commov. He is a good guy and has many experience in Digital and Technology area.He is a good guy and has many experiement in Digital and Technology area.Digital Village 是一个即将改变中国数字科技行业工作模式的新兴俱乐部。在这里，您能结交更多的行业领袖和精英人士。";
    eventDetail.fileArray = [[NSMutableArray alloc] init];
    eventDetail.videoArray = [[NSMutableArray alloc] init];
    eventDetail.picArray = [[NSMutableArray alloc] init];

    for (int i = 0; i < 5; i++) {
        DVFile *file = [[DVFile alloc] init];
        file.name = [NSString stringWithFormat:@"活动资料 %i",i+1];
        file.path = [NSString stringWithFormat:@"？？？？ %i",i+1];
        [eventDetail.fileArray addObject:file];
        file = [[DVFile alloc] init];
        file.name = [NSString stringWithFormat:@"活动视频 %i",i+1];
        [eventDetail.videoArray addObject:file];
        file = [[DVFile alloc] init];
        file.name = [NSString stringWithFormat:@"活动图片 %i",i+1];
        [eventDetail.picArray addObject:file];
    }
    return eventDetail;
}

@end
