//
//  BMMusicDisplayNode.h
//  Calm
//
//  Created by BirdMichael on 2018/10/20.
//  Copyright © 2018 BirdMichael. All rights reserved.
//



NS_ASSUME_NONNULL_BEGIN

@class BMMusicDisplayNode;
@protocol BMMusicDisplayNodeDelegate <NSObject>
@optional
- (void)BMMusicDisplayNode:(BMMusicDisplayNode *)node didClickedStopBtnNode:(ASButtonNode *)btnNode;
- (void)BMMusicDisplayNode:(BMMusicDisplayNode *)node didClickedPalybtnNode:(ASButtonNode *)btnNode;
- (void)BMMusicDisplayNode:(BMMusicDisplayNode *)node didClickedTimerNode:(ASButtonNode *)btnNode;
@end

@interface BMMusicDisplayNode : ASDisplayNode

@property (nonatomic, weak) id<BMMusicDisplayNodeDelegate> delegate;
@property (nonatomic, strong) BMItemModel* model;
@property (nonatomic, strong, readonly) ASButtonNode* palybtnNode;


- (void)updateCoverPictureRotating;
- (void)updateLoading:(BOOL)loading;
- (void)playBtnSelected:(BOOL)select;
- (void)updateTimerNodeWith:(NSTimeInterval)time;

@end

NS_ASSUME_NONNULL_END
