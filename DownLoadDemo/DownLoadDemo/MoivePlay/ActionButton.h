//
//  ActionButton.h
//  AVPlayMovie
//
//  Created by 穷极一生做不完一场梦 on 16/5/4.
//  Copyright © 2016年 穷极一生做不完一场梦 - 远. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ActionButton : UIButton

// 添加readonly使外界只能改变它的属性，不能替换
@property (nonatomic, strong, readonly) UILabel *textLabel;

@property (nonatomic, strong, readonly) UIImageView *iconImageView;
// 点击button改变图片
@property (nonatomic, strong, readonly) UIImageView *selectIconImageView;

@end
