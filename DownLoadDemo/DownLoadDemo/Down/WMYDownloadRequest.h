//
//  WMYDownloadRequest.h
//  DownLoadDemo
//
//  Created by 李林凯 on 16/9/23.
//  Copyright © 2016年 李林凯. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WMYDownModel.h"

typedef enum {
    WMYStateStart = 0,     ///下载中
    WMYStateSuspended,     ///暂停中
    WMYStateCompleted,     ///完成
    WMYStateCancel,         ///取消
    WMYStateFailed         ///失败
}WMYDownloadState;

typedef void(^progressBlock)(NSString *receivedSize, NSString *expectedSize, float progress, NSString *speed);

typedef void(^stateBlock)(WMYDownloadState state);

@interface WMYDownloadRequest : NSObject

/**
时间速率
 */
@property (nonatomic, strong)NSTimer *timer;

/**
 当前网速
 */
@property (nonatomic, assign)NSUInteger growth;

/**
 文件流
 */
@property (nonatomic, strong) NSOutputStream *stream;

/**
 数据的总长度
 */
@property (nonatomic, assign) NSInteger totalLength;
@property (nonatomic, copy) NSString *totalLengthString;

/**
 下载model
 */
@property (strong, nonatomic) WMYDownModel *downModel;

/**
 下载urlRequest配置
 */
@property (strong,nonatomic) NSMutableURLRequest *urlRequest;

/**
 下载任务对象
 */
@property (nonatomic) NSURLSessionDataTask *task;

/**
 下载状态
 */
@property (nonatomic, assign)WMYDownloadState downState;

/**
 下载进度回调
 */
@property (nonatomic, copy) progressBlock progressBlock;

/**
 下载状态回调
 */
@property (nonatomic, copy) stateBlock stateBlock;

- (void)configDownRequest;

@end
