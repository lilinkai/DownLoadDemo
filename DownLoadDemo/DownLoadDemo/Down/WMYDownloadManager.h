//
//  WMYDownloadManager.h
//  DownLoadDemo
//
//  Created by 李林凯 on 16/9/22.
//  Copyright © 2016年 李林凯. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WMYDownloadRequest.h"
#import "WMYDownModel.h"

typedef void(^progressBlock)(NSString *receivedSize, NSString *expectedSize, float progress, NSString *speed);

typedef void(^stateBlock)(WMYDownloadState state);

@interface WMYDownloadManager : NSObject

/**
 所有的下载任务
 */
@property (strong, nonatomic) NSMutableArray *downTasks;

/**
 下载队列管理单例对象

 @return self
 */
+ (instancetype)sharedInstance;


/**
 开启本地存在的下载
 */
- (void)startLocalDownTask;

/**
 获取对应url下载任务

 @param url 下载url

 @return 请求对象
 */
- (WMYDownloadRequest *)getRequestForUrl:(NSString *)url;


/**
 开始下载

 @param model           下载model
 @param progressBlock 下载进度回调
 @param stateBlock    下载状态回调
 */
- (void)download:(WMYDownModel *)model progressBlock:(progressBlock)progressBlock stateBlock:(stateBlock)stateBlock;

/**
 删除对应的下载任务

 @param url 下载url
 */
- (void)delDownLoadForUrl:(NSString *)url;

@end
