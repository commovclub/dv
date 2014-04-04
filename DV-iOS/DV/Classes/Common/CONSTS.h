//
//  CONSTS.h


#import "ITTSideBarViewController.h"
#import "HTActivityIndicator.h"
#import "AppDelegate.h"
#import "NSUserDefaults+RMSaveCustomObject.h"

//#define REQUEST_DOMAIN @"http://10.0.0.2:80/dv/api/" // default env
#define REQUEST_DOMAIN @"http://www.danaaa.com/dv/api/" // default env
#define is4InchScreen() ([UIScreen mainScreen].bounds.size.height == 568)
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
//text
#define TEXT_LOAD_MORE_NORMAL_STATE @"向上拉动加载更多..."
#define TEXT_LOAD_MORE_LOADING_STATE @"更多数据加载中..."

#define LIST_PAGE_COUNT 10

//other consts
typedef enum{
	kTagWindowIndicatorView = 501,
	kTagWindowIndicator,
} WindowSubViewTag;

typedef enum{
    kTagHintView = 101
} HintViewTag;

typedef enum
{
    ProfileInfoSelectTypeNickname = 0,
    ProfileInfoSelectTypeSex,
    ProfileInfoSelectTypeAge,
    ProfileInfoSelectTypeCity,
    ProfileInfoSelectTypeCareer,
    ProfileInfoSelectTypeFilter,
    ProfileInfoSelectTypeDesc,
    ProfileInfoSelectTypeHistory,
    ProfileInfoSelectTypeTags,

    ProfileInfoSelectTypeQQ,
    ProfileInfoSelectTypeTel,
    ProfileInfoSelectTypeWeixin,
    
    ProfileInfoSelectTypeIdentity,
    ProfileInfoSelectTypeExam,
    ProfileInfoSelectTypeTeachSection,
    ProfileInfoSelectTypeApplyYear,
   
    ProfileInfoSelectTypeSchool,
    ProfileInfoSelectTypeCompany,
    ProfileInfoSelectTypeIntroduce
    
}ProfileInfoSelectType;


typedef enum
{
    HTSchoolTypeZH = 0,
    HTSchoolTypeWL
}HTSchoolType;


//全局按钮颜色
#define BTN_GREEN_COLOR         [UIColor colorWithRed:0.0/255.0 green:170.0/255.0 blue:170.0/255.0 alpha:1]
#define BTN_LIGHT_GREEN_COLOR         [UIColor colorWithRed:170.0/255.0 green:236.0/255.0 blue:217.0/255.0 alpha:1]
#define BTN_GRAY_COLOR   [UIColor colorWithRed:179.0/255.0 green:179.0/255.0 blue:179.0/255.0 alpha:1]
#define BTN_LIGHT_GRAY_COLOR   [UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:230.0/255.0 alpha:1]
#define BTN_YELLOW_COLOR   [UIColor colorWithRed:255.0/255.0 green:235.0/255.0 blue:189.0/255.0 alpha:1]

//全局字体
#define FONT_BIG        [UIFont boldSystemFontOfSize:16]
#define FONT_MIDDLE     [UIFont systemFontOfSize:14]
#define FONT_SMALL      [UIFont systemFontOfSize:12]

//图片剪接尺寸
#define UPLOAD_IMAGE_WIDTH  400
#define UPLOAD_IMAGE_HEIGHT 400

#define APNS_TOKEN        @"APNS_TOKEN"
#define USERDEFAULT_LOGIN_USER          @"USERDEFAULT_LOGIN_USER"

#define TENCENT_APP_ID    @"100465420"  // 100712191

#define SINA_APP_KEY @"243926214"
#define SINA_SERCET  @"49749b93ae60505d923940574b0b0687"
#define SINA_CALLBACK    @""
#define UMENG_APPKEY @"530c913356240bfac8039df1"

//推荐联盟
#define WHOLE_VERSION_RECOMMEND_APPS    @"WHOLE_VERSION_RECOMMEND_APPS"
#define UPDATE_RECOMMEND_APPS           @"UPDATE_RECOMMEND_APPS"
#define RECOMMEND_APPS                  @"RECOMMEND_APPS"