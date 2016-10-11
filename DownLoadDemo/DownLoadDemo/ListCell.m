//
//  ListCell.m
//  DownLoadDemo
//
//  Created by 李林凯 on 16/9/26.
//  Copyright © 2016年 李林凯. All rights reserved.
//

#import "ListCell.h"

@implementation ListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setRequest:(WMYDownloadRequest *)request{
    _request = request;
    
    _videoName.text = _request.downModel.videoName;
    
    _totallength.text = _request.totalLengthString;
    
    switch (request.downState) {
        case WMYStateStart:
            self.stateLabel.text = @"下载中";
            break;
        case WMYStateWait:
            self.stateLabel.text = @"等待中";
            break;
        case WMYStateSuspended:
            self.stateLabel.text = @"暂停";
            break;
        case WMYStateCompleted:
            self.stateLabel.text = @"完成";
            break;
        default:
            break;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
