//
//  UIView+Constraint.h
//  VFLDemo
//
//  Created by DT on 15-3-27.
//  Copyright (c) 2015年 DT. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
    AllDefault,//没有
    AllLeft,//控件左边对齐
    AllRight,//控件右边对齐
    AllTop,//控件上边对齐
    AllBottom,//控件下边对齐
    AllCenterX,//控件横坐标对齐
    AllCenterY,//控件纵坐标对齐
    AllBaseline,//控件底部对齐
}LayoutOptions;//VFL的约束选项

typedef NS_OPTIONS(NSUInteger, LayoutAttribute) {
    Default     = 0,     //没有
    Top         = 1 << 0,//上边
    Left        = 1 << 1,//左边
    Bottom      = 1 << 2,//下边
    Right       = 1 << 3,//右边
    CenterX     = 1 << 4,//横坐标中心
    CenterY     = 1 << 5,//纵坐标中心
    Height      = 1 << 6,//高度
    Width       = 1 << 7,//宽度
    Baseline    = 1 << 8,//底部
};//布局属性

typedef enum {
    LessThanOrEqual,//小于等于
    Equal,//等于
    GreaterThanOrEqual,//大于等于
}LayoutRelation;//关系约束

/*!
 *  @author DT
 *
 *  @brief  自动布局约束UIView
 */
@interface UIView (Constraint)

/*!
 *  @author DT
 *
 *  @brief  初始化方法
 *          设置translatesAutoresizingMaskIntoConstraints属性为NO
 *
 *  @return UIView
 */
+(instancetype)constraintView;

#pragma mark VFL约束
/*!
 *  @author DT
 *
 *  @brief 增加NSString类型的约束
 *
 *  @param format 约束字符串
 *  @param views  被约束的views集合
 *
 *  @return NSArray
 */
-(NSArray *)addVisualFormat:(NSString*)format views:(NSDictionary *)views;

/*!
 *  @author DT
 *
 *  @brief 增加NSString类型的约束
 *
 *  @param format  约束字符串
 *  @param opts    约束对齐方式
 *  @param metrics 间隔参数字典,跟format字段相对应
 *  @param views   被约束的views集合
 *
 *  @return NSArray
 */
-(NSArray *)addVisualFormat:(NSString*)format options:(LayoutOptions)opts metrics:(NSDictionary *)metrics  views:(NSDictionary *)views;

/*!
 *  @author DT
 *
 *  @brief 增加NSArray类型的约束
 *
 *  @param formats 约束字符串集合
 *  @param views   被约束的views集合
 *
 *  @return NSArray
 */
-(NSArray *)addVisualFormats:(NSArray*)formats views:(NSDictionary *)views;

/*!
 *  @author DT
 *
 *  @brief 增加NSString类型的约束
 *
 *  @param formats  约束字符串集合
 *  @param opts     约束对齐方式
 *  @param metrics  间隔参数字典,跟format字段相对应
 *  @param views    被约束的views集合
 *
 *  @return NSArray
 */
-(NSArray *)addVisualFormats:(NSArray*)formats options:(LayoutOptions)opts metrics:(NSDictionary *)metrics  views:(NSDictionary *)views;


#pragma mark 明确约束

#pragma mark -- 与父类的约束 --

/*!
 *  @Author DT
 *
 *  @brief  当前view跟父类view直接的间隔约束
 *
 *  @param insets UIEdgeInsets类型值 top和left一般大于等于0,bottom和right一般小于等于0
 *
 *  @return
 */
-(NSArray*)superWithInset:(UIEdgeInsets)insets;

/*!
 *  @Author DT
 *
 *  @brief  当前view跟父类view的间隔约束
 *
 *  @param edges 约束的值
 *  @param attr  布局属性,可以多个,用|分割
 *
 *  @return
 */
-(NSArray*)superWithEdges:(float)edges attr:(LayoutAttribute)attr;

/*!
 *  @Author DT
 *
 *  @brief  当前view跟父类view的间隔约束
 *
 *  @param edges  约束的值
 *  @param attr   当前view的布局布局属性
 *  @param toAttr 父类view的布局布局属性
 *
 *  @return 
 */
-(NSLayoutConstraint*)superWithEdges:(float)edges attr:(LayoutAttribute)attr toAttr:(LayoutAttribute)toAttr;

/*!
 *  @Author DT
 *
 *  @brief  当前view的中心坐标跟父类view的中心坐标一致
 *
 *  @return
 */
-(NSArray*)superWithCenter;

/*!
 *  @Author DT
 *
 *  @brief  当前view的中心坐标跟父类view的中心坐标距离
 
 *  @param attr  布局属性,可以多个,用|分割
 *
 *  @param edges 与父类中心坐标的偏移量
 *
 *  @return
 */
-(NSArray*)superWithCenter:(float)edges attr:(LayoutAttribute)attr;

#pragma mark -- 与同类的约束 --

-(NSArray*)viewWithInset:(UIEdgeInsets)insets view:(UIView*)view;
-(NSArray*)viewWithEdges:(float)edges attr:(LayoutAttribute)attr view:(UIView*)view;
-(NSLayoutConstraint*)viewWithEdges:(float)edges attr:(LayoutAttribute)attr view:(UIView*)view toAttr:(LayoutAttribute)toAttr;
-(NSArray*)viewWithCenter:(UIView*)view;
-(NSArray*)viewWithCenter:(float)edges attr:(LayoutAttribute)attr view:(UIView*)view;
-(NSLayoutConstraint*)viewWithRelation:(LayoutRelation)relation attr:(LayoutAttribute)attr view:(UIView*)view;

#pragma mark -- 自身的约束 --

/*!
 *  @Author DT
 *
 *  @brief  约束当前view的size
 *
 *  @param size 大小
 *
 *  @return NSArray
 */
-(NSArray*)viewToSize:(CGSize)size;

/*!
 *  @Author DT
 *
 *  @brief  约束当前view的width
 *
 *  @param width 宽度
 *
 *  @return NSLayoutConstraint
 */
-(NSLayoutConstraint*)viewToWidth:(CGFloat)width;

/*!
 *  @Author DT
 *
 *  @brief  约束当前view的height
 *
 *  @param height 高度
 *
 *  @return NSLayoutConstraint
 */
-(NSLayoutConstraint*)viewToHeight:(CGFloat)height;

-(NSArray *)viewToMinimumSize:(CGSize)minimum;

-(NSArray *)viewToMaximumSize:(CGSize)maximum;

#pragma mark -- 以下暂时屏蔽 --
#pragma mark --  间隔约束 --
/*!
 *  @Author DT
 *
 *  @brief  当前view到superView的间隔
 *
 *  @param insets UIEdgeInsets类型值
 *
 *  @return NSArray
 */
-(NSArray*)edgesWithInset:(UIEdgeInsets)insets;

/*!
 *  @Author DT
 *
 *  @brief  当前view到view的间隔
 *
 *  @param insets UIEdgeInsets类型值
 *  @param view   参照view
 *
 *  @return NSArray
 */
-(NSArray*)edgesWithInset:(UIEdgeInsets)insets view:(UIView*)view;

/*!
 *  @Author DT
 *
 *  @brief  当前view到superView的间隔
 *
 *  @param inset 间隔值
 *  @param attr  方向 可以多个,用|区分
 *
 *  @return NSLayoutConstraint
 */
-(NSLayoutConstraint*)edgesWithInset:(CGFloat)inset attr:(LayoutAttribute)attr;

/*!
 *  @Author DT
 *
 *  @brief  当前view到superView的间隔
 *
 *  @param inset 间隔值
 *  @param view  参照view
 *  @param attr  方向 可以多个,用|区分
 *
 *  @return NSLayoutConstraint
 */
-(NSLayoutConstraint*)edgesWithInset:(CGFloat)inset view:(UIView*)view attr:(LayoutAttribute)attr;

/*!
 *  @Author DT
 *
 *  @brief  当前view到superView的间隔
 *
 *  @param inset   间隔值
 *  @param toView  参照view
 *  @param attr    当前view的方向
 *  @param toAttr  参照view的方向
 *
 *  @return NSLayoutConstraint
 */
-(NSLayoutConstraint*)edgesWithInset:(CGFloat)inset attr:(LayoutAttribute)attr toView:(UIView*)toView toAttr:(LayoutAttribute)toAttr;

#pragma mark -- 中心坐标约束 --
/*!
 *  @Author DT
 *
 *  @brief  当前view跟superView的中心点一致
 *
 *  @return NSArray
 */
-(NSArray*)centerInContainer;

/*!
 *  @Author DT
 *
 *  @brief  当前view跟view的中心点一致
 *
 *  @return NSArray
 */
-(NSArray*)centerInContainer:(UIView*)view;

/*!
 *  @Author DT
 *
 *  @brief  当前view的attr跟view的attr的点一致
 *          attr参数为CenterX或者CenterY
 *
 *  @param attr 方向
 *  @param view 参照view
 *
 *  @return NSLayoutConstraint
 */
-(NSLayoutConstraint*)centerInView:(LayoutAttribute)attr toView:(UIView*)view;

/*!
 *  @Author DT
 *
 *  @brief  当前view的attr跟view的toAttr的点一致
 *          attr参数为CenterX或者CenterY
 *
 *  @param attr 方向
 *  @param view 参照view
 *
 *  @return NSLayoutConstraint
 */
-(NSLayoutConstraint*)centerInView:(LayoutAttribute)attr toView:(UIView*)view toAttr:(LayoutAttribute)toAttr;

/*!
 *  @Author DT
 *
 *  @brief  当前view的attr跟view的toAttr的点偏差c像素
 *          attr参数为CenterX或者CenterY
 *
 *  @param attr 方向
 *  @param view 参照view
 *  @param c    偏差值
 *
 *  @return NSLayoutConstraint
 */
-(NSLayoutConstraint*)centerInView:(LayoutAttribute)attr toView:(UIView*)view toAttr:(LayoutAttribute)toAttr constant:(CGFloat)c;

#pragma mark -- 大小约束 --

#pragma mark 通用约束方法

/*!
 *  @Author DT
 *
 *  @brief  增加约束条件
 *
 *  @param attr       需要约束的属性
 *  @param relation   约束关系
 *  @param view       被约束的对象
 *  @param attribute  被约束的属性
 *
 *  @return NSLayoutConstraint
 */
-(NSLayoutConstraint*)constraint:(LayoutAttribute)attr relatedBy:(LayoutRelation)relation view:(UIView*)view attribute:(LayoutAttribute)attribute;

/*!
 *  @Author DT
 *
 *  @brief  增加约束条件
 *
 *  @param attr       需要约束的属性
 *  @param relation   约束关系
 *  @param view       被约束的对象
 *  @param attribute  被约束的属性
 *  @param multiplier 乘数
 *  @param c          值
 *
 *  @return NSLayoutConstraint
 */
-(NSLayoutConstraint*)constraint:(LayoutAttribute)attr relatedBy:(LayoutRelation)relation view:(UIView*)view attribute:(LayoutAttribute)attribute multiplier:(CGFloat)multiplier constant:(CGFloat)c;

@end
