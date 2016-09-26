//
//  WMYDownloadRequest.h
//  DownLoadDemo
//
//  Created by 李林凯 on 16/9/23.
//  Copyright © 2016年 李林凯. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WMYDownModel.h"
#import "NSFileManager+WMYDownLoadFileConfig.h"

typedef enum {
    WMYStateStart = 0,     ///下载中
    WMYStateSuspended,     ///暂停中
    WMYStateCompleted,     ///完成
    WMYStateFailed         ///失败
}WMYDownloadState;

typedef void(^progressBlock)(NSString *receivedSize, NSString * expectedSize,float progress, NSString *speed);    //下载进度回调

typedef void(^downloadStateBlock)(WMYDownloadState state);  //下载状态

@interface WMYDownloadRequest : NSObject

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

@property (strong,nonatomic) NSMutableURLRequest *urlRequest;

@property (nonatomic) NSURLSessionDataTask *task;               //下载任务对象

@property (nonatomic, assign)NSUInteger growth; //当前网速

/**
 下载进度
 */
@property (nonatomic, copy) progressBlock progressBlock;

/**
 下载状态
 */
@property (nonatomic, copy) downloadStateBlock downloadStateBlock;

+ (void)startDownload:(WMYDownModel *)downModel progressBlock:(progressBlock)progressBlock downloadStateBlock:(downloadStateBlock)downloadStateBlock;

@end
