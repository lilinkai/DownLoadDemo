//
//  ListCell.h
//  DownLoadDemo
//
//  Created by 李林凯 on 16/9/26.
//  Copyright © 2016年 李林凯. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WMYDownloadRequest.h"

@interface ListCell : UITableViewCell

@property (nonatomic, strong)WMYDownloadRequest *request;
@property (weak, nonatomic) IBOutlet UILabel *videoName;
@property (weak, nonatomic) IBOutlet UILabel *totallength;
@property (weak, nonatomic) IBOutlet UILabel *sudu;
@property (weak, nonatomic) IBOutlet UILabel *progressLabel;

@end
