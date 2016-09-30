//
//  ListVC.m
//  DownLoadDemo
//
//  Created by 李林凯 on 16/9/26.
//  Copyright © 2016年 李林凯. All rights reserved.
//

#import "ListVC.h"
#import "WMYDownloadManager.h"
#import "WMYDownloadRequest.h"
#import "ListCell.h"
#import "RootCell.h"
#import "CompletedViewController.h"

@interface ListVC ()

{
    NSArray *_listArr;
}

@property (weak, nonatomic) IBOutlet UITableView *contentTableView;
@property (nonatomic, strong) WMYDownloadManager *downloadManager;
@end

@implementation ListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
  
    _listArr = [WMYDownloadManager sharedInstance].downTasks;
   
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(doneDownLoad)];
    self.navigationItem.rightBarButtonItem = item;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    // Do any additional setup after loading the view.
}

- (void)doneDownLoad{
    CompletedViewController * co = [[CompletedViewController alloc] init];
    [self.navigationController pushViewController:co animated:YES];
}

- (WMYDownloadManager *)downloadManager
{
    if (!_downloadManager) {
        _downloadManager = [WMYDownloadManager sharedInstance];
    }
    return _downloadManager;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _listArr.count;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    RootCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RootCell" forIndexPath:indexPath];
    
    WMYDownloadRequest *request = [_listArr objectAtIndex:indexPath.row];
    
    __weak typeof(&*self)weakSelf = self;
    
    request.progressBlock = ^(NSString *receivedSize, NSString *expectedSize, float progress, NSString *speed){
     
        NSDictionary *dic = @{@"indexPath": indexPath,
                              @"receivedSize": receivedSize,
                              @"expectedSize": expectedSize,
                              @"speed": speed,
                              @"progress": [NSNumber numberWithFloat:progress]};
        
        [weakSelf updateCellOnMainThread:dic];
    };
    
    request.stateBlock = ^(WMYDownloadState state){
        NSDictionary *dic = @{@"indexPath": indexPath,
                              @"state": [NSNumber numberWithInteger:state]};
        [weakSelf updateCellStateOnMainThread:dic];
    };
    
    cell.downNameLabel.text = request.downModel.videoName;
    
    cell.pauseButton.tag = indexPath.row;
    
    [cell.pauseButton addTarget:self action:@selector(managerButtonClickAction:) forControlEvents:UIControlEventTouchUpInside];
    
    switch (request.downState) {
        case WMYStateStart:
            [cell.pauseButton setTitle:@"暂停" forState:UIControlStateNormal];
            cell.downState.text = @"下载中";
            break;
        case WMYStateSuspended:
            [cell.pauseButton setTitle:@"开始下载" forState:UIControlStateNormal];
            cell.downState.text = @"暂停";
            break;
        case WMYStateCompleted:
            [cell.pauseButton setTitle:@"删除" forState:UIControlStateNormal];
            cell.downState.text = @"完成";
            _listArr = [WMYDownloadManager sharedInstance].downTasks;
            [self.contentTableView reloadData];
            break;
        default:
            break;
    }
   
    cell.progressView.progress = 0.0;
    
    return cell;
}

- (void)managerButtonClickAction:(UIButton *)btn{

    WMYDownloadRequest *request = [_listArr objectAtIndex:btn.tag];
    
    if ([btn.titleLabel.text isEqualToString:@"暂停"] || [btn.titleLabel.text isEqualToString:@"开始下载"]) {
        
        [[WMYDownloadManager sharedInstance] download:request.downModel progressBlock:^(NSString *receivedSize, NSString *expectedSize, float progress, NSString *speed) {
            
        } stateBlock:^(WMYDownloadState state) {
            
        }];
    }else if ([btn.titleLabel.text isEqualToString:@"删除"]){
        NSLog(@"删除视频");
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   
    
    
}

- (void)updateCellOnMainThread:(NSDictionary *)dic{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        RootCell *cell = [self.contentTableView cellForRowAtIndexPath:[dic objectForKey:@"indexPath"]];
        
        cell.downLengthLabel.text = [NSString stringWithFormat:@"%@/%@", [dic objectForKey:@"receivedSize"], [dic objectForKey:@"expectedSize"]];
        
        cell.seepLabel.text = [dic objectForKey:@"speed"];
        
        cell.progressView.progress = [[dic objectForKey:@"progress"] floatValue];
    
    });
}

- (void)updateCellStateOnMainThread:(NSDictionary *)dic{
    dispatch_async(dispatch_get_main_queue(), ^{
        RootCell *cell = [self.contentTableView cellForRowAtIndexPath:[dic objectForKey:@"indexPath"]];
        
        switch ([[dic objectForKey:@"state"] integerValue]) {
            case WMYStateStart:
                [cell.pauseButton setTitle:@"暂停" forState:UIControlStateNormal];
                cell.downState.text = @"下载中";
                break;
            case WMYStateSuspended:
                [cell.pauseButton setTitle:@"开始下载" forState:UIControlStateNormal];
                cell.downState.text = @"暂停";
                break;
            case WMYStateCompleted:
                [cell.pauseButton setTitle:@"删除" forState:UIControlStateNormal];
                cell.downState.text = @"完成";
                _listArr = [WMYDownloadManager sharedInstance].downTasks;
                [self.contentTableView reloadData];
                break;
            default:
                break;
        }
    });
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
