//
//  JCSlider.h
//  PiPDemo
//
//  Created by TsoiKaShing on 15/11/15.
//  Copyright © 2015年 TsoiKaShing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JCSlider : UISlider
@property (strong, nonatomic) UIProgressView *progressView;
/**
 *  进度条的缓冲进度
 *
 *  @param value
 */
- (void)setExecuteValue:(float)value;
///**
// *  设置进度条缓冲部分颜色
// *
// *  @param color 颜色
// */
//- (void)setProgressTintColor:(UIColor *)color;

//- (void)setSecondaryValue:(float)value;
//- (void)setSecondaryTintColor:(UIColor *)tintColor;

@end
