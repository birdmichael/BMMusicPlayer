//
//  BMMusicViewController.m
//  Calm
//
//  Created by BirdMichael on 2018/10/16.
//  Copyright © 2018 BirdMichael. All rights reserved.
//

#import "BMMusicViewController.h"
#include <stdlib.h>
#import <MediaPlayer/MediaPlayer.h>
#import "BMMusicDisplayNode.h"
#import "BMMusicSlider.h"
#import "SVProgressHUD.h"
#import "BMMusicSelectTimerNode.h"

static void *kStatusKVOKey = &kStatusKVOKey;
static void *kDurationKVOKey = &kDurationKVOKey;
static void *kBufferingRatioKVOKey = &kBufferingRatioKVOKey;

@interface BMMusicViewController ()<UIViewControllerTransitioningDelegate, BMMusicDisplayNodeDelegate>
@property (nonatomic, strong, readwrite) BMMusicPlayer *player;
@property (nonatomic, strong) BMMusicDisplayNode *musicNode; // 播放器页面主视图 （不包含滑块）（线程安全）
@property (nonatomic, strong) BMMusicSlider *progressSlider;
@property (nonatomic, assign) BOOL isSliding;
@property (nonatomic, strong) UILabel *beginTimeLabel;
@property (nonatomic, strong) UILabel *endTimeLabel;

@property (nonatomic, copy) NSTimer *musicDurationTimer; // 单利保存不销毁 （更新播放器进度，停止时暂停）
@property (nonatomic, strong) NSTimer *definiteTimer; // 定时停止定时器


@property (nonatomic, strong) BMMusicSelectTimerNode *selectTimeNode; // 定时选择界面 默认透明加载，通过透明度改变现实状态

@property (nonatomic, strong) NSArray *playArray;// 播放列表
@property (nonatomic, assign) NSUInteger playIndex;
@end

@implementation BMMusicViewController

+ (instancetype)sharedInstance {
    static BMMusicViewController *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[BMMusicViewController alloc] init];
    });
    
    return _instance;
}

#pragma mark ——— Life cycle

- (instancetype)init
{
    self = [super init];
    if (self) {
        _musicBar = [[BMMusicBar alloc] initWithViewController:self];
        _player = [BMMusicPlayer sharedInstance];
        [self addMusicdisplayNode]; // 添加主视图
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    __weak __typeof(self)weakSelf = self;
    _musicDurationTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 repeats:YES block:^(NSTimer * _Nonnull timer) {
        [weakSelf updateSliderValue:nil];
    }];
    [_musicDurationTimer setFireDate:[NSDate distantFuture]];
    [self addPanDismissRecognizer];
    [self setMusicBarAction];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}



#pragma mark ——— 私有方法
- (void)setMusicBarAction {
    __weak __typeof(self)weakSelf = self;
    self.musicBar.playBtnClickedBlock = ^(ASButtonNode * _Nonnull btnNode) {
        [weakSelf updatePlaySelected:btnNode.selected];
    };
}

- (void)updatePlaySelected:(BOOL)selected{
    // 同步状态
    [self.musicNode playBtnSelected:selected];
    [self.musicBar playBtnSelected:selected];
    // 控制
    if (!selected) {
        // 暂停
        if (self.player.playerState != BMMusicPlayerStatePaused) {
             [self.player pause];
        }
        [_musicDurationTimer  setFireDate:[NSDate distantFuture]];
    }else {
        // 播放
        if (self.player.playerState == BMMusicPlayerStatePaused) {
            // 暂停时 检测没有在播放就播放
            if (self.player.playerState != BMMusicPlayerStatePlaying) {
                [self resumeMusic];
            }
        }else {
            // 其他清空重新播放视频
            [self playMusic];
        }
        
    }
    [self.musicNode updateCoverPictureRotating];
    [self.musicBar updateCoverPictureRotating];
}

- (void)addMusicdisplayNode {
    self.musicNode = [[BMMusicDisplayNode alloc] init];
    self.musicNode.delegate = self;
    [self.view addSubnode:self.musicNode];
    self.musicNode.frame = CGRectMake(0, 0, kBMSCREEN_WIDTH, kBMSCREEN_HEIGHT);
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setImage:[UIImage imageNamed:@"shutdown_icon"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(dissMiss) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kBMStatusBarHeight + 27);
        make.left.mas_equalTo(20);
    }];
    
    self.progressSlider = [[BMMusicSlider alloc] init];
    [self.progressSlider addTarget:self action:@selector(actionSliderProgress:) forControlEvents:UIControlEventValueChanged];
    [self.progressSlider addTarget:self action:@selector(didChangeMusicSliderValue:) forControlEvents:UIControlEventTouchUpInside];
    [self.progressSlider addTarget:self action:@selector(didNotChangeMusicSliderValue:) forControlEvents:UIControlEventTouchUpOutside];
    [self.view addSubview:self.progressSlider];
    __weak __typeof(self)weakSelf = self;
    [self.progressSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf.view).offset(- BM_FitW(108)- kMSafeBottomHeight);
        make.size.mas_offset(CGSizeMake(BM_FitW(600), 10));
        make.centerX.mas_equalTo(weakSelf.view.mas_centerX);
    }];
    
    self.beginTimeLabel = [UILabel new];
    [self.view addSubview:self.beginTimeLabel];
    self.beginTimeLabel.text = @"00:00";
    self.beginTimeLabel.font = BM_CLAM_FONT(13.5);
    self.beginTimeLabel.textColor = BM_HEX_RGBA(0xffffff, 0.5);
    [self.beginTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.progressSlider);
        make.top.equalTo(self.progressSlider.mas_bottom).offset(4);
    }];
    
    self.endTimeLabel = [UILabel new];
    [self.view addSubview:self.endTimeLabel];
    self.endTimeLabel.text = @"00:00";
    self.endTimeLabel.font = BM_CLAM_FONT(13.5);
    self.endTimeLabel.textColor = BM_HEX_RGBA(0xffffff, 0.5);
    [self.endTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.progressSlider);
        make.top.equalTo(self.progressSlider.mas_bottom).offset(4);
    }];
    
    _selectTimeNode = [[BMMusicSelectTimerNode alloc] init];
    _selectTimeNode.alpha = 0;
    _selectTimeNode.frame = CGRectMake(0, 0, kBMSCREEN_WIDTH, kBMSCREEN_HEIGHT);
    [self.view addSubnode:_selectTimeNode];
    _selectTimeNode.selectBlock = ^(BMMusicSelectTimerItem * _Nonnull item) {
        [weakSelf setTimingWithItem:item];
    };
}

- (void)pauseMusic {
    [self updatePlaySelected:!self.musicNode.palybtnNode.selected];
}

- (void)setTimingWithItem:(BMMusicSelectTimerItem *)item {
    [self.definiteTimer invalidate];
    __block NSTimeInterval time = [item.value doubleValue] *60;
    if (time == 0)  {
        self.selectTimeNode.isTiming = NO; // 设置取消时标示停止
        [self.musicNode updateTimerNodeWith:time];
        return;
    };
    
    __weak __typeof(self)weakSelf = self;
    self.definiteTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 repeats:YES block:^(NSTimer * _Nonnull timer) {
        time -= 1;
        if (time == 0.0) {
            [self stopMusic];
            [self dissMiss];
            self.selectTimeNode.isTiming = NO; // 定时器跑完时标示停止
            if (timer) {
                [timer invalidate];
                timer = nil;
            }
        }
        [weakSelf.musicNode updateTimerNodeWith:time];
        BMLOG(@"%f",time);
    }];
    self.selectTimeNode.isTiming = YES;
    [[NSRunLoop currentRunLoop] addTimer:self.definiteTimer forMode:NSRunLoopCommonModes];
}

- (void)addPanDismissRecognizer {
    UISwipeGestureRecognizer *swipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(dissMiss)];
    swipeRecognizer.direction = UISwipeGestureRecognizerDirectionDown;
    [self.view addGestureRecognizer:swipeRecognizer];
}


- (void)setNowPlayingInfoCenter {
    if (NSClassFromString(@"MPNowPlayingInfoCenter")) {
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        //        MusicEntity *music = [MusicViewController sharedInstance].currentPlayingMusic;
        AVURLAsset *audioAsset = [AVURLAsset URLAssetWithURL:[NSURL URLWithString:@"http://www.ytmp3.cn/down/53883.mp3"] options:nil];
        CMTime audioDuration = audioAsset.duration;
        float audioDurationSeconds = CMTimeGetSeconds(audioDuration);
        //
        [dict setObject:@"音乐名称" forKey:MPMediaItemPropertyTitle];
        [dict setObject:@"作家名" forKey:MPMediaItemPropertyArtist];
        [dict setObject:@"相册名" forKey:MPMediaItemPropertyAlbumTitle];
        [dict setObject:@(audioDurationSeconds) forKey:MPMediaItemPropertyPlaybackDuration];
        [dict setObject:[NSNumber numberWithFloat:1.0] forKey:MPNowPlayingInfoPropertyPlaybackRate];//进度光标的速度 （这个随 自己的播放速率调整，我默认是原速播放）
        CGFloat playerAlbumWidth = (kBMSCREEN_WIDTH - 16) * 2;
        UIImageView *playerAlbum = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, playerAlbumWidth, playerAlbumWidth)];
        UIImage *placeholderImage = [UIImage imageNamed:@"music_lock_screen_placeholder"];
        [playerAlbum setImage:placeholderImage];
        MPMediaItemArtwork *artwork2 = [[MPMediaItemArtwork alloc] initWithBoundsSize:CGSizeMake(playerAlbumWidth, playerAlbumWidth) requestHandler:^UIImage * _Nonnull(CGSize size) {
            return placeholderImage;
        }];
        playerAlbum.contentMode = UIViewContentModeScaleAspectFill;
        [dict setObject:artwork2 forKey:MPMediaItemPropertyArtwork];
        [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:dict];
        // 更新页面
    }
}
- (void)playNext {
    if (++self.playIndex <self.playArray.count) {
        [self playMusic];
    }else {
        self.playIndex = 0;
        if (self.playArray.count ==1) {
            [self playMusic];
        }else {
            [self updatePlaySelected:NO];
            [self stopMusic];
        }
    }
}

-(void)updateProgressLabelValue {
    _beginTimeLabel.text = [NSString bm_timeIntervalToMMSSFormat:self.player.currentTime];
    _endTimeLabel.text = [NSString bm_timeIntervalToMMSSFormat:self.player.duration];
}

#pragma mark ——— 外部方法
- (void)updatePlayArray:(NSArray<BMItemModel *> *)playArray index:(NSUInteger)index {
    _playArray = playArray;
    self.playIndex = index;
    [self playNewMusic];
}

#pragma mark ——— antion
- (void)dissMiss{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)resumeMusic{
    [self.player resume];
    [_musicDurationTimer  setFireDate:[NSDate distantPast]];
}
- (void)playMusic{
    [self updateProgressLabelValue];
    [self setNowPlayingInfoCenter];
    BMItemModel *model = self.playArray[self.playIndex];
    NSURL *fileURL = [NSURL URLWithString:model.url];
    self.player.playUrl = fileURL;
    self.musicNode.model = model;
    self.musicBar.model = model;
    [self.player play];
    @try {
        [self removeStreamerObserver];
    } @catch(id anException){
    }
    [self addStreamerObserver];
    [_musicDurationTimer  setFireDate:[NSDate distantPast]];
}

- (void)playNewMusic {
    [self stopMusic];
    [self updatePlaySelected:YES];
}

- (void)stopMusic {
    [self.player stop];
    [self updateSliderValue:nil];
    [_musicDurationTimer setFireDate:[NSDate distantFuture]];
    [self.musicBar removeFromSuperview];
    

}
- (void)actionSliderProgress:(id)sender {
    self.isSliding = YES;
    NSTimeInterval currentTime = self.player.duration * self.progressSlider.value;
    _beginTimeLabel.text = [NSString bm_timeIntervalToMMSSFormat:currentTime];
    _endTimeLabel.text = [NSString bm_timeIntervalToMMSSFormat:self.player.duration];
}
- (void)didChangeMusicSliderValue:(id)sender {
    self.isSliding = NO;
    [self.player setCurrentTime:[self.player duration] * self.progressSlider.value];
    [self updateProgressLabelValue];
}
- (void)didNotChangeMusicSliderValue:(id)sender {
    self.isSliding = NO;
}
#pragma mark ——— KVO Streamer and Kvo Action
- (void)removeStreamerObserver {
    [self.player removeObserver:self forKeyPath:@"playerState"];
    [self.player removeObserver:self forKeyPath:@"duration"];
    [self.player removeObserver:self forKeyPath:@"bufferingRatio"];
}

- (void)addStreamerObserver {
    [self.player addObserver:self forKeyPath:@"playerState" options:NSKeyValueObservingOptionNew context:kStatusKVOKey];
    [self.player addObserver:self forKeyPath:@"duration" options:NSKeyValueObservingOptionNew context:kDurationKVOKey];
    [self.player addObserver:self forKeyPath:@"bufferingRatio" options:NSKeyValueObservingOptionNew context:kBufferingRatioKVOKey];
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (context == kStatusKVOKey) {
        [self performSelector:@selector(updateStatus)
                     onThread:[NSThread mainThread]
                   withObject:nil
                waitUntilDone:NO];
    } else if (context == kDurationKVOKey) {
        [self performSelector:@selector(updateSliderValue:)
                     onThread:[NSThread mainThread]
                   withObject:nil
                waitUntilDone:NO];
    } else if (context == kBufferingRatioKVOKey) {
        [self performSelector:@selector(updateBufferingStatus)
                     onThread:[NSThread mainThread]
                   withObject:nil
                waitUntilDone:NO];
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}
- (void)updateStatus {
    self.musicIsPlaying = NO;
    switch (self.player.playerState) {
        case BMMusicPlayerStatePlaying:
            self.musicIsPlaying = YES;
            [self.musicNode updateLoading:NO];
            if (self.player.playerState != BMMusicPlayerStatePlaying) {
                [self playMusic];
            }
            break;
            
        case BMMusicPlayerStatePaused:
            self.musicIsPlaying = YES;
            [self.musicNode updateLoading:NO];
            if (self.player.playerState != BMMusicPlayerStatePaused) {
                [self pauseMusic];
            }
            break;
            
        case BMMusicPlayerStateStopped:
            [self.musicNode updateLoading:NO];
            break;
            
        case BMMusicPlayerStateEnded:
            [self.musicNode updateLoading:NO];
            [self playNext];
            break;
            
        case BMMusicPlayerStateBuffering:
            self.musicIsPlaying = YES;
            [self.musicNode updateLoading:YES];
            // 缓冲中 小状态要更新
            break;
            
        case BMMusicPlayerStateError:
            [self.musicNode updateLoading:YES];
            [SVProgressHUD showErrorWithStatus:@"Error"];
            break;
        case BMMusicPlayerStateLoading:
            self.musicIsPlaying = YES;
            [self.musicNode updateLoading:YES];
            break;
        case BMMusicPlayerStateStoppedBy:
            [self.musicNode updateLoading:NO];
            break;
    }
}

- (void)updateSliderValue:(id)timer {
    if (!self.player) {
        return;
    }
    
    if ([self.player duration] == 0.0) {
        [self.progressSlider setValue:0.0f animated:NO];
        _beginTimeLabel.text = [NSString bm_timeIntervalToMMSSFormat:0];
        _endTimeLabel.text = [NSString bm_timeIntervalToMMSSFormat:0];
        [self.musicBar updateSliderWithValue:0];
        [self.musicBar updateTimeLabel:[NSString bm_timeIntervalToMMSSFormat:0]];
    } else {
        if (!self.isSliding) {
            [self.progressSlider setValue:[self.player currentTime] / [self.player duration] animated:YES];
            [self updateProgressLabelValue];
            
            // 更新音乐条
            [self.musicBar updateSliderWithValue:[self.player currentTime] / [self.player duration]];
            [self.musicBar updateTimeLabel:[NSString bm_timeIntervalToMMSSFormat:self.player.currentTime]];
        }
    }
}

- (void)updateBufferingStatus {
    
}

#pragma mark ——— BMMusicDisplayNodeDelegate
- (void)BMMusicDisplayNode:(BMMusicDisplayNode *)node didClickedTimerNode:(ASButtonNode *)btnNode {
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.selectTimeNode.alpha = 1;
    } completion:^(BOOL finished) {
    }];
}
- (void)BMMusicDisplayNode:(BMMusicDisplayNode *)node didClickedPalybtnNode:(nonnull ASButtonNode *)btnNode{
    [self updatePlaySelected:btnNode.selected];
}
- (void)BMMusicDisplayNode:(BMMusicDisplayNode *)node didClickedStopBtnNode:(ASButtonNode *)btnNode {
    [self stopMusic];
    [self dissMiss];

}

- (BMItemModel *)isPlayIngModel {
    if (!self.musicIsPlaying) {
        return nil;
    }
    return self.playArray[self.playIndex];
}


@end
