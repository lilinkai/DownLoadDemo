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

typedef void(^getCurrentDownVideoInfoBlock)(NSDictionary *videoInfo);

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

/**
 暂停全部请求
 */
- (void)suspendedAllDownLoad;

/**
 开始全部请求
 */
- (void)startAllDownLoad;

/**
 获取当前正在下载的电影信息
 
 @param getCurrentDownVideoInfoBlock 电影信息回调
 */
- (void)getCurrentDownVideoInfo:(getCurrentDownVideoInfoBlock)getCurrentDownVideoInfoBlock;

@end
