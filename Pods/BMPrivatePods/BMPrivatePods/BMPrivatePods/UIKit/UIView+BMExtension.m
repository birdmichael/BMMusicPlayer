//
//  UIView+BMExtension.m
//  Pods
//
//  Created by BirdMichael on 2018/10/3.
//

#import "UIView+BMExtension.h"

@implementation UIView (BMExtension)
/**
 *  @brief  找到指定类名的view对象
 *
 *  @param clazz view类名
 *
 *  @return view对象
 */
- (id)bm_findSubViewWithSubViewClass:(Class)clazz {
    for (id subView in self.subviews) {
        if ([subView isKindOfClass:clazz]) {
            return subView;
        }
    }
    
    return nil;
}
/**
 *  @brief  找到指定类名的SuperView对象
 *
 *  @param clazz SuperView类名
 *
 *  @return view对象
 */
- (id)bm_findSuperViewWithSuperViewClass:(Class)clazz {
    if (self == nil) {
        return nil;
    } else if (self.superview == nil) {
        return nil;
    } else if ([self.superview isKindOfClass:clazz]) {
        return self.superview;
    } else {
        return [self.superview bm_findSuperViewWithSuperViewClass:clazz];
    }
}
/**
 *  @brief  找到当前view所在的viewcontroler
 */
- (UIViewController *)bm_viewController {
    UIResponder *responder = self.nextResponder;
    do {
        if ([responder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)responder;
        }
        responder = responder.nextResponder;
    } while (responder);
    return nil;
}


#pragma mark ——— shake
- (void)bm_shake {
    [self _bm_shake:10 direction:1 currentTimes:0 withDelta:5 speed:0.03 shakeDirection:BMShakeDirectionHorizontal completion:nil];
}

- (void)bm_shake:(int)times withDelta:(CGFloat)delta {
    [self _bm_shake:times direction:1 currentTimes:0 withDelta:delta speed:0.03 shakeDirection:BMShakeDirectionHorizontal completion:nil];
}

- (void)bm_shake:(int)times withDelta:(CGFloat)delta completion:(void(^)(void))handler {
    [self _bm_shake:times direction:1 currentTimes:0 withDelta:delta speed:0.03 shakeDirection:BMShakeDirectionHorizontal completion:handler];
}

- (void)bm_shake:(int)times withDelta:(CGFloat)delta speed:(NSTimeInterval)interval {
    [self _bm_shake:times direction:1 currentTimes:0 withDelta:delta speed:interval shakeDirection:BMShakeDirectionHorizontal completion:nil];
}

- (void)bm_shake:(int)times withDelta:(CGFloat)delta speed:(NSTimeInterval)interval completion:(void(^)(void))handler {
    [self _bm_shake:times direction:1 currentTimes:0 withDelta:delta speed:interval shakeDirection:BMShakeDirectionHorizontal completion:handler];
}

- (void)bm_shake:(int)times withDelta:(CGFloat)delta speed:(NSTimeInterval)interval shakeDirection:(BMShakeDirection)shakeDirection {
    [self _bm_shake:times direction:1 currentTimes:0 withDelta:delta speed:interval shakeDirection:shakeDirection completion:nil];
}

- (void)bm_shake:(int)times withDelta:(CGFloat)delta speed:(NSTimeInterval)interval shakeDirection:(BMShakeDirection)shakeDirection completion:(void (^)(void))completion {
    [self _bm_shake:times direction:1 currentTimes:0 withDelta:delta speed:interval shakeDirection:shakeDirection completion:completion];
}

- (void)_bm_shake:(int)times direction:(int)direction currentTimes:(int)current withDelta:(CGFloat)delta speed:(NSTimeInterval)interval shakeDirection:(BMShakeDirection)shakeDirection completion:(void (^)(void))completionHandler {
    [UIView animateWithDuration:interval animations:^{
        self.layer.affineTransform = (shakeDirection == BMShakeDirectionHorizontal) ? CGAffineTransformMakeTranslation(delta * direction, 0) : CGAffineTransformMakeTranslation(0, delta * direction);
    } completion:^(BOOL finished) {
        if(current >= times) {
            [UIView animateWithDuration:interval animations:^{
                self.layer.affineTransform = CGAffineTransformIdentity;
            } completion:^(BOOL finished){
                if (completionHandler != nil) {
                    completionHandler();
                }
            }];
            return;
        }
        [self _bm_shake:(times - 1)
              direction:direction * -1
           currentTimes:current + 1
              withDelta:delta
                  speed:interval
         shakeDirection:shakeDirection
             completion:completionHandler];
    }];
}


#pragma mark ——— frame
- (CGFloat)bm_Width{
    return self.frame.size.width;
}

- (void)setBm_Width:(CGFloat)bm_Width {
    CGRect rect = self.frame;
    rect.size.width = bm_Width;
    self.frame = rect;
}

- (CGFloat)bm_Height {
    return self.frame.size.height;
}
- (void)setBm_Height:(CGFloat)bm_Height {
    CGRect rect = self.frame;
    rect.size.height = bm_Height;
    self.frame = rect;
}


- (CGFloat)bm_RightEdge {
    return self.frame.origin.x + self.frame.size.width;
}
- (void)setBm_RightEdge:(CGFloat)bm_RightEdge {
    CGRect rect = self.frame;
    rect.origin.x = bm_RightEdge - rect.size.width;
    self.frame = rect;
}

- (CGFloat)bm_BottomEdge
{
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setBm_BottomEdge:(CGFloat)viewBottomEdge
{
    CGRect rect = self.frame;
    rect.origin.y = viewBottomEdge - rect.size.height;
    self.frame = rect;
}

- (CGFloat)bm_Y
{
    return self.frame.origin.y;
}

- (void)setBm_Y:(CGFloat)viewY
{
    CGRect rect = self.frame;
    rect.origin.y = viewY;
    self.frame = rect;
}

- (CGFloat)bm_CenterX {
    return self.center.x;
}

- (void)setBm_CenterX:(CGFloat)viewCenterX {
    CGPoint center = self.center;
    center.x = viewCenterX;
    self.center = center;
}

- (CGFloat)bm_CenterY {
    return self.center.y;
}

- (void)setBm_CenterY:(CGFloat)viewCenterY {
    CGPoint center = self.center;
    center.y = viewCenterY;
    self.center = center;
}

- (void)setBm_X:(CGFloat)viewX
{
    CGRect rect = self.frame;
    rect.origin.x = viewX;
    self.frame = rect;
}

- (CGFloat)bm_X
{
    return self.frame.origin.x;
}

- (void)setBm_Size:(CGSize)viewSize
{
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, viewSize.width, viewSize.height);
}

- (CGSize)bm_Size
{
    return self.frame.size;
}

- (void)setBm_Origin:(CGPoint)viewOrigin
{
    self.frame = CGRectMake(viewOrigin.x, viewOrigin.y, self.frame.size.width, self.frame.size.height);
}

- (CGPoint)bm_Origin
{
    return self.frame.origin;
}

- (CGFloat)bm_HalfWidth {
    return CGRectGetWidth(self.bounds) / 2.0;
}

- (CGFloat)bm_HalfHeight {
    return CGRectGetHeight(self.bounds) / 2.0;
}

- (CGPoint)bm_boundsCenter{
    return CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
}

- (void)bm_frameIntegral{
    self.frame = CGRectIntegral(self.frame);
}

- (CGPoint)bm_leftBottomCorner
{
    return CGPointMake(self.frame.origin.x, self.frame.origin.y + self.frame.size.height);
}

- (CGPoint)bm_leftTopCorner
{
    return self.frame.origin;
}

- (CGPoint)bm_rightTopCorner
{
    return CGPointMake(self.frame.origin.x + self.frame.size.width, self.frame.origin.y);
}

- (CGPoint)bm_rightBottomCorner
{
    return CGPointMake(self.frame.origin.x + self.frame.size.width, self.frame.origin.y + self.frame.size.height);
}

//-------------------------
#pragma mark View Alignment
//-------------------------

-(void)bm_align:( BMViewAlignment)alignment relativeToPoint:(CGPoint)point{
    switch (alignment) {
        case  BMViewAlignmentTopLeft:
            self.bm_Origin = CGPointMake(point.x, point.y);
            break;
        case  BMViewAlignmentTopCenter:
            self.bm_Origin = CGPointMake(point.x-self.bm_Width/2, point.y);
            break;
        case  BMViewAlignmentTopRight:
            self.bm_Origin = CGPointMake(point.x-self.bm_Width, point.y);
            break;
        case  BMViewAlignmentMiddleLeft:
            self.bm_Origin = CGPointMake(point.x, point.y-self.bm_Height/2);
            break;
        case  BMViewAlignmentCenter:
            self.center     = CGPointMake(point.x, point.y);
            break;
        case  BMViewAlignmentMiddleRight:
            self.bm_Origin = CGPointMake(point.x-self.bm_Width, point.y-self.bm_Height/2);
            break;
        case  BMViewAlignmentBottomLeft:
            self.bm_Origin = CGPointMake(point.x, point.y-self.bm_Height);
            break;
        case  BMViewAlignmentBottomCenter:
            self.bm_Origin = CGPointMake(point.x-self.bm_Width/2, point.y-self.bm_Height);
            break;
        case  BMViewAlignmentBottomRight:
            self.bm_Origin = CGPointMake(point.x-self.bm_Width, point.y-self.bm_Height);
            break;
        default:
            break;
    }
}


-(void)bm_align:( BMViewAlignment)alignment relativeToRect:(CGRect)rect{
    CGPoint point = CGPointZero;
    switch (alignment){
        case  BMViewAlignmentTopLeft:
            point = rect.origin;
            break;
        case  BMViewAlignmentTopCenter:
            point = CGPointMake(rect.origin.x+rect.size.width/2, rect.origin.y);
            break;
        case  BMViewAlignmentTopRight:
            point = CGPointMake(rect.origin.x+rect.size.width, rect.origin.y);
            break;
        case  BMViewAlignmentMiddleLeft:
            point = CGPointMake(rect.origin.x, rect.origin.y +rect.size.height/2);
            break;
        case  BMViewAlignmentCenter:
            point = CGPointMake(rect.origin.x+rect.size.width/2, rect.origin.y+rect.size.height/2);
            break;
        case  BMViewAlignmentMiddleRight:
            point = CGPointMake(rect.origin.x+rect.size.width, rect.origin.y+rect.size.height/2);
            break;
        case  BMViewAlignmentBottomLeft:
            point = CGPointMake(rect.origin.x, rect.origin.y+rect.size.height);
            break;
        case  BMViewAlignmentBottomCenter:
            point = CGPointMake(rect.origin.x+rect.size.width/2, rect.origin.y+rect.size.height);
            break;
        case  BMViewAlignmentBottomRight:
            point = CGPointMake(rect.origin.x+rect.size.width, rect.origin.y+rect.size.height);
            break;
        default:
            return;
    }
    [self bm_align:alignment relativeToPoint:point];
}
@end
