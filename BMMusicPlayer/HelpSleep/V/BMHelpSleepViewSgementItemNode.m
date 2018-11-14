//
//  BMHelpSleepViewSgementItemNode.m
//  Calm
//
//  Created by BirdMichael on 2018/10/23.
//  Copyright © 2018 BirdMichael. All rights reserved.
//

#import "BMHelpSleepViewSgementItemNode.h"
#import <AsyncDisplayKit/AsyncDisplayKit.h>

@interface BMHelpSleepViewSgementItemNode ()
@property (nonatomic, strong) ASImageNode *imageViewnNode;
@property (nonatomic, strong) ASTextNode2 *title;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) UIImage *selectImage;
@end

@implementation BMHelpSleepViewSgementItemNode

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupView];
    }
    return self;
}

- (void)setupView {
    _imageViewnNode = [[ASImageNode alloc] init];
    [self addSubnode:_imageViewnNode];
    _imageViewnNode.layerBacked = YES;
    
    
    _title = [[ASTextNode2 alloc] init];
    _title.layerBacked = YES;
    [self addSubnode:_title];
    
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize {
    _imageViewnNode.style.preferredSize = CGSizeMake(50, 50);
    return [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionVertical spacing:9 justifyContent:ASStackLayoutJustifyContentStart alignItems:ASStackLayoutAlignItemsCenter children:@[_imageViewnNode,_title]];
}

- (void)updateImage:(UIImage *)image selectImage:(UIImage *)selectImage title:(NSString *)title {
    self.image = image;
    _selectImage = selectImage;
    self.imageViewnNode.image = image;
    self.title.attributedText = [[NSAttributedString alloc] initWithString:BMDefultString(title, @"") attributes:@{NSFontAttributeName:BM_CLAM_FONT(15),NSForegroundColorAttributeName:BM_HEX_RGBA(0xffffff, 0.5)}];
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    if (selected) {
        self.imageViewnNode.image = self.selectImage;
        self.title.attributedText = [[NSAttributedString alloc] initWithString:self.title.attributedText.string attributes:@{NSFontAttributeName:BM_CLAM_FONT(15),NSForegroundColorAttributeName:BM_HEX_RGBA(0xffffff, 1)}];
    }else {
        self.imageViewnNode.image = self.image;self.title.attributedText = [[NSAttributedString alloc] initWithString:self.title.attributedText.string attributes:@{NSFontAttributeName:BM_CLAM_FONT(15),NSForegroundColorAttributeName:BM_HEX_RGBA(0xffffff, 0.5)}];
    }
    [self setNeedsLayout];
}

@end
