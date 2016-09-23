//
//  RootVC.m
//  DownLoadDemo
//
//  Created by 李林凯 on 16/9/21.
//  Copyright © 2016年 李林凯. All rights reserved.
//

#import "RootVC.h"
#import "WMYDownloadRequest.h"
#import "WMYDownModel.h"

@interface RootVC ()

@property (weak, nonatomic) IBOutlet UITableView *contentTableView;

@property (strong, nonatomic)NSMutableArray *downUrlArray;

@end

@implementation RootVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.downUrlArray = [NSMutableArray array];
    
    WMYDownModel *model1 = [[WMYDownModel alloc]init];
    model1.downUrl = @"http://baobab.cdn.wandoujia.com/14468618701471.mp4";
    model1.videoName = @"魔兽世界";
    [self.downUrlArray addObject:model1];
    
    WMYDownModel *model2 = [[WMYDownModel alloc]init];
    model2.downUrl = @"http://store.vcinema.com.cn/newKONGBUJI/Trailer/720PTOOLBOXMURDER2.mp4";
    model2.videoName = @"南瓜电影";
    [self.downUrlArray addObject:model2];

    
    [self.contentTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    // Do any additional setup after loading the view.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.downUrlArray.count;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    
    WMYDownModel *model = [self.downUrlArray objectAtIndex:indexPath.row];
    
    cell.textLabel.text = model.videoName;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    WMYDownloadManager *dm = [WMYDownloadManager sharedInstance];
//    
    WMYDownModel *model = [self.downUrlArray objectAtIndex:indexPath.row];
    [WMYDownloadRequest startDownload:model.downUrl];
  
}

- (IBAction)downButtonAction:(UIButton *)sender {
   
}

- (IBAction)zantingbuttonAction:(UIButton *)sender {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
