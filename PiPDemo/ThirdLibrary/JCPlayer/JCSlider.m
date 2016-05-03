//
//  JCSlider.m
//  PiPDemo
//
//  Created by TsoiKaShing on 15/11/15.
//  Copyright © 2015年 TsoiKaShing. All rights reserved.
//

#import "JCSlider.h"

@interface JCSlider ()



@end

@implementation JCSlider

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    
    return self;
}

//- (void)setup {
//    [self setMaximumTrackTintColor:[UIColor clearColor]];
//    
//    _progressView = [UIProgressView new];
//    [_progressView setTranslatesAutoresizingMaskIntoConstraints:NO];
//    [_progressView setClipsToBounds:YES];
//    [[_progressView layer] setCornerRadius:1.0f];
//    
//    CGFloat hue, sat, bri;
//    [[self tintColor] getHue:&hue saturation:&sat brightness:&bri alpha:nil];
//    [_progressView setTintColor:[UIColor colorWithHue:hue saturation:(sat * 0.6f) brightness:bri alpha:1]];
//    
//    [self addSubview:_progressView];
//    
//    NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[PV]|"
//                                                                   options:0
//                                                                   metrics:nil
//                                                                     views:@{@"PV" : _progressView}];
//    
//    [self addConstraints:constraints];
//    
//    constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(20)-[PV]"
//                                                          options:0
//                                                          metrics:nil
//                                                            views:@{@"PV" : _progressView}];
//    
//    [self addConstraints:constraints];
//}
//
//- (void)setSecondaryValue:(float)value {
//    [_progressView setProgress:value];
//}
//
//- (void)setTintColor:(UIColor *)tintColor {
//    [super setTintColor:tintColor];
//    
//    CGFloat hue, sat, bri;
//    [[self tintColor] getHue:&hue saturation:&sat brightness:&bri alpha:nil];
//    [_progressView setTintColor:[UIColor colorWithHue:hue saturation:(sat * 0.6f) brightness:bri alpha:1]];
//}
//
//- (void)setSecondaryTintColor:(UIColor *)tintColor {
//    [_progressView setTintColor:tintColor];
//}

//
- (void)setup {
    //右边进度条颜色
    [self setMaximumTrackTintColor:[UIColor clearColor]];
    _progressView = [UIProgressView new];
    //设置视图自动调整尺寸的掩码是否转化为基于约束布局的约束
    [_progressView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_progressView setClipsToBounds:YES];
    [[_progressView layer] setCornerRadius:1.0f];
    
    CGFloat hue, sat, bri;
    //获取当前slider的tintColor的颜色，下面赋值给progressView，使它看上去跟slider一样颜色。
    [[self tintColor] getHue:&hue saturation:&sat brightness:&bri alpha:nil];
    /**
     
     指定HSB，参数是：色调（hue），饱和的（saturation），亮度（brightness）
     + (UIColor *)colorWithHue:(CGFloat)hue saturation:(CGFloat)saturation brightness:(CGFloat)brightness alpha:(CGFloat)alpha;
     
     **/
    [_progressView setTintColor:[UIColor colorWithHue:hue saturation:(sat * 0.6f) brightness:bri alpha:1]];
    
    
    
    [self addSubview:_progressView];
    
    //  VFL自动布局 V表垂直，H:表示水平 |: 表示父视图 -:表示距离
    NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[PV]|"
                                                                   options:0
                                                                   metrics:nil
                                                                     views:@{@"PV" : _progressView}];
    
    [self addConstraints:constraints];
    NSString *str = [NSString stringWithFormat:@"V:|-(%f)-[PV]",self.frame.size.height/2-1];
    constraints = [NSLayoutConstraint constraintsWithVisualFormat:str
                                                          options:0
                                                          metrics:nil
                                                            views:@{@"PV" : _progressView}];
    
    [self addConstraints:constraints];
}

- (void)setExecuteValue:(float)value {
    NSLog(@"progress value ====%f",value);
    [_progressView setProgress:value];
    
}

- (void)setProgressTintColor:(UIColor *)color
{
    //默认白色
    _progressView.progressTintColor = [UIColor whiteColor];
    
    if (!color) return;
    
    _progressView.progressTintColor = color;
}


@end
