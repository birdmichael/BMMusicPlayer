//
//  BMMusicDisplayNode.m
//  Calm
//
//  Created by BirdMichael on 2018/10/20.
//  Copyright © 2018 BirdMichael. All rights reserved.
//

#import "BMMusicDisplayNode.h"
#import <GPUImage/GPUImage.h>
#import "iOSPalette.h"
#import "BMMusicTimerNode.h"
#import "BMMusicSelectTimerNode.h"
#import <Lottie/Lottie.h>

static const CGFloat kCoverPictureHW = 500;
static const CGFloat kCoverPictureRippleCount = 5;
static const CGFloat kCoverPictureRippleMaxBorderWidth = 2;
static const CGFloat kCoverPictureRippleDuration = 4;
static const CGFloat kCoverPictureRippleCircleSize = 10;

@interface BMMusicDisplayNode () 
@property (nonatomic, strong) ASNetworkImageNode *imageBackGroudNode; // 图片背景
@property (nonatomic, strong) ASDisplayNode *imageBackGroudCoverNode; // 图片背景
@property (nonatomic, strong) ASTextNode2 *titileTextNode; // 标题
@property (nonatomic, strong) ASNetworkImageNode *coverPictureNode; // 封面图
@property (nonatomic, strong) ASDisplayNode *coverPictureShadowNode; // 封面图
@property (nonatomic, strong) ASButtonNode *stopBtnNode, *palybtnNode, *timerNode; // 停止,播放,定时器按钮
@property (nonatomic, strong) LOTAnimationView *loadingView;
@property (nonatomic, strong) BMMusicTimerNode *timingNode;
@property (nonatomic, strong) NSMutableArray<CALayer *> *rippleArray;
@property (nonatomic, strong) NSMutableArray<CALayer *> *rippleCircleArray;
@property (nonatomic, weak) CALayer * animationLayer;
@property (nonatomic, assign) BOOL isTiming;



@end

@implementation BMMusicDisplayNode

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupSubNode];
    }
    return self;
}

- (void)didLoad {
    [super didLoad];
    [self addAnimation];
    [self addRippleAnimation];
    self.view.backgroundColor = BM_HEX_RGB(0x121112);
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize {
    // 背景（图片+透明蒙层）
    ASWrapperLayoutSpec *imageSpec = [ASWrapperLayoutSpec wrapperWithLayoutElement:_imageBackGroudNode];
    ASOverlayLayoutSpec *imageOverSpec = [ASOverlayLayoutSpec overlayLayoutSpecWithChild:imageSpec overlay:self.imageBackGroudCoverNode];
    
    // 左右两边的3个按钮（d定时与非定时状态）都固定宽高以保证 在文字变换过程中居中
    _timerNode.style.preferredSize = CGSizeMake(50, 40);
    _timingNode.style.preferredSize = CGSizeMake(50, 40);
    _stopBtnNode.style.preferredSize = CGSizeMake(50, 40);
    ASStackLayoutSpec *stackBtnLayout;
    if (self.isTiming) {
       stackBtnLayout =  [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionHorizontal
                                                spacing:85
                                         justifyContent:ASStackLayoutJustifyContentSpaceAround
                                             alignItems:ASStackLayoutAlignItemsCenter
                                               children:@[self.stopBtnNode,self.palybtnNode, self.timingNode]];
    }else {
        stackBtnLayout =[ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionHorizontal
                                                spacing:85
                                         justifyContent:ASStackLayoutJustifyContentSpaceAround
                                             alignItems:ASStackLayoutAlignItemsCenter
                                               children:@[self.stopBtnNode,self.palybtnNode, self.timerNode]];
    }
    
    // 垂直布局
    self.titileTextNode.style.spacingBefore = kBMStatusBarHeight + 69;
    self.coverPictureShadowNode.style.spacingBefore = 46;
    self.coverPictureShadowNode.style.flexGrow = 1;
    stackBtnLayout.style.spacingAfter = BM_FitW(276) + kMSafeBottomHeight;
    ASStackLayoutSpec *stackLayout = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionVertical
                                                                             spacing:0
                                                                      justifyContent:ASStackLayoutJustifyContentStart
                                                                          alignItems:ASStackLayoutAlignItemsCenter
                                                                            children:@[self.titileTextNode, self.coverPictureShadowNode,stackBtnLayout]];
    
    ASOverlayLayoutSpec *endOverSpec = [ASOverlayLayoutSpec overlayLayoutSpecWithChild:imageOverSpec overlay:stackLayout];
    return endOverSpec;
}


- (void)addAnimation {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    animation.duration = 15;
    animation.repeatCount = MAXFLOAT;
    animation.removedOnCompletion = NO;
    animation.toValue = @(M_PI*2);
    [self.coverPictureNode.layer addAnimation:animation forKey:@"rotationAnimation"];
//    return;
    
}

- (void)addRippleAnimation {
    self.rippleArray = [@[] mutableCopy];
    self.rippleCircleArray = [@[] mutableCopy];
    CALayer * animationLayer = [CALayer layer];
    CGFloat maxRadius = kBMSCREEN_WIDTH /2;
    for (int i = 0; i<kCoverPictureRippleCount; i++) {
        CALayer * pulsingLayer = [CALayer layer];
        pulsingLayer.frame = CGRectMake(0, 0, maxRadius*2, maxRadius*2);
        pulsingLayer.position = CGPointMake(BM_FitW(kCoverPictureHW)/2, BM_FitW(kCoverPictureHW)/2);
        pulsingLayer.backgroundColor = [UIColor clearColor].CGColor;
        pulsingLayer.cornerRadius = maxRadius;
        pulsingLayer.borderWidth = kCoverPictureRippleMaxBorderWidth;
        
        CALayer *lay = [CALayer layer];
        lay.frame = CGRectMake(0, 0, kCoverPictureRippleCircleSize, kCoverPictureRippleCircleSize);
        lay.cornerRadius = kCoverPictureRippleCircleSize/2;
        lay.masksToBounds = YES;
        lay.position = CGPointMake(maxRadius*2 * sin(45), maxRadius*2 * sin(45));
        [pulsingLayer addSublayer:lay];
        
        CAMediaTimingFunction * defaultCurve = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
        
        CAAnimationGroup * animationGroup = [CAAnimationGroup animation];
        animationGroup.fillMode = kCAFillModeBackwards;
        animationGroup.beginTime = CACurrentMediaTime() + i * kCoverPictureRippleDuration / kCoverPictureRippleCount;
        animationGroup.duration = kCoverPictureRippleDuration;
        animationGroup.repeatCount = HUGE;
        animationGroup.timingFunction = defaultCurve;
        
        CABasicAnimation * scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        scaleAnimation.fromValue = @(BM_FitW(kCoverPictureHW)/2 / maxRadius);
        scaleAnimation.toValue = @1.0;
        scaleAnimation.beginTime = CACurrentMediaTime() + i * kCoverPictureRippleDuration / kCoverPictureRippleCount;
        scaleAnimation.fillMode = kCAFillModeBackwards;
        scaleAnimation.timingFunction = defaultCurve;
        scaleAnimation.duration = kCoverPictureRippleDuration;
        scaleAnimation.repeatCount = HUGE;
        scaleAnimation.removedOnCompletion = NO;
        scaleAnimation.fillMode = kCAFillModeForwards;
        
        
        CABasicAnimation *animation = [CABasicAnimation new];
        animation.keyPath = @"transform.rotation.z";
        animation.beginTime = CACurrentMediaTime() + i * kCoverPictureRippleDuration / kCoverPictureRippleCount;
        animation.fromValue = [NSNumber numberWithFloat:i *(M_PI/2)]; // 起始角度
        animation.toValue = [NSNumber numberWithFloat:i *(M_PI/2) + 2*M_PI]; // 终止角度
        animation.duration = 20;
        animation.repeatCount = HUGE;
        animation.timingFunction = defaultCurve;
        animation.removedOnCompletion = NO;
        animation.fillMode = kCAFillModeForwards;
        
        CAKeyframeAnimation * opacityAnimation = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
        opacityAnimation.beginTime = CACurrentMediaTime() + i * kCoverPictureRippleDuration / kCoverPictureRippleCount;
        opacityAnimation.values = @[@0.3, @0.5, @0];
        opacityAnimation.keyTimes = @[@0, @0.3, @1];
        opacityAnimation.duration = kCoverPictureRippleDuration;
        opacityAnimation.repeatCount = HUGE;
        opacityAnimation.timingFunction = defaultCurve;
        opacityAnimation.removedOnCompletion = NO;
        opacityAnimation.fillMode = kCAFillModeForwards;
        
        // 有一个位置问题，ASDK使用animationGroup 仅显示一个。
//        animationGroup.animations = @[scaleAnimation, opacityAnimation,animation];
        [pulsingLayer addAnimation:scaleAnimation forKey:@"plulsing"];
        [pulsingLayer addAnimation:animation forKey:@"dsdasdasd"];
        [pulsingLayer addAnimation:opacityAnimation forKey:@"plulsidsadang"];
        [animationLayer addSublayer:pulsingLayer];
        [self.rippleArray addObject:pulsingLayer];
        [self.rippleCircleArray addObject:lay];
    }
    _animationLayer = animationLayer;
    [self.coverPictureShadowNode.layer addSublayer:animationLayer];
}

- (void)setupSubNode {
    _imageBackGroudNode = [[ASNetworkImageNode alloc] init];
    _imageBackGroudNode.placeholderColor = BM_HEX_RGB(0x121112);
    _imageBackGroudNode.layerBacked = YES;
    _imageBackGroudNode.contentMode = UIViewContentModeScaleAspectFill;
    _imageBackGroudNode.placeholderFadeDuration = 3;
    _imageBackGroudNode.imageModificationBlock = ^UIImage * _Nullable(UIImage * _Nonnull image) {
        // GPUimage
        GPUImageGaussianBlurFilter *filter = [[GPUImageGaussianBlurFilter alloc] init];
        filter.blurRadiusInPixels = 40.0;
        [filter forceProcessingAtSize:image.size];
        GPUImagePicture *pic = [[GPUImagePicture alloc] initWithImage:image];
        [pic addTarget:filter];
        [pic processImage];
        [filter useNextFrameForImageCapture];
        return [filter imageFromCurrentFramebuffer];
    };
    [self addSubnode:_imageBackGroudNode];
    
    _imageBackGroudCoverNode = [[ASDisplayNode alloc] init];
    _imageBackGroudCoverNode.layerBacked = YES;
    _imageBackGroudCoverNode.backgroundColor = BM_HEX_RGBA(0x121112, 0.6);
    [self addSubnode:_imageBackGroudCoverNode];
    
    _titileTextNode = [[ASTextNode2 alloc] init];
    _titileTextNode.maximumNumberOfLines = 1;
    _titileTextNode.attributedText = [[NSAttributedString alloc] initWithString:@"Grimms fairytales" attributes:@{NSFontAttributeName:BM_CLAM_BOLD_FONT(18),NSForegroundColorAttributeName:BM_HEX_RGBA(0xffffff, 1)}];
    _titileTextNode.layerBacked = YES;
    [self addSubnode:_titileTextNode];
    
    CGSize coverSize = CGSizeMake(BM_FitW(kCoverPictureHW), BM_FitW(kCoverPictureHW));
    _coverPictureShadowNode = [[ASDisplayNode alloc] init];
    _coverPictureShadowNode.style.preferredSize = coverSize;
    [self addSubnode:_coverPictureShadowNode];
    
    _coverPictureNode = [[ASNetworkImageNode alloc] init];
    _coverPictureNode.frame = CGRectMake(0, 0, coverSize.width, coverSize.height);
    _coverPictureNode.layerBacked = YES;
    _coverPictureNode.placeholderColor = BM_HEX_RGBA(0x121112, 0.6);
    _coverPictureNode.style.preferredSize = coverSize;
    _coverPictureNode.layer.cornerRadius =BM_FitW(500)/2.0;
    _coverPictureNode.layer.masksToBounds = YES;
    _coverPictureNode.contentMode = UIViewContentModeScaleAspectFill;
    _coverPictureNode.placeholderFadeDuration = 3;
    __weak __typeof(self)weakSelf = self;
    _coverPictureNode.imageModificationBlock = ^UIImage * _Nullable(UIImage * _Nonnull image) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [image getPaletteImageColor:^(PaletteColorModel *recommendColor, NSDictionary *allModeColorDic, NSError *error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    weakSelf.coverPictureShadowNode.layer.shadowColor = [UIColor bm_colorWithHexString:recommendColor.imageColorString].CGColor;
                    weakSelf.coverPictureShadowNode.layer.shadowOffset = CGSizeMake(0,10);
                    weakSelf.coverPictureShadowNode.shadowRadius = 29;
                    weakSelf.coverPictureShadowNode.shadowOpacity = 0.5;
                    
                    for (CALayer *layer in weakSelf.rippleArray) {
                        layer.borderColor = [UIColor bm_colorWithHexString:recommendColor.imageColorString].CGColor;
                    }
                    for (CALayer *layer in weakSelf.rippleCircleArray) {
                        layer.backgroundColor = [UIColor bm_colorWithHexString:recommendColor.imageColorString].CGColor;
                    }
                });
            }];
        });
        CGRect circleRect = (CGRect) {CGPointZero, CGSizeMake(image.size.width, image.size.height)};
        UIGraphicsBeginImageContextWithOptions(circleRect.size, NO, 0);
        UIBezierPath *circle = [UIBezierPath bezierPathWithRoundedRect:circleRect cornerRadius:circleRect.size.width/2];
        [circle addClip];
        [[UIColor whiteColor] set];
        [circle fill];
        [image drawInRect:circleRect];
        UIImage *roundedImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return roundedImage;
    };
    [_coverPictureShadowNode addSubnode:_coverPictureNode];
    
    
    _stopBtnNode = [[ASButtonNode alloc] init];
    [_stopBtnNode setImage:[UIImage imageNamed:@"stop_icon"] forState:UIControlStateNormal];
    [_stopBtnNode addTarget:self action:@selector(stopBtnNodeClicked) forControlEvents:ASControlNodeEventTouchUpInside];
    [self addSubnode:_stopBtnNode];
    
    _palybtnNode = [[ASButtonNode alloc] init];
    _palybtnNode.selected = YES;
    _palybtnNode.style.preferredSize = CGSizeMake(50, 50);
    _palybtnNode.contentMode = UIViewContentModeScaleAspectFit;
    _palybtnNode.imageNode.layer.masksToBounds = NO;
    [_palybtnNode setImage:[UIImage imageNamed:@"player_icon"] forState:UIControlStateNormal];
    [_palybtnNode setImage:[UIImage imageNamed:@"pause_icon"] forState:UIControlStateSelected];
    [_palybtnNode addTarget:self action:@selector(palybtnNodeClicked) forControlEvents:ASControlNodeEventTouchUpInside];
    [self addSubnode:_palybtnNode];
    
    _loadingView = [LOTAnimationView animationNamed:@"loader" inBundle:[NSBundle mainBundle]];
    _loadingView.bm_X = 0;
    _loadingView.bm_Y = 0;
    _loadingView.bm_Size = CGSizeMake(50, 50);
    [_loadingView play];
    _loadingView.hidden = YES;
    _loadingView.loopAnimation = YES;
    [_palybtnNode.view addSubview:_loadingView];
    
    _timerNode = [[ASButtonNode alloc] init];
    [_timerNode setImage:[UIImage imageNamed:@"countdown_icon"] forState:UIControlStateNormal];
    [_timerNode addTarget:self action:@selector(timerNodeClicked) forControlEvents:ASControlNodeEventTouchUpInside];
    [self addSubnode:_timerNode];
    
    _timingNode = [[BMMusicTimerNode alloc] init];
    _timingNode.timeLabelNode.attributedText = [[NSAttributedString alloc] initWithString:@"30:00" attributes:@{NSFontAttributeName:BM_CLAM_BOLD_FONT(15),NSForegroundColorAttributeName:BM_HEX_RGBA(0xffffff, 1)}];
    _timingNode.contentMode = UIViewContentModeCenter;
    [_timingNode addTarget:self action:@selector(timerNodeClicked) forControlEvents:ASControlNodeEventTouchUpInside];
    [self addSubnode:_timingNode];
}

#pragma mark ——— 外部方法

- (void)updateLoading:(BOOL)loading {
    if (loading) {
        self.loadingView.hidden = NO;
        [self.loadingView play];
        self.palybtnNode.imageNode.hidden = YES;
        self.palybtnNode.userInteractionEnabled = NO;
    }else {
        self.loadingView.hidden = YES;
         [self.loadingView pause];
        self.palybtnNode.imageNode.hidden = NO;
        self.palybtnNode.userInteractionEnabled = YES;
    }
}
- (void)setModel:(BMItemModel *)model {
    _model = model;
    _imageBackGroudNode.URL = [NSURL URLWithString:model.picUrl];
    _coverPictureNode.URL = [NSURL URLWithString:model.picUrl];
    _titileTextNode.attributedText = [[NSAttributedString alloc] initWithString:BMDefultString(model.title, @"") attributes:@{NSFontAttributeName:BM_CLAM_BOLD_FONT(18),NSForegroundColorAttributeName:BM_HEX_RGBA(0xffffff, 1)}];
}

- (void)updateCoverPictureRotating {
    if (!_palybtnNode.selected) {
        // 停止动画
        CFTimeInterval pausedTime = [self.coverPictureNode.layer convertTime:CACurrentMediaTime() fromLayer:nil];
        self.coverPictureNode.layer.speed = 0.0;
        self.coverPictureNode.layer.timeOffset = pausedTime;
        _animationLayer.hidden = YES;
    }else {
        CFTimeInterval pausedTime = [self.coverPictureNode.layer timeOffset];
        self.coverPictureNode.layer.speed = 1.0;
        self.coverPictureNode.layer.timeOffset = 0.0;
        self.coverPictureNode.layer.beginTime = 0.0;
        CFTimeInterval timeSincePause = [self.coverPictureNode.layer convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime;
        self.coverPictureNode.layer.beginTime = timeSincePause;
        _animationLayer.hidden = NO;
    }
}
- (void)playBtnSelected:(BOOL)select {
    _palybtnNode.selected = select;
}

- (void)updateTimerNodeWith:(NSTimeInterval)time {
    // 定时器
    if (time > 0) {
        self.isTiming = YES;
        self.timerNode.hidden = YES;
        self.timingNode.hidden = NO;
        NSString *timeMMss = [NSString bm_timeIntervalToMMSSFormat:time];
        _timingNode.timeLabelNode.attributedText = [[NSAttributedString alloc] initWithString:timeMMss attributes:@{NSFontAttributeName:BM_CLAM_BOLD_FONT(15),NSForegroundColorAttributeName:BM_HEX_RGBA(0xffffff, 1)}];
    }else {
        self.isTiming = NO;
        self.timerNode.hidden = NO;
        self.timingNode.hidden = YES;
        _timingNode.timeLabelNode.attributedText = [[NSAttributedString alloc] initWithString:@"00:00" attributes:@{NSFontAttributeName:BM_CLAM_BOLD_FONT(15),NSForegroundColorAttributeName:BM_HEX_RGBA(0xffffff, 1)}];
    }
    [self setNeedsLayout];
}

#pragma mark ——— action
- (void)stopBtnNodeClicked {
    _stopBtnNode.selected = !_stopBtnNode.selected;
    if (self.delegate && [self.delegate respondsToSelector:@selector(BMMusicDisplayNode:didClickedStopBtnNode:)]) {
        [self.delegate BMMusicDisplayNode:self didClickedStopBtnNode:self.stopBtnNode];
    }
}
- (void)palybtnNodeClicked {
    _palybtnNode.selected = !_palybtnNode.selected;
    if (self.delegate && [self.delegate respondsToSelector:@selector(BMMusicDisplayNode:didClickedPalybtnNode:)]) {
        [self.delegate BMMusicDisplayNode:self didClickedPalybtnNode:self.palybtnNode];
    }
}
- (void)timerNodeClicked {
    _timerNode.selected = !_timerNode.selected;
    if (self.delegate && [self.delegate respondsToSelector:@selector(BMMusicDisplayNode:didClickedTimerNode:)]) {
        [self.delegate BMMusicDisplayNode:self didClickedTimerNode:self.timerNode];
    }
}




@end
