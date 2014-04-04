//
//  Contact.m
//  DV
//
//  Created by Zhao Zhicheng on 1/3/14.
//
//

#import "Contact.h"

@implementation Contact
    //TODO
- (NSDictionary*)attributeMapDictionary{
	return @{@"name": @"realname"
             ,@"desc": @"description"
             ,@"contactId":@"uuid"
             ,@"username":@"username"
             ,@"career":@"title"
             ,@"weixin":@"weixin"
             ,@"qq":@"qq"
             ,@"phone":@"phone"
             ,@"province":@"province"
             ,@"city":@"city"
             ,@"address":@"address"
             ,@"gender":@"gender"//man woman
             ,@"category":@"category"
             ,@"tag":@"tags"
             ,@"path":@"image"
             ,@"avatar":@"avatar"
             ,@"hasFollowed":@"hasFollowed"
             };
}
    
+ (NSMutableArray *)getDumpData
    {
        
        NSMutableArray *_dataArr = [[NSMutableArray alloc] init];
        
        //add test data
        [_dataArr addObject:@"郭靖"];
        [_dataArr addObject:@"黄蓉"];
        [_dataArr addObject:@"杨过"];
        [_dataArr addObject:@"苗若兰"];
        [_dataArr addObject:@"令狐冲"];
        [_dataArr addObject:@"小龙女"];
        [_dataArr addObject:@"胡斐"];
        [_dataArr addObject:@"水笙"];
        [_dataArr addObject:@"任盈盈"];
        [_dataArr addObject:@"白琇"];
        [_dataArr addObject:@"狄云"];
        [_dataArr addObject:@"石破天"];
        [_dataArr addObject:@"殷素素"];
        [_dataArr addObject:@"张翠山"];
        [_dataArr addObject:@"张无忌"];
        [_dataArr addObject:@"青青"];
        [_dataArr addObject:@"袁冠南"];
        [_dataArr addObject:@"萧中慧"];
        [_dataArr addObject:@"袁承志"];
        [_dataArr addObject:@"乔峰"];
        [_dataArr addObject:@"王语嫣"];
        [_dataArr addObject:@"段玉"];
        [_dataArr addObject:@"虚竹"];
        [_dataArr addObject:@"苏星河"];
        [_dataArr addObject:@"丁春秋"];
        [_dataArr addObject:@"庄聚贤"];
        [_dataArr addObject:@"阿紫"];
        [_dataArr addObject:@"阿朱"];
        [_dataArr addObject:@"阿碧"];
        [_dataArr addObject:@"鸠魔智"];
        [_dataArr addObject:@"萧远山"];
        [_dataArr addObject:@"慕容复"];
        [_dataArr addObject:@"慕容博"];
        [_dataArr addObject:@"Jim"];
        [_dataArr addObject:@"Lily"];
        [_dataArr addObject:@"Ethan"];
        [_dataArr addObject:@"DavidSmall"];
        [_dataArr addObject:@"DavidBig"];
        [_dataArr addObject:@"James"];
        [_dataArr addObject:@"Kobe Brand"];
        [_dataArr addObject:@"Kobe Crand"];
        
        NSMutableArray *contactArray = [NSMutableArray array];
        for (int i = 0; i < [_dataArr count]; i++) {
            Contact *contact = [[Contact alloc] init];
            contact.name = [_dataArr objectAtIndex:i];
            contact.desc = [NSString stringWithFormat:@"软件工程师，曾就职于xxx%i 现就职于某某软件公司",i];
            contact.location = contact.desc;
            if (i%5 == 0) {
                contact.category = @"数字";
            }else if (i%5 == 1){
                contact.category = @"科技";
            }else if (i%5 == 2){
                contact.category = @"数字";
            }else if (i%5 == 3){
                contact.category = @"科技";
            }else if (i%5 == 4){
                contact.category = @"数字,科技";
            }
            if (i%2==1) {
                contact.gender = @"男";
            }else{
                contact.gender = @"女";
            }
            contact.location = @"北京市 朝阳区";
            contact.birthday = @"1975-06-07";
            contact.career = @"软件工程师";
            contact.qq = @"123456";
            contact.weixin = @"commov";
            NSMutableArray *tempArray = [NSMutableArray array];
            [tempArray addObject:@"java"];
            [tempArray addObject:@"iOS"];
            [tempArray addObject:@"Android"];
            [tempArray addObject:@"Oracle"];
            [tempArray addObject:@"tag1"];
            [tempArray addObject:@"tag2"];
            [tempArray addObject:@"tag3"];
            [tempArray addObject:@"test tag"];
            contact.tags = tempArray;
            tempArray = [NSMutableArray array];
            [tempArray addObject:@"13412345678"];
            [tempArray addObject:@"010-12345678"];
            [tempArray addObject:@"010-88888888"];
            contact.tels = tempArray;
            [contactArray addObject:contact];
        }
        
        return contactArray;
    }
    
    - (void)copyFromContact:(Contact *)contact
    {
        self.contactId=contact.contactId;
        self.name=contact.name;
        self.path=contact.path;
        self.desc=contact.desc;
        self.type=contact.type;
        self.location=contact.location;
        self.category=contact.category;
        self.pinYin=contact.pinYin;
        self.isFavorite=contact.isFavorite;
    }
    
    @end
