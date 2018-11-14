//
//  UIButton+BMExtension.h
//  Pods
//
//  Created by BirdMichael on 2018/10/2.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^BMTouchedBlock)(void);

typedef NS_ENUM(NSUInteger, BMImageTextAlignment) {
    BMImageTextAlignmentImageLeftTextRight,
    BMImageTextAlignmentImageRightTextLeft,
    BMImageTextAlignmentImageTopTextBottom,
    BMImageTextAlignmentImageBottomTextTop
};

@interface UIButton (BMExtension)

/** 设置按钮额外点击区域 */
@property (nonatomic, assign) UIEdgeInsets bm_touchAreaInsets;

/**
 添加 addtarget
 */
- (void)bm_addActionHandler:(BMTouchedBlock)touchHandler;

/**
 *  @brief  使用颜色设置按钮背景
 *
 *  @param backgroundColor 背景颜色
 *  @param state           按钮状态
 */
- (void)bm_setBackgroundColor:(UIColor *)backgroundColor forState:(UIControlState)state;

/**
 *  @brief  设置按钮图片与文字排列方式 以及两者相对间距
 *
 *  @param alignment 对其方式
 *
 */

- (void)bm_setImageTextAlignment:(BMImageTextAlignment)alignment padding:(CGFloat)padding;

// 根据按钮内容与边距，计算按钮应该的大小（文字或图片）
// 优先判断 normal title，如果不存在，则判断 normal image
// 仅做大小计算，不进行重新布局

/**
 *  @brief  根据按钮内容与边距，计算按钮应该的大小（文字或图片）
 *
 *  优先判断 normal title，如果不存在，则判断 normal image （仅做大小计算，不进行重新布局）
 *
 *
 *  @param insets 按钮间距
 *
 *  @return 计算后的按钮大小
 */
- (CGSize)bm_sizeWithContentInsets:(UIEdgeInsets)insets;

/**
 *  @brief  根据按钮内容与边距，计算按钮应该的大小（文字或图片）
 *
 *  优先判断 normal title，如果不存在，则判断 normal image （仅做大小计算，不进行重新布局）
 *
 *  @param insets 按钮间距
 *  @param alignment 文字图片对其方式
 *  @param padding 图片文字间隔距离
 *
 *  @return 计算后的按钮大小
 */
- (CGSize)st_sizeWithContentInsets:(UIEdgeInsets)insets alignment:(BMImageTextAlignment)alignment padding:(CGFloat)padding;


#pragma mark ——— UIButton Badge(Category)
/** Badge badge显示的容器Label */
@property (nonatomic, strong, nullable) UILabel *bm_badge;

/** Badge显示内容(Str) */
@property (nonatomic, copy) NSString *bm_badgeValue;
/** Badge 背景色 默认:redColor */
@property (nonatomic, strong) UIColor *bm_badgeBGColor;
/** Badge 文字颜色 默认:whiteColor */
@property (nonatomic, strong) UIColor *bm_badgeTextColor;
/** Badge 文字字体 默认:12号系统字体*/
@property (nonatomic, strong) UIFont *bm_badgeFont;
/** Badge Padding 默认:6 */
@property (nonatomic, assign) CGFloat bm_badgePadding;
/** Badge 最小尺寸 默认:8 */
@property (nonatomic, assign) CGFloat bm_badgeMinSize;
/** Badge Padding X默认:jz取整居中Btnd宽 Y默认:-4（已适配Padding）*/
@property (nonatomic, assign) CGFloat bm_badgeOriginX;
@property (nonatomic, assign) CGFloat bm_badgeOriginY;
/** 当Badge为数组时，0是否隐藏Badge  默认值：YES*/
@property BOOL bm_shouldHideBadgeAtZero;
/** 需要需要当值改变时Badge有一个bounce的动画 默认值：YES*/
@property BOOL bm_shouldAnimateBadge;

@end


NS_ASSUME_NONNULL_END

#pragma mark ——— BMRoundedButton
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

IB_DESIGNABLE
@interface BMRoundedButton : UIButton

@property (nonatomic, assign) IBInspectable UIRectCorner bm_corners;
@property (nonatomic, assign) IBInspectable CGFloat bm_cornerRaduous;

@end

NS_ASSUME_NONNULL_END

