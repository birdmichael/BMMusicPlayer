//
//  BMMusicSelectTimerNode.m
//  Calm
//
//  Created by BirdMichael on 2018/10/22.
//  Copyright © 2018 BirdMichael. All rights reserved.
//

#import "BMMusicSelectTimerNode.h"
#import <AsyncDisplayKit/AsyncDisplayKit.h>

static const CGFloat kMusicSelectTimerNodePading = 15;

@interface BMMusicSelectTimerNode () <ASCollectionDelegate, ASCollectionDataSource>
@property (nonatomic, strong) ASButtonNode *converBtnNode;
@property (nonatomic, strong) ASCollectionNode *selectCollectNode;
@property (nonatomic, strong) NSMutableArray<BMMusicSelectTimerItem *> *dataArray;
@end

@implementation BMMusicSelectTimerNode

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupView];
    }
    return self;
}

- (void)setupView {
    _converBtnNode = [[ASButtonNode alloc] init];
    _converBtnNode.backgroundColor = BM_HEX_RGBA(0x000000, 0.8);
    [_converBtnNode addTarget:self action:@selector(dismiss) forControlEvents:ASControlNodeEventTouchUpInside];
    [self addSubnode:_converBtnNode];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.sectionInset = UIEdgeInsetsMake(0, kMusicSelectTimerNodePading, 0, kMusicSelectTimerNodePading);
    layout.minimumInteritemSpacing = kMusicSelectTimerNodePading; //列间距
    _selectCollectNode = [[ASCollectionNode alloc] initWithCollectionViewLayout:layout];
    _selectCollectNode.backgroundColor = BM_HEX_RGB(0x121112);
    _selectCollectNode.dataSource = self;
    _selectCollectNode.delegate = self;
    _selectCollectNode.accessibilityIdentifier = @"BMHelpSleepViewControllerASCollectionNode";
    [self addSubnode:_selectCollectNode];
    
    NSMutableArray *array = [[BMMusicSelectTimerItem getData] mutableCopy];
    [array removeObjectAtIndex:0];
    self.dataArray = array;
}
- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize {
    ASWrapperLayoutSpec *wrapperLayout = [ASWrapperLayoutSpec wrapperWithLayoutElement:self.converBtnNode];
    _selectCollectNode.style.preferredSize = CGSizeMake(kBMSCREEN_WIDTH, 120);
    ASInsetLayoutSpec *insetSpec = [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(INFINITY, 0, 0, 0) child:self.selectCollectNode];
    ASOverlayLayoutSpec *overSpec = [ASOverlayLayoutSpec overlayLayoutSpecWithChild:wrapperLayout overlay:insetSpec];
    return overSpec;
}

#pragma mark ——— action
- (void)dismiss {
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
    }];
}

- (ASCellNode *)collectionNode:(ASCollectionNode *)collectionNode nodeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    ASCellNode *node = [[ASCellNode alloc] init];
    node.cornerRadius = 35;
    node.backgroundColor = BM_HEX_RGB(0x201F24);
    ASTextNode2 *textNode = [[ASTextNode2 alloc] init];
    textNode.attributedText = [[NSAttributedString alloc] initWithString:self.dataArray[indexPath.row].title attributes:@{NSFontAttributeName:BM_CLAM_BOLD_FONT(15),NSForegroundColorAttributeName:BM_HEX_RGBA(0xffffff, 1)}];
    [node addSubnode:textNode];
    textNode.layerBacked = YES;
    node.layoutSpecBlock = ^ASLayoutSpec * _Nonnull(__kindof ASDisplayNode * _Nonnull node, ASSizeRange constrainedSize) {
        ASCenterLayoutSpec *center = [ASCenterLayoutSpec centerLayoutSpecWithCenteringOptions:ASCenterLayoutSpecCenteringXY sizingOptions:ASCenterLayoutSpecSizingOptionDefault child:textNode];
        return center;
    };
    return node;
}
- (void)collectionNode:(ASCollectionNode *)collectionNode didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.selectBlock) {
        BMMusicSelectTimerItem *item = self.dataArray[indexPath.row];
        self.selectBlock(item);
    }
    [self dismiss];
}

- (id)collectionNode:(ASCollectionNode *)collectionNode nodeModelForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return self.dataArray[indexPath.item];
}

- (ASSizeRange)collectionNode:(ASCollectionNode *)collectionNode constrainedSizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return ASSizeRangeMake(CGSizeMake(70, 70), CGSizeMake(70, 70));
}

- (NSInteger)collectionNode:(ASCollectionNode *)collectionNode numberOfItemsInSection:(NSInteger)section
{
    return [self.dataArray count];
}

- (NSInteger)numberOfSectionsInCollectionNode:(ASCollectionNode *)collectionNode
{
    return 1;
}

#pragma mark ——— setter and getter
- (void)setIsTiming:(BOOL)isTiming {
    _isTiming = isTiming;
    if (!isTiming) {
        NSMutableArray *array = [[BMMusicSelectTimerItem getData] mutableCopy];
        [array removeObjectAtIndex:0];
        self.dataArray = array;
    }else {
        self.dataArray = [BMMusicSelectTimerItem getData];
    }
    [self.selectCollectNode reloadData];
}


@end
