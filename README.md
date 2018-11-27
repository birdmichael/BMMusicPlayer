[![logo](https://github.com/birdmichael/MultiAudio/raw/master/logo.jpg)](https://github.com/birdmichael/MultiAudio/blob/master/logo.jpg)

# BMMusicPlayer

基于FreeStreamer播放器二次封装。仿网易云封面图旋转，转圈音乐动效。全局基于ASDK

## 安装

为了包的体积，手机运行会报错找不到`pod`,在`BMMusicPlayer`文件夹内运行`pod install`即可。

## 使用pods目录

- pod 'Masonry' -> 部分页面布局使用
- pod 'MJExtension' -> 音频feed页面json转模型
- pod 'AFNetworking' -> 请求网络资源
- pod 'BMPrivatePods' -> 私有库，主要动些宏定义（项目快速移植版本，懒的特调）
- pod 'Texture'-> 部分界面使用到了ASDK。（项目原本使用的ASDK，不影响阅读，换成VIew也可以）
- pod 'GPUImage' -> GPU模糊
- pod 'lottie-ios' -> 部分动画
-  pod 'FreeStreamer' -> 播放器
- pod 'iOSPalette' -> 提取图片主颜色

## 截图演示(声音播放部分无法演示)

![](/Users/birdmichael/Documents/GitHub/BMMusicPlayer/2.gif)

## 项目特点

- 仿'爱奇艺'Tabbar点击动画切换效果
- list页面cell采用ASDK实现layer化
- 播放器单利实现，除"关闭"，"进度条滑块"采用ASDK实现layer化。
- 播放器背景使用封面图背景高斯模糊效果，获取图片主色调作为shandow。音效动画同样获取图片主色调

## 主代码说明

1.Tabbar部分

`BMTabBarController.m`

```
- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    NSArray * sss = self.tabBar.subviews;
    NSMutableArray *tabbatButtonArray = [@[] mutableCopy];
    for (UIView *view in sss) {
        if ([view isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
            [tabbatButtonArray addObject:view];
        }
    }
    
    for (UIView *view in [tabbatButtonArray[item.tag] subviews]) {
        if ([view isKindOfClass:NSClassFromString(@"UITabBarSwappableImageView")]) {
            [self.animation removeFromSuperview];
            NSString * name = item.title;
            LOTAnimationView *animation = [LOTAnimationView animationNamed:name];
            [view addSubview:animation];
            animation.bounds = CGRectMake(0, 0,view.bounds.size.width,view.bounds.size.width);
            animation.center = CGPointMake(view.bounds.size.width/2, view.bounds.size.height/2);
            [animation playWithCompletion:^(BOOL animationFinished) {
                // Do Something
            }];
            self.animation = animation;
        }
    }
}
```

使用同一个`animation`来播放动画，通过移除添加控制生命周期。

2.播放器页面高斯模糊，shandow，音效动画

`BMMusicDisplayNode.m`

- 高斯模糊

因为使用asdk异步线程，告诉模糊放在了图片的归解档中。正常在主线程拿到下载后的图片中操作就好了。



```
_imageBackGroudNode.imageModificationBlock = ^UIImage * _Nullable(UIImage * _Nonnull image) {
        // GPUimage
        GPUImageGaussianBlurFilter *filter = [[GPUImageGaussianBlurFilter alloc] init];
        filter.blurRadiusInPixels = 40.0;
        [filter forceProcessingAtSize:image.size];
        GPUImagePicture *pic = [[GPUImagePicture alloc] initWithImage:image];
        [pic addTarget:filter];
        [pic processImage];
        [filter useNextFrameForImageCapture];
        return [filter imageFromCurrentFramebuffer];
    };
```

- 获取主色作为shandow

  1。因为是圆角添加shandow，涉及`masksToBounds`所以是在`coverPictureNode`背后有一个同样大小的`coverPictureShadowNode`上添加的shandow。

  2。使用`#import "iOSPalette.h"`在`- (**void**)getPaletteImageColor:(GetColorBlock)block;`中获取主颜色，并设置给`coverPictureShadowNode`。同时这个时候把颜色给音效动画。

```
_coverPictureNode.imageModificationBlock = ^UIImage * _Nullable(UIImage * _Nonnull image) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [image getPaletteImageColor:^(PaletteColorModel *recommendColor, NSDictionary *allModeColorDic, NSError *error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    weakSelf.coverPictureShadowNode.layer.shadowColor = [UIColor bm_colorWithHexString:recommendColor.imageColorString].CGColor;
                    weakSelf.coverPictureShadowNode.layer.shadowOffset = CGSizeMake(0,10);
                    weakSelf.coverPictureShadowNode.shadowRadius = 29;
                    weakSelf.coverPictureShadowNode.shadowOpacity = 0.5;
                    
                    for (CALayer *layer in weakSelf.rippleArray) {
                        layer.borderColor = [UIColor bm_colorWithHexString:recommendColor.imageColorString].CGColor;
                    }
                    for (CALayer *layer in weakSelf.rippleCircleArray) {
                        layer.backgroundColor = [UIColor bm_colorWithHexString:recommendColor.imageColorString].CGColor;
                    }
                });
            }];
        });
        CGRect circleRect = (CGRect) {CGPointZero, CGSizeMake(image.size.width, image.size.height)};
        UIGraphicsBeginImageContextWithOptions(circleRect.size, NO, 0);
        UIBezierPath *circle = [UIBezierPath bezierPathWithRoundedRect:circleRect cornerRadius:circleRect.size.width/2];
        [circle addClip];
        [[UIColor whiteColor] set];
        [circle fill];
        [image drawInRect:circleRect];
        UIImage *roundedImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return roundedImage;
    };
```

- 音效动画

音效动画分为2个小模块：1.旋转。2.波纹

音效部分：

```
- (void)addAnimation {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    animation.duration = 15;
    animation.repeatCount = MAXFLOAT;
    animation.removedOnCompletion = NO;
    animation.toValue = @(M_PI*2);
    [self.coverPictureNode.layer addAnimation:animation forKey:@"rotationAnimation"];
    
}
```

波纹部分：

​	在波纹地方有其实就是有`kCoverPictureRippleCount`条圈通过不同的`beginTime`实现。在asdk中有一个小问题是当使用动画组的时候，仅显示第一个动画，还没找到原因。当使用正常View时，通过设置动画组，并删除动画相同属性就好了，这样代码也精简很多。

```
- (void)addRippleAnimation {
    self.rippleArray = [@[] mutableCopy];
    self.rippleCircleArray = [@[] mutableCopy];
    CALayer * animationLayer = [CALayer layer];
    CGFloat maxRadius = kBMSCREEN_WIDTH /2;
    for (int i = 0; i<kCoverPictureRippleCount; i++) {
        CALayer * pulsingLayer = [CALayer layer];
        pulsingLayer.frame = CGRectMake(0, 0, maxRadius*2, maxRadius*2);
        pulsingLayer.position = CGPointMake(BM_FitW(kCoverPictureHW)/2, BM_FitW(kCoverPictureHW)/2);
        pulsingLayer.backgroundColor = [UIColor clearColor].CGColor;
        pulsingLayer.cornerRadius = maxRadius;
        pulsingLayer.borderWidth = kCoverPictureRippleMaxBorderWidth;
        
        CALayer *lay = [CALayer layer];
        lay.frame = CGRectMake(0, 0, kCoverPictureRippleCircleSize, kCoverPictureRippleCircleSize);
        lay.cornerRadius = kCoverPictureRippleCircleSize/2;
        lay.masksToBounds = YES;
        lay.position = CGPointMake(maxRadius*2 * sin(45), maxRadius*2 * sin(45));
        [pulsingLayer addSublayer:lay];
        
        CAMediaTimingFunction * defaultCurve = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
        
        CAAnimationGroup * animationGroup = [CAAnimationGroup animation];
        animationGroup.fillMode = kCAFillModeBackwards;
        animationGroup.beginTime = CACurrentMediaTime() + i * kCoverPictureRippleDuration / kCoverPictureRippleCount;
        animationGroup.duration = kCoverPictureRippleDuration;
        animationGroup.repeatCount = HUGE;
        animationGroup.timingFunction = defaultCurve;
        
        CABasicAnimation * scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        scaleAnimation.fromValue = @(BM_FitW(kCoverPictureHW)/2 / maxRadius);
        scaleAnimation.toValue = @1.0;
        scaleAnimation.beginTime = CACurrentMediaTime() + i * kCoverPictureRippleDuration / kCoverPictureRippleCount;
        scaleAnimation.fillMode = kCAFillModeBackwards;
        scaleAnimation.timingFunction = defaultCurve;
        scaleAnimation.duration = kCoverPictureRippleDuration;
        scaleAnimation.repeatCount = HUGE;
        scaleAnimation.removedOnCompletion = NO;
        scaleAnimation.fillMode = kCAFillModeForwards;
        
        
        CABasicAnimation *animation = [CABasicAnimation new];
        animation.keyPath = @"transform.rotation.z";
        animation.beginTime = CACurrentMediaTime() + i * kCoverPictureRippleDuration / kCoverPictureRippleCount;
        animation.fromValue = [NSNumber numberWithFloat:i *(M_PI/2)]; // 起始角度
        animation.toValue = [NSNumber numberWithFloat:i *(M_PI/2) + 2*M_PI]; // 终止角度
        animation.duration = 20;
        animation.repeatCount = HUGE;
        animation.timingFunction = defaultCurve;
        animation.removedOnCompletion = NO;
        animation.fillMode = kCAFillModeForwards;
        
        CAKeyframeAnimation * opacityAnimation = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
        opacityAnimation.beginTime = CACurrentMediaTime() + i * kCoverPictureRippleDuration / kCoverPictureRippleCount;
        opacityAnimation.values = @[@0.3, @0.5, @0];
        opacityAnimation.keyTimes = @[@0, @0.3, @1];
        opacityAnimation.duration = kCoverPictureRippleDuration;
        opacityAnimation.repeatCount = HUGE;
        opacityAnimation.timingFunction = defaultCurve;
        opacityAnimation.removedOnCompletion = NO;
        opacityAnimation.fillMode = kCAFillModeForwards;
        
        // 有一个位置问题，ASDK使用animationGroup 仅显示一个。
//        animationGroup.animations = @[scaleAnimation, opacityAnimation,animation];
        [pulsingLayer addAnimation:scaleAnimation forKey:@"plulsing"];
        [pulsingLayer addAnimation:animation forKey:@"dsdasdasd"];
        [pulsingLayer addAnimation:opacityAnimation forKey:@"plulsidsadang"];
        [animationLayer addSublayer:pulsingLayer];
        [self.rippleArray addObject:pulsingLayer];
        [self.rippleCircleArray addObject:lay];
    }
    _animationLayer = animationLayer;
    [self.coverPictureShadowNode.layer addSublayer:animationLayer];
}
```

## 联系

邮箱：[birdmichael126@gmail.com](mailto:birdmichael126@gmail.com)

微信：birdmichael

## License

The Texture project is available for free use, as described by the [LICENSE](https://github.com/texturegroup/texture/blob/master/LICENSE) (Apache 2.0).