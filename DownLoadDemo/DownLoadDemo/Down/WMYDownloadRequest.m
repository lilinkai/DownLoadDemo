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

@property (strong,nonatomic) WMYDownloadManager *downloadManager;

@end

@implementation WMYDownloadRequest

- (instancetype)initWithDownModel:(WMYDownModel *)downModel
{
    self = [super init];
    if (self) {
        self.downModel = downModel;
        self.downloadManager = [WMYDownloadManager sharedInstance];
        self.urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:downModel.downUrl]];
    }
    return self;
}

/**
 * 实例化请求对象 已经存在则返回 不存在则创建一个并返回
 **/
+ (void)startDownload:(WMYDownModel *)downModel
{
    WMYDownloadRequest *request = [[WMYDownloadManager sharedInstance] getRequestForUrl:downModel.downUrl];
    if (!request) {
        request = [[WMYDownloadRequest alloc] initWithDownModel:downModel];
        [request.downloadManager startRequestTask:request];
    }
}

@end
