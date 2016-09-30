//
//  DTPlayerView.h
//  AVPlayerDemo
//
//  Created by DT on 15/6/5.
//  Copyright (c) 2015年 DT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "DTPlayerSupport.h"
#import "DTPlayerConfig.h"

/*!
 *  @author DT
 *
 *  @brief  视频播放类(无界面)
 */
@interface DTPlayerView : UIView

#pragma mark - object

#pragma mark - public method
/*!
 *  @author DT
 *
 *  @brief  加载网络视频
 *
 *  @param url 视频url,为nil或为空字符串的话会返回
 */
-(void)contentURL:(NSString*)url;

/*!
 *  @author DT
 *
 *  @brief  加载本地视频
 *
 *  @param path 本地视频url,为nil或为空字符串的话会返回
 */
-(void)contentPath:(NSString*)path;

//当准备完毕后会自动播放
-(void)prepare;

/*!
 *  @author DT
 *
 *  @brief  视频播放
 */
-(void)play;

/*!
 *  @author DT
 *
 *  @brief  视频暂停
 */
-(void)pause;

/*!
 *  @author DT
 *
 *  @brief  停止视频,释放掉AVPlayer
 */
-(void)stop;

/*!
 *  @author DT
 *
 *  @brief  视频进度设置
 *
 *  @param time 进度值,单位为秒
 */
-(void)seekTo:(CGFloat)time;

/*!
 *  @author DT
 *
 *  @brief  设置屏幕是否允许休眠
 *
 *  @param enabled YES:是 NO:否
 */
-(void)idleTimerDisabled:(BOOL)enabled;

/*!
 *  @author DT
 *
 *  @brief  获取屏幕亮度值
 *
 *  @return 屏幕亮度值,单位在0~1之间
 */
-(CGFloat)getBrightnessValue;

/*!
 *  @author DT
 *
 *  @brief  增加屏幕亮度值,默认每次增加0.0625f,可以修改DTPlayerConfig.h类中的默认值
 */
-(void)addBrightness;

/*!
 *  @author DT
 *
 *  @brief  减少屏幕亮度值,默认每次减少0.0625f,可以修改DTPlayerConfig.h类中的默认值
 */
-(void)lessBrightness;

/*!
 *  @author DT
 *
 *  @brief  获取系统音量值
 *
 *  @return 音量值,单位在0～1之间
 */
-(CGFloat)getVolumeValue;

/*!
 *  @author DT
 *
 *  @brief  增加系统音量,默认每次增加0.0625f,可以修改DTPlayerConfig.h类中的默认值
 */
-(void)addVolume;

/*!
 *  @author DT
 *
 *  @brief  减少系统音量,默认每次减少0.0625f,可以修改DTPlayerConfig.h类中的默认值
 */
-(void)lessVolume;

/*!
 *  @author DT
 *
 *  @brief  增加视频播放进度,默认每次增加0.5f,可以修改DTPlayerConfig.h类中的默认值
 */
-(void)addProgress;

/*!
 *  @author DT
 *
 *  @brief  减少视频播放进度,默认每次减少0.0625f,可以修改DTPlayerConfig.h类中的默认值
 */
-(void)lessProgress;

#pragma mark - property

@property(nonatomic,assign) DTPlaybackState playbackState;
@property(nonatomic,assign) DTPlayerGravity playerGravity;

/** 总的视频时间,单位秒,只在DTPlayerStatusReadyToPlay枚举之后有效 */
@property(nonatomic,assign)CGFloat durationTime;
/** 当前视频播放时间,单位秒 */
@property(nonatomic,assign)CGFloat currentTime;
/** 是否显示系统音量图标,默认为NO */
@property(nonatomic,assign)BOOL showVolumeIcon;
/** 视频是否在播放中 */
@property(nonatomic,assign)BOOL isPlaying;

#pragma mark block
/** 视频加载状态改变的回调 */
@property(nonatomic,copy) void(^loadStateBlock)(DTPlayLoadState state);
/** 视频播放状态改变的回调 */
@property(nonatomic,copy) void(^backStateBlock)(DTPlaybackState state);
/** 播放时间改变的回调 */
@property(nonatomic,copy) void(^currentTimeChangedBlock)(CGFloat currentTime);
/** 视频缓冲值改变的回调 */
@property(nonatomic,copy) void(^bufferChangedBlock)(CGFloat bufferedSecond);
/** 网络状态不好的回调 */
@property(nonatomic,copy) void(^networkNotBestBlock)();

@end
