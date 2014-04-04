//
//  News.m
//  DV
//
//  Created by Zhao Zhicheng on 1/3/14.
//
//

#import "News.h"

@implementation News

- (NSDictionary*)attributeMapDictionary{
	return @{ @"title": @"title"
             ,@"summary": @"summary"
             ,@"content": @"content"
             ,@"time": @"createdAt"
             ,@"path1": @"path1"
             ,@"path2": @"path2"
             ,@"path3": @"path3"
             ,@"type": @"infoType"
             ,@"newsId": @"uuid"
             ,@"images": @"images"
             ,@"image": @"image"

             };
}

+ (NSArray *)getDumpData
{
    NSMutableArray *newsArray = [NSMutableArray array];
    for (int i = 0; i < 12; i++) {
        News *news = [[News alloc] init];
        news.title = [NSString stringWithFormat:@"Digital Village 于1月17日举行了声势浩大的Opening Party ： %i",i];
        news.time = [NSString stringWithFormat:@"2013年%i月15日 14:30",i+1];
        if (i%3==0) {
            news.type = @"1";
        }else if (i%3==1) {
            news.type = @"0";
            news.content = @"据央视新闻网报道，COMMOV于1月17日举行了隆重的Opening Party。众多数字界与科技界的大腕级人物出席";
        }else if (i%3==2) {
            news.type = @"3";
        }
        news.content = @" <img src=\"http://www.baidu.com/img/bdlogo.gif\"/><br><Br><br>Digital Village 是一个即将改变中国数字科技行业工作模式的新兴俱乐部。在这里，您能结交更多的行业领袖和精英人士。Digital Village 是一个即将改变中国数字科技行业工作模式的新兴俱乐部。在这里，您能结交更多的行业领袖和精英人士。Digital Village 是一个即将改变中国数字科技行业工作模式的新兴俱乐部。在这里，您能结交更多的行业领袖和精英人士。<br><br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Digital Village 是一个即将改变中国数字科技行业   工作模式的新兴俱乐部。在这里，您能结交更多的行业领袖和精英人士。Digital Village 是一个即将改变中国数字科技行业工作模式的新兴俱乐部。在这里，您能结交更多的行业领袖和精英人士。<Br><Br><Br><Br><font color=red>Create Together<font>";
        [newsArray addObject:news];
    }
    return newsArray;
}

+(NSDictionary *)getTableMapping
{
    //return nil
    return @{
             @"title": @"title"
             ,@"summary": @"summary"
             ,@"type": @"type"
             ,@"content": @"content"
             ,@"time": @"time"
             ,@"path1": @"path1"
             ,@"path2": @"path2"
             ,@"path3": @"path3"
             ,@"newsId": @"newsId"
             ,@"images": @"images"
             };
}

+(NSString *)getPrimaryKey
{
    return @"newsId";
}

+(NSString *)getTableName
{
    return @"News";
}

+(int)getTableVersion
{
    return 1;
}

@end
