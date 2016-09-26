//
//  WMYDownloadRequest.m
//  DownLoadDemo
//
//  Created by 李林凯 on 16/9/23.
//  Copyright © 2016年 李林凯. All rights reserved.
//

#import "WMYDownloadRequest.h"
#import "WMYDownloadManager.h"

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
    NSUInteger receivedSize = [NSFileManager WMYfileLengthWithUrl:[NSFileManager WMYfileNamemd5StringWith:self.downModel.downUrl]];
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

/**
 * 实例化请求对象 已经存在则返回 不存在则创建一个并返回
 **/
+ (void)startDownload:(WMYDownModel *)downModel progressBlock:(progressBlock)progressBlock downloadStateBlock:(downloadStateBlock)downloadStateBlock
{
    WMYDownloadRequest *request = [[WMYDownloadManager sharedInstance] getRequestForUrl:downModel.downUrl];
    if (!request) {
        request = [[WMYDownloadRequest alloc] init];
        request.downModel = downModel;
        [request configDownRequest];
        request.progressBlock = progressBlock;
        request.downloadStateBlock = downloadStateBlock;
    }
    [request.downloadManager startRequestTask:request];
}

@end
