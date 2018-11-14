//
//  BMUIFunctionC.h
//  Pods
//
//  Created by BirdMichael on 2018/10/2.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>






#pragma mark ——— INLINE
/**
 *  交换高度与宽度
 */
UIKIT_STATIC_INLINE CGSize SizeSWAP(CGSize size) {
    return CGSizeMake(size.height, size.width);
}
