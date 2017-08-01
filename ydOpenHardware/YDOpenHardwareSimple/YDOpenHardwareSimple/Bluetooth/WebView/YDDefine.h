//
//  YDDefine.h
//  
//
//  Created by Aka on 2017/8/1.
//
//

#ifndef YDDefine_h
#define YDDefine_h

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, YDWebViewType) {
    YDWebViewTypeInner,
    YDWebViewTypeOuter,
    YDWebViewTypeS3,
};

#define IS_SCREEN_SIZE_1 [UIScreen mainScreen].bounds.size.height == 480
#define IS_SCREEN_SIZE_2 [UIScreen mainScreen].bounds.size.height == 568
#define IS_SCREEN_SIZE_3 [UIScreen mainScreen].bounds.size.height == 667
#define IS_SCREEN_SIZE_4 [UIScreen mainScreen].bounds.size.height >= 736
#define DEVICE_WIDTH_SCALE ([UIScreen mainScreen].bounds.size.width / 375.0)
#define DEVICE_WIDTH_SCALE_FOR_FONT (([UIScreen mainScreen].bounds.size.width / 375.0) > 1 ? 1 : ([UIScreen mainScreen].bounds.size.width / 375.0))
#define DEVICE_HEIGHT_SCALE ([UIScreen mainScreen].bounds.size.height / 667.0)
#define DEVICE_WIDTH_OF(x) round((x) * DEVICE_WIDTH_SCALE)
#define DEVICE_WIDTH_OF_FOR_FONT(x) round((x) * DEVICE_WIDTH_SCALE_FOR_FONT)
#define DEVICE_HEIGHT_OF(x) round((x) * DEVICE_HEIGHT_SCALE)
#define INDEX_PROGRESS_SCALE ([UIScreen mainScreen].bounds.size.width >= 375 ? 0.53333 : ([UIScreen mainScreen].bounds.size.height == 480 ? 0.5 : 0.6))

#define BEFORE_IOS8 [[[UIDevice currentDevice] systemVersion] floatValue] < 8
#define GE_IOS8 [[[UIDevice currentDevice] systemVersion] floatValue] >= 8
#define BEFORE_IOS9 [[[UIDevice currentDevice] systemVersion] floatValue] < 9
#define AFTER_IOS9 [[[UIDevice currentDevice] systemVersion] floatValue] >= 9
#define BEFORE_IOS10 [[[UIDevice currentDevice] systemVersion] floatValue] < 10
#define AFTER_IOS10 [[[UIDevice currentDevice] systemVersion] floatValue] >= 10

#define DEGREES_TO_RADOANS(x) (M_PI * (x) / 180.0) // 将角度转为弧度

#define YDSP_WIDTH (1.0 / [UIScreen mainScreen].scale) // separator line width

// color
#define YD_RGBA(r, g, b, a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a/1.0]
#define YD_RGB(r, g, b)     [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]
#define YD_WHITE(a)         [UIColor colorWithWhite:1.0 alpha:a]
#define YD_BLACK(a)         [UIColor colorWithWhite:0.0 alpha:a]
#define YD_GRAY(g)          [UIColor colorWithWhite:g/255.0 alpha:1.0]
#define YD_GRAYA(g, a)      [UIColor colorWithWhite:g/255.0 alpha:a]

// font
#define YDF_SYS(s)     [UIFont systemFontOfSize:s]
#define YDF_SYS_B(s)   [UIFont boldSystemFontOfSize:s]
#define YDF_SYS_FIT(s) [UIFont systemFontOfSize:DEVICE_WIDTH_OF_FOR_FONT(s)]
#define YDF_SYS_B_FIT(s) [UIFont boldSystemFontOfSize:DEVICE_WIDTH_OF_FOR_FONT(s)]
#define YDF_NUM(s)     [UIFont fontWithName:@"DIN Condensed" size:s]
#define YDF_NUM_FIT(s) [UIFont fontWithName:@"DIN Condensed" size:DEVICE_WIDTH_OF_FOR_FONT(s)]
#define YDF_CUS(n, s)  [UIFont fontWithName:n size:s]
#define YDF_CUS_FIT(n, s)  [UIFont fontWithName:n size:DEVICE_WIDTH_OF_FOR_FONT(s)]

#define YDF_DEFAULT_R(s) (BEFORE_IOS9 ? [UIFont systemFontOfSize:s] : [UIFont fontWithName:@"PingFangSC-Regular" size:s])
#define YDF_DEFAULT_M(s) (BEFORE_IOS9 ? [UIFont boldSystemFontOfSize:s] : [UIFont fontWithName:@"PingFangSC-Medium" size:s])
#define YDF_DEFAULT_B(s) (BEFORE_IOS9 ? [UIFont boldSystemFontOfSize:s] : [UIFont fontWithName:@"PingFangSC-Semibold" size:s])
#define YDF_DEFAULT_R_FIT(s) (BEFORE_IOS9 ? [UIFont systemFontOfSize:DEVICE_WIDTH_OF_FOR_FONT(s)] : [UIFont fontWithName:@"PingFangSC-Regular" size:DEVICE_WIDTH_OF_FOR_FONT(s)])
#define YDF_DEFAULT_M_FIT(s) (BEFORE_IOS9 ? [UIFont boldSystemFontOfSize:DEVICE_WIDTH_OF_FOR_FONT(s)] : [UIFont fontWithName:@"PingFangSC-Medium" size:DEVICE_WIDTH_OF_FOR_FONT(s)])
#define YDF_DEFAULT_B_FIT(s) (BEFORE_IOS9 ? [UIFont boldSystemFontOfSize:DEVICE_WIDTH_OF_FOR_FONT(s)] : [UIFont fontWithName:@"PingFangSC-Semibold" size:DEVICE_WIDTH_OF_FOR_FONT(s)])


#define SuppressPerformSelectorLeakWarning(Stuff) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
Stuff; \
_Pragma("clang diagnostic pop") \
} while (0)

typedef enum _BasicViewControllerInfo {
    eBasicControllerInfo_Title,
    eBasicControllerInfo_ImageName,
    eBasicControllerInfo_BadgeString
}BasicViewControllerInfo;

#pragma mark - runtime macros
// check if runs on iPad
#define IS_IPAD_RUNTIME (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

// version check
#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:       NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:       NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:       NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:       NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:       NSNumericSearch] != NSOrderedDescending)

#define NTF_WILLSENDMESSAGETOJID                @"NTF_WILLSENDMESSAGETOJID"
#define WILLSENDMESSAGETOJID                    @"WILLSENDMESSAGETOJID"
#define WILLSENDMESSAGETOJID_CHATROOMMESSAGE    @"WILLSENDMESSAGETOJID_CHATROOMMESSAGE"
#define WILLSENDMESSAGETOJID_CHATDATA           @"WILLSENDMESSAGETOJID_CHATDATA"

#define NTF_FINISHED_LOAD_DATA_FROM_DB  @"NTF_FINISHED_LOAD_DATA_FROM_DB"

// used in settings.
typedef enum _playSoundMode {
    ePlaySoundMode_AutoDetect,
    ePlaySoundMode_Speaker,
    ePlaySoundMode_Handset
}PlaySoundMode;

// exception macros
#define NOT_IMPLEMENTED_EXCEPTION   @"NOT_IMPLEMENTED_EXCEPTION"

typedef NS_ENUM(NSInteger, YDViewAlign) {
    YDViewAlignUnknow,
    YDViewAlignTop,
    YDViewAlignLeft,
    YDViewAlignBottom,
    YDViewAlignRight,
    YDViewAlignBothVertical,
    YDViewAlignBothHorizontal,
    YDViewAlignTopLeft,
    YDViewAlignTopRight,
    YDViewAlignLeftTop,
    YDViewAlignLeftBottom,
    YDViewAlignBottomLeft,
    YDViewAlignBottomRight,
    YDViewAlignRightTop,
    YDViewAlignRightBottom,
};

typedef NS_ENUM(NSInteger, YDLiveType) {
    YDLiveTypeUnknown = -1,
    YDLiveTypeWatcher = 0,
    YDLiveTypePlayback,
    YDLiveTypePlayer
};
//获取列表的类型
typedef NS_ENUM(NSInteger, YDLiveFilterType) {
    YDLiveFilterTypeAll,
    YDLiveFilterTypeLive,
    YDLiveFilterTypePlayBack,
};
//操作房间类型
typedef NS_ENUM(NSInteger, YDLiveRoomOperType) {
    YDLiveRoomOperTypeCreate,
    YDLiveRoomOperTypeClose,
    YDLiveRoomOperTypeEnter,
    YDLiveRoomOperTypeExit,
    YDLiveRoomOperTypeLeft,
    YDLiveRoomOperTypeBack,
};
//操作动态类型
typedef NS_ENUM(NSInteger, YDLiveDynamicOperType) {
    YDLiveDynamicOperTypeAdd,
    YDLiveDynamicOperTypeLike,
};
//礼物类型
typedef NS_ENUM(NSInteger, YDLiveGiftOperType) {
    YDLiveGiftOperTypeGive,
    YDLiveGiftOperTypeGet,
};
//收发红包
typedef NS_ENUM(NSInteger, YDLiveRewarOperType) {
    YDLiveRewarOperTypeAdd,
    YDLiveRewarOperTypeDraw,
};
//悦豆操作类型
typedef NS_ENUM(NSInteger, YDLiveYueDouOperType) {
    YDLiveYueDouOperTypePay,
    YDLiveYueDouOperTypeDraw,
    YDLiveYueDouOperTypeGet,
};
//悦豆详情类型
typedef NS_ENUM(NSInteger, YDLiveYueDouDetailType) {
    YDLiveYueDouDetailTypeDraw,
    YDLiveYueDouDetailTypeList,
};
//webSocket userType
typedef NS_ENUM(NSInteger, YDLiveSocketUserType) {
    YDLiveSocketUserTypeVisitor,
    YDLiveSocketUserTypePlayer,
    YDLiveSocketUserTypeRoomManager,
    YDLiveSocketUserTypeSystem,
};
typedef NS_ENUM(NSInteger, YDLiveRoomMessageType) {
    YDLiveRoomMessageTypeChat = 1,
    YDLiveRoomMessageTypeGift,
    YDLiveRoomMessageTypeReward,
    YDLiveRoomMessageTypeEnter,
    YDLiveRoomMessageTypeExit,
    YDLiveRoomMessageTypeShare,
    YDLiveRoomMessageTypeLike,
    YDLiveRoomMessageTypeEnd,  //直播结束
    YDLiveRoomMessageTypeLeave, //暂时离开
    YDLiveRoomMessageTypeBack,
};
typedef NS_ENUM(NSInteger, YDLiveTalkType) {
    YDLiveTalkTypeTalk,
    YDLiveTalkTypeShut,
};
typedef NS_ENUM(NSInteger, YDApplePayCode) {
    YDApplePayCodeSuccess = 0,
    YDApplePayCodeNotPay = -1,
    YDApplePayCodePayedNotValidate = - 2,
    YDApplePayCodeGetProductsFail = -3
};

typedef NS_ENUM(NSInteger, YDModCheckStatus) {
    YDModCheckStatusSuccess,
    YDModCheckStatusFail,
    YDModCheckStatusNotModified,
};

typedef NS_ENUM(NSInteger, YDAdType) {
    YDAdTypeIndexHead,
    YDAdTypeIndexTail,
    YDAdTypeCircleFlow,
};

typedef NS_ENUM(NSInteger, YDFriendRecommendType) {
    YDFriendRecommendTypeAddFollow,
    YDFriendRecommendTypeFollowed,
    YDFriendRecommendTypeFollowedEachOther,
    YDFriendRecommendTypeInvite,
};

typedef NS_ENUM(NSInteger, YDFriendUserType) {
    YDFriendUserTypeNormal,
    YDFriendUserTypeContact,
    YDFriendUserTypeQQ,
};

typedef NS_ENUM(NSInteger, YDFriendGetType) {
    YDFriendGetTypeFriend,
    YDFriendGetTypeConcern,
    YDFriendGetTypeFans,
};
typedef NS_ENUM(NSInteger, YDSharedMobikeType) {
    YDSharedMobikeTypeNone,
    YDSharedMobikeTypeMobike,
};
typedef NS_ENUM(NSInteger, YDVerifyPhoneType) {
    YDVerifyPhoneTypeDefault,
    YDVerifyPhoneTypeMobike,
};

typedef NS_ENUM(NSInteger, YDMobikeUserStatus) {
    YDMobikeUserStatusNormal = 0,
    YDMobikeUserStatusWaitPayDeposit = 2,
    YDMobikeUserStatusWaitRealNameAuth = 3,
};


typedef NS_ENUM(NSInteger, YDTagUserOperType) {
    YDTagUserOperTypeCreate,
    YDTagUserOperTypeDelete,
    YDTagUserOperTypeReplace,
};
typedef NS_ENUM(NSInteger, YDUserHeadOperType) {
    YDUserHeadOperTypeSetDefault,
    YDUserHeadOperTypeDelete,
    YDUserHeadOperTypeSetBgImage,
    YDUserHeadOperTypeAdd,
};
typedef NS_ENUM(NSInteger, YDParentControlType) {
    YDParentControlTypeDiscover,
    YDParentControlTypeCircle,
};
typedef NS_ENUM(NSInteger, YDMapUseType) {
    YDMapUseTypeLocation = 0,
    YDMapUseTypeReview,
    YDMapUseTypeTreasure,
    YDMapUseTypePrepareLocation
};
typedef NS_ENUM(NSInteger, YDLastLoginType) {
    YDLastLoginTypeNone = -1,
    YDLastLoginTypePhone,
    YDLastLoginTypeQQ,
    YDLastLoginTypeWx,
    
};
typedef NS_ENUM(NSInteger, YDSportType) {
    YDSportTypeOutSideRunNormal = 0, //室外跑
    YDSportTypeIndoorRunNormal = 1, //室内跑
    YDSportTypeCycleRunNormal = 3, //骑行
    YDSportTypeStep = 4, //记步
    YDSportTypeFitness = 5, // 健身课程
    YDSportTypeGym, // 健身房
    YDSportTypeRun
};

#define YDC_G     YD_RGBA( 17, 213, 156, 1.0) //YD_RGBA( 28, 192,  25, 1.0) // YD theme green normal
#define YDC_HG    YD_RGB( 17, 200, 144) //YD_RGB( 36, 168, 34) //YD theme green highlight
#define YDC_G2     YD_RGBA( 17, 213, 156, 1.0) // YD theme green normal
#define YDC_HG2    YD_RGBA( 17, 213, 156, .5) //YD theme green highlight
#define YDC_GA(a) YD_RGBA( 28, 192,  25, a) // YD theme green normal
#define YDC_BG    YD_RGBA(245, 245, 245, 1.0) // background gray
#define YDC_SP    YD_RGBA(229, 229, 229, 1.0) // separator line color
#define YDC_NAV   YD_RGBA(255, 255, 255, 1.0) // nav bar gray color
#define YDC_NAV_TINT   YD_RGBA(51, 51, 51, 1.0) // nav bar gray color
#define YDC_NAV_TINT_H   YD_RGBA(51, 51, 51, .3) // nav bar gray color
#define YDC_NAV_TINT_NORMAL   YD_RGBA(102, 102, 102, 1) // nav bar gray color
#define YDC_NAV_TINT_NORMAL_H   YD_RGBA(102, 102, 102, .3) // nav bar gray color
#define YDC_NAV_TINT_WEAK   YD_RGBA(153, 153, 153, 1) // nav bar gray color
#define YDC_TITLE YD_RGBA( 51,  51,  51, 1.0) // title text color
#define YDC_TITLE_A(a) YD_RGBA( 51,  51,  51, a) // title text color
#define YDC_TEXT  YD_RGBA(153, 153, 153, 1.0) // content text color
#define YDC_TEXT_A(a)  YD_RGBA(79, 73, 87, a) // content text color

#define YDC_PREV_G     YD_RGBA( 28, 192,  25, 1.0) // // YD theme green normal
#define YDC_PREV_HG    YD_RGB( 36, 168, 34) // //YD theme green highlight


#pragma mark - common

static NSString *const YDThemeDefault = @"default";
static const NSTimeInterval YDThemeAnimationDuration = 0.5f;
// font
static NSString *const YDFontDin            = @"DIN Condensed";
static NSString *const YDFontPFangRegular    = @"PingFangSC-Regular";
static NSString *const YDFontPFangMedium    = @"PingFangSC-Medium";
static NSString *const YDFontPFangSemibold  = @"PingFangSC-Semibold";

static const float YDFontSizeNav = 18.0; // 导航栏标题字体大小

// length
static const CGFloat YDStatusBarH = 20.0; // 状态栏默认高度
static const CGFloat YDNavBarH    = 44.0; // 导航栏默认高度
static const CGFloat YDTopLayoutH = 64.0; // 导航栏＋状态栏高度
static const CGFloat YDTabBarH    = 49.0; // Tabbar 默认高度
static const CGFloat YDCellH50    = 50.0; // TableViewCell 默认高度
static const CGFloat YDCellH55    = 55.0;
static const CGFloat YDSectionH10 = 10.0; //TableView 节头默认高度
static const CGFloat YDBtnH44     = 44.0;
static const CGFloat YDCtrlH40    = 40.0;

#endif /* YDDefine_h */
