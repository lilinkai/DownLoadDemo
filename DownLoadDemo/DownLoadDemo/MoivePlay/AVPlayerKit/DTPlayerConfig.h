//
//  DTPlayerConfig.h
//  AVPlayerDemo
//
//  Created by DT on 15/6/5.
//  Copyright (c) 2015年 DT. All rights reserved.
//

/*!
 *  @author DT
 *
 *  @brief  参数类
 */

#pragma mark - observer

#define SystemVolumeDidChangeNotification @"AVSystemController_SystemVolumeDidChangeNotification"
#define AVPlayer_rate @"rate"
#define AVPlayerItem_status @"status"
#define AVPlayerItem_loadedTimeRanges @"loadedTimeRanges"
#define AVPlayerItem_playbackBufferEmpty @"playbackBufferEmpty"
#define AVPlayerItem_playbackLikelyToKeepUp @"playbackLikelyToKeepUp"

#pragma mark - parameters

#define AVPlayerVolumeStep 0.0625f
#define AVPlayerBrightnessStep 0.0625f
#define AVPlayerProgressStep 5.0f


#pragma mark - enum

typedef enum{
    DTPlayerStatusReadyToPlay,//资源加载完成,可以播放
    DTPlayerStatusFailed,//资源加载失败
    DTPlayerStateUnknown,//未知错误
}DTPlayLoadState;//视频加载状态

typedef enum{
    DTPlayStateContentLoading,//正在加载中
    DTPlaybackStatePlaying,//正在播放中
    DTPlaybackStatePaused,//暂停播放中
    DTPlaybackStateStopped,//播放结束
    DTPlaybackStateSeekingForward,//回到前台中
    DTPlaybackStateSeekingBackward//回到后台中
} DTPlaybackState;//视频播放状态

typedef enum{
    DTPlayerGravityResizeAspect,//视频按宽高比显示在当前图层
    DTPlayerGravityResizeAspectFill,//视频按宽高比铺满显示在当前图层
    DTPlayerGravityResize,//视频铺满显示在当前图层
} DTPlayerGravity;//视频填充方式
