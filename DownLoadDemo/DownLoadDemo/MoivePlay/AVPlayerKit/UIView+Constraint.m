//
//  UIView+Constraint.m
//  VFLDemo
//
//  Created by DT on 15-3-27.
//  Copyright (c) 2015年 DT. All rights reserved.
//

#import "UIView+Constraint.h"

@implementation UIView (Constraint)

+(instancetype)constraintView;
{
    UIView *viewToReturn = [self new];
    viewToReturn.translatesAutoresizingMaskIntoConstraints = NO;
    return viewToReturn;
}

-(NSArray *)addVisualFormat:(NSString*)format views:(NSDictionary *)views
{
    return [self addVisualFormat:format options:AllDefault metrics:nil views:views];
}

-(NSArray *)addVisualFormat:(NSString*)format options:(LayoutOptions)opts metrics:(NSDictionary *)metrics  views:(NSDictionary *)views
{
    NSArray *formats = [[NSArray alloc] initWithObjects:format, nil];
    return [self addVisualFormats:formats options:AllDefault metrics:nil views:views];
}

-(NSArray *)addVisualFormats:(NSArray*)formats views:(NSDictionary *)views
{
    return [self addVisualFormats:formats options:AllDefault metrics:nil views:views];
}

-(NSArray *)addVisualFormats:(NSArray*)formats options:(LayoutOptions)opts metrics:(NSDictionary *)metrics  views:(NSDictionary *)views;
{
    NSMutableArray *constraints = [NSMutableArray new];
    for (NSString *format in formats) {
        NSArray *array = [NSLayoutConstraint constraintsWithVisualFormat:format options:[self getFormatOptions:opts] metrics:metrics views:views];
        [constraints addObject:array];
        [self addConstraints:array];
    }
    return [constraints copy];
}

-(NSArray*)edgesWithInset:(UIEdgeInsets)insets
{
    return [self edgesWithInset:insets view:self.superview];
}

-(NSArray*)edgesWithInset:(UIEdgeInsets)insets view:(UIView*)view
{
    NSLayoutConstraint *top = [self edgesWithInset:insets.top view:view attr:Top];
    NSLayoutConstraint *left = [self edgesWithInset:insets.left view:view attr:Left];
    NSLayoutConstraint *bottom = [self edgesWithInset:insets.bottom view:view attr:Bottom];
    NSLayoutConstraint *right = [self edgesWithInset:insets.right view:view attr:Right];
    
    return [NSArray arrayWithObjects:top,left,bottom,right,nil];
}

-(NSLayoutConstraint*)edgesWithInset:(CGFloat)inset attr:(LayoutAttribute)attr
{
    return [self edgesWithInset:inset view:self.superview attr:attr];
}

-(NSLayoutConstraint*)edgesWithInset:(CGFloat)inset view:(UIView*)view attr:(LayoutAttribute)attr
{
    return [self edgesWithInset:inset attr:attr toView:view toAttr:attr];
}

-(NSLayoutConstraint*)edgesWithInset:(CGFloat)inset attr:(LayoutAttribute)attr toView:(UIView*)toView toAttr:(LayoutAttribute)toAttr
{
    return [self constraint:attr relatedBy:Equal view:toView attribute:toAttr multiplier:1 constant:inset];
}

-(NSArray*)centerInContainer
{
    return [self centerInContainer:self.superview];
}

-(NSArray*)centerInContainer:(UIView*)view
{
    NSMutableArray *constraints = [NSMutableArray new];
    [constraints addObject:[self centerInView:CenterX toView:view toAttr:CenterX]];
    [constraints addObject:[self centerInView:CenterY toView:view toAttr:CenterY]];
    return [constraints copy];
}

-(NSLayoutConstraint*)centerInView:(LayoutAttribute)attr toView:(UIView*)view
{
    return [self centerInView:attr toView:view toAttr:attr];
}

-(NSLayoutConstraint*)centerInView:(LayoutAttribute)attr toView:(UIView*)view toAttr:(LayoutAttribute)toAttr
{
    return [self centerInView:attr toView:view toAttr:toAttr constant:0];
}

-(NSLayoutConstraint*)centerInView:(LayoutAttribute)attr toView:(UIView*)view toAttr:(LayoutAttribute)toAttr constant:(CGFloat)c
{
    NSLayoutConstraint *constraint = [self constraint:attr relatedBy:Equal view:view attribute:toAttr multiplier:1 constant:c];
    return constraint;
}

-(NSArray*)viewToSize:(CGSize)size
{
    NSMutableArray *constraints = [NSMutableArray new];
    if (size.width)
        [constraints addObject:[self viewToWidth:size.width]];
    if (size.height)
        [constraints addObject:[self viewToHeight:size.height]];
    
    return [constraints copy];
}
-(NSLayoutConstraint*)viewToWidth:(CGFloat)width
{
    return [self constraint:Width relatedBy:Equal view:nil attribute:Width multiplier:1 constant:width];
}
-(NSLayoutConstraint*)viewToHeight:(CGFloat)height
{
    return [self constraint:Height relatedBy:Equal view:nil attribute:Height multiplier:1 constant:height];
}

-(NSArray *)viewToMinimumSize:(CGSize)minimum
{
    NSMutableArray *constraints = [NSMutableArray new];
    if (minimum.width && minimum.width >0){
        [constraints addObject:[self constraint:Width relatedBy:GreaterThanOrEqual view:nil attribute:minimum.width multiplier:1 constant:minimum.width]];
    }
    if (minimum.height && minimum.height >0){
        [constraints addObject:[self constraint:Width relatedBy:GreaterThanOrEqual view:nil attribute:minimum.width multiplier:1 constant:minimum.width]];
    }
    return [constraints copy];
}

-(NSArray *)viewToMaximumSize:(CGSize)maximum
{
    NSMutableArray *constraints = [NSMutableArray new];
    if (maximum.width && maximum.width >0){
        [constraints addObject:[self constraint:Width relatedBy:LessThanOrEqual view:nil attribute:maximum.width multiplier:1 constant:maximum.width]];
    }
    if (maximum.height && maximum.height >0){
        [constraints addObject:[self constraint:Width relatedBy:LessThanOrEqual view:nil attribute:maximum.width multiplier:1 constant:maximum.width]];
    }
    return [constraints copy];
}


#pragma mark -- common --

-(NSLayoutConstraint*)constraint:(LayoutAttribute)attr relatedBy:(LayoutRelation)relation view:(UIView*)view attribute:(LayoutAttribute)attribute
{
    return [self constraint:attr relatedBy:relation view:view attribute:attr multiplier:1 constant:0];
}

-(NSLayoutConstraint*)constraint:(LayoutAttribute)attr relatedBy:(LayoutRelation)relation view:(UIView*)view attribute:(LayoutAttribute)attribute multiplier:(CGFloat)multiplier constant:(CGFloat)c
{
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self attribute:[self getAttribute:attr] relatedBy:[self getRelation:relation] toItem:view attribute:[self getAttribute:attribute] multiplier:multiplier constant:c];
    [self.superview addConstraint:constraint];
    return constraint;
}

#pragma mark -- start --

-(NSArray*)superWithInset:(UIEdgeInsets)insets
{
    NSArray *top = [self superWithEdges:insets.top attr:Top];
    NSArray *left = [self superWithEdges:insets.left attr:Left];
    NSArray *bottom = [self superWithEdges:insets.bottom attr:Bottom];
    NSArray *right = [self superWithEdges:insets.right attr:Right];
    
    return [NSArray arrayWithObjects:top,left,bottom,right,nil];
}

-(NSArray*)superWithEdges:(float)edges attr:(LayoutAttribute)attr
{
    NSMutableArray *array = [NSMutableArray new];
    if (attr & Top) {
        [array addObject:[self constraint:Top relatedBy:Equal view:self.superview attribute:Top multiplier:1 constant:edges]];
    }
    if (attr & Left) {
        [array addObject:[self constraint:Left relatedBy:Equal view:self.superview attribute:Left multiplier:1 constant:edges]];
    }
    if (attr & Bottom) {
        [array addObject:[self constraint:Bottom relatedBy:Equal view:self.superview attribute:Bottom multiplier:1 constant:edges]];
    }
    if (attr & Right) {
        [array addObject:[self constraint:Right relatedBy:Equal view:self.superview attribute:Right multiplier:1 constant:edges]];
    }
    return [array copy];
}

-(NSLayoutConstraint*)superWithEdges:(float)edges attr:(LayoutAttribute)attr toAttr:(LayoutAttribute)toAttr
{
    return [self constraint:attr relatedBy:Equal view:self.superview attribute:toAttr multiplier:1 constant:edges];
}

-(NSArray*)superWithCenter
{
    NSMutableArray *array = [NSMutableArray new];
    [array addObject:[self constraint:CenterX relatedBy:Equal view:self.superview attribute:CenterX multiplier:1 constant:0]];
    [array addObject:[self constraint:CenterY relatedBy:Equal view:self.superview attribute:CenterY multiplier:1 constant:0]];
    return [array copy];
}

-(NSArray*)superWithCenter:(float)edges attr:(LayoutAttribute)attr;
{
    NSMutableArray *array = [NSMutableArray new];
    if (attr & CenterX) {
        [array addObject:[self constraint:CenterX relatedBy:Equal view:self.superview attribute:CenterX multiplier:1 constant:edges]];
    }
    if (attr & CenterY) {
        [array addObject:[self constraint:CenterY relatedBy:Equal view:self.superview attribute:CenterY multiplier:1 constant:edges]];
    }
    return [array copy];
}

-(NSArray*)viewWithInset:(UIEdgeInsets)insets view:(UIView*)view;
{
    NSArray *top = [self viewWithEdges:insets.top attr:Top view:view];
    NSArray *left = [self viewWithEdges:insets.left attr:Left view:view];
    NSArray *bottom = [self viewWithEdges:insets.bottom attr:Bottom view:view];
    NSArray *right = [self viewWithEdges:insets.right attr:Right view:view];
    
    return [NSArray arrayWithObjects:top,left,bottom,right,nil];
}
-(NSArray*)viewWithEdges:(float)edges attr:(LayoutAttribute)attr view:(UIView*)view;
{
    NSMutableArray *array = [NSMutableArray new];
    if (attr & Top) {
        [array addObject:[self constraint:Top relatedBy:Equal view:view attribute:Top multiplier:1 constant:edges]];
    }
    if (attr & Left) {
        [array addObject:[self constraint:Left relatedBy:Equal view:view attribute:Left multiplier:1 constant:edges]];
    }
    if (attr & Bottom) {
        [array addObject:[self constraint:Bottom relatedBy:Equal view:view attribute:Bottom multiplier:1 constant:edges]];
    }
    if (attr & Right) {
        [array addObject:[self constraint:Right relatedBy:Equal view:view attribute:Right multiplier:1 constant:edges]];
    }
    return [array copy];
}
-(NSLayoutConstraint*)viewWithEdges:(float)edges attr:(LayoutAttribute)attr view:(UIView*)view toAttr:(LayoutAttribute)toAttr;
{
    return [self constraint:attr relatedBy:Equal view:view attribute:toAttr multiplier:1 constant:edges];
}
-(NSArray*)viewWithCenter:(UIView*)view;
{
    NSMutableArray *array = [NSMutableArray new];
    [array addObject:[self constraint:CenterX relatedBy:Equal view:view attribute:CenterX multiplier:1 constant:0]];
    [array addObject:[self constraint:CenterY relatedBy:Equal view:view attribute:CenterY multiplier:1 constant:0]];
    return [array copy];
}
-(NSArray*)viewWithCenter:(float)edges attr:(LayoutAttribute)attr view:(UIView*)view;
{
    NSMutableArray *array = [NSMutableArray new];
    if (attr & CenterX) {
        [array addObject:[self constraint:CenterX relatedBy:Equal view:view attribute:CenterX multiplier:1 constant:edges]];
    }
    if (attr & CenterY) {
        [array addObject:[self constraint:CenterY relatedBy:Equal view:view attribute:CenterY multiplier:1 constant:edges]];
    }
    return [array copy];
}
-(NSLayoutConstraint*)viewWithRelation:(LayoutRelation)relation attr:(LayoutAttribute)attr view:(UIView*)view
{
    return [self constraint:attr relatedBy:relation view:view attribute:attr];
}

#pragma mark -- end --

/*!
 *  @author DT
 *
 *  @brief  约束条件转化成NSLayoutAttribute
 *
 *  @param attr 自定义的约束条件
 *
 *  @return NSLayoutAttribute约束条件
 */
-(NSLayoutAttribute)getAttribute:(LayoutAttribute)attr
{
    if (attr == Default){
        return NSLayoutAttributeNotAnAttribute;
    }else if (attr == Left) {
        return NSLayoutAttributeLeft;
    }else if (attr == Right){
        return NSLayoutAttributeRight;
    }else if (attr == Bottom){
        return NSLayoutAttributeBottom;
    }else if (attr == Top){
        return NSLayoutAttributeTop;
    }else if (attr == CenterX){
        return NSLayoutAttributeCenterX;
    }else if (attr == CenterY){
        return NSLayoutAttributeCenterY;
    }else if (attr == Height){
        return NSLayoutAttributeHeight;
    }else if (attr == Width){
        return NSLayoutAttributeWidth;
    }else if (attr == Baseline){
        return NSLayoutAttributeBaseline;
    }
    return NSLayoutAttributeNotAnAttribute;
}

/*!
 *  @author DT
 *
 *  @brief  约束条件转化成NSLayoutFormatOptions
 *
 *  @param opts 自定义的约束条件
 *
 *  @return NSLayoutFormatOptions约束条件
 */
-(NSLayoutFormatOptions)getFormatOptions:(LayoutOptions)opts
{
    if (opts == AllLeft) {
        return NSLayoutFormatAlignAllLeft;
    }else if (opts == AllRight){
        return NSLayoutFormatAlignAllRight;
    }else if (opts == AllBottom){
        return NSLayoutFormatAlignAllBottom;
    }else if (opts == AllTop){
        return NSLayoutFormatAlignAllTop;
    }else if (opts == AllCenterX){
        return NSLayoutFormatAlignAllCenterX;
    }else if (opts == AllCenterY){
        return NSLayoutFormatAlignAllCenterY;
    }else if (opts == AllBaseline){
        return NSLayoutFormatAlignAllBaseline;
    }else if (opts == AllDefault){
        return NSLayoutFormatDirectionLeadingToTrailing;
    }
    return NSLayoutFormatDirectionLeadingToTrailing;
}

/*!
 *  @author DT
 *
 *  @brief  约束条件转化成NSLayoutRelation
 *
 *  @param relation 自定义的约束条件
 *
 *  @return NSLayoutRelation约束条件
 */
-(NSLayoutRelation)getRelation:(LayoutRelation)relation
{
    if (relation == LessThanOrEqual) {
        return NSLayoutRelationLessThanOrEqual;
    }else if (relation == Equal){
        return NSLayoutRelationEqual;
    }else if (relation == GreaterThanOrEqual){
        return NSLayoutRelationGreaterThanOrEqual;
    }
    return NSLayoutRelationEqual;
}

@end
