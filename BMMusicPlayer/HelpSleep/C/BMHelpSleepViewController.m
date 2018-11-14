//
//  BMHelpSleepViewController.m
//  Calm
//
//  Created by BirdMichael on 2018/10/16.
//  Copyright © 2018 BirdMichael. All rights reserved.
//

#import "BMHelpSleepViewController.h"
#import <AsyncDisplayKit/AsyncDisplayKit.h>
#import "BMHelpSleepCellNode.h"
#import <GPUImage/GPUImage.h>
#import "BMHelpSleepViewSgementItemNode.h"
#import "BMNavViewController.h"
#import "BMSleepModel.h"
#import "BMHttpManager.h"

static const NSInteger BMHelpSleepViewControllerTitleH = 162;
// 页面分类
typedef NS_ENUM(NSInteger,  BMHelpSleepViewControllerPageType) {
    BMHelpSleepViewControllerPageTypeHypnosis,
    BMHelpSleepViewControllerPageTypeStories,
    BMHelpSleepViewControllerPageTypeMusic
};

@interface BMHelpSleepViewController () <ASCollectionDataSource, ASCollectionDelegate, ASCollectionDelegateFlowLayout>
@property (nonatomic, strong) ASCollectionNode *collectionNode;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, copy) NSArray *sgementItems;
@property (nonatomic, assign) BMHelpSleepViewControllerPageType pageType;
@property (nonatomic, strong) BMSleepModel *model;
@end

@implementation BMHelpSleepViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self settupCollectionView];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubnode:_collectionNode];
    [self setupTitleView];
    __weak __typeof(self)weakSelf = self;
    [[BMHttpManager sharedInstance] getSleep:^(BMSleepModel * _Nonnull model) {
        weakSelf.model = model;
        [weakSelf updatePageDateArray];
    }];
    // 不会被销毁 不用移除
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(purchaseSuccess) name:kPURCHASE_SUCCESS_NOTIFICATION object:nil];
}


#pragma mark ——— 私有方法
- (void)purchaseSuccess {
    [self.collectionNode reloadData];
}

- (void)updatePageDateArray {
    switch (self.pageType) {
        case BMHelpSleepViewControllerPageTypeHypnosis:
            self.dataArray = self.model.hypnosisData;
            break;
        case BMHelpSleepViewControllerPageTypeStories:
            self.dataArray = self.model.storiesData;
            break;
        case BMHelpSleepViewControllerPageTypeMusic:
            self.dataArray = self.model.musicData;
            break;
            
        default:
            break;
    }
    [self.collectionNode reloadData];
}
- (void)settupCollectionView {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.sectionInset = UIEdgeInsetsMake(0, kHelpSleepHorizontalSectionPadding, kBMAppHomeCollectionBottomInset, kHelpSleepHorizontalSectionPadding);
    layout.minimumLineSpacing = 30;// 行间距
    layout.minimumInteritemSpacing = kHelpSleepHorizontalSectionPadding; //列间距
    _collectionNode = [[ASCollectionNode alloc] initWithCollectionViewLayout:layout];
    _collectionNode.dataSource = self;
    _collectionNode.delegate = self;
    _collectionNode.accessibilityIdentifier = @"BMHelpSleepViewControllerASCollectionNode";
    
    ASRangeTuningParameters preloadTuning;
    preloadTuning.leadingBufferScreenfuls = 2;
    preloadTuning.trailingBufferScreenfuls = 1;
    [_collectionNode setTuningParameters:preloadTuning forRangeType:ASLayoutRangeTypePreload];
    [_collectionNode.view setBackgroundColor:[UIColor clearColor]];
    
    ASRangeTuningParameters displayTuning;
    displayTuning.leadingBufferScreenfuls = 1;
    displayTuning.trailingBufferScreenfuls = 0.5;
    [_collectionNode setTuningParameters:displayTuning forRangeType:ASLayoutRangeTypeDisplay];
    _collectionNode.frame =  CGRectMake(0, BMHelpSleepViewControllerTitleH + kBMStatusBarHeight, kBMSCREEN_WIDTH, BM_HEIGHT(self.view)- BMHelpSleepViewControllerTitleH - kBMStatusBarHeight);
    
}

- (void)setupTitleView {
    UIView *titeleBackgroud = [UIView new];
    [self.view addSubview:titeleBackgroud];
    [titeleBackgroud mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.mas_equalTo(BMHelpSleepViewControllerTitleH + kBMStatusBarHeight);
    }];
    
    
    UILabel *label = [UILabel new];
    label.text = @"Sleep";
    label.font = BM_CLAM_BOLD_FONT(21);
    label.textColor = [UIColor whiteColor];
    [titeleBackgroud addSubview:label];
    label.textAlignment = NSTextAlignmentCenter;
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(titeleBackgroud);
        make.top.mas_equalTo(28 + kBMStatusBarHeight);
    }];
    
    [titeleBackgroud layoutIfNeeded];
    
    ASDisplayNode *content = [[ASDisplayNode alloc] init];
    content.backgroundColor = [UIColor clearColor];
    content.frame = CGRectMake(0, label.bm_BottomEdge, kBMSCREEN_WIDTH, titeleBackgroud.bm_Height - label.bm_BottomEdge);
    //    content.layerBacked = YES;
    [titeleBackgroud addSubnode:content];
    
    
    BMHelpSleepViewSgementItemNode *hypnosis = [[BMHelpSleepViewSgementItemNode alloc] init];
    hypnosis.accessibilityIdentifier = @"Hypnosis";
    [hypnosis addTarget:self action:@selector(sgementItemClicked:) forControlEvents:ASControlNodeEventTouchUpInside];
    [hypnosis updateImage:[UIImage imageNamed:@"hypnosis_icon"] selectImage:[UIImage imageNamed:@"hypnosis_icon_select"] title:@"Hypnosis"];
    [content addSubnode:hypnosis];
    hypnosis.style.preferredSize = CGSizeMake(80, 75);
    
    BMHelpSleepViewSgementItemNode *stories = [[BMHelpSleepViewSgementItemNode alloc] init];
    stories.accessibilityIdentifier = @"Stories";
    [stories addTarget:self action:@selector(sgementItemClicked:) forControlEvents:ASControlNodeEventTouchUpInside];
    [stories updateImage:[UIImage imageNamed:@"stories_icon"] selectImage:[UIImage imageNamed:@"stories_icon_select"] title:@"Stories"];
    [content addSubnode:stories];
    stories.selected = YES;
    self.pageType = BMHelpSleepViewControllerPageTypeStories;
    stories.style.preferredSize = CGSizeMake(80, 75);
    
    BMHelpSleepViewSgementItemNode *music = [[BMHelpSleepViewSgementItemNode alloc] init];
    music.accessibilityIdentifier = @"Music";
    [music addTarget:self action:@selector(sgementItemClicked:) forControlEvents:ASControlNodeEventTouchUpInside];
    [music updateImage:[UIImage imageNamed:@"music_icon"] selectImage:[UIImage imageNamed:@"music_icon_select"] title:@"Music"];
    [content addSubnode:music];
    music.style.preferredSize = CGSizeMake(80, 75);
    
    content.layoutSpecBlock = ^ASLayoutSpec * _Nonnull(__kindof ASDisplayNode * _Nonnull node, ASSizeRange constrainedSize) {
        return [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionHorizontal spacing:0 justifyContent:ASStackLayoutJustifyContentSpaceAround alignItems:ASStackLayoutAlignItemsCenter children:@[hypnosis,stories,music]];
    };
    self.sgementItems = @[hypnosis,stories,music];
    
}

- (void)addBackBroundImageNode {
    ASImageNode *bgImageView = [[ASImageNode alloc] init];
    bgImageView.placeholderColor = KBM_CLAM_BACKGROUND_COLER;
//    bgImageView.image = [UIImage imageNamed:@"homeBg"];
    bgImageView.contentMode = UIViewContentModeScaleToFill;
    bgImageView.placeholderFadeDuration = 3;
    bgImageView.frame = CGRectMake(0, 0, kBMSCREEN_WIDTH, BM_HEIGHT(self.view));
    bgImageView.imageModificationBlock = ^UIImage * _Nullable(UIImage * _Nonnull image) {
        GPUImageGaussianSelectiveBlurFilter *filter = [[GPUImageGaussianSelectiveBlurFilter alloc] init];
        filter.blurRadiusInPixels = 30.0;
        filter.excludeCircleRadius = 20 / 320.0;
        [filter forceProcessingAtSize:image.size];
        GPUImagePicture *pic = [[GPUImagePicture alloc] initWithImage:image];
        [pic addTarget:filter];
        [pic processImage];
        [filter useNextFrameForImageCapture];
        return [filter imageFromCurrentFramebuffer];
    };
    [self.view addSubnode:bgImageView];
}




#pragma mark - ASCollectionNodeDelegate / ASCollectionNodeDataSource

- (ASCellNodeBlock)collectionNode:(ASCollectionNode *)collectionNode nodeBlockForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return ^{
        BMHelpSleepCellNode *node = [[BMHelpSleepCellNode alloc] init];
        return node;
    };
}

- (id)collectionNode:(ASCollectionNode *)collectionNode nodeModelForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return self.dataArray[indexPath.item];
}

- (ASSizeRange)collectionNode:(ASCollectionNode *)collectionNode constrainedSizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return ASSizeRangeMake([BMHelpSleepCellNode preferredViewSize], [BMHelpSleepCellNode preferredViewSize]);
}

- (NSInteger)collectionNode:(ASCollectionNode *)collectionNode numberOfItemsInSection:(NSInteger)section
{
    return [self.dataArray count];
}

- (NSInteger)numberOfSectionsInCollectionNode:(ASCollectionNode *)collectionNode
{
    return 1;
}

- (void)collectionNode:(ASCollectionNode *)collectionNode didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    
    BMMusicViewController *vc = [BMMusicViewController sharedInstance];
    [vc updatePlayArray:@[self.dataArray[indexPath.row]] index:0];
    [self presentViewController:vc animated:YES completion:nil];
}

#pragma mark ——— action
- (void)sgementItemClicked:(ASButtonNode *)btn {
    // 更新选中状态
    for (ASButtonNode *node in self.sgementItems) {
        if ([node.accessibilityIdentifier isEqualToString:btn.accessibilityIdentifier]) {
            node.selected = YES;
        }else {
            node.selected = NO;
        }
    }
    // 设置type
    self.pageType = [self.sgementItems indexOfObject:btn];
    if (self.model) {
        [self updatePageDateArray];
    }
    
}

@end
