//
//  DTPlayerView.m
//  AVPlayerDemo
//
//  Created by DT on 15/6/5.
//  Copyright (c) 2015年 DT. All rights reserved.
//

#import "DTPlayerView.h"

// block self
#define WEAKSELF typeof(self) __weak weakSelf = self;

@interface DTPlayerView()
{
    int _type;//视频类型 -1:未知 1:网络视频 2:本地视频
}
@property(nonatomic,strong)AVPlayerLayer *playerLayer;
@property(nonatomic,strong)AVPlayerItem *playerItem;
@property(nonatomic,strong)AVPlayer *player;

@property (nonatomic ,strong) id playbackTimeObserver;

@property(nonatomic,copy)NSString *url;
@property(nonatomic,copy)NSString *path;

@end

@implementation DTPlayerView

#pragma mark - life cycle
-(instancetype)init
{
    self = [super init];
    if (self) {
        _type = -1;
        self.showVolumeIcon = NO;
        self.playerGravity = DTPlayerGravityResizeAspect;
        self.playbackState = DTPlaybackStateStopped;
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _type = -1;
        self.showVolumeIcon = NO;
        self.playerGravity = DTPlayerGravityResizeAspect;
        self.playbackState = DTPlaybackStateStopped;
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    self.playerLayer.frame = self.layer.bounds;
}

-(void)dealloc
{
    [self unSetupObservers];
}

#pragma mark - public method
-(void)contentURL:(NSString*)url
{
    _type = 1;
    self.url = url;
    [self initPlayer];
}

-(void)contentPath:(NSString *)path
{
    _type = 2;
    self.path = path;
    [self initPlayer];
}

-(void)prepare
{
    
}

-(void)play
{
    if (!self.player) {
        return;
    }
    self.playbackState = DTPlaybackStatePlaying;
    if (self.backStateBlock) {
        self.backStateBlock(self.playbackState);
    }
    [self.player play];
}

-(void)pause
{
    if (!self.player) {
        return;
    }
    self.playbackState = DTPlaybackStatePaused;
    if (self.backStateBlock) {
        self.backStateBlock(self.playbackState);
    }
    [self.player pause];
}

-(void)stop
{
    if (!self.player) {
        return;
    }
    //释放播放资源
    [self.player replaceCurrentItemWithPlayerItem:nil];
    
    self.playbackState = DTPlaybackStateStopped;
//    if (self.backStateBlock) {
//        self.backStateBlock(self.playbackState);
//    }
}

-(void)seekTo:(CGFloat)time;
{
    if (!self.player) {
        return;
    }
    CMTime changedTime = CMTimeMakeWithSeconds(time, 1);
    [self.player seekToTime:changedTime completionHandler:^(BOOL finished) {
        
    }];
}

-(void)idleTimerDisabled:(BOOL)enabled
{
    [DTPlayerSupport idleTimerDisabled:enabled];
}

-(CGFloat)getBrightnessValue
{
    return [DTPlayerSupport getBrightnessValue];
}

-(void)addBrightness
{
    CGFloat value = [self getBrightnessValue];
    if (value > 1) {
        return;
    }
    value = value + AVPlayerBrightnessStep;
    [DTPlayerSupport setBrightnessValue:value];
}
-(void)lessBrightness
{
    CGFloat value = [self getBrightnessValue];
    if (value < 0) {
        return;
    }
    value = value - AVPlayerBrightnessStep;
    [DTPlayerSupport setBrightnessValue:value];
}

-(CGFloat)getVolumeValue
{
    return [DTPlayerSupport getVolumeValue];
}

-(void)addVolume
{
    CGFloat value = [self getVolumeValue];
    if (value > 1) {
        return;
    }
    value = value + AVPlayerVolumeStep;
    [DTPlayerSupport setVolumeValue:value showIcon:self.showVolumeIcon];
}

-(void)lessVolume
{
    CGFloat value = [self getVolumeValue];
    if (value < 0) {
        return;
    }
    value = value - AVPlayerVolumeStep;
    [DTPlayerSupport setVolumeValue:value showIcon:self.showVolumeIcon];
}


-(void)addProgress
{
    if (self.currentTime > self.durationTime) {
        return;
    }
    CGFloat value = self.currentTime + AVPlayerProgressStep;
    [self seekTo:value];
}

-(void)lessProgress
{
    if (self.currentTime < 0 ) {
        return;
    }
    CGFloat value = self.currentTime - AVPlayerProgressStep;
    [self seekTo:value];
}

#pragma mark - priavte method

//初始化player
-(void)initPlayer
{
    if (self.player) {
        return;
    }
    if (_type ==1) {//网络视频
        if (!self.url || [self.url isEqualToString:@""]) {
            return;
        }
        self.playerItem = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:self.url]];
    }else if (_type ==2){
        if (!self.path || [self.path isEqualToString:@""]) {
            return;
        }
        NSURL *sourceMovieURL = [NSURL fileURLWithPath:self.path];
        AVURLAsset *movieAsset = [AVURLAsset URLAssetWithURL:sourceMovieURL options:nil];
        self.playerItem = [AVPlayerItem playerItemWithAsset:movieAsset];
    }
    
    
    //player是视频播放的控制器，可以用来快进播放，暂停等
    self.player = [AVPlayer playerWithPlayerItem:self.playerItem];
    self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    self.playerLayer.frame = self.layer.bounds;
    self.playerLayer.backgroundColor = [UIColor blackColor].CGColor;
    self.playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
    [self.layer addSublayer:self.playerLayer];
    
    [self setupObservers];
}

//增加通知/KVO
- (void)setupObservers
{
    //监听物理音量键
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(systemVolumeDidChange:)
                                                 name:SystemVolumeDidChangeNotification
                                               object:nil];
    //进入APP
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationDidEnterForeground:)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:[UIApplication sharedApplication]];
    //回到桌面
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationDidEnterBackground:)
                                                 name:UIApplicationWillResignActiveNotification
                                               object:[UIApplication sharedApplication]];
    
    // 添加视频播放结束通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayDidEnd:)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:nil];
    
    // 监听rate属性
//    [self.player addObserver:self forKeyPath:AVPlayer_rate
//                     options:NSKeyValueObservingOptionNew
//                     context:nil];
    // 监听status属性
    [self.playerItem addObserver:self
                      forKeyPath:AVPlayerItem_status
                         options:NSKeyValueObservingOptionNew
                         context:nil];
    // 监听loadedTimeRanges属性
    [self.playerItem addObserver:self
                      forKeyPath:AVPlayerItem_loadedTimeRanges
                         options:NSKeyValueObservingOptionNew
                         context:nil];
    // 监听playbackBufferEmpty属性
    [self.playerItem addObserver:self
                      forKeyPath:AVPlayerItem_playbackBufferEmpty
                         options:NSKeyValueObservingOptionNew context:nil];
    // 监听playbackLikelyToKeepUp属性
    [self.playerItem addObserver:self
                      forKeyPath:AVPlayerItem_playbackLikelyToKeepUp
                         options:NSKeyValueObservingOptionNew context:nil];
}

//移除通知
- (void)unSetupObservers
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
//    [self.player removeObserver:self forKeyPath:AVPlayer_rate context:nil];
    [self.playerItem removeObserver:self forKeyPath:AVPlayerItem_status context:nil];
    [self.playerItem removeObserver:self forKeyPath:AVPlayerItem_loadedTimeRanges context:nil];
    [self.playerItem removeObserver:self forKeyPath:AVPlayerItem_playbackBufferEmpty context:nil];
    [self.playerItem removeObserver:self forKeyPath:AVPlayerItem_playbackLikelyToKeepUp context:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    [self.player removeTimeObserver:self.playbackTimeObserver];
}

/*!
 *  @author DT
 *
 *  @brief  为playerItem添加定时器,监控每秒的播放时长
 *
 *  @param playerItem
 */
- (void)monitoringPlayback:(AVPlayerItem *)playerItem {
    WEAKSELF
    self.playbackTimeObserver = [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1, 1) queue:NULL usingBlock:^(CMTime time) {
//        CGFloat currentSecond = playerItem.currentTime.value/playerItem.currentTime.timescale;// 计算当前在第几秒
        //获取视频当前播放时长(秒)
        CGFloat currentSecond = CMTimeGetSeconds(playerItem.currentTime);
        weakSelf.currentTime = currentSecond;
        if (weakSelf.currentTimeChangedBlock) {
            weakSelf.currentTimeChangedBlock(currentSecond);
        }
    }];
}

/*!
 *  @author DT
 *
 *  @brief  获取player的缓冲大小
 *
 *  @return 缓冲值
 */
- (NSTimeInterval)availableDuration
{
    NSArray *loadedTimeRanges = [[self.player currentItem] loadedTimeRanges];
    CMTimeRange timeRange = [loadedTimeRanges.firstObject CMTimeRangeValue];// 获取缓冲区域
    float startSeconds = CMTimeGetSeconds(timeRange.start);
    float durationSeconds = CMTimeGetSeconds(timeRange.duration);
    NSTimeInterval result = startSeconds + durationSeconds;// 计算缓冲总进度
    return result;
}

#pragma mark - observer response
- (void)systemVolumeDidChange:(NSNotification *)notification
{
    NSLog(@"------");
}

- (void)moviePlayDidEnd:(NSNotification *)notification
{
//    self.player.actionAtItemEnd = AVPlayerActionAtItemEndNone;
    self.playbackState = DTPlaybackStateStopped;
    if (self.backStateBlock) {
        self.backStateBlock(self.playbackState);
    }
}

- (void)applicationDidEnterForeground:(NSNotification *)notification
{
    NSLog(@"DTPlaybackStateSeekingForward");
    self.playbackState = DTPlaybackStateSeekingForward;
    if (self.backStateBlock) {
        self.backStateBlock(self.playbackState);
    }
}

- (void)applicationDidEnterBackground:(NSNotification *)notification
{
    NSLog(@"DTPlaybackStateSeekingBackward");
    self.playbackState = DTPlaybackStateSeekingBackward;
    if (self.backStateBlock) {
        self.backStateBlock(self.playbackState);
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    AVPlayerItem *playerItem = (AVPlayerItem *)object;
    if ([keyPath isEqualToString:AVPlayerItem_status]) {
        if ([playerItem status] == AVPlayerStatusReadyToPlay) {
            NSLog(@"AVPlayerStatusReadyToPlay");
            //获取视频总时长(秒)
            self.durationTime = CMTimeGetSeconds(playerItem.duration);
            if (self.loadStateBlock) {
                self.loadStateBlock(DTPlayerStatusReadyToPlay);
            }
            [self monitoringPlayback:playerItem];
        } else if ([playerItem status] == AVPlayerStatusFailed) {
            NSLog(@"AVPlayerStatusFailed");
            if (self.loadStateBlock) {
                self.loadStateBlock(DTPlayerStatusFailed);
            }
        }else if ([playerItem status] == AVPlayerStatusUnknown) {
            NSLog(@"AVPlayerStatusUnknown");
            if (self.loadStateBlock) {
                self.loadStateBlock(DTPlayerStateUnknown);
            }
        }
    } else if ([keyPath isEqualToString:AVPlayerItem_loadedTimeRanges]) {
//        NSLog(@"loadedTimeRanges");
        NSTimeInterval timeInterval = [self availableDuration];//获取缓冲值
        if (self.bufferChangedBlock) {
            self.bufferChangedBlock(timeInterval);
        }
        int rate =[[NSString stringWithFormat:@"%f",self.player.rate] intValue];
        if (self.playbackState == DTPlaybackStatePlaying && rate==0) {
            if (self.networkNotBestBlock) {
                self.networkNotBestBlock();
            }
            float ti =[[NSString stringWithFormat:@"%f",timeInterval] floatValue];
            if (ti >self.currentTime + 2) {//缓冲时间大于播放时间2秒就自动播放
                [self.player play];
            }
        }
        
    }else if ([keyPath isEqualToString:AVPlayerItem_playbackBufferEmpty]){//表示没有缓存
        NSLog(@"playbackBufferEmpty");
        //当self.player.rate==0时,self.player会被pause
        NSLog(@"rate:%f",self.player.rate);
    }else if ([keyPath isEqualToString:AVPlayerItem_playbackLikelyToKeepUp]){
        NSLog(@"playbackLikelyToKeepUp");
//        NSLog(@"KeepUp:%i",self.playerItem.playbackLikelyToKeepUp);
    }
}

#pragma mark - getter
//- (AVPlayer*)player
//{
//    return [(AVPlayerLayer*)[self layer] player];
//}
-(BOOL)isPlaying
{
    if (self.playbackState == DTPlaybackStatePlaying) {
        return YES;
    }
    return NO;
}

#pragma mark - setter
//- (void)setPlayer:(AVPlayer*)player
//{
//    [(AVPlayerLayer*)[self layer] setPlayer:player];
//}

-(void)setPlayerGravity:(DTPlayerGravity)playerGravity
{
    _playerGravity = playerGravity;
    if (!self.player) {
        return;
    }
    if (playerGravity == DTPlayerGravityResizeAspect) {
        self.playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
    }else if (playerGravity == DTPlayerGravityResizeAspectFill){
        self.playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    }else if (playerGravity == DTPlayerGravityResize){
        self.playerLayer.videoGravity = AVLayerVideoGravityResize;
    }
}

@end
