//
//  DTPlayerSupport.h
//  AVPlayerDemo
//
//  Created by DT on 15/6/5.
//  Copyright (c) 2015年 DT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import <UIKit/UIKit.h>

/*!
 *  @author DT
 *
 *  @brief  辅助工具
 */
@interface DTPlayerSupport : NSObject

/*!
 *  @author DT
 *
 *  @brief  获取屏幕亮度
 *
 *  @return 亮度值
 */
+(CGFloat)getBrightnessValue;

/*!
 *  @author DT
 *
 *  @brief  设置屏幕亮度
 *
 *  @param value 屏幕亮度值,大小在0~1之间
 */
+(void)setBrightnessValue:(CGFloat)value;

/*!
 *  @author DT
 *
 *  @brief  获取系统音量
 *
 *  @return 音量值
 */
+(CGFloat)getVolumeValue;

/*!
 *  @author DT
 *
 *  @brief  设置系统音量
 *
 *  @param value 音量值,,大小在0~1之间
 *  @param showIcon 是否现实系统音量图标,NO:不显示 YES:显示
 */
+(void)setVolumeValue:(CGFloat)value showIcon:(BOOL)showIcon;

/*!
 *  @author DT
 *
 *  @brief  设置屏幕是否休眠
 *
 *  @param enabled
 */
+(void)idleTimerDisabled:(BOOL)enabled;

@end
