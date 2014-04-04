//
//  News.h
//  DV
//
//  Created by Zhao Zhicheng on 1/3/14.
//
//
/*
 /info/list
 参数:
 页码：pageNumber, 默认值 1
 条数：pageSize, 默认值10
 结果：新闻列表数组
 结果中每一条新闻字段如下：
 id：	数字编号
 uuid：唯一ID
 title：标题
 summary：内容摘要
 images：缩略图url数组
 publishedAt：发布时间
 
 
 /info/{uuid}
 参数:
 uuid：唯一ID
 结果：一条新闻信息，字段如下：
 uuid：唯一ID
 title：标题
 content：内容正文
 publishedAt：发布时间
 */

#import <Foundation/Foundation.h>
#import "ITTBaseModelObject.h"
#import "NSObject+RMArchivable.h"
#import "LKDBHelper.h"

@interface News : ITTBaseModelObject
@property (nonatomic, strong)NSString *title;
@property (nonatomic, strong)NSString *summary;
@property (nonatomic, strong)NSString *content;
@property (nonatomic, strong)NSString *time;
@property (nonatomic, strong)NSString *path1;
@property (nonatomic, strong)NSString *path2;
@property (nonatomic, strong)NSString *path3;
@property (nonatomic, strong)NSString *type;
@property (nonatomic, strong)NSString *newsId;
@property (nonatomic, strong)NSString *image;
@property (nonatomic, strong)NSMutableArray *images;
@property (nonatomic)BOOL isFavorite;

@end
