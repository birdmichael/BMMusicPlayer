//
//  BMMusicTimerNode.m
//  Calm
//
//  Created by BirdMichael on 2018/10/22.
//  Copyright © 2018 BirdMichael. All rights reserved.
//  播放器定时器按钮（定时中）

#import "BMMusicTimerNode.h"
#import <AsyncDisplayKit/AsyncDisplayKit.h>

@interface BMMusicTimerNode ()
@property (nonatomic, strong) ASImageNode *topNode, *downNode;

@end

@implementation BMMusicTimerNode


- (instancetype)init
{
    self = [super init];
    if (self) {
        _timeLabelNode = [[ASTextNode2 alloc] init];
//        _timeLabelNode.layerBacked = YES;
        [self addSubnode:_timeLabelNode];
        
        _topNode = [[ASImageNode alloc] init];
        _topNode.image = [UIImage imageNamed:@"countdown_up"];
        [self addSubnode:_topNode];
        
        _downNode = [[ASImageNode alloc] init];
        _downNode.image = [UIImage imageNamed:@"countdown_bottom"];
        [self addSubnode:_downNode];
    }
    return self;
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize {
    ASStackLayoutSpec *spc =
    [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionVertical
                                            spacing:2
                                     justifyContent:ASStackLayoutJustifyContentCenter
                                         alignItems:ASStackLayoutAlignItemsCenter
                                           children:@[_topNode,_timeLabelNode,_downNode]];
    return spc;
}

@end
