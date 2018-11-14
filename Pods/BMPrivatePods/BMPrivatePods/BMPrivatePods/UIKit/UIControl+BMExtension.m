//
//  UIControl+BMExtension.m
//  Pods
//
//  Created by BirdMichael on 2018/10/3.
//

#import "UIControl+BMExtension.h"
#import <objc/runtime.h>

#define BM_UICONTROL_EVENT(methodName, eventName)                                \
-(void)methodName : (void (^)(void))eventBlock {                              \
objc_setAssociatedObject(self, @selector(methodName:), eventBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);\
[self addTarget:self                                                        \
action:@selector(methodName##Action:)                                       \
forControlEvents:UIControlEvent##eventName];                                \
}                                                                               \
-(void)methodName##Action:(id)sender {                                        \
void (^block)(void) = objc_getAssociatedObject(self, @selector(methodName:));  \
if (block) {                                                                \
block();                                                                \
}                                                                           \
}

@implementation UIControl (BMExtension)

BM_UICONTROL_EVENT(bm_touchDown, TouchDown)
BM_UICONTROL_EVENT(bm_touchDownRepeat, TouchDownRepeat)
BM_UICONTROL_EVENT(bm_touchDragInside, TouchDragInside)
BM_UICONTROL_EVENT(bm_touchDragOutside, TouchDragOutside)
BM_UICONTROL_EVENT(bm_touchDragEnter, TouchDragEnter)
BM_UICONTROL_EVENT(bm_touchDragExit, TouchDragExit)
BM_UICONTROL_EVENT(bm_touchUpInside, TouchUpInside)
BM_UICONTROL_EVENT(bm_touchUpOutside, TouchUpOutside)
BM_UICONTROL_EVENT(bm_touchCancel, TouchCancel)
BM_UICONTROL_EVENT(bm_valueChanged, ValueChanged)
BM_UICONTROL_EVENT(bm_editingDidBegin, EditingDidBegin)
BM_UICONTROL_EVENT(bm_editingChanged, EditingChanged)
BM_UICONTROL_EVENT(bm_editingDidEnd, EditingDidEnd)
BM_UICONTROL_EVENT(bm_editingDidEndOnExit, EditingDidEndOnExit)

@end
