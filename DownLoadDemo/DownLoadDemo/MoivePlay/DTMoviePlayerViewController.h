//
//  DTMoviePlayerViewController.h
//  AVPlayMovie
//
//  Created by 穷极一生做不完一场梦 on 16/5/3.
//  Copyright © 2016年 穷极一生做不完一场梦 - 远. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import "DTPlayerView.h"
#import "UIView+Constraint.h"
#import "ActionButton.h"


@interface DTMoviePlayerViewController : UIViewController

@property(nonatomic,strong)DTPlayerView *playerView;
@property(nonatomic,strong)UIActivityIndicatorView *activityView;//等待框
@property(nonatomic,strong)UILabel *titleLabel;//标题
@property(nonatomic,strong)UIView *footView;//底部状态栏
@property(nonatomic,strong)UIButton *playerButton;//播放按钮
@property(nonatomic,strong)UILabel *currentLabel;//播放时间
@property(nonatomic,strong)UILabel *durationLabel;//总共时间
@property(nonatomic,strong)UISlider *progressSlider;//播放进度条
@property(nonatomic,strong)UIProgressView *progressView;//缓冲进度
@property(nonatomic,strong)UIButton *gravityButton;//播放视图
@property(nonatomic,strong)UIView *headerView; //顶部状态栏
@property(nonatomic,strong)ActionButton *backButton;//返回按钮
@property(nonatomic,strong)NSString *urlString;

@end
