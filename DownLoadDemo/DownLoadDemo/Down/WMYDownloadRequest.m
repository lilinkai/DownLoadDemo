//
//  WMYDownloadRequest.m
//  DownLoadDemo
//
//  Created by 李林凯 on 16/9/23.
//  Copyright © 2016年 李林凯. All rights reserved.
//

#import "WMYDownloadRequest.h"
#import "WMYDownloadManager.h"
#import "NSFileManager+WMYDownLoadFileConfig.h"

@interface WMYDownloadRequest ()
{
    NSUInteger       _lastSize;
}

@property (strong,nonatomic) WMYDownloadManager *downloadManager;

@end

@implementation WMYDownloadRequest

//计算一次文件大小增加部分的尺寸
-(void)getGrowthSize
{
    NSUInteger receivedSize = [NSFileManager WMYfileLengthWithUrl:self.downModel.downUrl];
    _growth=receivedSize-_lastSize;
    _lastSize=receivedSize;
}

- (void)configDownRequest
{
    self.downloadManager = [WMYDownloadManager sharedInstance];
    self.urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:self.downModel.downUrl]];
    // 创建流
    self.stream = [NSOutputStream outputStreamToFileAtPath:[NSFileManager WMYFilePathWithFileName:[NSFileManager WMYfileNamemd5StringWith:self.downModel.downUrl]] append:YES];

    //每0.5秒计算一次文件大小增加部分的尺寸
    _timer=[NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(getGrowthSize) userInfo:nil repeats:YES];
}

@end
