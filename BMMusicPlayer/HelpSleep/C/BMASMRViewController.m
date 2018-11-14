//
//  BMASMRViewController.m
//  Calm
//
//  Created by BirdMichael on 2018/10/22.
//  Copyright © 2018 BirdMichael. All rights reserved.
//

#import "BMASMRViewController.h"
#import <AsyncDisplayKit/AsyncDisplayKit.h>
#import "BMHelpSleepCellNode.h"
#import <GPUImage/GPUImage.h>
#import "BMHttpManager.h"

static const NSInteger BMASMRViewControllerTitleH = 162;

@interface BMASMRViewController () <ASCollectionDataSource, ASCollectionDelegate, ASCollectionDelegateFlowLayout>
@property (nonatomic, strong) ASCollectionNode *collectionNode;
@property (nonatomic, strong) NSMutableArray *dataArray;
@end

@implementation BMASMRViewController

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
    __weak __typeof(self)weakSelf = self;;
    [[BMHttpManager sharedInstance] getASMR:^(NSArray<BMItemModel *> * _Nonnull modelArray) {
        weakSelf.dataArray = [modelArray mutableCopy];
        [weakSelf.collectionNode reloadData];
    }];
    // 不会被销毁 不用移除
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(purchaseSuccess) name:kPURCHASE_SUCCESS_NOTIFICATION object:nil];
}


#pragma mark ——— 私有方法
- (void)purchaseSuccess {
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
    _collectionNode.accessibilityIdentifier = @"BMASMRViewController";
    
    ASRangeTuningParameters preloadTuning;
    preloadTuning.leadingBufferScreenfuls = 2;
    preloadTuning.trailingBufferScreenfuls = 1;
    [_collectionNode setTuningParameters:preloadTuning forRangeType:ASLayoutRangeTypePreload];
    [_collectionNode.view setBackgroundColor:[UIColor clearColor]];
    
    ASRangeTuningParameters displayTuning;
    displayTuning.leadingBufferScreenfuls = 1;
    displayTuning.trailingBufferScreenfuls = 0.5;
    [_collectionNode setTuningParameters:displayTuning forRangeType:ASLayoutRangeTypeDisplay];
    _collectionNode.frame =  CGRectMake(0, BMASMRViewControllerTitleH + kBMStatusBarHeight, kBMSCREEN_WIDTH, BM_HEIGHT(self.view)- BMASMRViewControllerTitleH - kBMStatusBarHeight);
    
}

- (void)setupTitleView {
    UIView *titeleBackgroud = [UIView new];
    [self.view addSubview:titeleBackgroud];
    titeleBackgroud.frame = CGRectMake(0, 0, kBMSCREEN_WIDTH, BMASMRViewControllerTitleH + kBMStatusBarHeight);
    
    
    
    UILabel *label = [UILabel new];
    label.text = @"ASMR";
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
    
    ASImageNode *imageNode = [[ASImageNode alloc] init];
    imageNode.image = [UIImage imageNamed:@"headphone_icon"];
    imageNode.layerBacked = YES;
    [content addSubnode:imageNode];
    
    
    
    ASTextNode2 *textNode = [[ASTextNode2 alloc] init];
    textNode.style.alignSelf = ASStackLayoutAlignSelfCenter;
    textNode.maximumNumberOfLines = 2;
    textNode.attributedText = [[NSAttributedString alloc] initWithString:@"For the best experience, please wear headphones" attributes:@{NSFontAttributeName:BM_CLAM_FONT(15),NSForegroundColorAttributeName:BM_HEX_RGBA(0xffffff, 1)}];
//    textNode.layerBacked = YES;
    
    
    ASDisplayNode *textContent = [[ASDisplayNode alloc] init];
    textContent.style.preferredSize = CGSizeMake(BM_FitW(480), 60);
    [content addSubnode:textContent];
    [textContent addSubnode:textNode];
    textContent.layoutSpecBlock = ^ASLayoutSpec * _Nonnull(__kindof ASDisplayNode * _Nonnull node, ASSizeRange constrainedSize) {
        return [ASCenterLayoutSpec centerLayoutSpecWithCenteringOptions:ASCenterLayoutSpecCenteringXY sizingOptions:ASCenterLayoutSpecSizingOptionDefault child:textNode];
    };
    
    content.layoutSpecBlock = ^ASLayoutSpec * _Nonnull(__kindof ASDisplayNode * _Nonnull node, ASSizeRange constrainedSize) {
        imageNode.style.spacingBefore = BM_FitW(30);
        textContent.style.spacingBefore = BM_FitW(46);
        return [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionHorizontal spacing:0 justifyContent:ASStackLayoutJustifyContentStart alignItems:ASStackLayoutAlignItemsCenter children:@[imageNode,textContent]];
    };
    
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

- (void)collectionNode:(ASCollectionNode *)collectionNode didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    BMItemModel *model = self.dataArray[indexPath.row];
    BMMusicViewController *vc = [BMMusicViewController sharedInstance];
    [vc updatePlayArray:@[model] index:0];
    [self presentViewController:vc animated:YES completion:nil];;
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

@end
