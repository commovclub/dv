//
//  MessageManager.m
//  HotWord
//
//  Created by Jack on 13-5-25.
//
//

#import "MessageManager.h"
#import "ITTObjectSingleton.h"
#import "Message.h"

@implementation MessageManager

- (id)init{
    self = [super init];
	if ( self) {
        _messages = [[NSMutableArray alloc] init];
        NSArray *existMessages = (NSArray *)[[DataCacheManager sharedManager] getCachedObjectByKey:ALL_MESSAGES_LIST];
        if (existMessages) {
            [_messages addObjectsFromArray:existMessages];
        }
        _replies = [[NSMutableArray alloc] init];
        NSArray *existReplies = (NSArray *)[[DataCacheManager sharedManager] getCachedObjectByKey:ALL_REPLIES_LIST];
        if (existReplies) {
            [_replies addObjectsFromArray:existReplies];
        }
	}
	return self;
}

- (void)syncMessageListWithNewMessage:(NSArray *)newMessages
{
    NSMutableArray *needUpdateMessages = [NSMutableArray array];
    NSString *maxtimestamp = (NSString *)[[DataCacheManager sharedManager] getCachedObjectByKey:MESSAGE_UPDATE_TIMESTAMP];
    for (DVMessage *message in newMessages) {
        if ([message.createdAt doubleValue] > [maxtimestamp doubleValue]) {
            maxtimestamp = message.createdAt;
        }
        for (DVMessage *existMessage in self.messages) {
//            if ([message.senderId isEqualToString:existMessage.senderId]) {
//                [needUpdateMessages addObject:existMessage];
//            }
        }
    }
    [self.messages removeObjectsInArray:needUpdateMessages];
    
    //将消息逆序放进新消息列表
    for (int i = 0; i < [newMessages count] ; i++) {
        [self.messages insertObject:[newMessages objectAtIndex:i] atIndex:0];
    }
    [[DataCacheManager sharedManager] addObject:maxtimestamp forKey:MESSAGE_UPDATE_TIMESTAMP];
    [[DataCacheManager sharedManager] addObject:self.messages forKey:ALL_MESSAGES_LIST];
    [[NSNotificationCenter defaultCenter] postNotificationName:DID_REIVICE_MESSAGE object:nil userInfo:@{@"newMessages":newMessages}];
}

- (void)syncReplyListWithNewMessage:(NSArray *)newMessages
{
    NSMutableArray *needUpdateRepies = [NSMutableArray array];
    for (Reply *reply in newMessages) {
        for (Reply *existReply in self.replies) {
            if ([reply.messageId isEqualToString:existReply.messageId]) {
                [needUpdateRepies addObject:existReply];
            }
        }
    }
    [self.replies removeObjectsInArray:needUpdateRepies];
    for (int i = 0; i < [newMessages count] ; i++) {
        [self.replies insertObject:[newMessages objectAtIndex:i] atIndex:i];
    }
    [[DataCacheManager sharedManager] addObject:self.replies forKey:ALL_REPLIES_LIST];
    //for updateNewMessageStatus
    [[NSNotificationCenter defaultCenter] postNotificationName:DID_REIVICE_MESSAGE object:nil userInfo:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:DID_REIVICE_REPLY object:nil userInfo:@{@"newRepies":newMessages}];

}


- (void)readAllMesssage
{
    for (DVMessage *message in self.messages) {
       // message.messageCount = @"0";
    }
    [[DataCacheManager sharedManager] addObject:self.messages forKey:ALL_MESSAGES_LIST];
}


- (void)readMessageWithId:(NSString *)senderId
{
    for (DVMessage *message in self.messages) {
//        if ([message.senderId isEqualToString:senderId]) {
//            message.messageCount = @"0";
//            break;
//        }
    }
    if ([self getNewMessageCount] == 0) {
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setObject:DATA_ENV.currentUser.userId forKey:@"uid"];
        NSString *timestamp = (NSString *)[[DataCacheManager sharedManager] getCachedObjectByKey:MESSAGE_UPDATE_TIMESTAMP];
        if (!timestamp) {
            timestamp = @"0";
        }
        
        [params setObject:timestamp forKey:@"time"];
        //[HTUpdateLastReadMessageDataRequest requestWithDelegate:nil withParameters:params];
    }
    [[DataCacheManager sharedManager] addObject:self.messages forKey:ALL_MESSAGES_LIST];
    [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_HAS_READ object:nil];
}

- (void)readReplyWithId:(NSString *)messageId{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:DATA_ENV.currentUser.userId forKey:@"uid"];
    [params setObject:messageId forKey:@"mid"];
    //[HTReadMessageDataRequest requestWithDelegate:nil withParameters:params];
}

- (void)addSendMessageToInbox:(Message *)message toNickname:(NSString *)toNickname
{
    DVMessage *newMessage = [[DVMessage alloc] init];
//    newMessage.senderId = message.recevierUserId;
//    newMessage.messageCount = @"0";
    //newMessage.nickname = message.dialogNickname;
    //newMessage.remarkNickname = toNickname;
    //newMessage.avatar = message.recevierAvator;
    newMessage.createdAt = [NSString stringWithFormat:@"%.0f" ,[message.timestamp doubleValue]];
    //newMessage.lastestMessage = message.content;
    //newMessage.gender = message.gender;
    [self syncMessageListWithNewMessage:[NSArray arrayWithObject:newMessage]];
    
}

- (NSInteger)getNewMessageCount
{
    NSInteger newMessageCount = 0;
    for (DVMessage *message in self.messages) {
        //newMessageCount = newMessageCount + [message.messageCount integerValue];
    }
    //check repley
    if (newMessageCount==0) {
        for (Reply *reply in _replies) {
            if ([reply.isRead isEqualToString:@"0"]) {
                newMessageCount = 1;
                break;
            }
        }

    }
    return newMessageCount;
}

- (void)requestNewMessages
{
    if (DATA_ENV.currentUser.userId) {
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        NSString *timestamp = (NSString *)[[DataCacheManager sharedManager] getCachedObjectByKey:MESSAGE_UPDATE_TIMESTAMP];
        if (!timestamp) {
            timestamp = @"0";
        }
        [params setObject:DATA_ENV.currentUser.userId forKey:@"uid"];
        [params setObject:timestamp forKey:@"lastGetTime"];
        //[HTGetChatMessageDataRequest requestWithDelegate:self withParameters:params];
    }
}

- (void)requestNewReply
{
    if (DATA_ENV.currentUser.userId) {
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setObject:DATA_ENV.currentUser.userId forKey:@"uid"];
        //[HTGetMessageDataRequest requestWithDelegate:self withParameters:params];
    }
}

- (void)requestDidFinishLoad:(ITTBaseDataRequest*)request
{
    if ([request isSuccess]) {
//        if ([request isKindOfClass:[HTGetChatMessageDataRequest class]]) {
//            NSMutableArray *messages = [request.resultDic objectForKey:@"messsages"];
//            if ([messages count] > 0) {
//                [self syncMessageListWithNewMessage:messages];
//            }
//        }else{
//            NSMutableArray *messages = [request.resultDic objectForKey:@"relies"];
//            if ([messages count] > 0) {
//                [self syncReplyListWithNewMessage:messages];
//            }
//        }
       
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:DID_REIVICE_MESSAGE object:nil userInfo:nil];
    [self performSelector:@selector(requestNewMessages) withObject:nil afterDelay:MESSSAGE_UPDATE_DELAY];
    [self performSelector:@selector(requestNewReply) withObject:nil afterDelay:REPLY_UPDATE_DELAY];
}

- (void)request:(ITTBaseDataRequest*)request didFailLoadWithError:(NSError*)error
{
    
}


+ (NSMutableArray *)filterMessages:(NSArray *)messages withNewMessage:(NSArray *)newMessages
{
    NSMutableArray *filteredMessages = [NSMutableArray array];
    for (Message *message in newMessages) {
        BOOL isFounded = NO;
        for (Message *existMessage in messages) {
            if ([existMessage.messageId isEqualToString:message.messageId]) {
                isFounded = YES;
                break;
            }
        }
        if (!isFounded){
            [filteredMessages addObject:message];
        }
    }
    return filteredMessages;
}


- (void)clearMessages
{
    [_messages removeAllObjects];
    [_replies removeAllObjects];
    [[NSNotificationCenter defaultCenter] postNotificationName:DID_REIVICE_MESSAGE object:nil userInfo:nil];
}


@end
