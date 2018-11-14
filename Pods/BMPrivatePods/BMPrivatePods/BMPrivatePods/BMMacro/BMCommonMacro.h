//
//  BMCommonMacro.h
//  BMPrivatePods
//
//  Created by BirdMichael on 2018/9/21.
//

#ifndef BMCommonMacro_h
#define BMCommonMacro_h

#pragma mark ——— 文件沙盒路径

#define kBMPATH_OF_APP_HOME    NSHomeDirectory()
#define kBMPATH_OF_TEMP        NSTemporaryDirectory()
#define kBMPATH_OF_DOCUMENT    [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]



#pragma mark - Frame ( x, y, width, height)

// App Frame
#define kBMApplication_Frame       [[UIScreen mainScreen] applicationFrame]
#define kBMApp_Frame_Height        [[UIScreen mainScreen] applicationFrame].size.height
#define kBMApp_Frame_Width         [[UIScreen mainScreen] applicationFrame].size.width

//MainScreen Height&Width
#define kBMSCREEN_WIDTH    [[UIScreen mainScreen] bounds].size.width
#define kBMSCREEN_HEIGHT   [[UIScreen mainScreen] bounds].size.height

//Appdelegate
#define kBMAppDelegate     (AppDelegate *)[[UIApplication sharedApplication] delegate]
#define kBMFileManager [NSFileManager defaultManager]
#define kBMUserDefaults   [NSUserDefaults standardUserDefaults]
#define kBMUserDefaultsGET(KEY)     [[NSUserDefaults standardUserDefaults]objectForKey:KEY]
#define kBMUserDefaultsSET(VALUE,KEY)  [[NSUserDefaults standardUserDefaults] setObject:VALUE forKey:KEY]
#define kBMUserDefaultsSYN [[NSUserDefaults standardUserDefaults] synchronize]
#define BM_NOTIF_CENTER [NSNotificationCenter defaultCenter]
#define kBMWindow         [[UIApplication sharedApplication] keyWindow]


// View 坐标(x,y)和宽高(width,height)
#define BM_X(v)                    (v).frame.origin.x
#define BM_Y(v)                    (v).frame.origin.y
#define BM_WIDTH(v)                (v).frame.size.width
#define BM_HEIGHT(v)               (v).frame.size.height

#define BM_MinX(v)                 CGRectGetMinX((v).frame)
#define BM_MinY(v)                 CGRectGetMinY((v).frame)
#define BM_MidX(v)                 CGRectGetMidX((v).frame)
#define BM_MidY(v)                 CGRectGetMidY((v).frame)
#define BM_MaxX(v)                 CGRectGetMaxX((v).frame)
#define BM_MaxY(v)                 CGRectGetMaxY((v).frame)

// 适配宽度，已经取整适配宽度
#define BM_FitW(value)          ((value)/750.0f*[UIScreen mainScreen].bounds.size.width)
#define BM_FitCeilW(value)      ceil(((value)/750.0f*[UIScreen mainScreen].bounds.size.width))

// ios11 safeArea
#define kBMStatusBarHeight [[UIApplication sharedApplication] statusBarFrame].size.height
#define kBMNavBarHeight 44.0
#define kBMTabBarHeight ([[UIApplication sharedApplication] statusBarFrame].size.height>20?83:49)
#define kBMTopHeight (kBMStatusBarHeight + kBMNavBarHeight)
#define kMSafeBottomHeight (BM_IS_IPHONEX ? 34 : 0)

// some_height
#define kBMEnglishKeyboardHeight  (216.f)
#define kBMChineseKeyboardHeight  (252.f)

#pragma mark - UI
// 字体大小
#define BM_S_FONT(FONTSIZE)    [UIFont systemFontOfSize:FONTSIZE]
#define BM_S_BOLD_FONT(FONTSIZE)   [UIFont boldSystemFontOfSize:FONTSIZE]

// 颜色(RGB，随机色)
#define BM_RGB(r,g,b)  [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1];
#define BM_RGBA(r,g,b,a)   [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]
#define BM_HEX_RGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define BM_HEX_RGBA(rgbValue,a) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:(a)]
#define BM_RADNDOM_RGB [UIColor colorWithRed:arc4random_uniform(256) / 255.0 green:arc4random_uniform(256) / 255.0 blue:arc4random_uniform(256) / 255.0 alpha:1]

#define BMViewRadius(View, Radius)\
\
[View.layer setCornerRadius:(Radius)];\
[View.layer setMasksToBounds:YES]

#define RandomColor [UIColor colorWithRed:arc4random_uniform(256) / 255.0 green:arc4random_uniform(256) / 255.0 blue:arc4random_uniform(256) / 255.0 alpha:1]


// 快速字体
#define BM_H30 [UIFont systemFontOfSize:30]
#define BM_H29 [UIFont systemFontOfSize:29]
#define BM_H28 [UIFont systemFontOfSize:28]
#define BM_H27 [UIFont systemFontOfSize:27]
#define BM_H26 [UIFont systemFontOfSize:26]
#define BM_H25 [UIFont systemFontOfSize:25]
#define BM_H24 [UIFont systemFontOfSize:24]
#define BM_H23 [UIFont systemFontOfSize:23]
#define BM_H22 [UIFont systemFontOfSize:22]
#define BM_H20 [UIFont systemFontOfSize:20]
#define BM_H19 [UIFont systemFontOfSize:19]
#define BM_H18 [UIFont systemFontOfSize:18]
#define BM_H17 [UIFont systemFontOfSize:17]
#define BM_H16 [UIFont systemFontOfSize:16]
#define BM_H15 [UIFont systemFontOfSize:15]
#define BM_H14 [UIFont systemFontOfSize:14]
#define BM_H13 [UIFont systemFontOfSize:13]
#define BM_H12 [UIFont systemFontOfSize:12]
#define BM_H11 [UIFont systemFontOfSize:11]
#define BM_H10 [UIFont systemFontOfSize:10]
#define BM_H8 [UIFont systemFontOfSize:8]
///粗体
#define BM_HB30 [UIFont boldSystemFontOfSize:30]
#define BM_HB20 [UIFont boldSystemFontOfSize:20]
#define BM_HB19 [UIFont boldSystemFontOfSize:19]
#define BM_HB18 [UIFont boldSystemFontOfSize:18]
#define BM_HB17 [UIFont boldSystemFontOfSize:17]
#define BM_HB16 [UIFont boldSystemFontOfSize:16]
#define BM_HB15 [UIFont boldSystemFontOfSize:15]
#define BM_HB14 [UIFont boldSystemFontOfSize:14]
#define BM_HB13 [UIFont boldSystemFontOfSize:13]
#define BM_HB12 [UIFont boldSystemFontOfSize:12]
#define BM_HB11 [UIFont boldSystemFontOfSize:11]
#define BM_HB10 [UIFont boldSystemFontOfSize:10]
#define BM_HB8 [UIFont boldSystemFontOfSize:8]


#pragma mark ——— APP及设备相关

#define BMiOS11Later ([UIDevice currentDevice].systemVersion.floatValue >= 11.0f)
#define BMiOS11Later ([UIDevice currentDevice].systemVersion.floatValue >= 11.0f)
#define BMiOS9Later ([UIDevice currentDevice].systemVersion.floatValue >= 9.0f)
#define BM_IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define BM_IS_IPHONEX  ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)


#define BM_SYSTEM_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]
#define BM_APP_VERSION  [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
#define BM_APP_DISPLAY_NAME  [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"]
#define BM_APP_BUNDLE_ID  [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleIdentifier"]

#pragma mark ——— 数据 类型
#define BM_Is_Empty_Sty(_ref)    (((_ref) == nil) || ([(_ref) isEqual:[NSNull null]]) ||([(_ref)isEqualToString:@""]))
#define BM_Is_Empty_Array(_ref)    (((_ref) == nil) || ([(_ref) isEqual:[NSNull null]]) ||([(_ref) count] == 0))
#define BM_S_TO_URL(url) [NSURL URLWithString:url]

#pragma mark ——— BMLOG
/** 输出*/

#ifndef DEBUG
#undef NSLog
#define NSLog(args, ...)
#endif

#ifdef DEBUG
#define BMLOG(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#define BMLOG(...)
#endif


#define BMPrint_CurrentMethod BMLOG(@"%s",__FUNCTION__);
#define BMPrint_CurrentLine BMLOG(@"%d",__LINE__);
#define BMPrint_CurrentClass BMLOG(@"%s",__FILE__);
#define BMPrint_CurrentStack BMLOG(@"%@",[NSThread callStackSymbols]);
#define BMPrint_CurrentPath BMLOG(@"%s",__FILE__);
#define BMPrint_CurrentDetail BMLOG(@"class==>%@, method==>%s, line==>%d",[self class],__FUNCTION__,__LINE__);
#define BMPrint_BMRect(rect) BMLOG(@"rect x:%f y:%f w:%f h:%f",rect.origin.x,rect.origin.y,rect.size.width,rect.size.height)
#define BMPrint_Sign BMLOG(@"~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ B M ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~")
#define BMPrint_Rect(rect) BMLOG(@"%@",NSStringFromCGRect(rect))
#define BMPrint_Size(size) BMLOG(@"%@",NSStringFromCGSize(size))


#pragma mark ——— 其他
#define BM_GO_TO_SYS_SETTING_PAGE [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
// 图片延伸
#define BM_IMAGE_STRETCH_IMG(image,w,h) [(image) stretchableImageWithLeftCapWidth:(image.size.width*(w)) topCapHeight:image.size.height*(h)]?:[UIImage new]
#define BMImageName(name)          [UIImage imageNamed:(name)]


// unaviable designed initializer
// UIView
#define BM_UNAVAILABLE_UIVIEW_INITIALIZER \
- (instancetype)init NS_UNAVAILABLE; \
- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE; \
- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE; \
+ (instancetype)new NS_UNAVAILABLE;

// UIViewController
#define BM_UNAVAILABLE_UIVIEWCONTROLLER_INITIALIZER \
- (instancetype)init NS_UNAVAILABLE; \
- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE; \
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil NS_UNAVAILABLE; \
+ (instancetype)new NS_UNAVAILABLE;

#if DEBUG
#define BM_PARAMETER_EXCEPTION(condition, des) \
if (!(condition)) { \
[NSException raise:@"com.birdmichael.error" format:des]; \
}
#else
#define BM_PARAMETER_EXCEPTION(condition, des)
#endif

#endif /* BMCommonMacro_h */
