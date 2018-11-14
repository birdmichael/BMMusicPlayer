//
//  BMMusicPlayer.m
//  Calm
//
//  Created by BirdMichael on 2018/11/2.
//  Copyright © 2018 BirdMichael. All rights reserved.
//

#import "BMMusicPlayer.h"

@interface BMMusicPlayer()

@property (nonatomic, strong) FSAudioStream *audioStream;

@property (nonatomic, strong) NSTimer       *playTimer;
@property (nonatomic, strong) NSTimer       *bufferTimer;
@property (nonatomic, assign, readwrite) BMMusicPlayerState    playerState;
@property (nonatomic, assign, readwrite) NSTimeInterval duration; // 总时长

@end



@implementation BMMusicPlayer

+ (instancetype)sharedInstance {
    static BMMusicPlayer *player = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        player = [BMMusicPlayer new];
    });
    return player;
}

- (instancetype)init {
    if (self = [super init]) {
        self.playerState = BMMusicPlayerStateStopped;
    }
    return self;
}

#pragma mark ——— 私有方法

- (void)bufferTimerAction:(id)sender {
    __weak __typeof(self)weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        __strong typeof(weakSelf) sself = weakSelf;
        float preBuffer      = (float)self.audioStream.prebufferedByteCount;
        float contentLength  = (float)self.audioStream.contentLength;
        
        // 这里获取的进度不能准确地获取到1
        float bufferProgress = contentLength > 0 ? preBuffer / contentLength : 0;
        
        // 为了能使进度准确的到1，这里做了一些处理
        int buffer = (int)(bufferProgress + 0.5);
        
        if (bufferProgress > 0.99 && buffer >= 1) {
            sself->_bufferState = BMMusicPlayerBufferStateFinished;
            [self stopBufferTimer];
            // 这里把进度设置为1，防止进度条出现不准确的情况
            bufferProgress = 1.0f;
            
            NSLog(@"缓冲结束了，停止进度");
        }else {
            sself->_bufferState = BMMusicPlayerBufferStateBuffering;
        }
        sself->_bufferState = bufferProgress;
    });
}

- (void)timerAction:(id)sender {
    __weak __typeof(self)weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        __strong typeof(weakSelf) sself = weakSelf;
        // 获取当前时间以及总时间
        FSStreamPosition cur = self.audioStream.currentTimePlayed;
        NSTimeInterval currentTime = cur.playbackTimeInSeconds ;
        NSTimeInterval totalTime = self.audioStream.duration.playbackTimeInSeconds;
        sself->_currentTime = currentTime;
        sself->_duration = totalTime;
        
    });
}

- (void)removeCache {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSArray *arr = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:self.audioStream.configuration.cacheDirectory error:nil];
        
        for (NSString *filePath in arr) {
            if ([filePath hasPrefix:@"FSCache-"]) {
                NSString *path = [NSString stringWithFormat:@"%@/%@", self.audioStream.configuration.cacheDirectory, filePath];
                [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
            }
        }
    });
}

- (CGFloat)cachesize {
    
    return self.audioStream.totalCachedObjectsSize/1000000;
}

#pragma mark ——— 外部方法
- (void)setPlayUrl:(NSURL *)playUrl {
    if (![_playUrl.absoluteString isEqualToString:playUrl.absoluteString]) {
        // 切换数据，清除缓存
        [self removeCache];
        _playUrl = playUrl;
    }
    __weak __typeof(self)weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        self.audioStream.url = weakSelf.playUrl;
    });
}

- (void)setCurrentTime:(NSTimeInterval)currentTime {
    _currentTime = currentTime;
    FSStreamPosition position = {0};
    CGFloat progress = _currentTime/_duration;
    NSLog(@"%f----,%f---%f",progress,_currentTime,_duration);
    position.position = progress;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.audioStream seekToPosition:position];
    });
}
- (void)play {
    
    NSAssert(self.playUrl, @"url不能为空");
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.audioStream play];
    });
    
    [self startTimer];
    
    // 如果缓冲未完成
    if (_bufferState != BMMusicPlayerBufferStateFinished) {
        _bufferState = BMMusicPlayerBufferStateNone;
        [self startBufferTimer];
    }
}
- (void)pause {
    self.playerState = BMMusicPlayerStatePaused;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.audioStream pause];
    });
    [self stopTimer];
}

- (void)resume {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.audioStream pause];
    });
    [self startTimer];
}

- (void)stop {
    self.playerState = BMMusicPlayerStateStoppedBy;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.audioStream stop];
    });
    self.currentTime = 0; // 每一次停止重置
    self.duration = 0;
    [self stopTimer];
}
#pragma mark ——— Timer
- (void)startTimer {
    if (self.playTimer) return;
    self.playTimer = [BMTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(timerAction:) userInfo:nil repeats:YES];
}

- (void)stopTimer {
    if (self.playTimer) {
        [self.playTimer invalidate];
        self.playTimer = nil;
    }
}

- (void)startBufferTimer {
    if (self.bufferTimer) return;
    self.bufferTimer = [BMTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(bufferTimerAction:) userInfo:nil repeats:YES];
}

- (void)stopBufferTimer {
    if (self.bufferTimer) {
        [self.bufferTimer invalidate];
        self.bufferTimer = nil;
    }
}

#pragma mark ——— 懒加载
- (FSAudioStream *)audioStream {
    if (!_audioStream) {
        FSStreamConfiguration *configuration = [FSStreamConfiguration new];
        configuration.enableTimeAndPitchConversion = YES;
        
        _audioStream = [[FSAudioStream alloc] initWithConfiguration:configuration];
        _audioStream.strictContentTypeChecking = NO;
        _audioStream.defaultContentType = @"audio/x-m4a";
        
        __weak __typeof(self) weakSelf = self;
        
        _audioStream.onStateChange = ^(FSAudioStreamState state) {
            __strong typeof(weakSelf) sself = weakSelf;
            switch (state) {
                case kFsAudioStreamRetrievingURL:       // 检索url
                    weakSelf.playerState = BMMusicPlayerStateLoading;
                    BMLOG(@"d");
                    break;
                case kFsAudioStreamBuffering:           // 缓冲
                    weakSelf.playerState = BMMusicPlayerStateBuffering;
                    sself->_bufferState = BMMusicPlayerBufferStateBuffering;
                    break;
                case kFsAudioStreamSeeking:             // seek
                    weakSelf.playerState = BMMusicPlayerStateLoading;
                    BMLOG(@"d");
                    break;
                case kFsAudioStreamPlaying:             // 播放
                    weakSelf.playerState = BMMusicPlayerStatePlaying;
                    break;
                case kFsAudioStreamPaused:              // 暂停
                    weakSelf.playerState = BMMusicPlayerStatePaused;
                    break;
                case kFsAudioStreamStopped:              // 停止
                    // 切换歌曲时主动调用停止方法也会走这里，所以这里添加判断，区分是切换歌曲还是被打断等停止
                    if (weakSelf.playerState != BMMusicPlayerStateStoppedBy && weakSelf.playerState != BMMusicPlayerStateEnded) {
                        weakSelf.playerState = BMMusicPlayerStateStopped;
                    }
                    break;
                case kFsAudioStreamRetryingFailed:              // 检索失败
                    weakSelf.playerState = BMMusicPlayerStateError;
                    break;
                case kFsAudioStreamRetryingStarted:             // 检索开始
                    weakSelf.playerState = BMMusicPlayerStateLoading;
                    BMLOG(@"d");
                    break;
                case kFsAudioStreamFailed:                      // 播放失败
                    weakSelf.playerState = BMMusicPlayerStateError;
                    break;
                case kFsAudioStreamPlaybackCompleted:           // 播放完成
                    weakSelf.playerState = BMMusicPlayerStateEnded;
                    break;
                case kFsAudioStreamRetryingSucceeded:           // 检索成功
                    weakSelf.playerState = BMMusicPlayerStateLoading;
                    BMLOG(@"d");
                    break;
                case kFsAudioStreamUnknownState:                // 未知状态
                    weakSelf.playerState = BMMusicPlayerStateError;
                    break;
                case kFSAudioStreamEndOfFile:                   // 缓冲结束
                {
                    
                    if (weakSelf.bufferState == BMMusicPlayerBufferStateFinished) return;
                    // 定时器停止后需要再次调用获取进度方法，防止出现进度不准确的情况
                    [weakSelf bufferTimerAction:nil];
                    
                    [weakSelf stopBufferTimer];
                }
                    break;
                    
                default:
                    break;
            }
        };
    }
    return _audioStream;
}

@end
