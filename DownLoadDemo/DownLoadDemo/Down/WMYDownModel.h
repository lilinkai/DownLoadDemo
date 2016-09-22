//
//  WMYDownModel.h
//  DownLoadDemo
//
//  Created by 李林凯 on 16/9/22.
//  Copyright © 2016年 李林凯. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WMYDownModel : NSObject

/**
 文件流
 */
@property (nonatomic, strong) NSOutputStream *stream;

/**
 文件下载地址
 */
@property (nonatomic, copy) NSString *downUrl;

/**
 电影名
 */
@property (nonatomic, copy) NSString *videoName;

@end
