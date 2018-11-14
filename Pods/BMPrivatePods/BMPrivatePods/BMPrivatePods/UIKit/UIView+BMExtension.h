//
//  UIView+BMExtension.h
//  Pods
//
//  Created by BirdMichael on 2018/10/3.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, BMShakeDirection) {
    BMShakeDirectionHorizontal = 0,
    BMShakeDirectionVertical
};

NS_ASSUME_NONNULL_BEGIN

@interface UIView (BMExtension)

- (id)bm_findSubViewWithSubViewClass:(Class)clazz;
- (id)bm_findSuperViewWithSuperViewClass:(Class)clazz;
@property (readonly) UIViewController *bm_viewController;

#pragma mark ——— shake
- (void)bm_shake;
- (void)bm_shake:(int)times withDelta:(CGFloat)delta;
- (void)bm_shake:(int)times withDelta:(CGFloat)delta completion:(void((^)(void)))handler;
- (void)bm_shake:(int)times withDelta:(CGFloat)delta speed:(NSTimeInterval)interval;
- (void)bm_shake:(int)times withDelta:(CGFloat)delta speed:(NSTimeInterval)interval completion:(void((^)(void)))handler;
- (void)bm_shake:(int)times withDelta:(CGFloat)delta speed:(NSTimeInterval)interval shakeDirection:(BMShakeDirection)shakeDirection;
- (void)bm_shake:(int)times withDelta:(CGFloat)delta speed:(NSTimeInterval)interval shakeDirection:(BMShakeDirection)shakeDirection completion:(void(^)(void))completion;


#pragma mark ——— frame

typedef enum{
    BMViewAlignmentTopLeft,
    BMViewAlignmentTopCenter,
    BMViewAlignmentTopRight,
    BMViewAlignmentMiddleLeft,
    BMViewAlignmentCenter,
    BMViewAlignmentMiddleRight,
    BMViewAlignmentBottomLeft,
    BMViewAlignmentBottomCenter,
    BMViewAlignmentBottomRight,
}BMViewAlignment;

@property (nonatomic) CGFloat bm_Width;        //view.frame.size.width
@property (nonatomic) CGFloat bm_Height;        //view.frame.size.height
@property (nonatomic) CGFloat bm_X;            //view.frame.origin.x
@property (nonatomic) CGFloat bm_Y;            //view.frame.origin.y
@property (nonatomic) CGPoint bm_Origin;        //view.frame.origin
@property (nonatomic) CGSize  bm_Size;            //view.frame.size
@property (nonatomic) CGFloat bm_RightEdge;    //view.frame.origin.x + view.frame.size.width
@property (nonatomic) CGFloat bm_BottomEdge;    //view.frame.origin.y + view.frame.size.height
@property (nonatomic) CGFloat bm_CenterX;      //view.center.x
@property (nonatomic) CGFloat bm_CenterY;      //view.center.y
@property (nonatomic, readonly) CGFloat bm_HalfWidth;    //view.frame.size.width/2
@property (nonatomic, readonly) CGFloat bm_HalfHeight;   //view.frame.size.height/2

- (CGPoint)bm_boundsCenter;
- (void)bm_frameIntegral;
- (CGPoint)bm_leftBottomCorner;
- (CGPoint)bm_leftTopCorner;
- (CGPoint)bm_rightTopCorner;
- (CGPoint)bm_rightBottomCorner;
-(void)bm_align:(BMViewAlignment)alignment relativeToPoint:(CGPoint)point;
//position the view relative to a rectangle
-(void)bm_align:(BMViewAlignment)alignment relativeToRect:(CGRect)rect;

@end

NS_ASSUME_NONNULL_END
