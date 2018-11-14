//
//  BMMusicBar.h
//  Calm
//
//  Created by BirdMichael on 2018/10/17.
//  Copyright © 2018 BirdMichael. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BMItemModel.h"

NS_ASSUME_NONNULL_BEGIN

static const CGFloat kMusicBarH = 60;

@class ASButtonNode;
typedef void (^BMMusicBarClickedPalyBtnNode)(ASButtonNode *btnNode);
@interface BMMusicBar : UIView

@property (nonatomic, copy) BMMusicBarClickedPalyBtnNode playBtnClickedBlock;
@property (nonatomic, strong) BMItemModel* model;

BM_UNAVAILABLE_UIVIEW_INITIALIZER

- (instancetype)initWithViewController:(UIViewController *)vc;  // 仅让单利播放器初始化并一直持有
- (void)updateCoverPictureRotating;
- (void)playBtnSelected:(BOOL)select;
- (void)updateSliderWithValue:(double)value;
- (void)updateTimeLabel:(NSString *)time;
- (void)updateNameLabel:(NSString *)name;
@end

NS_ASSUME_NONNULL_END
