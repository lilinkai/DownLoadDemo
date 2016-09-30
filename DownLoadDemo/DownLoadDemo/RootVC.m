//
//  RootVC.m
//  DownLoadDemo
//
//  Created by 李林凯 on 16/9/21.
//  Copyright © 2016年 李林凯. All rights reserved.
//

#import "RootVC.h"
#import "WMYDownloadManager.h"
#import "WMYDownModel.h"
#import "ListVC.h"
#import "RootCell.h"
#import "NSFileManager+WMYDownLoadFileConfig.h"

@interface RootVC ()

@property (weak, nonatomic) IBOutlet UITableView *contentTableView;

@property (strong, nonatomic)NSMutableArray *downUrlArray;

@end

@implementation RootVC

- (void)clicklist{
    UIStoryboard *listSB = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ListVC *listvc = [listSB instantiateViewControllerWithIdentifier:@"ListVC"];
    [self.navigationController pushViewController:listvc animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
 
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(clicklist)];
    self.navigationItem.rightBarButtonItem = item;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.downUrlArray = [NSMutableArray array];
    
    WMYDownModel *model1 = [[WMYDownModel alloc]init];
    model1.downUrl = @"http://baobab.cdn.wandoujia.com/14468618701471.mp4";
    model1.videoName = @"魔兽世界预告片";
    model1.movieCid = @"111111";
    model1.movieKey = @"222222";
    model1.movieImgUrl = @"uiimageUrl";
    [self.downUrlArray addObject:model1];
    
    WMYDownModel *model2 = [[WMYDownModel alloc]init];
    model2.downUrl = @"http://store.vcinema.com.cn/newKONGBUJI/Trailer/720PTOOLBOXMURDER2.mp4";
    model2.videoName = @"南瓜电影预告片";
    model2.movieCid = @"222222";
    model2.movieKey = @"333333";
    model2.movieImgUrl = @"uiimageUrl";
    [self.downUrlArray addObject:model2];
   
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
    [[WMYDownloadManager sharedInstance] download:model progressBlock:^(NSString *receivedSize, NSString *expectedSize, float progress, NSString *speed) {
        
    } stateBlock:^(WMYDownloadState state) {
        
    }];

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
