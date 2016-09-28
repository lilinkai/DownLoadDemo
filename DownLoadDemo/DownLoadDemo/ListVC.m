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
   
    // Do any additional setup after loading the view.
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
    
    ListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ListCell" forIndexPath:indexPath];
    
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
    
    cell.request = request;

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   
    WMYDownloadRequest *request = [_listArr objectAtIndex:indexPath.row];
    [[WMYDownloadManager sharedInstance] download:request.downModel progressBlock:^(NSString *receivedSize, NSString *expectedSize, float progress, NSString *speed) {
        
    } stateBlock:^(WMYDownloadState state) {
        
    }];
    
}

- (void)updateCellOnMainThread:(NSDictionary *)dic{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        ListCell *cell = [self.contentTableView cellForRowAtIndexPath:[dic objectForKey:@"indexPath"]];
        
        cell.totallength.text = [NSString stringWithFormat:@"%@/%@", [dic objectForKey:@"receivedSize"], [dic objectForKey:@"expectedSize"]];
        
        cell.sudu.text = [dic objectForKey:@"speed"];
        
        cell.progressLabel.text = [NSString stringWithFormat:@"%.1f%%", [[dic objectForKey:@"progress"] floatValue]*100.0];
    
    });
}

- (void)updateCellStateOnMainThread:(NSDictionary *)dic{
    dispatch_async(dispatch_get_main_queue(), ^{
        ListCell *cell = [self.contentTableView cellForRowAtIndexPath:[dic objectForKey:@"indexPath"]];
        
        switch ([[dic objectForKey:@"state"] integerValue]) {
            case WMYStateStart:
                cell.stateLabel.text = @"下载中";
                break;
            case WMYStateSuspended:
                cell.stateLabel.text = @"暂停";
                break;
            case WMYStateCompleted:
                cell.stateLabel.text = @"完成";
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
