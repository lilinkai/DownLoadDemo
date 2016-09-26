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

@end

@implementation ListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    _listArr = [WMYDownloadManager sharedInstance].downTasks;
   
    // Do any additional setup after loading the view.
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
    
    request.progressBlock = ^(NSString *receivedSize, NSString * expectedSize,float progress, NSString *speed){
        
        NSDictionary *dic = @{@"receivedSize": receivedSize,
                              @"expectedSize": expectedSize,
                              @"progress": [NSNumber numberWithFloat:progress],
                              @"speed": speed,
                              @"indexPath": indexPath};
        
        [weakSelf performSelectorOnMainThread:@selector(updateCellOnMainThread:) withObject:dic waitUntilDone:YES];
    };
    
    cell.request = request;

    return cell;
}

- (void)updateCellOnMainThread:(NSDictionary *)dic{
    
    ListCell *cell = [self.contentTableView cellForRowAtIndexPath:[dic objectForKey:@"indexPath"]];
    
    cell.totallength.text = [NSString stringWithFormat:@"%@/%@", [dic objectForKey:@"receivedSize"], [dic objectForKey:@"expectedSize"]];
    
    cell.sudu.text = [dic objectForKey:@"speed"];
    
    cell.progressLabel.text = [NSString stringWithFormat:@"%.1f", [[dic objectForKey:@"progress"] floatValue]*100.0];
    NSLog(@"建设大厦阿斯顿=======%@", dic);
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
