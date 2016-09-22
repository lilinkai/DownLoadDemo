//
//  WMYDownOperation.h
//  DownLoadDemo
//
//  Created by 李林凯 on 16/9/22.
//  Copyright © 2016年 李林凯. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WMYDownModel;

@interface WMYDownOperation : NSOperation

#pragma mark 开始下载
+ (WMYDownOperation *)downOperationWithWMYDownModel:(WMYDownModel *)downModel;

@end
