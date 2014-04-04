//
//  Contact.h
//  DV
//
//  Created by Zhao Zhicheng on 1/3/14.
//
//

#import <Foundation/Foundation.h>
#import "ITTBaseModelObject.h"
#import "NSObject+RMArchivable.h"

@interface Contact : ITTBaseModelObject
@property (nonatomic, strong)NSString *contactId;
@property (nonatomic, strong)NSString *name;
@property (nonatomic, strong)NSString *username;
@property (nonatomic, strong)NSString *gender;
@property (nonatomic, strong)NSString *birthday;
@property (nonatomic, strong)NSString *province;
@property (nonatomic, strong)NSString *city;
@property (nonatomic, strong)NSString *address;

@property (nonatomic, strong)NSString *location;
@property (nonatomic, strong)NSString *career;
@property (nonatomic, strong)NSString *history;
@property (nonatomic, strong)NSString *tag;
@property (nonatomic, strong)NSArray *tags;
//联系
@property (nonatomic, strong)NSString *qq;
@property (nonatomic, strong)NSString *phone;
@property (nonatomic, strong)NSArray *tels;
@property (nonatomic, strong)NSString *weixin;
@property (nonatomic, strong)NSString *avatar;
@property (nonatomic, strong)NSString *desc;
@property (nonatomic, strong)NSString *path;
@property (nonatomic, strong)NSString *type;
@property (nonatomic, strong)NSString *category;
@property (nonatomic, strong)NSString *pinYin;
@property (nonatomic, strong)NSString *hasFollowed;
@property (nonatomic)BOOL isFavorite;
//@property (nonatomic)BOOL isFollow;

- (void)copyFromContact:(Contact *)contact;
@end
