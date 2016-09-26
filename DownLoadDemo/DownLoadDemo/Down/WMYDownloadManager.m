//
//  WMYDownloadManager.m
//  DownLoadDemo
//
//  Created by 李林凯 on 16/9/22.
//  Copyright © 2016年 李林凯. All rights reserved.
//

#import "WMYDownloadManager.h"
#import "WMYDownloadRequest.h"

@interface WMYDownloadManager ()<NSURLSessionDelegate>
{
    
}

@property (strong, nonatomic) NSURLSession *session;

@end

@implementation WMYDownloadManager

#pragma mark 下载队列管理单例对象
+ (instancetype)sharedInstance{
    static WMYDownloadManager *manager;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[WMYDownloadManager alloc] init];
        [NSFileManager WMYCreateCacheDirectory];
    });
    return manager;
}

#pragma mark 获取对应url下载任务
- (WMYDownloadRequest *)getRequestForUrl:(NSString *)url{
    WMYDownloadRequest *downloadRequest = nil;
    for (WMYDownloadRequest *request in self.downTasks) {
        if ([request.downModel.downUrl isEqualToString:url]) {
            downloadRequest = request;
            NSLog(@"有对应的url");
            break;
        }
    }
    return downloadRequest;
}

- (void)startRequestTask:(WMYDownloadRequest *)request{

    if ([NSFileManager WMYfileLengthWithUrl:[NSFileManager WMYfileNamemd5StringWith:[NSFileManager WMYfileNamemd5StringWith:request.downModel.downUrl]]] == request.totalLength && [NSFileManager WMYfileLengthWithUrl:[NSFileManager WMYfileNamemd5StringWith:request.downModel.downUrl]] != 0) {
        
        NSLog(@"已经下载完成");
        
        [request.timer invalidate];
        request.downloadStateBlock(WMYStateCompleted);
        
        return;
    }
    
    if ([self.downTasks containsObject:request]) {
        //已经存在此下载任务了
        NSLog(@"有这个下载了");
        if (request.task.state == NSURLSessionTaskStateRunning) {
            [request.task suspend];
            request.downloadStateBlock(WMYStateSuspended);
        }else{
            [request.task resume];
            request.downloadStateBlock(WMYStateStart);
        }
    }else{
        
        NSURLSessionDataTask *task = [self.session dataTaskWithRequest:request.urlRequest];
        request.task = task;
        request.task.taskDescription = [NSFileManager WMYfileNamemd5StringWith:request.downModel.downUrl];
        
        // 设置请求头
        NSString *range = [NSString stringWithFormat:@"bytes=%zd-", [NSFileManager WMYfileLengthWithUrl:[NSFileManager WMYfileNamemd5StringWith:request.downModel.downUrl]]];
        [request.urlRequest setValue:range forHTTPHeaderField:@"Range"];
        
        //未存在添加到下载队列数组中
        [self.downTasks addObject:request];
        
        //开始下载
        [request.task resume];
        
        //开始下载
        request.downloadStateBlock(WMYStateStart);
    }
}

/**
 *  根据url获取对应的下载信息模型
 */
- (WMYDownloadRequest *)getDownloadRequest:(NSString *)taskIdentifier
{
    for (WMYDownloadRequest *request in self.downTasks) {
        if ([request.task.taskDescription isEqualToString:taskIdentifier]) {
            return request;
        }
    }
    return nil;
}

#pragma mark 下载代理方法NSURLSessionDataDelegate
/**
 * 接收到响应
 */
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSHTTPURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler
{
    WMYDownloadRequest *downloadRequest = [self getDownloadRequest:dataTask.taskDescription];
    
    // 打开流
    [downloadRequest.stream open];
    
    // 获得服务器这次请求 返回数据的总长度
    NSInteger totalLength = [response.allHeaderFields[@"Content-Length"] integerValue];
    downloadRequest.totalLength = totalLength;
    downloadRequest.totalLengthString = [self convertSize:totalLength];
    // 接收这个请求，允许接收服务器的数据
    completionHandler(NSURLSessionResponseAllow);
    
    NSLog(@"开始接受文件流");
}

/**
 * 接收到服务器返回的数据
 */
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data
{
    WMYDownloadRequest *downloadRequest = [self getDownloadRequest:dataTask.taskDescription];
    
    // 写入数据
    [downloadRequest.stream write:data.bytes maxLength:data.length];
    
    // 下载进度
    NSUInteger receivedSize = [NSFileManager WMYfileLengthWithUrl:dataTask.taskDescription];
    NSUInteger expectedSize = downloadRequest.totalLength;
    
    float progress = 1.0 * receivedSize / expectedSize;
  
    //计算网速
    NSString *speedString=@"0.00Kb/s";
    NSString *growString=[self convertSize:downloadRequest.growth];
    speedString=[NSString stringWithFormat:@"%@/s",growString];
    
    downloadRequest.progressBlock([self convertSize:receivedSize], [self convertSize:expectedSize], progress, speedString);
}

/**
 * 请求完毕（成功|失败）
 */
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
    WMYDownloadRequest *downloadRequest = [self getDownloadRequest:task.taskDescription];
    
    // 下载完成
    downloadRequest.downloadStateBlock(WMYStateCompleted);
    
    // 关闭流
    [downloadRequest.stream close];
    downloadRequest.stream = nil;
    
    // 清除任务
    [self.downTasks removeObject:downloadRequest];
}

#pragma mark 初始化

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

/**
 * 计算缓存的占用存储大小
 *
 * @prama length  文件大小
 */
-(NSString *)convertSize:(NSUInteger)length
{
    if(length<1024)
        return [NSString stringWithFormat:@"%ldB",(NSUInteger)length];
    else if(length>=1024&&length<1024*1024)
        return [NSString stringWithFormat:@"%.0fK",(float)length/1024];
    else if(length >=1024*1024&&length<1024*1024*1024)
        return [NSString stringWithFormat:@"%.1fM",(float)length/(1024*1024)];
    else
        return [NSString stringWithFormat:@"%.1fG",(float)length/(1024*1024*1024)];
}

@end
