//
//  ViewController.m
//  PiPDemo
//
//  Created by TsoiKaShing on 15/11/14.
//  Copyright © 2015年 TsoiKaShing. All rights reserved.
//

#import "ViewController.h"
#import "MyCell.h"
#import "JCPlayer.h"
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>

@interface ViewController ()<MyCellDelegate,JCPlayerDelegate>
{
    CGFloat oldScrollViewContentOffsetY;
    CGFloat newScrollViewContentOffsetY;
    CGFloat vedioOrignalY;
    CGFloat vedioHeight;
    BOOL isSmall;
    BOOL isPlay;
    UIView *full;
    BOOL isRotaion;
    
    
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (assign, nonatomic) BOOL fullscreen;
@property (assign, nonatomic) CGRect defaultFrame;
//旋转屏
@property (strong, nonatomic) JCPlayer *fullScreenView;

@property (strong,nonatomic) AVPlayer *player;
@property (strong,nonatomic) AVPlayerLayer *playerLayer;
@property (strong,nonatomic) JCPlayer *jCPlayer;
@property (strong,nonatomic) JCPlayer *oldJCPlayer;
@property (strong,nonatomic) UIView *tempPlayer;

@property (strong,nonatomic) NSIndexPath *selectIndexPath;
//@property (strong,nonatomic) UITableViewCell *tempCell;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    isRotaion = NO;
    // Do any additional setup after loading the view, typically from a nib.
}


#pragma mark ************创建tableView*************
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"cellId";
    MyCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell= [[[NSBundle mainBundle]loadNibNamed:@"MyCell" owner:nil options:nil] lastObject];
        cell.delegate = self;
        
    }
    return cell;
}



- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
//    NSLog(@"scrollView.contentOffset.y ======== %f",scrollView.contentOffset.y);
    oldScrollViewContentOffsetY = scrollView.contentOffset.y;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
//    NSLog(@"scrollView.contentOffset.y ======== %f",scrollView.contentOffset.y);
    MyCell *cell = [_tableView cellForRowAtIndexPath:_selectIndexPath];
    CGRect rect = [cell convertRect:cell.vedioBgView.frame toView:self.view];
//    NSLog(@"cellRect ===================%@",NSStringFromCGRect(rect));
    newScrollViewContentOffsetY = scrollView.contentOffset.y;
    CGFloat result = newScrollViewContentOffsetY - oldScrollViewContentOffsetY;

   
    if (result > vedioOrignalY + vedioHeight && _tempPlayer == nil &&isPlay == YES) {
        [self showSmallplayerLayer];
    }
    if (rect.origin.y + rect.size.height > 0 ) {
        [self showBigplayerLayerWithCell:cell];
    }
    
}
- (void)showBigplayerLayerWithCell:(UITableViewCell *)cell
{
    [_tempPlayer removeFromSuperview];
    _tempPlayer = nil;
    
    MyCell *myCell = (MyCell *)cell;
    [myCell.vedioBgView addSubview:_jCPlayer];
    
    [UIView animateWithDuration:0 animations:^{
        [_jCPlayer updateWithFrame:CGRectMake(0, 0, myCell.vedioBgView.frame.size.width, myCell.vedioBgView.frame.size.height)];

        
    } completion:^(BOOL finished) {
        isSmall = NO;
    }];
}
- (void)showSmallplayerLayer
{
    if (isSmall) return;
    if (!_tempPlayer) {
        
        _tempPlayer = [[UIView alloc]initWithFrame:CGRectMake(10, 400, 100, 100)];
        _tempPlayer.backgroundColor = [UIColor redColor];
        [self.view addSubview:_tempPlayer];
    }
    
    [_tempPlayer addSubview: _jCPlayer];
    
    [UIView animateWithDuration:0 animations:^{
        
        [_jCPlayer updateWithFrame:CGRectMake(0, 0, 100,100)];
        

        
    } completion:^(BOOL finished) {
         isSmall = YES;
    }];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    if (isRotaion) {
        full.frame = CGRectMake(0, 0, self.view.frame.size.height, self.view.frame.size.width);
    }
    
    
}
//- (void)dismissFullScreenPlayerLayer {
//    if (!_fullScreenView) {
//        
//        [UIView animateWithDuration:0 animations:^{
//            self.fullScreenView.transform = CGAffineTransformIdentity;
//        } completion:^(BOOL finished) {
//            
//        }];
//        
//    }
//}
#pragma mark - JCPlayerDelegate
- (void)vedioScreenWillEnterFullScreen {
  
}
- (void)vedioScreenWillLeaveFullScreenWithIndex:(NSIndexPath *)indexPath Player:(JCPlayer *)player{
    MyCell *myCell = [self.tableView cellForRowAtIndexPath:indexPath];
    [myCell.vedioBgView addSubview:player];
    [UIView animateWithDuration:0 animations:^{
        [_jCPlayer updateWithFrame:CGRectMake(0, 0, myCell.vedioBgView.frame.size.width, myCell.vedioBgView.frame.size.height)];
        
        
    } completion:^(BOOL finished) {
        
    }];
}
#pragma mark ************MyCellDelegate

- (void)didSelectPlayButtonWithCell:(UITableViewCell *)cell
{
    MyCell *myCell = (MyCell *)cell;
    if (_oldJCPlayer) {
        [_oldJCPlayer remove];
    }
    if (_tempPlayer) {
        [_tempPlayer removeFromSuperview];
        _tempPlayer = nil;
    }
//    _tempCell = cell;
    
    isPlay = YES;
    
    NSIndexPath *indexPath = [_tableView indexPathForCell:cell];
        NSLog(@"didSelectedindexPath is = %ld",indexPath.row);
    _selectIndexPath = indexPath;
    
    
    CGRect rect = [myCell convertRect:myCell.vedioBgView.frame toView:self.view];
    NSLog(@"myCell.vedioBgView.frame =====%@",NSStringFromCGRect(rect));
    
    //记录选中播放视频的cell的Rect
    vedioOrignalY = rect.origin.y;
    vedioHeight = rect.size.height;
    
    //根据坐标创建播放器
    
    _jCPlayer = [[JCPlayer alloc]initWithFrame:CGRectMake(0, 0, rect.size.width, rect.size.height)];
    _jCPlayer.indexPath = indexPath;
    _jCPlayer.delegate = self;
    _jCPlayer.vedioUrl = @"http://wscdn.miaopai.com/stream/2rgLUF9Ejv~knP4D3zrmFA__.mp4";
    _oldJCPlayer = _jCPlayer;
    [myCell.vedioBgView addSubview:_jCPlayer];
   
    
}


@end
