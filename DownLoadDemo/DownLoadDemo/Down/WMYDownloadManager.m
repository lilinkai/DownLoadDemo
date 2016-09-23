//
//  WMYDownloadManager.m
//  DownLoadDemo
//
//  Created by 李林凯 on 16/9/22.
//  Copyright © 2016年 李林凯. All rights reserved.
//

#import "WMYDownloadManager.h"
#import "WMYDownloadRequest.h"
#import "NSFileManager+WMYDownLoadFileConfig.h"

@interface WMYDownloadManager ()<NSURLSessionDelegate>
{
    
}

/**
 下载队列queue
 */
@property (strong, nonatomic) NSOperationQueue *downQueue;

/**
  所有的下载任务
 */
@property (strong, nonatomic) NSMutableArray *downTasks;


@property (strong, nonatomic) NSURLSession *session;

@end

@implementation WMYDownloadManager

#pragma mark 下载队列管理单例对象
+ (instancetype)sharedInstance{
    static WMYDownloadManager *manager;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[WMYDownloadManager alloc] init];
        
    });
    return manager;
}

#pragma mark 获取对应url下载任务
- (WMYDownloadRequest *)getRequestForUrl:(NSString *)url{
    WMYDownloadRequest *downloadRequest = nil;
    for (WMYDownloadRequest *request in self.downTasks) {
        if ([request.downModel.downUrl isEqualToString:url]) {
            downloadRequest = request;
            break;
        }
    }
    return downloadRequest;
}

- (void)startRequestTask:(WMYDownloadRequest *)request{
    NSURLSessionDataTask *task = [self.session dataTaskWithRequest:request.urlRequest];
    request.task = task;
    [self saveTaskRequst:request];
}

/**
 * 添加下载任务/恢复下载任务
 **/
- (void)saveTaskRequst:(WMYDownloadRequest *)request
{
    if ([self.downTasks containsObject:request]) {
        //已经存在此下载任务了
        
    }else{
        //未存在添加到下载队列数组中
        [self.downTasks addObject:request];
    }
    
    //开始下载
    [request.task resume];
}

#pragma mark 下载代理方法NSURLSessionDataDelegate
/**
 * 接收到响应
 */
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSHTTPURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler
{
    // 接收这个请求，允许接收服务器的数据
    completionHandler(NSURLSessionResponseAllow);
    
    NSLog(@"开始接受文件流");
}

/**
 * 接收到服务器返回的数据
 */
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data
{
    NSLog(@"下载中...");
}

/**
 * 请求完毕（成功|失败）
 */
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
    NSLog(@"请求成功");
}

#pragma mark 初始化

- (NSOperationQueue *)downQueue{
    if (_downQueue == nil) {
        _downQueue = [[NSOperationQueue alloc] init];
        _downQueue.maxConcurrentOperationCount = 1;
    }
    return _downQueue;
}

- (NSMutableArray *)downTasks
{
    if (!_downTasks) {
        _downTasks = [NSMutableArray array];
    }
    return _downTasks;
}

-(NSURLSession*)session {
    
    if (!_session) {
        _session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[[NSOperationQueue alloc] init]];
    }
    return _session;
}

@end
