//
//  BMMusicPlayer.h
//  Calm
//
//  Created by BirdMichael on 2018/11/2.
//  Copyright © 2018 BirdMichael. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FreeStreamer/FSAudioStream.h>

// 播放器播放状态
typedef NS_ENUM(NSUInteger, BMMusicPlayerState) {
    BMMusicPlayerStateLoading,          // 加载中
    BMMusicPlayerStateBuffering,        // 缓冲中
    BMMusicPlayerStatePlaying,          // 播放
    BMMusicPlayerStatePaused,           // 暂停
    BMMusicPlayerStateStoppedBy,        // 停止（用户切换歌曲时调用）
    BMMusicPlayerStateStopped,          // 停止（播放器主动发出：如播放被打断）
    BMMusicPlayerStateEnded,            // 结束（播放完成）
    BMMusicPlayerStateError             // 错误
};

// 播放器缓冲状态
typedef NS_ENUM(NSUInteger, BMMusicPlayerBufferState) {
    BMMusicPlayerBufferStateNone,       // 未缓存
    BMMusicPlayerBufferStateBuffering,  // 正在缓存
    BMMusicPlayerBufferStateFinished    // 缓存完毕
};

NS_ASSUME_NONNULL_BEGIN

@interface BMMusicPlayer : NSObject

+ (instancetype)sharedInstance;
//@property (nonatomic, weak) id<GKAudioPlayerDelegate> delegate;

@property (nonatomic, copy) NSURL *playUrl;
/** 播放状态 */
@property (nonatomic, assign, readonly) BMMusicPlayerState    playerState;
/** 缓冲状态 */
@property (nonatomic, assign, readonly) BMMusicPlayerBufferState    bufferState;

@property (nonatomic, assign, readonly) NSTimeInterval duration; // 总时长
@property (nonatomic, assign) NSTimeInterval currentTime; // 当前时长
@property (nonatomic, assign, readonly) double bufferingRatio; // 缓存进度

// 播放控制层
- (void)play;
- (void)pause;
- (void)resume; // 恢复播放
- (void)stop;

- (CGFloat)cachesize;
- (void)removeCache;

@end

NS_ASSUME_NONNULL_END
