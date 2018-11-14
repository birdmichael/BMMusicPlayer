//
//  BMHelpSleepCellNode.m
//  Calm
//
//  Created by BirdMichael on 2018/10/16.
//  Copyright © 2018 BirdMichael. All rights reserved.
//

#import "BMHelpSleepCellNode.h"
#import <AsyncDisplayKit/AsyncDisplayKit.h>
#import "BMDataTypesFunctionC.h"
#import <GPUImage/GPUImage.h>
#import "BMItemModel.h"

@class BMHelpSleepCellNodeStyles;
@interface BMHelpSleepCellNode ()<ASNetworkImageNodeDelegate>

@property (nonatomic, strong) ASNetworkImageNode *contetImageView;
@property (nonatomic, strong) ASTextNode *titleTextNode, *desTextNode, *iconTextNode;
@property (nonatomic, strong) ASDisplayNode *iconTextContent;
@property (nonatomic, strong) ASImageNode *lockImageNode;
@property (nonatomic, strong) CAGradientLayer *gradientLayer;

/** icon文字，可以Hot等。。因为t斜体，切要视觉居中，需要后面加@" ",空格 */
@property (nonatomic, copy) NSString *iconStr;
@end

@implementation BMHelpSleepCellNode

- (instancetype)init {
    self = [super init];
    if (self != nil) {
        [self setupNodes];
        self.neverShowPlaceholders = YES;
        
    }
    return self;
}

- (void)didLoad {
    [super didLoad];
    [self.view setBackgroundColor:[UIColor clearColor]];
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize {
    self.contetImageView.style.preferredSize = CGSizeMake([BMHelpSleepCellNode preferredViewSize].width, [BMHelpSleepCellNode preferredViewSize].width);
    self.iconTextContent.style.preferredSize = CGSizeMake([self calculatedIconSize:self.iconStr], BM_FitW(60));
    _iconTextContent.backgroundColor = [UIColor bm_gradientFromColor:BM_HEX_RGB(0x444183) toColor:BM_HEX_RGB(0x5C2872) direction:BMGradientDirectionHorizontal withRange:[self calculatedIconSize:self.iconStr]];
    
    // 顶部
    ASCenterLayoutSpec *CenterIconSpac = [ASCenterLayoutSpec centerLayoutSpecWithCenteringOptions:ASCenterLayoutSpecCenteringXY sizingOptions:ASCenterLayoutSpecSizingOptionMinimumY child:self.iconTextNode];
    ASOverlayLayoutSpec *overIconTextSpace = [ASOverlayLayoutSpec overlayLayoutSpecWithChild:self.iconTextContent overlay:CenterIconSpac];
     ASInsetLayoutSpec *insetIconContentSpec = [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(INFINITY, 10, 10, INFINITY) child:overIconTextSpace];
    ASInsetLayoutSpec *insetLockImageSpec = [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(10, INFINITY, INFINITY, 10) child:self.lockImageNode];
    ASOverlayLayoutSpec *overIconSpace = [ASOverlayLayoutSpec overlayLayoutSpecWithChild:self.contetImageView overlay:insetIconContentSpec];
    ASOverlayLayoutSpec *overLockSpace = [ASOverlayLayoutSpec overlayLayoutSpecWithChild:overIconSpace overlay:insetLockImageSpec];
    
    // 底部
    ASStackLayoutSpec *stackSpac = [[ASStackLayoutSpec alloc] init];
    stackSpac.children = @[overLockSpace,self.titleTextNode,self.desTextNode];
    stackSpac.direction = ASStackLayoutDirectionVertical;
    stackSpac.alignItems = ASStackLayoutAlignContentStart;
    stackSpac.justifyContent = ASStackLayoutJustifyContentStart;
    self.titleTextNode.style.spacingBefore = 15;
    return stackSpac;
}
- (void)setNodeModel:(id)nodeModel {
    [super setNodeModel:nodeModel];
    // item
    if ([nodeModel isKindOfClass:[BMItemModel class]]) {
        BMItemModel *model = (BMItemModel *)nodeModel;
        if (model.isNew) {
            self.iconStr = @"New ";
            self.iconTextContent.hidden = NO;
        }else {
            self.iconStr = @"";
            self.iconTextContent.hidden = YES;
        }
        self.lockImageNode.hidden = !model.isLock; // 先判断决定状态，如果VIP直接不显示；
//        if ([BMPurchaseManager sharedManager].isVip) {
//            self.lockImageNode.hidden = YES;
//        }
        _contetImageView.URL = [NSURL URLWithString:model.picUrl];
        _titleTextNode.attributedText = [[NSAttributedString alloc] initWithString:BMDefultString(model.title, @"") attributes:[BMHelpSleepCellNodeStyles titleStyle]];
        
        _desTextNode.attributedText = [[NSAttributedString alloc] initWithString:[NSString bm_timeIntervalToMMSSFormat:model.duration] attributes:[BMHelpSleepCellNodeStyles desTextNodeStyle]];
        _iconTextNode.attributedText = [[NSAttributedString alloc] initWithString:self.iconStr attributes:[BMHelpSleepCellNodeStyles iconNodeStyle]];
    }
    
    [self setNeedsDisplay];
    
}

#pragma mark ——— 私有方法

- (void)setupNodes {
    _contetImageView = [[ASNetworkImageNode alloc] init];
    _contetImageView.delegate = self;
    _contetImageView.cornerRadius = 20;
    _contetImageView.placeholderEnabled = NO;
    _contetImageView.placeholderFadeDuration = 3;
    _contetImageView.placeholderColor = BM_HEX_RGB(0x201F24);
    _contetImageView.contentMode = UIViewContentModeScaleToFill;
    _contetImageView.layerBacked = YES;
    
    
    _titleTextNode = [[ASTextNode alloc] init];
    _titleTextNode.truncationMode = NSLineBreakByTruncatingTail;
    _titleTextNode.style.maxWidth = ASDimensionMake([BMHelpSleepCellNode preferredViewSize].width);
    _titleTextNode.maximumNumberOfLines = 1;
    _titleTextNode.style.flexGrow = 1.0;
    _titleTextNode.layerBacked = YES;
    
    _desTextNode = [[ASTextNode alloc] init];
    _desTextNode.maximumNumberOfLines = 1;
    _desTextNode.style.maxWidth = ASDimensionMake([BMHelpSleepCellNode preferredViewSize].width);
    _desTextNode.layerBacked = YES;
    
    _iconTextNode = [[ASTextNode alloc] init];
    _iconTextNode.maximumNumberOfLines = 0;
    _iconTextNode.layerBacked = YES;
    _iconTextNode.style.spacingAfter = 2;
    
    _iconTextContent = [[ASDisplayNode alloc] init];
    _iconTextContent.cornerRadius = BM_FitW(60)/2;
    _iconTextContent.layerBacked = YES;
    
    
    
    _lockImageNode = [[ASImageNode alloc] init];
    _lockImageNode.layerBacked = YES;
    _lockImageNode.image = [BMHelpSleepCellNodeStyles lockImage];
    _lockImageNode.contentMode = UIViewContentModeScaleAspectFill;
    
    [self addSubnode:_contetImageView];
    [self addSubnode:_titleTextNode];
    [self addSubnode:_desTextNode];
    [self addSubnode:_iconTextContent];
    [self addSubnode:_iconTextNode];
    [self addSubnode:_lockImageNode];
}

- (CGFloat)calculatedIconSize:(NSString *)str{
    CGSize size = [str boundingRectWithSize:CGSizeMake(HUGE, HUGE)
                                                                        options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                                                     attributes:[BMHelpSleepCellNodeStyles iconNodeStyle] context:nil].size;
    
    return size.width + 25;
}

#pragma mark ——— 外部方法
+ (CGSize)preferredViewSize {
    CGFloat with = floor((kBMSCREEN_WIDTH-kHelpSleepHorizontalSectionPadding *3)/2); // 2列
    return CGSizeMake(with, with + kBMHelpSleepCellBottomTextFitH);
}
@end

#pragma mark ———  BMHelpSleepCellNodeStyles

@implementation BMHelpSleepCellNodeStyles

+ (NSDictionary *)titleStyle {
    return @{ NSFontAttributeName:BM_CLAM_BOLD_FONT(15),
              NSForegroundColorAttributeName:BM_HEX_RGB(0xffffff) };
}

+ (NSDictionary *)desTextNodeStyle {
    return @{ NSFontAttributeName:BM_CLAM_FONT(15),
              NSForegroundColorAttributeName:BM_HEX_RGBA(0xffffff, 0.5) };
}
+ (NSDictionary *)iconNodeStyle {
    return @{ NSFontAttributeName:BM_CLAM_BOLD_FONT(13),
              NSForegroundColorAttributeName:BM_HEX_RGBA(0xffffff, 1),
              NSObliquenessAttributeName:@(0.3),
              };
}

+ (UIImage *)placeholderImage {
    static UIImage *__placeholderImage = nil;
    static dispatch_once_t onceToken;
    dispatch_once (&onceToken, ^{
        __placeholderImage = [UIImage imageNamed:@"1_bg"];
    });
    return __placeholderImage;
}
+ (UIImage *)lockImage {
    static UIImage *__lockImage= nil;
    static dispatch_once_t onceToken;
    dispatch_once (&onceToken, ^{
        __lockImage = [UIImage imageNamed:@"lock_icon"];
    });
    return __lockImage;
}
@end
