//
//  RootCell.h
//  DownLoadDemo
//
//  Created by 李林凯 on 16/9/28.
//  Copyright © 2016年 李林凯. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RootCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *downState;
@property (weak, nonatomic) IBOutlet UILabel *downNameLabel;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@property (weak, nonatomic) IBOutlet UILabel *downLengthLabel;
@property (weak, nonatomic) IBOutlet UILabel *seepLabel;

@end
