//
//  NSFileManager+WMYDownLoadFileConfig.h
//  DownLoadDemo
//
//  Created by 李林凯 on 16/9/22.
//  Copyright © 2016年 李林凯. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WMYDownloadRequest.h"

@interface NSFileManager (WMYDownLoadFileConfig)

#pragma mark -- 缓存主目录路径生成
+ (NSString *)WMYCachesDirectory;

#pragma mark -- 文件的存放路径生成
+ (NSString *)WMYFilePathWithFileName:(NSString *)fileName;

#pragma mark -- 创建缓存目录文件
+ (void)WMYCreateCacheDirectory;

#pragma mark -- 文件名格式化（因为是用url做文件名有//会创建文件失败所以Md5一下）
+ (NSString *)WMYfileNamemd5StringWith:(NSString *)urlString;

#pragma mark -- 本地文件大小
+ (NSInteger)WMYfileLengthWithUrl:(NSString *)urlString;

#pragma mark -- 文件对应总长度列表
+ (NSString *)WMYTotalLengthFilepath;

#pragma mark --下载信息plist文件地址
+ (NSString *)WMYDownListPlistFilePath;

#pragma mark --创建下载信息plist文件
+ (void)WMYCreateDownListPlist;

#pragma mark --存储下载电影信息
+ (void)WMYSaveVideoModelWith:(WMYDownloadRequest *)request;

@end
