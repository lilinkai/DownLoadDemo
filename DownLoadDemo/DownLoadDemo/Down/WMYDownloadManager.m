//
//  WMYDownloadManager.m
//  DownLoadDemo
//
//  Created by 李林凯 on 16/9/22.
//  Copyright © 2016年 李林凯. All rights reserved.
//

#import "WMYDownloadManager.h"
#import "WMYDownOperation.h"

@interface WMYDownloadManager ()

@end

@implementation WMYDownloadManager

#pragma mark 下载队列管理单例对象
+ (instancetype)sharedInstance
{
    static WMYDownloadManager *manager;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[WMYDownloadManager alloc] init];
    });
    return manager;
}

- (NSOperationQueue *)downQueue
{
    if (_downQueue == nil) {
        _downQueue = [[NSOperationQueue alloc] init];
        _downQueue.maxConcurrentOperationCount = 1;
    }
    return _downQueue;
}

#pragma mark 下载
- (void)downLoadFileWithWithWMYDownModel:(WMYDownModel *)downModel{
    [WMYDownOperation downOperationWithWMYDownModel:downModel];
}

@end
