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
 文件下载地址
 */
@property (nonatomic, copy) NSString *downUrl;

/**
 电影名
 */
@property (nonatomic, copy) NSString *videoName;
/**
 cid
 */
@property (nonatomic, copy) NSString *movieCid;
/**
 key
 */
@property (nonatomic, copy) NSString *movieKey;
/**
 电影海报
 */
@property (nonatomic, copy) NSString *movieImgUrl;
/**
 电影信息
 */
@property (nonatomic, copy) id contentData;

@end
