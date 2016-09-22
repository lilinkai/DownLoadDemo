//
//  WMYDownloadManager.h
//  DownLoadDemo
//
//  Created by 李林凯 on 16/9/22.
//  Copyright © 2016年 李林凯. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WMYDownModel;

@interface WMYDownloadManager : NSObject

@property (nonatomic,strong) NSOperationQueue *downQueue;

#pragma mark 下载队列管理单例对象
+ (instancetype)sharedInstance;

#pragma mark 下载
- (void)downLoadFileWithWithWMYDownModel:(WMYDownModel *)downModel;

@end
