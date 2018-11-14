//
//  BMHelpSleepViewSgementItemNode.h
//  Calm
//
//  Created by BirdMichael on 2018/10/23.
//  Copyright © 2018 BirdMichael. All rights reserved.
//

#import <AsyncDisplayKit/AsyncDisplayKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BMHelpSleepViewSgementItemNode : ASButtonNode

- (void)updateImage:(UIImage *)image selectImage:(UIImage *)selectImage title:(NSString *)title;

@end

NS_ASSUME_NONNULL_END
