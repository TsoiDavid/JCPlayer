//
//  MyCell.m
//  PiPDemo
//
//  Created by TsoiKaShing on 15/11/14.
//  Copyright © 2015年 TsoiKaShing. All rights reserved.
//

#import "MyCell.h"

@implementation MyCell

- (void)awakeFromNib {
    // Initialization code
}
- (IBAction)playVedio:(id)sender {
    [self.delegate didSelectPlayButtonWithCell:self];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
