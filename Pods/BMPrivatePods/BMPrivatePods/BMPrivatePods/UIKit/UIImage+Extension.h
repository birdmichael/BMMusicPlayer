//
//  UIImage+Extension.h
//  BMPrivatePods
//
//  Created by BirdMichael on 2018/10/15.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (Extension)

- (UIImage *)bm_fixOrientation;

- (UIImage *)bm_thumbnailWithSize:(CGSize)asize;

- (UIImage *)bm_rescaleImageToSize:(CGSize)size;

- (UIImage *)bm_cropImageToRect:(CGRect)cropRect;

- (CGSize)bm_calculateNewSizeForCroppingBox:(CGSize)croppingBox;

- (UIImage *)bm_cropCenterAndScaleImageToSize:(CGSize)cropSize;

- (UIImage *)bm_cropToSquareImage;

// path为图片的键值
- (void)bm_saveToCacheWithKey:(NSString *)key;

+ (UIImage *)bm_loadFromCacheWithKey:(NSString *)key;

+ (UIImage *)bm_imageWithColor:(UIColor *)color;

+ (UIImage *)bm_imageWithColor:(UIColor *)color size:(CGSize)size;

+ (UIImage *)bm_randomColorImageWith:(CGSize)size;

- (UIImage *)bm_croppedImage:(CGRect)bounds;

@end

NS_ASSUME_NONNULL_END
