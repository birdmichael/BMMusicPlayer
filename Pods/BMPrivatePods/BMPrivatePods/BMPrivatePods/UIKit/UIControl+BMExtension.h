//
//  UIControl+BMExtension.h
//  Pods
//
//  Created by BirdMichael on 2018/10/3.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIControl (BMExtension)

- (void)bm_touchDown:(void (^)(void))eventBlock;
- (void)bm_touchDownRepeat:(void (^)(void))eventBlock;
- (void)bm_touchDragInside:(void (^)(void))eventBlock;
- (void)bm_touchDragOutside:(void (^)(void))eventBlock;
- (void)bm_touchDragEnter:(void (^)(void))eventBlock;
- (void)bm_touchDragExit:(void (^)(void))eventBlock;
- (void)bm_touchUpInside:(void (^)(void))eventBlock;
- (void)bm_touchUpOutside:(void (^)(void))eventBlock;
- (void)bm_touchCancel:(void (^)(void))eventBlock;
- (void)bm_valueChanged:(void (^)(void))eventBlock;
- (void)bm_editingDidBegin:(void (^)(void))eventBlock;
- (void)bm_editingChanged:(void (^)(void))eventBlock;
- (void)bm_editingDidEnd:(void (^)(void))eventBlock;
- (void)bm_editingDidEndOnExit:(void (^)(void))eventBlock;

@end

NS_ASSUME_NONNULL_END
