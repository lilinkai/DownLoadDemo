//
//  WMYDownOperation.m
//  DownLoadDemo
//
//  Created by 李林凯 on 16/9/22.
//  Copyright © 2016年 李林凯. All rights reserved.
//

#import "WMYDownOperation.h"
#import "WMYDownloadManager.h"
#import "NSFileManager+WMYDownLoadFileConfig.h"
#import "WMYDownModel.h"

@interface WMYDownOperation ()<NSURLSessionDelegate>
{
    BOOL finished;  //完成监听
    BOOL executing; //执行监听
}

@property (nonatomic, strong)WMYDownModel *downModel;

@end

@implementation WMYDownOperation

#pragma mark 开始下载
+ (WMYDownOperation *)downOperationWithWMYDownModel:(WMYDownModel *)downModel;{
    WMYDownOperation *op = [[WMYDownOperation alloc] init];
    op.downModel = downModel;
    [op start];
    return op;
}

- (id) init {
    self = [super init];
    if (self != nil){
        NSLog(@"isfinished ===== %d", self.isFinished);
        NSLog(@"isexecuting ===== %d", self.isExecuting);
    }
    return self;
}

- (void) start {
    if ([self isCancelled]){
        [self willChangeValueForKey:@"isFinished"];
        finished = YES;
        [self didChangeValueForKey:@"isFinished"];
        return;
    } else {
        [self willChangeValueForKey:@"isExecuting"];
        executing = YES;
        [self main];
        [self didChangeValueForKey:@"isExecuting"];
    }
}

-(void)main{
    
    if (self.isCancelled)  return;
    
    // 创建缓存目录文件
    [NSFileManager WMYCreateCacheDirectory];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[WMYDownloadManager sharedInstance].downQueue];
    
    // 创建流
    NSOutputStream *stream = [NSOutputStream outputStreamToFileAtPath:[NSFileManager WMYFilePathWithFileName:[NSFileManager WMYfileNamemd5StringWith:self.downModel.downUrl]] append:YES];
    
    // 创建请求
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:self.downModel.downUrl]];

    // 创建一个Data任务
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request];
   
    self.downModel.stream = stream;
    
    [task resume];
    NSLog(@"开始下载了");
}

#pragma mark 下载响应代理NSURLSessionDataDelegate
/**
 * 接收到响应
 */
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSHTTPURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler
{
    // 打开流
    [self.downModel.stream open];
    NSLog(@"接受长度=======%ld", [response.allHeaderFields[@"Content-Length"] integerValue]);
    // 接收这个请求，允许接收服务器的数据
    completionHandler(NSURLSessionResponseAllow);
}

/**
 * 接收到服务器返回的数据
 */
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data
{
    NSLog(@"写出文件长度 ======= %ld", data.length);
    //写入数据
    [self.downModel.stream write:data.bytes maxLength:data.length];
}

/**
 * 请求完毕（成功/失败）
 */
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
    // 关闭流
    [self.downModel.stream close];
    self.downModel.stream = nil;
    
    [self willChangeValueForKey:@"isFinished"];
    [self willChangeValueForKey:@"isExecuting"];
    finished = YES;
    executing = NO;
    [self didChangeValueForKey:@"isFinished"];
    [self didChangeValueForKey:@"isExecuting"];
}

- (BOOL) isAsynchronous{
    return YES;
}

- (BOOL) isFinished{
    
    return finished;
}

- (BOOL) isExecuting{
    
    return executing;
}

@end
