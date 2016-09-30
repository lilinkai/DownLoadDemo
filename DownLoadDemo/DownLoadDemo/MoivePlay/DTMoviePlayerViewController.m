//
//  DTMoviePlayerViewController.m
//  AVPlayMovie
//
//  Created by 穷极一生做不完一场梦 on 16/5/3.
//  Copyright © 2016年 穷极一生做不完一场梦 - 远. All rights reserved.
//

#import "DTMoviePlayerViewController.h"
#import "UIView+Constraint.h"
#import "UIView+Additions.h"
#import "NSFileManager+WMYDownLoadFileConfig.h"

//颜色
#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]
// block self
#define WEAKSELF typeof(self) __weak weakSelf = self;

#define Tolerant 10

//全屏宽，高
#define SCREEN_WIDTH  [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

@interface DTMoviePlayerViewController ()
{
    CGFloat _height;
    CGFloat _footHeight;
    BOOL _isHiding;
    CGPoint _beginPoint;
    
    BOOL _isPause;//是否暂停
    NSTimer *_timer;//定时器
    double _currentTime;
    double _totalTime;
    UIStatusBarStyle _statusBarStyle;

    BOOL _isSize;//横屏竖屏

}

@property(nonatomic, assign)BOOL isSupportLandscape;


@end

@implementation DTMoviePlayerViewController

- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = YES;
//    _statusBarStyle = [[UIApplication sharedApplication] statusBarStyle];
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    [[UIApplication sharedApplication] setStatusBarStyle:_statusBarStyle animated:YES];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.isSupportLandscape = YES;

    [self addSubViews];
//    @"http://baobab.cdn.wandoujia.com/14468618701471.mp4"
    
//    NSString*thePath=[[NSBundle mainBundle] pathForResource:@"yourVideo" ofType:@"MOV"];
//    NSURL*theurl=[NSURL fileURLWithPath:thePath];
    
    NSLog(@"self.urlString == %@",self.urlString);

    NSString * s = [[NSFileManager WMYCachesDirectory] stringByAppendingPathComponent:self.urlString];
    
    [self.playerView contentPath:s];

    
    _isPause = NO;
    _isSize = NO;
}

-(void)playFromPathUrl:(NSString*)url inSuperView:(UIView*)superView
{
    _height = 160;
    _footHeight = 40;
    
}

#pragma mark - event response
-(void)playerResponse
{
    WEAKSELF
    [self.activityView startAnimating];
    [self.footView setHidden:YES];
    [self changePlayerButtonIcon];
    
    //视频加载状态回调
    [self.playerView setLoadStateBlock:^(DTPlayLoadState state) {
        [weakSelf.activityView stopAnimating];
        [weakSelf.footView setHidden:NO];
        weakSelf.playerView.playerGravity = DTPlayerGravityResizeAspect;
        
        [weakSelf performSelector:@selector(hideFootView) withObject:nil afterDelay:2];
        
        if (state == DTPlayerStatusReadyToPlay) {
            if (weakSelf.playerView.playbackState == DTPlaybackStateSeekingBackward) {//表示按home键的时候不处理
                return ;
            }
            CGFloat currentTime = weakSelf.playerView.currentTime;
            CGFloat durationTime = weakSelf.playerView.durationTime;
            weakSelf.durationLabel.text = [weakSelf convertTime:durationTime];
            weakSelf.currentLabel.text = [weakSelf convertTime:currentTime];
            weakSelf.progressSlider.minimumValue = currentTime;
            weakSelf.progressSlider.maximumValue = durationTime;
            
            
//            [weakSelf.playerView seekTo:20];//跳转到指定时间
            
            
            [weakSelf.playerView play];
            [weakSelf changePlayerButtonIcon];
        }else if (state == DTPlayerStatusFailed || state == DTPlayerStateUnknown){
            NSLog(@"加载失败,请返回...");
        }
    }];
    //视频播放状态回调
    [self.playerView setBackStateBlock:^(DTPlaybackState state) {
        if (state == DTPlaybackStateSeekingBackward){
            [weakSelf.playerView pause];
        }else if (state == DTPlaybackStateSeekingForward) {
            [weakSelf.playerView play];
        }else if (state == DTPlaybackStateStopped){
            [weakSelf.playerView seekTo:0];
            [weakSelf.playerView play];
        }
    }];
    //视频播放时间回调
    [self.playerView setCurrentTimeChangedBlock:^(CGFloat currentTime) {
        
//        weakSelf.currentLabel.text = @"00:10";
//        [weakSelf.progressSlider setValue:20.00013 animated:YES];

        weakSelf.currentLabel.text = [weakSelf convertTime:currentTime];
        [weakSelf.progressSlider setValue:currentTime animated:YES];
    }];
    //视频缓冲时间回调
    [self.playerView setBufferChangedBlock:^(CGFloat bufferedSecond) {
        if (bufferedSecond >0 && weakSelf.playerView.durationTime >0) {
            weakSelf.progressView.progress=bufferedSecond/weakSelf.playerView.durationTime;
        }
    }];
    //视频网络延迟回调
    [self.playerView setNetworkNotBestBlock:^{
        NSLog(@"网络卡...");
    }];
}

//播放按钮事件
-(void)clickPlayerButton:(UIButton*)button
{
    if (self.playerView.isPlaying) {
        [self.playerView pause];
        [self changePlayerButtonIcon];
    }else{
        [self.playerView play];
        [self changePlayerButtonIcon];
    }
}

//改变播放按钮图标
-(void)changePlayerButtonIcon
{
    if (!self.playerView.isPlaying) {
        [self.playerButton setImage:[UIImage imageNamed:@"icon_play_nomal.png"] forState:UIControlStateNormal];
        [self.playerButton setImage:[UIImage imageNamed:@"icon_play_pressed.png"] forState:UIControlStateHighlighted];
    }else{
        [self.playerButton setImage:[UIImage imageNamed:@"icon_pause_normal.png"] forState:UIControlStateNormal];
        [self.playerButton setImage:[UIImage imageNamed:@"icon_pause_pressed.png"] forState:UIControlStateHighlighted];
    }
}

-(void)sliderTouchDown:(UISlider*)slider
{
    [self.playerView pause];
    [self changePlayerButtonIcon];
}

//拖动slider触发事件
-(void)sliderValueChanged:(UISlider*)slider
{
    float f = slider.value;
    self.currentLabel.text = [self convertTime:f];
}

-(void)sliderTouchUpInside:(UISlider*)slider
{
    [self.playerView seekTo:slider.value];
    [self.playerView play];
    [self changePlayerButtonIcon];
}

//点击手事件
-(void)handleTapGesture:(UIGestureRecognizer*)sender
{
    //拿到手指目前的位置
    CGPoint location = [sender locationInView:sender.view];
    if (CGRectContainsPoint(self.footView.frame, location) || CGRectContainsPoint(self.headerView.frame, location)) {//坐标在上下导航栏范围内
        return;
    }
    [self hideShowFootView];
}

//滑动手势事件
-(void)handlePanGesture:(UIPanGestureRecognizer*)sender
{
    //拿到手指目前的位置
    CGPoint location = [sender locationInView:sender.view];
    
    if (sender.state == UIGestureRecognizerStateChanged){
        
        //拿到手指滑动的大小
        CGPoint translation = [sender translationInView:sender.view];
        
        if (ABS(translation.x) <= Tolerant && location.y < _beginPoint.y) {
            //            NSLog(@"向上");
            CGRect brightnessRect = CGRectMake(0, 0, CGRectGetWidth(self.view.frame)*0.5, CGRectGetHeight(self.view.frame));
            CGRect volumeRect = CGRectMake(CGRectGetWidth(self.view.frame)-CGRectGetWidth(self.view.frame)*0.5, 0, CGRectGetWidth(self.view.frame)*0.5,CGRectGetHeight(self.view.frame));
            
            if (CGRectContainsPoint(brightnessRect, location)) {
                NSLog(@"增加亮度");
                [self.playerView addBrightness];
            }else if (CGRectContainsPoint(volumeRect, location)){
                NSLog(@"增加音量");
                [self.playerView addVolume];
            }
            
        }else if (ABS(translation.x) <= Tolerant && location.y > _beginPoint.y){
            //            NSLog(@"向下");
            CGRect brightnessRect = CGRectMake(0, 0, CGRectGetWidth(self.view.frame)*0.5, CGRectGetHeight(self.view.frame));
            CGRect volumeRect = CGRectMake(CGRectGetWidth(self.view.frame)-CGRectGetWidth(self.view.frame)*0.5, 0, CGRectGetWidth(self.view.frame)*0.5,CGRectGetHeight(self.view.frame));
            
            if (CGRectContainsPoint(brightnessRect, location)) {
                NSLog(@"降低亮度");
                [self.playerView lessBrightness];
            }else if (CGRectContainsPoint(volumeRect, location)){
                NSLog(@"降低音量");
                [self.playerView lessVolume];
            }
            
        }else if (location.x > _beginPoint.x && ABS(translation.y) <= Tolerant){
            NSLog(@"快进");
            _isPause = YES;
            [self.playerView pause];
            [self.playerView addProgress];
        }else if (location.x < _beginPoint.x && ABS(translation.y) <= Tolerant){
            NSLog(@"后退");
            _isPause = YES;
            [self.playerView pause];
            [self.playerView lessProgress];
        }
        _beginPoint = location;
        
    }else if (sender.state == UIGestureRecognizerStateBegan){
        //拿到手指目前的位置
        CGPoint location = [sender locationInView:sender.view];
        if (CGRectContainsPoint(self.footView.frame, location) ) {//坐标在上下导航栏范围内
            return;
        }
        
        if (!self.activityView.isAnimating) {
            return;
        }
        
        _beginPoint = location;
    }else if (sender.state == UIGestureRecognizerStateEnded){
        if (_isPause) {
            _isPause = NO;
            [self.playerView play];
        }
    }
}

#pragma mark - private method
-(void)addGestureRecognizer
{
    UITapGestureRecognizer *gr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    [self.playerView addGestureRecognizer:gr];
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    [self.playerView addGestureRecognizer:panGesture];
}

/*!
 *  @author DT
 *
 *  @brief  隐藏状态栏
 */
-(void)hideFootView
{
    [self addGestureRecognizer];
    [self hideShowFootView];
}

/*!
 *  @author DT
 *
 *  @brief  隐藏显示状态栏
 */
-(void)hideShowFootView
{
    if (!self.activityView.isAnimating) {
        if (!_isHiding) {
            _isHiding = YES;
            
            /** 判断
             *  竖屏不隐藏状态栏返回按钮
             *  横屏全隐藏
             */

            if (_isSize) {
                self.headerView.hidden = !self.headerView.hidden;
                self.footView.hidden = !self.footView.hidden;
                if(self.footView.hidden){
                    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
                }else{
                    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
                }
            }else{
                self.footView.hidden = !self.footView.hidden;
            }
         
            _isHiding = NO;
            /*
             [UIView animateWithDuration:1.25 animations:^{
             if ([self.footView isHidden]) {
             self.footView.alpha = 1;
             }else{
             self.footView.alpha = 0;
             }
             } completion:^(BOOL finished) {
             if ([self.footView isHidden]) {
             self.footView.hidden = NO;
             self.footView.alpha = 0;
             }else{
             self.footView.hidden = YES;
             self.footView.alpha = 1;
             }
             _isHiding = NO;
             }];
             //*/
        }
    }
}
/*!
 *  @author DT
 *
 *  @brief  秒转化成时间文本
 *
 *  @param second 秒
 *
 *  @return 字符串文本
 */
-(NSString *)convertTime:(CGFloat)second
{
    if (second==0){
        return @"00:00";
    }
    NSUInteger hMinutes = floor((int)second/60/60);
    NSUInteger dMinutes = floor(((int)second/60)%60);
    NSUInteger dSeconds = floor((int)second%60);
    if (hMinutes ==0) {
        return [NSString stringWithFormat:@"%02lu:%02lu", (unsigned long)dMinutes, (unsigned long)dSeconds];
    }else{
        return [NSString stringWithFormat:@"%02lu:%02lu:%02lu", (unsigned long)hMinutes,(unsigned long)dMinutes, (unsigned long)dSeconds];
    }
}

-(void)addSubViews
{
    self.playerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 230);

    [self.view addSubview:self.playerView];
    [self.view addSubview:self.activityView];
    self.activityView.center = self.playerView.center;
    
    [self.view addSubview:self.headerView];
    [self.headerView addSubview:self.backButton];
    [self.headerView addSubview:self.titleLabel];
    [self.view addSubview:self.footView];
    [self.footView addSubview:self.playerButton];
    [self.footView addSubview:self.currentLabel];
    [self.footView addSubview:self.progressView];
    [self.progressView addSubview:self.progressSlider];
    [self.footView addSubview:self.durationLabel];
    [self.footView addSubview:self.gravityButton];
    
    [self verticalFrame];
    [self playerResponse];
}

- (void)verticalFrame
{
    _titleLabel.text = @"友谊的小船说翻就翻";

    _footHeight = 40;
    self.headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, _footHeight + 10);
    self.backButton.frame = CGRectMake(5, 0, _footHeight, _footHeight+10);
    self.titleLabel.frame = CGRectMake(_footHeight - 10, 12, self.headerView.width - _footHeight-10, _footHeight);
    self.footView.frame = CGRectMake(0, self.playerView.height - _footHeight, SCREEN_WIDTH, _footHeight);
    self.playerButton.frame = CGRectMake(0, 5, 35, 30);
    self.currentLabel.frame = CGRectMake(self.playerButton.width-2, 0, _footHeight, _footHeight);
    self.gravityButton.frame = CGRectMake(SCREEN_WIDTH-35, 10, 20, 20);
    self.durationLabel.frame = CGRectMake(SCREEN_WIDTH-80, 0, _footHeight, _footHeight);
    self.progressView.frame = CGRectMake(self.playerButton.width + self.currentLabel.width + 5, 20, SCREEN_WIDTH - 160, 6);
    self.progressSlider.frame = CGRectMake(-2, -1, self.progressView.width+2, 4);
    
    _backButton.iconImageView.image = [UIImage imageNamed:@"icon_back_white_pressed.png"];
    _backButton.iconImageView.frame = CGRectMake(5, 25, 15, 15); // 给返回图标一个frame
}
#pragma mark - 系统相关
//隐藏状态栏
- (BOOL)prefersStatusBarHidden
{
    return YES;//隐藏为YES，显示为NO
}
#pragma mark 屏幕旋转
-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    // 判断横竖屏
    if (UIInterfaceOrientationIsPortrait(toInterfaceOrientation)) {
        NSLog(@"屏幕将旋转 为 竖屏");
        [self setmoviePlay:NO];
        
    }else{
        [self setmoviePlay:YES];
        NSLog(@"屏幕将旋转 为 横屏");
    }
}
#pragma mark 适配横竖屏
- (void)setmoviePlay:(BOOL)relation{    
    if (relation == YES) {
        
        [UIView animateWithDuration:0.25 animations:^{
//            [self prefersStatusBarHidden];

            self.playerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
            [self verticalFrame];
            self.footView.hidden = NO;

            _isSize = YES;
        }];
    }else{
        
        [UIView animateWithDuration:0.25 animations:^{
            self.playerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 230);

            [self verticalFrame];
            /** 竖屏不隐藏状态栏返回按钮*/
            _isSize = NO;
            [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
            self.headerView.hidden = NO;
        }];
    }

}
// 支持屏幕旋转方向 好像就这一个有效果，其他两个注释了也没发现啥问题，不理解。(＞﹏＜)
-(UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    if (self.isSupportLandscape == YES) {
        
        return (UIInterfaceOrientationMaskAll /*| UIInterfaceOrientationMaskLandscapeLeft | UIInterfaceOrientationMaskLandscapeRight*/);
    }else{
        
        return (UIInterfaceOrientationMaskPortrait /*| UIInterfaceOrientationMaskLandscapeLeft | UIInterfaceOrientationMaskLandscapeRight*/);
    }
}
// 不自动旋转
- (BOOL)shouldAutorotate
{
    if (self.isSupportLandscape == YES) {
        return YES;
    }else{
        return NO;
    }
}

//返回按钮事件
-(void)clickBackButton:(UIButton*)button
{
    self.navigationController.navigationBarHidden = NO;
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - getter
-(DTPlayerView*)playerView
{
    if (!_playerView) {
        _playerView = [[DTPlayerView alloc] init];
        _playerView.backgroundColor = [UIColor blackColor];
    }
    return _playerView;
}
-(UIActivityIndicatorView*)activityView
{
    if (!_activityView) {
        _activityView = [[UIActivityIndicatorView alloc] init];
        [_activityView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhite];
    }
    return _activityView;
}

-(UIView*)headerView
{
    if (!_headerView) {
        _headerView = [[UIView alloc] init];
        _headerView.backgroundColor = RGBACOLOR(0, 0, 0, 0.5);
        _headerView.backgroundColor = [UIColor redColor];
    }
    return _headerView;
}
-(UIView*)footView
{
    if (!_footView) {
        _footView = [[UIView alloc] init];
        _footView.backgroundColor = RGBACOLOR(0, 0, 0, 0.5);
        _footView.backgroundColor = [UIColor orangeColor];
    }
    return _footView;
}

-(UIButton*)playerButton
{
    if (!_playerButton) {
        _playerButton = [[UIButton alloc] init];
        _playerButton.tag = 100;
        [_playerButton addTarget:self action:@selector(clickPlayerButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _playerButton;
}
-(UIButton*)gravityButton
{
    if (!_gravityButton) {
        _gravityButton = [[UIButton alloc] init];
        _gravityButton.tag = 100;
        [_gravityButton addTarget:self action:@selector(clickPlayerButton:) forControlEvents:UIControlEventTouchUpInside];
        [_gravityButton setImage:[UIImage imageNamed:@"icon_zoomout_pressed.png"] forState:UIControlStateNormal];
    }
    return _gravityButton;
}
-(UIButton*)backButton
{
    if (!_backButton) {
        _backButton = [ActionButton buttonWithType:UIButtonTypeCustom];
        [_backButton addTarget:self action:@selector(clickBackButton:) forControlEvents:
         UIControlEventTouchUpInside];

    }
    return _backButton;
}
-(UILabel*)currentLabel
{
    if (!_currentLabel) {
        _currentLabel = [[UILabel alloc] init];
        _currentLabel.backgroundColor = [UIColor clearColor];
        _currentLabel.font = [UIFont systemFontOfSize:12.0f];
        _currentLabel.textColor = [UIColor whiteColor];
        _currentLabel.textAlignment = NSTextAlignmentCenter;
        [_currentLabel sizeToFit];
        _currentLabel.text = @"";
    }
    return _currentLabel;
}

-(UIProgressView*)progressView
{
    if (!_progressView) {
        _progressView = [[UIProgressView alloc] init];
        _progressView.backgroundColor = [UIColor blueColor];
    }
    return _progressView;
}

-(UISlider*)progressSlider
{
    if (!_progressSlider) {
        _progressSlider = [[UISlider alloc] init];
        [_progressSlider setThumbImage:[UIImage imageNamed:@"kr-video-player-point"] forState:UIControlStateNormal];
        [_progressSlider setMinimumTrackTintColor:[UIColor blueColor]];
        [_progressSlider setMaximumTrackTintColor:[UIColor lightGrayColor]];
        [_progressSlider setValue:0.0f];
        [_progressSlider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
        [_progressSlider addTarget:self action:@selector(sliderTouchDown:) forControlEvents:UIControlEventTouchDown];
        [_progressSlider addTarget:self action:@selector(sliderTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _progressSlider;
}

-(UILabel*)durationLabel
{
    if (!_durationLabel) {
        _durationLabel = [[UILabel alloc] init];
        _durationLabel.backgroundColor = [UIColor clearColor];
        _durationLabel.font = [UIFont systemFontOfSize:12.0f];
        _durationLabel.textColor = [UIColor whiteColor];
        _durationLabel.textAlignment = NSTextAlignmentCenter;
        _durationLabel.text = @"";
    }
    return _durationLabel;
}
-(UILabel*)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.font = [UIFont systemFontOfSize:12.0f];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.text = @"";
    }
    return _titleLabel;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
