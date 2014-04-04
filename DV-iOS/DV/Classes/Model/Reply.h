//
//  Reply.h
//  
//
//  Created by zzc on 10/25/13.
//
//

#import "ITTBaseDataRequest.h"
//回帖
@interface Reply : ITTBaseModelObject
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *content;
//1: 问题被回答
//2: 答案被评论
//3: 答案评论被评论
//4: 吐槽被评论
//5: 吐槽评论被评论
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *replyId;
//是否读过(0:否 1:是)
@property (nonatomic, strong) NSString *isRead;
@property (nonatomic, strong) NSString *messageId;

@end
