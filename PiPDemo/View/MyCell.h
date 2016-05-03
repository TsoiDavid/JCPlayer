//
//  MyCell.h
//  PiPDemo
//
//  Created by TsoiKaShing on 15/11/14.
//  Copyright © 2015年 TsoiKaShing. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MyCellDelegate <NSObject>

- (void)didSelectPlayButtonWithCell:(UITableViewCell *)cell;

@end

@interface MyCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *vedioBgView;
@property (weak,nonatomic) id<MyCellDelegate> delegate;
@end
