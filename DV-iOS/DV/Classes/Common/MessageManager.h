//
//  MessageManager.h
//  HotWord
//
//  Created by Jack on 13-5-25.
//
//

#import <Foundation/Foundation.h>
#import "ITTDataRequest.h"
#import "DVMessage.h"
#import "Message.h"
#import "Reply.h"

#define DID_REIVICE_MESSAGE         @"DID_REIVICE_MESSAGE"
#define DID_REIVICE_REPLY           @"DID_REIVICE_REPLY"

#define MESSSAGE_UPDATE_DELAY       2000000000000
#define REPLY_UPDATE_DELAY          2000000000000

#define MESSAGE_HAS_READ            @"MESSAGE_HAS_READ"
#define MESSAGE_UPDATE_TIMESTAMP    @"MESSAGE_UPDATE_TIMESTAMP"
#define ALL_MESSAGES_LIST           @"ALL_MESSAGES_LIST"
#define REPLY_UPDATE_TIMESTAMP      @"REPLY_UPDATE_TIMESTAMP"
#define ALL_REPLIES_LIST            @"ALL_REPLIES_LIST"

@interface MessageManager : NSObject<DataRequestDelegate>

@property (nonatomic, strong)NSMutableArray *messages;
@property (nonatomic, strong)NSMutableArray *replies;
@property (nonatomic, strong)NSString *talkingFriendId;

+ (MessageManager *)sharedMessageManager;

- (void)readAllMesssage;
- (void)clearMessages;
- (NSInteger)getNewMessageCount;
- (void)requestNewMessages;
- (void)requestNewReply;
- (void)readMessageWithId:(NSString *)senderId;
- (void)readReplyWithId:(NSString *)messageId;
- (void)addSendMessageToInbox:(Message *)message toNickname:(NSString *)toNickname;
+ (NSMutableArray *)filterMessages:(NSArray *)messages withNewMessage:(NSArray *)newMessages;
@end
