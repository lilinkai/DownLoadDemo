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
+ (NSInteger)WMYfileLengthWithUrl:(NSString *)urlString{
    
    return [[[NSFileManager defaultManager] attributesOfItemAtPath:[NSFileManager WMYFilePathWithFileName:urlString] error:nil][NSFileSize] integerValue];

}

#pragma mark -- 文件对应总长度列表
+ (NSString *)WMYTotalLengthFilepath{
    return [[NSFileManager WMYCachesDirectory] stringByAppendingPathComponent:@"totalLength.plist"];
}

#pragma mark --下载信息plist文件地址
+ (NSString *)WMYDownListPlistFilePath{
    return [[NSFileManager WMYCachesDirectory] stringByAppendingPathComponent:@"DownList.plist"];
}

#pragma mark --创建下载信息plist文件
+ (void)WMYCreateDownListPlist{
    if ([[NSFileManager defaultManager] fileExistsAtPath:[NSFileManager WMYDownListPlistFilePath]]) {
        
    }else{
        NSString *plistPath = [NSFileManager WMYDownListPlistFilePath];
        NSMutableArray *arrayPlist = [[NSMutableArray alloc ] init];
        [arrayPlist writeToFile:plistPath atomically:YES];
    }
};

#pragma mark --存储下载电影信息
+ (void)WMYSaveVideoModelWith:(WMYDownloadRequest *)request{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSMutableArray *infolist= [[NSMutableArray alloc]initWithContentsOfFile:[NSFileManager WMYDownListPlistFilePath]];
        
        NSLog(@"plist文件路径=========%@", [NSFileManager WMYDownListPlistFilePath]);
    
        BOOL isEqualDic = NO;
        
        for (NSMutableDictionary *dic in infolist) {
            if ([[dic objectForKey:@"videoName"] isEqualToString:request.downModel.videoName]) {
                
                [dic setObject:[dic objectForKey:@"downUrl"] forKey:@"downUrl"];
                [dic setObject:[dic objectForKey:@"videoName"] forKey:@"videoName"];
                [dic setObject:[dic objectForKey:@"movieCid"] forKey:@"movieCid"];
                [dic setObject:[dic objectForKey:@"movieKey"] forKey:@"movieKey"];
                [dic setObject:[dic objectForKey:@"movieImgUrl"] forKey:@"movieImgUrl"];
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
                                       @"state": [NSNumber numberWithInteger:request.downState],
                                       @"index": [NSNumber numberWithInteger:infolist.count]
                                       };
            
            [infolist addObject:modelDic];
            
            [infolist writeToFile:[NSFileManager WMYDownListPlistFilePath] atomically:YES];
        }

        NSMutableArray *infolist111= [[NSMutableArray alloc]initWithContentsOfFile:[NSFileManager WMYDownListPlistFilePath]];
        NSLog(@"infolist111 ==== %@", infolist111);
        
    });
}



@end
