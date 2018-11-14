//
//  BMMusicBar.m
//  Calm
//
//  Created by BirdMichael on 2018/10/17.
//  Copyright © 2018 BirdMichael. All rights reserved.
//

#import "BMMusicBar.h"
#import <AsyncDisplayKit/AsyncDisplayKit.h>
#import "BMMusicSlider.h"
#import <AsyncDisplayKit/AsyncDisplayKit.h>
#import "BMMusicViewController.h"
#import "ASButtonNode+BMExtension.h"

@interface BMMusicBar ()
@property (nonatomic,strong) ASDisplayNode *contentNode;
/** 图片 */
@property (nonatomic, strong) ASNetworkImageNode *musicCoverImageNode;
/** 歌曲名称 */
@property (nonatomic, strong) ASTextNode2 *musicNameNode;
/** 当前播放时长 */
@property (nonatomic, strong) ASTextNode2 *currentDuationNode;
/** 当前播放进度条 */
@property (nonatomic, strong) ASDisplayNode *currentDuationSliderNode;
/** 播放暂停按钮 */
@property (nonatomic, strong) ASButtonNode *playButtonNode;

@property (nonatomic, strong) BMMusicSlider *progressSlider;
@end

static const CGFloat kMusicBarImageH = 65;

@implementation BMMusicBar

- (instancetype)initWithViewController:(UIViewController *)vc {
    NSAssert([vc isKindOfClass:[BMMusicViewController class]], @"滚犊子，不看注释的么？");
    self = [super initWithFrame:CGRectMake(30, 0, kBMSCREEN_WIDTH - 60, kMusicBarH)];
    if (self) {
        [self setDefaultValue];
        [self setupView];
        [self layoutView];
        [self addSingleTap];
        [self addAnimation];
    }
    return self;
}
- (void)setDefaultValue {
    self.clipsToBounds = NO;
    self.userInteractionEnabled = YES;
    self.backgroundColor = BM_HEX_RGB(0x201F24);
    self.layer.cornerRadius = 15;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _contentNode.frame = self.bounds;
    [_contentNode setNeedsLayout];
}

#pragma mark ——— 私有方法
- (void)addAnimation {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    animation.duration = 10;
    animation.repeatCount = MAXFLOAT;
    animation.removedOnCompletion = NO;
    animation.toValue = @(M_PI*2);
    [self.musicCoverImageNode.layer addAnimation:animation forKey:@"rotationAnimation"];
}

- (void)setupView {
    
    _contentNode = [[ASDisplayNode alloc] init];
    [self addSubnode:_contentNode];
    _contentNode.userInteractionEnabled = YES;
    _contentNode.frame = self.bounds;
    
    _musicCoverImageNode = [[ASNetworkImageNode alloc] init];
//    _musicCoverImageNode.placeholderColor = BM_HEX_RGB(0x201F24);
//    _musicCoverImageNode.placeholderFadeDuration = 2;
    _musicCoverImageNode.frame = CGRectMake(15, -(BM_FitW(kMusicBarImageH*2) - kMusicBarH +15), BM_FitW(kMusicBarImageH*2), BM_FitW(kMusicBarImageH*2));
    _musicCoverImageNode.cornerRadius = BM_FitW(kMusicBarImageH*2)/2;
    [_musicCoverImageNode setPlaceholderColor:BM_HEX_RGB(0x19191b)];
    _musicCoverImageNode.imageModificationBlock = ^UIImage * _Nullable(UIImage * _Nonnull image) {
        CGRect circleRect = (CGRect) {CGPointZero, CGSizeMake(image.size.width +20, image.size.height+20)};
        UIGraphicsBeginImageContextWithOptions(circleRect.size, NO, 0);
        UIBezierPath *circle = [UIBezierPath bezierPathWithRoundedRect:circleRect cornerRadius:circleRect.size.width/2];
        [circle addClip];
        [[UIColor whiteColor] set];
        [circle fill];
        [image drawInRect:circleRect];
        circle.lineWidth = 20;
        [BM_HEX_RGBA(0x201F24, 0.3) set];
        [circle stroke];
        UIImage *roundedImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        return roundedImage;
    };
    [_contentNode addSubnode:_musicCoverImageNode];
    
    _musicNameNode = [[ASTextNode2 alloc] init];
    _musicNameNode.layerBacked = YES;
    _musicNameNode.attributedText = [[NSAttributedString alloc] initWithString:@"Grimms fGrimms fGrimms fGrimms f" attributes:@{NSFontAttributeName:BM_CLAM_BOLD_FONT(15),NSForegroundColorAttributeName:BM_HEX_RGBA(0xffffff, 1)}];
    _musicNameNode.maximumNumberOfLines = 1;
    [_contentNode addSubnode:_musicNameNode];
    
    _currentDuationNode = [[ASTextNode2 alloc] init];
    _currentDuationNode.layerBacked = YES;
    [_contentNode addSubnode:_currentDuationNode];
    _currentDuationNode.attributedText = [[NSAttributedString alloc] initWithString:@"2:11" attributes:@{NSFontAttributeName:BM_CLAM_BOLD_FONT(15),NSForegroundColorAttributeName:BM_HEX_RGBA(0xffffff, 1)}];
    
    __weak __typeof(self)weakSelf = self;
    _currentDuationSliderNode = [[ASDisplayNode alloc] initWithViewBlock:^UIView * _Nonnull{
        // 偷懒用现有带颜色控件
        BMMusicSlider *view = [[BMMusicSlider alloc] init];
        [view setThumbImage:nil forState:UIControlStateNormal];
        view.thumbTintColor = [UIColor clearColor];
        view.userInteractionEnabled = NO;
        view.clipsToBounds = YES;
        return view;
    }];
    [_contentNode addSubnode:_currentDuationSliderNode];
    _currentDuationSliderNode.style.preferredSize = CGSizeMake(30, 5);
    
    _playButtonNode = [[ASButtonNode alloc] init];
    _playButtonNode.selected = YES;
    [_playButtonNode setImage:[UIImage imageNamed:@"little_play_icon"] forState:UIControlStateNormal];
    [_playButtonNode setImage:[UIImage imageNamed:@"little_pause_icon"] forState:UIControlStateSelected];
    [_playButtonNode addTarget:self action:@selector(playButtionClicked:) forControlEvents:ASControlNodeEventTouchUpInside];
    [_contentNode addSubnode:_playButtonNode];
    _playButtonNode.bm_touchAreaInsets = UIEdgeInsetsMake(30, 30, 30, 30);
    
}

- (void)layoutView {
    __weak __typeof(self)weakSelf = self;
    _contentNode.layoutSpecBlock = ^ASLayoutSpec * _Nonnull(__kindof ASDisplayNode * _Nonnull node, ASSizeRange constrainedSize) {
        
        ASStackLayoutSpec *duationSpec = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionVertical spacing:3 justifyContent:ASStackLayoutJustifyContentCenter alignItems:ASStackLayoutAlignItemsCenter children:@[weakSelf.currentDuationNode,weakSelf.currentDuationSliderNode]];
        weakSelf.musicNameNode.style.flexGrow  = 1;
        weakSelf.musicNameNode.style.flexShrink  = 1;
        duationSpec.style.preferredSize = CGSizeMake(40, 40);
        weakSelf.playButtonNode.style.spacingAfter = 20;
        duationSpec.style.spacingAfter = 25;
        weakSelf.musicNameNode.style.spacingBefore = 100;
        ASStackLayoutSpec *steack = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionHorizontal spacing:3 justifyContent:ASStackLayoutJustifyContentEnd alignItems:ASStackLayoutAlignItemsCenter children:@[weakSelf.musicNameNode,duationSpec,weakSelf.playButtonNode]];
        return steack;
    };
}

- (void)addSingleTap {
    // 点击手势，方式误操作，只加载图片和文字上
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(musicBarClicked)];
    [self addGestureRecognizer:singleTap];
    
    // 滑动呼出
    UISwipeGestureRecognizer *swipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(musicBarClicked)];
    swipeRecognizer.direction = UISwipeGestureRecognizerDirectionUp;
    [self addGestureRecognizer:swipeRecognizer];
}


#pragma mark ——— 外部方法
- (void)updateSliderWithValue:(double)value{
    
    [(BMMusicSlider *)self.currentDuationSliderNode.view setValue:0 animated:YES];
    [_contentNode setNeedsDisplay];
    [_currentDuationSliderNode setNeedsDisplay];
}
- (void)updateTimeLabel:(NSString *)time{
    self.currentDuationNode.attributedText = [[NSAttributedString alloc] initWithString:time attributes:@{NSFontAttributeName:BM_CLAM_FONT(12),NSForegroundColorAttributeName:BM_HEX_RGBA(0xffffff, 1)}];
    [_contentNode setNeedsDisplay];
}
- (void)updateNameLabel:(NSString *)name {
    _musicNameNode.attributedText = [[NSAttributedString alloc] initWithString:@"Grimms fGrimms fGrimms fGrimms f" attributes:@{NSFontAttributeName:BM_CLAM_BOLD_FONT(15),NSForegroundColorAttributeName:BM_HEX_RGBA(0xffffff, 1)}];
}
- (void)updateCoverPictureRotating {
    if (!_playButtonNode.selected) {
        CFTimeInterval pausedTime = [self.musicCoverImageNode.layer convertTime:CACurrentMediaTime() fromLayer:nil];
        self.musicCoverImageNode.layer.speed = 0.0;
        self.musicCoverImageNode.layer.timeOffset = pausedTime;
    }else {
        CFTimeInterval pausedTime = [self.musicCoverImageNode.layer timeOffset];
        self.musicCoverImageNode.layer.speed = 1.0;
        self.musicCoverImageNode.layer.timeOffset = 0.0;
        self.musicCoverImageNode.layer.beginTime = 0.0;
        CFTimeInterval timeSincePause = [self.musicCoverImageNode.layer convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime;
        self.musicCoverImageNode.layer.beginTime = timeSincePause;
    }
}

- (void)setModel:(BMItemModel *)model {
    _model = model;
    _musicNameNode.attributedText = [[NSAttributedString alloc] initWithString:BMDefultString(model.title, @"") attributes:@{NSFontAttributeName:BM_CLAM_BOLD_FONT(15),NSForegroundColorAttributeName:BM_HEX_RGBA(0xffffff, 1)}];
    _musicCoverImageNode.URL = [NSURL URLWithString:model.picUrl];
}
- (void)playBtnSelected:(BOOL)select {
    _playButtonNode.selected = select;
}

#pragma mark ——— action
- (void)musicBarClicked {
    [self.bm_viewController presentViewController:[BMMusicViewController sharedInstance] animated:YES completion:nil];
}

- (void)playButtionClicked:(ASButtonNode *)btnNode {
    btnNode.selected = !btnNode.selected;
    if (self.playBtnClickedBlock) {
        self.playBtnClickedBlock(btnNode);
    }
}


#pragma mark ——— setter and getter


@end
