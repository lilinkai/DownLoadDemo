//
//  NSFileManager+WMYDownLoadFileConfig.m
//  DownLoadDemo
//
//  Created by 李林凯 on 16/9/22.
//  Copyright © 2016年 李林凯. All rights reserved.
//

#import "NSFileManager+WMYDownLoadFileConfig.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSFileManager (WMYDownLoadFileConfig)

#pragma mark -- 缓存主目录url生成
/**
 缓存主目录url生成

 @return 缓存主目录url
 */
+ (NSString *)WMYCachesDirectory{
    return [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"WMYCache"];
}

#pragma mark -- 文件的存放路径生成
/**
 文件的存放路径生成

 @param fileName 文件名

 @return 文件的存放路径生成
 */
+ (NSString *)WMYFilePathWithFileName:(NSString *)fileName{
    return [[NSFileManager WMYCachesDirectory] stringByAppendingPathComponent:fileName];
}

#pragma mark -- 创建缓存目录文件
/**
 创建缓存目录文件
 */
+ (void)WMYCreateCacheDirectory
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:[NSFileManager WMYCachesDirectory]]) {
        [fileManager createDirectoryAtPath:[NSFileManager WMYCachesDirectory] withIntermediateDirectories:YES attributes:nil error:NULL];
        
    }
    NSLog(@"缓存目录========%@", [NSFileManager WMYCachesDirectory]);
}

#pragma mark -- 文件名格式化（因为是用url做文件名有//会创建文件失败所以Md5一下）
/**
文件名格式化
 */
+ (NSString *)WMYfileNamemd5StringWith:(NSString *)urlString;
{
    const char *string = urlString.UTF8String;
    int length = (int)strlen(string);
    unsigned char bytes[CC_MD5_DIGEST_LENGTH];
    CC_MD5(string, length, bytes);
    
    NSMutableString *mutableString = @"".mutableCopy;
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [mutableString appendFormat:@"%02x", bytes[i]];
    return [NSString stringWithString:mutableString];
}

#pragma mark -- 本地文件大小
+ (NSInteger)WMYfileLengthWithUrl:(NSString *)urlString{
    
    return [[[NSFileManager defaultManager] attributesOfItemAtPath:[NSFileManager WMYFilePathWithFileName:urlString] error:nil][NSFileSize] integerValue];

}




@end
