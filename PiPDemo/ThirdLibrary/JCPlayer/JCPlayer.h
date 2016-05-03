//
//  JCPlayer.h
//  PiPDemo
//
//  Created by TsoiKaShing on 15/11/14.
//  Copyright © 2015年 TsoiKaShing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>
#import "JCSlider.h"

@class JCPlayer;

@protocol JCPlayerDelegate <NSObject>

- (void)vedioScreenWillEnterFullScreen;
- (void)vedioScreenWillLeaveFullScreenWithIndex:(NSIndexPath *)indexPath Player:(JCPlayer *)player;

@end

@interface JCPlayer : UIView

@property (weak, nonatomic) id<JCPlayerDelegate> delegate;
/**
 *  被点击的视频坐标
 */
@property (strong, nonatomic) NSIndexPath *indexPath;
/**
 *  play vedio with Url
 */
@property (strong,nonatomic) NSString *vedioUrl;

- (UIView *)initWithFrame:(CGRect)frame;
/**
 *  更新frame
 *
 *  @param frame
 */
- (void)updateWithFrame:(CGRect)frame;
/**
 *  移除player
 */
- (void)remove;

@end
