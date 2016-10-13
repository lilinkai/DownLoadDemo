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
    return [[NSFileManager WMYCachesDirectory] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp4", fileName]];
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

/**
 本地文件大小
 
 @param urlString 下载url
 
 @return 返回大小
 */
+ (NSInteger)WMYfileLengthWithUrl:(NSString *)urlString{
    
    return [[[NSFileManager defaultManager] attributesOfItemAtPath:[NSFileManager WMYFilePathWithFileName:[NSFileManager WMYfileNamemd5StringWith:urlString]] error:nil][NSFileSize] integerValue];
    
}

#pragma mark --下载信息plist文件地址
/**
 下载信息plist文件地址
 
 @return 下载信息plist地址路径
 */
+ (NSString *)WMYDownListPlistFilePath{
    NSLog(@"[NSFileManager WMYCachesDirectory] ====== %@", [NSFileManager WMYCachesDirectory]);
    return [[NSFileManager WMYCachesDirectory] stringByAppendingPathComponent:@"DownList.plist"];
}

#pragma mark --创建下载信息plist文件
/**
 创建下载信息plist文件
 */
+ (void)WMYCreateDownListPlist{
    if ([[NSFileManager defaultManager] fileExistsAtPath:[NSFileManager WMYDownListPlistFilePath]]) {
        
    }else{
        NSString *plistPath = [NSFileManager WMYDownListPlistFilePath];
        NSMutableArray *arrayPlist = [[NSMutableArray alloc ] init];
        [arrayPlist writeToFile:plistPath atomically:YES];
    }
};

#pragma mark --存储下载电影信息
/**
 存储下载电影信息
 
 @param request 请求
 */
+ (void)WMYSaveVideoModelWith:(WMYDownloadRequest *)request{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSMutableArray *infolist= [[NSMutableArray alloc]initWithContentsOfFile:[NSFileManager WMYDownListPlistFilePath]];
        
        BOOL isEqualDic = NO;
        
        for (NSMutableDictionary *dic in infolist) {
            if ([[dic objectForKey:@"downUrl"] isEqualToString:request.downModel.downUrl]) {
                
                [dic setObject:[dic objectForKey:@"downUrl"] forKey:@"downUrl"];
                [dic setObject:[dic objectForKey:@"videoName"] forKey:@"videoName"];
                [dic setObject:[dic objectForKey:@"movieCid"] forKey:@"movieCid"];
                [dic setObject:[dic objectForKey:@"movieKey"] forKey:@"movieKey"];
                [dic setObject:[dic objectForKey:@"movieImgUrl"] forKey:@"movieImgUrl"];
                [dic setObject:[dic objectForKey:@"contentData"] forKey:@"contentData"];
                [dic setObject:[NSNumber numberWithLongLong:request.totalLength] forKey:@"totalLength"];
                [dic setObject:[NSNumber numberWithInteger:request.downState] forKey:@"state"];
                [dic setObject:[NSNumber numberWithInteger:[[dic objectForKey:@"index"] integerValue]] forKey:@"index"];
                
                isEqualDic = YES;
                NSLog(@"有相同的");
            }
        }
        
        if (isEqualDic) {
            [infolist writeToFile:[NSFileManager WMYDownListPlistFilePath] atomically:YES];
        }else{
            NSDictionary *modelDic = @{@"downUrl": request.downModel.downUrl,
                                       @"videoName": request.downModel.videoName,
                                       @"movieCid": request.downModel.movieCid,
                                       @"movieKey": request.downModel.movieKey,
                                       @"movieImgUrl": request.downModel.movieImgUrl,
                                       @"contentData": request.downModel.contentData,
                                       @"totalLength": [NSNumber numberWithLongLong:request.totalLength],
                                       @"state": [NSNumber numberWithInteger:request.downState],
                                       @"index": [NSNumber numberWithInteger:infolist.count]
                                       };
            
            [infolist addObject:modelDic];
            
            [infolist writeToFile:[NSFileManager WMYDownListPlistFilePath] atomically:YES];
        }
    });
}

#pragma mark --获取对应url的电影信息
/**
 获取对应url的电影信息
 
 @param videoUrl 对应电影下载url
 
 @return 电影信息字典
 */
+ (id)WMYGetVideonModelWith:(NSString *)videoUrl{
    
    NSMutableArray *infolist= [[NSMutableArray alloc]initWithContentsOfFile:[NSFileManager WMYDownListPlistFilePath]];
    
    BOOL isEqualDic = NO;
    
    for (NSMutableDictionary *dic in infolist) {
        if ([[dic objectForKey:@"downUrl"] isEqualToString:videoUrl]) {
            isEqualDic = YES;
            return dic;
        }
    }
    return nil;
    
}

#pragma mark --获取全部下载完成的电影信息
/**
 获取全部下载完成的电影信息
 
 @return 下载完成信息数组
 */
+ (id)WMYGetAllVideonModel{
    
    NSMutableArray *infolist= [[NSMutableArray alloc]initWithContentsOfFile:[NSFileManager WMYDownListPlistFilePath]];
    
    NSMutableArray *completedVideoArray = [NSMutableArray array];
    
    for (NSMutableDictionary *dic in infolist) {
        if ([[dic objectForKey:@"state"] integerValue] == WMYStateCompleted) {
            [completedVideoArray addObject:dic];
        }
    }
    
    return completedVideoArray;
}

#pragma mark --删除对应url的电影信息
/**
 删除对应url的电影信息
 
 @param videoUrl videoUrl 对应电影下载url
 */
+ (void)WMYDelVideoModelWith:(NSString *)videoUrl{
    NSMutableArray *infolist= [[NSMutableArray alloc]initWithContentsOfFile:[NSFileManager WMYDownListPlistFilePath]];
    
    NSInteger index = 0;
    BOOL isEqual = NO;
    
    for (int i = 0; i < infolist.count; i++) {
        if ([[[infolist objectAtIndex:i] objectForKey:@"downUrl"] isEqualToString:videoUrl]) {
            index = i;
            isEqual = YES;
            NSLog(@"有相同的");
        }
    }
    
    if (isEqual) {
        [infolist removeObjectAtIndex:index];
        
        [infolist writeToFile:[NSFileManager WMYDownListPlistFilePath] atomically:YES];
    }
}

@end
