//
//  BMHelpSleepCellNode.h
//  Calm
//
//  Created by BirdMichael on 2018/10/16.
//  Copyright © 2018 BirdMichael. All rights reserved.
//

#import <AsyncDisplayKit/AsyncDisplayKit.h>

NS_ASSUME_NONNULL_BEGIN

static const CGFloat kHelpSleepHorizontalSectionPadding = 10;
static const CGFloat kBMHelpSleepCellBottomTextFitH = 50;


@interface BMHelpSleepCellNode : ASCellNode

+ (CGSize)preferredViewSize;
- (void)updateLabels;

@end


#pragma mark ———  BMHelpSleepCellNodeStyles

@interface BMHelpSleepCellNodeStyles : NSObject
+ (NSDictionary *)titleStyle;
+ (NSDictionary *)desTextNodeStyle;
+ (NSDictionary *)iconNodeStyle;
+ (UIImage *)placeholderImage;
+ (UIImage *)lockImage;
@end

NS_ASSUME_NONNULL_END
