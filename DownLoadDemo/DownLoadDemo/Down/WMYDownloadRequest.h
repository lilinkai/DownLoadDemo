//
//  WMYDownloadRequest.h
//  DownLoadDemo
//
//  Created by 李林凯 on 16/9/23.
//  Copyright © 2016年 李林凯. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WMYDownModel.h"

@interface WMYDownloadRequest : NSObject

/**
 下载链接
 */
@property (strong, nonatomic) WMYDownModel *downModel;

@property (strong,nonatomic) NSMutableURLRequest *urlRequest;

@property (nonatomic) NSURLSessionDataTask *task;               //下载任务对象

+ (void)startDownload:(WMYDownModel *)downModel;

@end
