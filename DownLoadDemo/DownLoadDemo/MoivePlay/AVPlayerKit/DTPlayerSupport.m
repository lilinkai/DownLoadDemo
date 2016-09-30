//
//  DTPlayerSupport.m
//  AVPlayerDemo
//
//  Created by DT on 15/6/5.
//  Copyright (c) 2015年 DT. All rights reserved.
//

#import "DTPlayerSupport.h"
#import "DTPlayerConfig.h"

@implementation DTPlayerSupport

+(CGFloat)getBrightnessValue
{
    return [[UIScreen mainScreen] brightness];
}

+(void)setBrightnessValue:(CGFloat)value
{
    [[UIScreen mainScreen] setBrightness:value];
}

+(void)idleTimerDisabled:(BOOL)enabled
{
    [[UIApplication sharedApplication] setIdleTimerDisabled:enabled];
}

+(CGFloat)getVolumeValue
{
    /*MPVolumeView *volumeView = [[MPVolumeView alloc] init];
    UISlider* volumeViewSlider = nil;
    for (UIView *view in [volumeView subviews]){
        if ([view.class.description isEqualToString:@"MPVolumeSlider"]){
            volumeViewSlider = (UISlider*)view;
            break;
        }
    }
    return volumeViewSlider.value;*/

    MPMusicPlayerController *mpc = [MPMusicPlayerController applicationMusicPlayer];
    
    return [mpc volume];
    
}

+(void)setVolumeValue:(CGFloat)value showIcon:(BOOL)showIcon
{
    MPVolumeView *volumeView = [[MPVolumeView alloc] init];
//    if (!showIcon) {
//        volumeView.frame = CGRectMake(-9999, -9999, -9999, -9999);
//    }
    UISlider* volumeViewSlider = nil;
    for (UIView *view in [volumeView subviews]){
        if ([view.class.description isEqualToString:@"MPVolumeSlider"]){
            volumeViewSlider = (UISlider*)view;
            break;
        }
    }
    
    // change system volume, the value is between 0.0f and 1.0f
    [volumeViewSlider setValue:value animated:YES];
    
    // send UI control event to make the change effect right now.
    [volumeViewSlider sendActionsForControlEvents:UIControlEventTouchUpInside];
}

@end
