//
//  ActionButton.m
//  AVPlayMovie
//
//  Created by 穷极一生做不完一场梦 on 16/5/4.
//  Copyright © 2016年 穷极一生做不完一场梦 - 远. All rights reserved.
//

#import "ActionButton.h"

@implementation ActionButton

/***
 * 重写button的frame方法，在里面修改视图
 */
- (void)setFrame:(CGRect)frame
{
    // setFrame方法会多次调用，如果不删除之前的，会造成视图堆积
    [_textLabel removeFromSuperview];
    [_iconImageView removeFromSuperview];
    [_selectIconImageView removeFromSuperview];
    
    CGFloat width = frame.size.height;
    
    // 创建视图
    _iconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, width, width)];
    _iconImageView.userInteractionEnabled = YES;
    [self addSubview:_iconImageView];
    
    _selectIconImageView = [[UIImageView alloc]initWithFrame:_iconImageView.frame];
    _selectIconImageView.hidden = YES;
    _selectIconImageView.userInteractionEnabled = YES;
    [self addSubview:_selectIconImageView];
    
    
    // 创建label
    _textLabel = [[UILabel alloc]initWithFrame:CGRectMake(width + 10, 0, frame.size.width - width - 10, width)];
    _textLabel.textColor = [UIColor whiteColor];
    _textLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:_textLabel];
    // 调用super setFrame的方法
    [super setFrame:frame];
}

/**
 * 点击button转换图片方法
 */
- (void)setSelected:(BOOL)selected
{
    if (selected) {
        _iconImageView.hidden = YES;
        _selectIconImageView.hidden = NO;
    }else{
        _iconImageView.hidden = NO;
        _selectIconImageView.hidden = YES;
    }
    [super setSelected:selected];
    
}








@end
