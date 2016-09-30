//
//  CompletedViewController.m
//  DownLoadDemo
//
//  Created by 穷极一生做不完一场梦 on 16/9/27.
//  Copyright © 2016年 李林凯. All rights reserved.
//

#import "CompletedViewController.h"
#import "CompletedTableViewCell.h"
#import "NSFileManager+WMYDownLoadFileConfig.h"
#import "DTMoviePlayerViewController.h"

@interface CompletedViewController ()
@property (strong, nonatomic) IBOutlet UITableView *completedTableview;
@property (strong, nonatomic) NSMutableArray * dataArray;
@end

@implementation CompletedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.dataArray = [NSMutableArray array];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellName = @"youCanGuess";
    
        CompletedTableViewCell *cell = [tableView  dequeueReusableCellWithIdentifier:cellName];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"CompletedTableViewCell" owner:nil options:nil] lastObject];
        }

        return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString * str = [self.dataArray objectAtIndex:indexPath.row];
    
    DTMoviePlayerViewController * mv = [[DTMoviePlayerViewController alloc] init];
    mv.urlString = str;
    [self.navigationController pushViewController:mv animated:YES];
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
