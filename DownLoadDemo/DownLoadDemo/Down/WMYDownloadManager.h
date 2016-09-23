//
//  WMYDownloadManager.h
//  DownLoadDemo
//
//  Created by 李林凯 on 16/9/22.
//  Copyright © 2016年 李林凯. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WMYDownloadRequest;

@class WMYDownModel;

@interface WMYDownloadManager : NSObject

#pragma mark 下载队列管理单例对象
+ (instancetype)sharedInstance;

#pragma mark 获取对应url下载任务
- (WMYDownloadRequest *)getRequestForUrl:(NSString *)url;

- (void)startRequestTask:(WMYDownloadRequest *)request;

@end
