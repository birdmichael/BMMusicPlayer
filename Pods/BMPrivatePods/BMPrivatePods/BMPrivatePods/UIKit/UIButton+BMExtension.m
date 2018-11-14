//
//  UIButton+BMExtension.m
//  Pods
//
//  Created by BirdMichael on 2018/10/2.
//

#import "UIButton+BMExtension.h"
#import <objc/runtime.h>
#import "NSString+BMExtension.h"

@implementation UIButton (BMExtension)

static const void *UIButtonBlockKey = &UIButtonBlockKey;
- (void)bm_addActionHandler:(BMTouchedBlock)touchHandler {
    objc_setAssociatedObject(self, UIButtonBlockKey, touchHandler, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self addTarget:self action:@selector(actionTouched:) forControlEvents:UIControlEventTouchUpInside];
}
-(void)actionTouched:(UIButton *)btn{
    BMTouchedBlock block = objc_getAssociatedObject(self, UIButtonBlockKey);
    if (block) {
        block();
    }
}



- (UIEdgeInsets)bm_touchAreaInsets
{
    return [objc_getAssociatedObject(self, @selector(bm_touchAreaInsets)) UIEdgeInsetsValue];
}
/**
 *  @brief  设置按钮额外热区
 */

- (void)setBm_touchAreaInsets:(UIEdgeInsets)bm_touchAreaInsets {
    NSValue *value = [NSValue valueWithUIEdgeInsets:bm_touchAreaInsets];
    objc_setAssociatedObject(self, @selector(bm_touchAreaInsets), value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    UIEdgeInsets touchAreaInsets = self.bm_touchAreaInsets;
    CGRect bounds = self.bounds;
    bounds = CGRectMake(bounds.origin.x - touchAreaInsets.left,
                        bounds.origin.y - touchAreaInsets.top,
                        bounds.size.width + touchAreaInsets.left + touchAreaInsets.right,
                        bounds.size.height + touchAreaInsets.top + touchAreaInsets.bottom);
    return CGRectContainsPoint(bounds, point);
}

- (void)bm_setBackgroundColor:(UIColor *)backgroundColor forState:(UIControlState)state {
    [self setBackgroundImage:[UIButton imageWithColor:backgroundColor] forState:state];
}
+ (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (void)bm_setImageTextAlignment:(BMImageTextAlignment)alignment padding:(CGFloat)padding {
    self.imageEdgeInsets = UIEdgeInsetsZero;
    self.titleEdgeInsets = UIEdgeInsetsZero;
    self.contentEdgeInsets = UIEdgeInsetsZero;
    
    UIImageView *imageView = self.imageView;
    UILabel *textLabel = self.titleLabel;
    
    CGFloat selfWidth = CGRectGetWidth(self.bounds);
    CGFloat selfHeight = CGRectGetHeight(self.bounds);
    CGFloat textX = CGRectGetMinX(textLabel.frame);
    CGFloat textY = CGRectGetMinY(textLabel.frame);
    CGFloat imageX = CGRectGetMinX(imageView.frame);
    CGFloat imageY = CGRectGetMinY(imageView.frame);
    CGFloat textWidth = CGRectGetWidth(textLabel.bounds);
    CGFloat textHeight = CGRectGetHeight(textLabel.bounds);
    CGFloat imageWidth = CGRectGetWidth(imageView.bounds);
    CGFloat imageHeight = CGRectGetHeight(imageView.bounds);
    CGFloat totalHeight = textHeight + padding + imageHeight;
    
    UIEdgeInsets imageEdge = UIEdgeInsetsZero;
    UIEdgeInsets textEdge = UIEdgeInsetsZero;
    
    switch (alignment) {
        case BMImageTextAlignmentImageLeftTextRight:
            textEdge = UIEdgeInsetsMake(0, padding / 2, 0, -padding / 2);
            imageEdge = UIEdgeInsetsMake(0, -padding / 2, 0, padding / 2);
            break;
        case BMImageTextAlignmentImageRightTextLeft:
            textEdge = UIEdgeInsetsMake(0, -(imageWidth + padding / 2), 0, (imageWidth + padding / 2));
            imageEdge = UIEdgeInsetsMake(0, (textWidth + padding / 2), 0, -(textWidth + padding / 2));
            break;
        case BMImageTextAlignmentImageTopTextBottom:
            textEdge = UIEdgeInsetsMake(((selfHeight - totalHeight) / 2 + imageHeight + padding - textY),
                                        (selfWidth / 2 - textX - textWidth / 2) - (selfWidth - textWidth) / 2,
                                        -((selfHeight - totalHeight) / 2 + imageHeight + padding - textY),
                                        -(selfWidth/2 - textX - textWidth / 2) - (selfWidth - textWidth) / 2);
            imageEdge = UIEdgeInsetsMake(((selfHeight - totalHeight) / 2 - imageY),
                                         (selfWidth / 2 - imageX - imageWidth / 2),
                                         -((selfHeight - totalHeight) / 2 - imageY),
                                         -(selfWidth / 2 - imageX - imageWidth / 2));
            break;
        case BMImageTextAlignmentImageBottomTextTop:
            textEdge = UIEdgeInsetsMake(((selfHeight - totalHeight) / 2 - textY),
                                        (selfWidth / 2 - textX - textWidth / 2) - (selfWidth - textWidth) / 2,
                                        -((selfHeight - totalHeight) / 2 - textY),
                                        -(selfWidth / 2 - textX - textWidth / 2) - (selfWidth - textWidth) / 2);
            imageEdge = UIEdgeInsetsMake(((selfHeight - totalHeight) / 2 + textHeight + padding - imageY),
                                         (selfWidth / 2 - imageX - imageWidth / 2),
                                         -((selfHeight - totalHeight) / 2 + textHeight + padding - imageY),
                                         -(selfWidth / 2 - imageX - imageWidth / 2));
            break;
        default:
            break;
    }
    if (UIEdgeInsetsEqualToEdgeInsets(textEdge, UIEdgeInsetsZero) || UIEdgeInsetsEqualToEdgeInsets(imageEdge, UIEdgeInsetsZero)) {
        return;
    }
    self.imageEdgeInsets = imageEdge;
    self.titleEdgeInsets = textEdge;
}
- (CGSize)bm_sizeWithContentInsets:(UIEdgeInsets)insets {
    NSString *title = [self titleForState:UIControlStateNormal];
    // 计算 title
    if (title != nil && title.length != 0) {
        UIFont *titleFont = self.titleLabel.font;
        CGSize titleSize = [title bm_sizeWithFont:titleFont];
        return CGSizeMake(titleSize.width + insets.left + insets.right, titleSize.height + insets.top + insets.bottom);
    }
    UIImage *image = [self imageForState:UIControlStateNormal];
    if (image != nil) {
        CGSize imageSize = image.size;
        return CGSizeMake(imageSize.width + insets.left + insets.right, imageSize.height + insets.top + insets.bottom);
    }
    return CGSizeMake(insets.left + insets.right, insets.top + insets.bottom);
}
- (CGSize)st_sizeWithContentInsets:(UIEdgeInsets)insets alignment:(BMImageTextAlignment)alignment padding:(CGFloat)padding {
    NSString *title = [self titleForState:UIControlStateNormal];
    UIImage *image = [self imageForState:UIControlStateNormal];
    
    if (title == nil || title.length == 0 || image == nil) {
        return CGSizeMake(insets.left + insets.right, insets.top + insets.bottom);
    }
    UIFont *titleFont = self.titleLabel.font;
    CGSize titleSize = [title bm_sizeWithFont:titleFont];
    CGSize imageSize = image.size;
    
    CGFloat sumHeight = 0;
    CGFloat sumWidth = 0;
    
    switch (alignment) {
        case BMImageTextAlignmentImageLeftTextRight:
        case BMImageTextAlignmentImageRightTextLeft:
            sumWidth = titleSize.width + imageSize.width + padding;
            sumHeight = MAX(titleSize.height, imageSize.height);
            break;
        case BMImageTextAlignmentImageTopTextBottom:
        case BMImageTextAlignmentImageBottomTextTop:
            sumWidth = MAX(titleSize.width, imageSize.width);
            sumHeight = titleSize.height + imageSize.height + padding;
            break;
    }
    
    return CGSizeMake(ceil(insets.left + insets.right + sumWidth), ceil(insets.top + insets.bottom + sumHeight));
}

#pragma mark ——— UIButton Badge(Category)
NSString const *bm_UIButton_badgeKey = @"bm_UIButton_badgeKey";

NSString const *bm_UIButton_badgeBGColorKey = @"bm_UIButton_badgeBGColorKey";
NSString const *bm_UIButton_badgeTextColorKey = @"bm_UIButton_badgeTextColorKey";
NSString const *bm_UIButton_badgeFontKey = @"bm_UIButton_badgeFontKey";
NSString const *bm_UIButton_badgePaddingKey = @"bm_UIButton_badgePaddingKey";
NSString const *bm_UIButton_badgeMinSizeKey = @"bm_UIButton_badgeMinSizeKey";
NSString const *bm_UIButton_badgeOriginXKey = @"bm_UIButton_badgeOriginXKey";
NSString const *bm_UIButton_badgeOriginYKey = @"bm_UIButton_badgeOriginYKey";
NSString const *bm_UIButton_shouldHideBadgeAtZeroKey = @"bm_UIButton_shouldHideBadgeAtZeroKey";
NSString const *bm_UIButton_shouldAnimateBadgeKey = @"bm_UIButton_shouldAnimateBadgeKey";
NSString const *bm_UIButton_badgeValueKey = @"bm_UIButton_badgeValueKey";


//@dynamic bm_badgeValue, bm_badgeBGColor, bm_badgeTextColor, bm_badgeFont;
//@dynamic bm_badgePadding, bm_badgeMinSize, bm_badgeOriginX, bm_badgeOriginY;
//@dynamic bm_shouldHideBadgeAtZero, bm_shouldAnimateBadge;

- (void)bm_badgeInit
{
    // 初始化默认值
    self.bm_badgeBGColor   = [UIColor redColor];
    self.bm_badgeTextColor = [UIColor whiteColor];
    self.bm_badgeFont      = [UIFont systemFontOfSize:12.0];
    self.bm_badgePadding   = 6;
    self.bm_badgeMinSize   = 8;
    self.bm_badgeOriginX   = self.frame.size.width - self.bm_badge.frame.size.width/2;
    self.bm_badgeOriginY   = -4;
    self.bm_shouldHideBadgeAtZero = YES;
    self.bm_shouldAnimateBadge = YES;
    self.clipsToBounds = NO;
}

#pragma mark - Badge Utility methods

// 当字体颜色，背景色，字体等更改时需要刷新视图
- (void)bm_refreshBadge {
    // Change new attributes
    self.bm_badge.textColor        = self.bm_badgeTextColor;
    self.bm_badge.backgroundColor  = self.bm_badgeBGColor;
    self.bm_badge.font             = self.bm_badgeFont;
}

- (CGSize) bm_badgeExpectedSize {
    UILabel *frameLabel = [self bm_duplicateLabel:self.bm_badge];
    [frameLabel sizeToFit];
    
    CGSize expectedLabelSize = frameLabel.frame.size;
    return expectedLabelSize;
}

- (void)bm_updateBadgeFrame {
    
    CGSize expectedLabelSize = [self bm_badgeExpectedSize];
    
    // Make sure that for small value, the badge will be big enough
    CGFloat minHeight = expectedLabelSize.height;
    
    // Using a const we make sure the badge respect the minimum size
    minHeight = (minHeight < self.bm_badgeMinSize) ? ceilf(self.bm_badgeMinSize) : ceilf(expectedLabelSize.height);
    CGFloat minWidth = expectedLabelSize.width;
    CGFloat padding = self.bm_badgePadding;
    
    // Using const we make sure the badge doesn't get too smal
    minWidth = (minWidth < minHeight) ? ceilf(minHeight) : ceilf(expectedLabelSize.width);
    self.bm_badge.frame = CGRectMake(self.bm_badgeOriginX -padding/2, self.bm_badgeOriginY -padding/2, minWidth + padding, minHeight + padding);
    self.bm_badge.layer.cornerRadius = (minHeight + padding) / 2;
    self.bm_badge.layer.masksToBounds = YES;
}

// Handle the badge changing value
- (void)bm_updateBadgeValueAnimated:(BOOL)animated {
    // Bounce animation on badge if value changed and if animation authorized
    if (animated && self.bm_shouldAnimateBadge && ![self.bm_badge.text isEqualToString:self.bm_badgeValue]) {
        CABasicAnimation * animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        [animation setFromValue:[NSNumber numberWithFloat:1.5]];
        [animation setToValue:[NSNumber numberWithFloat:1]];
        [animation setDuration:0.2];
        [animation setTimingFunction:[CAMediaTimingFunction functionWithControlPoints:.4f :1.3f :1.f :1.f]];
        [self.bm_badge.layer addAnimation:animation forKey:@"bounceAnimation"];
    }
    
    // Set the new value
    self.bm_badge.text = self.bm_badgeValue;
    
    // Animate the size modification if needed
    NSTimeInterval duration = animated ? 0.2 : 0;
    [UIView animateWithDuration:duration animations:^{
        [self bm_updateBadgeFrame];
    }];
}

- (UILabel *)bm_duplicateLabel:(UILabel *)labelToCopy {
    UILabel *duplicateLabel = [[UILabel alloc] initWithFrame:labelToCopy.frame];
    duplicateLabel.text = labelToCopy.text;
    duplicateLabel.font = labelToCopy.font;
    
    return duplicateLabel;
}

- (void)bm_removeBadge {

    [UIView animateWithDuration:0.2 animations:^{
        self.bm_badge.transform = CGAffineTransformMakeScale(0, 0);
    } completion:^(BOOL finished) {
        [self.bm_badge removeFromSuperview];
        self.bm_badge = nil;
    }];
}

#pragma mark - Badge getters/setters
-(UILabel*)bm_badge {
    return objc_getAssociatedObject(self, &bm_UIButton_badgeKey);
}
- (void)setBm_badge:(UILabel *)bm_badge{
    objc_setAssociatedObject(self, &bm_UIButton_badgeKey, bm_badge, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


- (NSString *)bm_badgeValue {
    return objc_getAssociatedObject(self, &bm_UIButton_badgeValueKey);
}

- (void)setBm_badgeValue:(NSString *)bm_badgeValue{
    objc_setAssociatedObject(self, &bm_UIButton_badgeValueKey, bm_badgeValue, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    // 当字符串为空或者数字为0时候隐藏Badge
    if (!bm_badgeValue || [bm_badgeValue isEqualToString:@""] || ([bm_badgeValue isEqualToString:@"0"] && self.bm_shouldHideBadgeAtZero)) {
        [self bm_removeBadge];
    } else if (!self.bm_badge) {
        // Create a new badge because not existing
        self.bm_badge                      = [[UILabel alloc] initWithFrame:CGRectMake(self.bm_badgeOriginX, self.bm_badgeOriginY, 20, 20)];
        self.bm_badge.textColor            = self.bm_badgeTextColor;
        self.bm_badge.backgroundColor      = self.bm_badgeBGColor;
        self.bm_badge.font                 = self.bm_badgeFont;
        self.bm_badge.textAlignment        = NSTextAlignmentCenter;
        [self bm_badgeInit];
        [self addSubview:self.bm_badge];
        [self bm_updateBadgeValueAnimated:NO];
    } else {
        [self bm_updateBadgeValueAnimated:YES];
    }
}


- (UIColor *)bm_badgeBGColor {
    return objc_getAssociatedObject(self, &bm_UIButton_badgeBGColorKey);
}
- (void)setBm_badgeBGColor:(UIColor *)badgeBGColor
{
    objc_setAssociatedObject(self, &bm_UIButton_badgeBGColorKey, badgeBGColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (self.bm_badge) {
        [self bm_refreshBadge];
    }
}

- (UIColor *)bm_badgeTextColor {
    return objc_getAssociatedObject(self, &bm_UIButton_badgeTextColorKey);
}
- (void)setBm_badgeTextColor:(UIColor *)badgeTextColor
{
    objc_setAssociatedObject(self, &bm_UIButton_badgeTextColorKey, badgeTextColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (self.bm_badge) {
        [self bm_refreshBadge];
    }
}

- (UIFont *)bm_badgeFont {
    return objc_getAssociatedObject(self, &bm_UIButton_badgeFontKey);
}
- (void)setBm_badgeFont:(UIFont *)badgeFont
{
    objc_setAssociatedObject(self, &bm_UIButton_badgeFontKey, badgeFont, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (self.bm_badge) {
        [self bm_refreshBadge];
    }
}


- (CGFloat) bm_badgePadding {
    NSNumber *number = objc_getAssociatedObject(self, &bm_UIButton_badgePaddingKey);
    return number.floatValue;
}
- (void) setBm_badgePadding:(CGFloat)badgePadding
{
    NSNumber *number = [NSNumber numberWithDouble:badgePadding];
    objc_setAssociatedObject(self, &bm_UIButton_badgePaddingKey, number, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (self.bm_badge) {
        [self bm_updateBadgeFrame];
    }
}

- (CGFloat) bm_badgeMinSize {
    NSNumber *number = objc_getAssociatedObject(self, &bm_UIButton_badgeMinSizeKey);
    return number.floatValue;
}
- (void) setBm_badgeMinSize:(CGFloat)badgeMinSize
{
    NSNumber *number = [NSNumber numberWithDouble:badgeMinSize];
    objc_setAssociatedObject(self, &bm_UIButton_badgeMinSizeKey, number, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (self.bm_badge) {
        [self bm_updateBadgeFrame];
    }
}

- (CGFloat) bm_badgeOriginX {
    NSNumber *number = objc_getAssociatedObject(self, &bm_UIButton_badgeOriginXKey);
    return number.floatValue;
}
- (void) setBm_badgeOriginX:(CGFloat)badgeOriginX
{
    NSNumber *number = [NSNumber numberWithDouble:badgeOriginX];
    objc_setAssociatedObject(self, &bm_UIButton_badgeOriginXKey, number, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (self.bm_badge) {
        [self bm_updateBadgeFrame];
    }
}

- (CGFloat) bm_badgeOriginY {
    NSNumber *number = objc_getAssociatedObject(self, &bm_UIButton_badgeOriginYKey);
    return number.floatValue;
}
- (void) setBm_badgeOriginY:(CGFloat)badgeOriginY
{
    NSNumber *number = [NSNumber numberWithDouble:badgeOriginY];
    objc_setAssociatedObject(self, &bm_UIButton_badgeOriginYKey, number, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (self.bm_badge) {
        [self bm_updateBadgeFrame];
    }
}

- (BOOL) bm_shouldHideBadgeAtZero {
    NSNumber *number = objc_getAssociatedObject(self, &bm_UIButton_shouldHideBadgeAtZeroKey);
    return number.boolValue;
}
- (void)setBm_shouldHideBadgeAtZero:(BOOL)shouldHideBadgeAtZero
{
    NSNumber *number = [NSNumber numberWithBool:shouldHideBadgeAtZero];
    objc_setAssociatedObject(self, &bm_UIButton_shouldHideBadgeAtZeroKey, number, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL) bm_shouldAnimateBadge {
    NSNumber *number = objc_getAssociatedObject(self, &bm_UIButton_shouldAnimateBadgeKey);
    return number.boolValue;
}
- (void)setBm_shouldAnimateBadge:(BOOL)shouldAnimateBadge
{
    NSNumber *number = [NSNumber numberWithBool:shouldAnimateBadge];
    objc_setAssociatedObject(self, &bm_UIButton_shouldAnimateBadgeKey, number, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end


#pragma mark ——— BMRoundedButton
@implementation BMRoundedButton

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupShapeLayer];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setupShapeLayer];
    }
    return self;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupShapeLayer];
}

- (void)makeCorner {
    _bm_cornerRaduous = _bm_cornerRaduous ?: 5.0;
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                                   byRoundingCorners:self.bm_corners
                                                         cornerRadii:CGSizeMake(_bm_cornerRaduous, _bm_cornerRaduous)];
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame         = self.bounds;
    maskLayer.path          = maskPath.CGPath;
    self.layer.mask         = maskLayer;
}

- (void)setupShapeLayer {
    [self makeCorner];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self makeCorner];
}

@end
