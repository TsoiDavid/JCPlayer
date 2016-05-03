//
//  JCPlayer.m
//  PiPDemo
//
//  Created by TsoiKaShing on 15/11/14.
//  Copyright © 2015年 TsoiKaShing. All rights reserved.
//
#define playerW  self.frame.size.width
#define playerH  self.frame.size.height
#import "JCPlayer.h"
#import "Masonry.h"
static const CGFloat buttonHW = 30;
static const CGFloat progressH = 30;
@interface JCPlayer ()
{
    
    NSDateFormatter *_dateFormatter;
    UIView *full;
    id timeObserver;
}
@property (assign, nonatomic) BOOL fullscreen;
@property (assign, nonatomic) CGRect defaultFrame;

@property (nonatomic ,strong) AVPlayerItem *playerItem;
@property (assign, nonatomic)BOOL isReadToPlay;

@property (strong, nonatomic) UIWindow *keyWindow;
/**
 *  播放器
 */
@property (strong,nonatomic) AVPlayer *player;
@property (strong,nonatomic) AVPlayerLayer *playerLayer;
/**
 *  操作部分view
 */
@property (strong, nonatomic) UIView *containerView;
/**
 *  操作栏
 */
@property (strong,nonatomic) UIView *operation;
/**
 *  播放按钮
 */
@property (strong,nonatomic) UIButton *playButton;
/**
 *  全屏按钮
 */
@property (strong,nonatomic) UIButton *fullButton;
/**
 *  进度条
 */
@property (strong,nonatomic)  JCSlider *progress;
/**
 *  总时间
 */
@property (strong,nonatomic)  UILabel *timeLabel;
/**
 *  当前播放的时间
 */
@property (assign,nonatomic) NSNumber *currentTime;
//总时间
@property (strong, nonatomic) NSString *totalTime;
//是否在滑动
@property (assign, nonatomic) BOOL isSlidering;

@end

@implementation JCPlayer

- (UIView *)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.keyWindow = [UIApplication sharedApplication].keyWindow;
        self.backgroundColor = [UIColor blackColor];
    }
    return self;
}

- (void)updateWithFrame:(CGRect)frame
{
    self.frame = frame;
    _playerLayer.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
   
    if (frame.size.width <150) {
        _playerLayer.videoGravity=AVLayerVideoGravityResize;
        _operation.hidden = YES;
    }else
    {
        _playerLayer.videoGravity=AVLayerVideoGravityResizeAspectFill;
        _operation.hidden = NO;
    }
}

-(void)setupUI{
    //默认没拖动进度条
    _isSlidering = NO;
    //创建播放器层
    _playerLayer=[AVPlayerLayer playerLayerWithPlayer:self.player];
    _player.volume = 0.3;
    _playerLayer.frame=CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
//    _playerLayer.backgroundColor = [UIColor blackColor].CGColor;
    _playerLayer.videoGravity=AVLayerVideoGravityResizeAspectFill;//视频填充模式
    [self.layer addSublayer:_playerLayer];
   [self setOperationView];
    _playButton.selected = YES;
    [_player play];
}


-(void)setVedioUrl:(NSString *)vedioUrl
{
    _vedioUrl = vedioUrl;
    [self setupUI];
}

-(AVPlayer *)player{
    if (!_player) {
        _playerItem = [self getPlayItem:0];
        _player=[AVPlayer playerWithPlayerItem:_playerItem];
        [self addProgressObserver];
        [self addObserverToPlayerItem:_playerItem];
    }
    return _player;
}

/**
 *  根据视频索引取得AVPlayerItem对象
 *
 *  @param videoIndex 视频顺序索引
 *
 *  @return AVPlayerItem对象
 */
-(AVPlayerItem *)getPlayItem:(int)videoIndex{
    
    NSURL *url=[NSURL URLWithString:_vedioUrl];
    AVPlayerItem *playerItem=[AVPlayerItem playerItemWithURL:url];
    return playerItem;
}

- (void)setOperationView
{

    
    _containerView = [[UIView alloc]init];
    _containerView.backgroundColor = [UIColor yellowColor];
    [_containerView setBackgroundColor:[UIColor colorWithWhite:0.0f alpha:0.45f]];
    [_containerView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self addSubview:_containerView];
  
    [_containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).with.offset(0); //with with
        make.left.equalTo(self.mas_left).offset(0); //without with
        make.bottom.equalTo(self.mas_bottom).offset(0);
        make.right.equalTo(self.mas_right).offset(0);
    
    }];
    
    //UIControl
    
    _operation = [[UIView alloc]init];
    _operation.backgroundColor = [UIColor grayColor];
    [_operation setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.containerView addSubview:_operation];
    
    [_operation mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_containerView.mas_left).offset(0); //without with
        make.bottom.equalTo(_containerView.mas_bottom).offset(0);
        make.right.equalTo(_containerView.mas_right).offset(0);
        make.height.equalTo(@50);
        
    }];

    
    _playButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_playButton setBackgroundColor:[UIColor redColor]];
    [_playButton setImage:[UIImage imageNamed:@"gui_play@2x"] forState:UIControlStateNormal];
    [_playButton setImage:[UIImage imageNamed:@"gui_pause@2x"] forState:UIControlStateSelected];
    [_playButton addTarget:self action:@selector(playAction) forControlEvents:UIControlEventTouchUpInside];
    [_playButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.operation addSubview:_playButton];

    [_playButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_operation.mas_left).offset(5); //without with
        make.top.equalTo(_operation.mas_top).offset(10);
        make.height.equalTo(@(buttonHW));
        make.width.equalTo(@(buttonHW));
        
    }];
    
   


    _fullButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_fullButton setImage:[UIImage imageNamed:@"gui_shrink@2x"] forState:UIControlStateNormal];
    [_fullButton setImage:[UIImage imageNamed:@"gui_shrink@2x"] forState:UIControlStateSelected];
    [_fullButton addTarget:self action:@selector(fullScreenAction) forControlEvents:UIControlEventTouchUpInside];
    [_fullButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.operation addSubview:_fullButton];
    
    [_fullButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(_playButton.mas_right).offset(5); //without with
        make.top.equalTo(_operation.mas_top).offset(10);
        make.right.equalTo(_operation.mas_right).offset(-5);
        make.height.equalTo(@(buttonHW));
        make.width.equalTo(@(buttonHW));
        
        
    }];
    
    
    _progress = [[JCSlider alloc]init];
//    [self.progress addTarget:self action:@selector(avSliderAction) forControlEvents:
//     UIControlEventTouchUpInside|UIControlEventTouchCancel|UIControlEventTouchUpOutside];
    [self.progress addTarget:self action:@selector(starPanSliderAction) forControlEvents:UIControlEventValueChanged];
    [self.progress addTarget:self action:@selector(endPanSliderAction) forControlEvents:UIControlEventTouchUpInside];
    [_progress setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_progress setContinuous:YES];
    [self.operation addSubview:_progress];
    
    [_progress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_playButton.mas_right).offset(5); //without with
        make.top.equalTo(_operation.mas_top).offset(6);
        make.right.equalTo(_fullButton.mas_left).offset(-5);
        make.height.mas_equalTo(@(progressH));
    }];
    
    _timeLabel = [[UILabel alloc]init];
    _timeLabel.text = @"00:00/00:00";
    _timeLabel.font = [UIFont systemFontOfSize:12];
    CGSize sumSize = [_timeLabel sizeThatFits:CGSizeMake(100, MAXFLOAT)];
    [_timeLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.operation addSubview:_timeLabel];

    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {

        make.bottom.equalTo(_operation.mas_bottom).offset(0);
        make.right.equalTo(_fullButton.mas_left).offset(-5);
        make.height.equalTo(@(sumSize.height));
        make.width.equalTo(@(sumSize.width));
    }];
    
}
//停止拽动进度条
- (void)endPanSliderAction {
    //slider的value值为视频的时间
    
    CGFloat seconds =  self.progress.value;
    //    NSLog(@"self.progress.value === %f",self.progress.value);
    NSLog(@"seconds value === %f",seconds);
    //
    //
    //    //让视频从指定的CMTime对象处播放。
    CMTime startTime = CMTimeMakeWithSeconds(seconds, self.playerItem.currentTime.timescale);
    //让视频从指定处播放
    [self.player seekToTime:startTime completionHandler:^(BOOL finished) {
        if (finished) {
            [_player play];
            _playButton.selected = YES;
            _isSlidering = NO;
            [self updateSlide];
        }
    }];
 
}

//开始拽动进度条
- (void)starPanSliderAction{
    _isSlidering = YES;

    [self updateTime];

    
}
- (void)updateTime {

    NSString *currentSecond = [self convertTime:self.progress.value];

    self.timeLabel.text = [NSString stringWithFormat:@"%@/%@",currentSecond,self.totalTime];


}
- (void)updateSlide {
 
    CGFloat current=CMTimeGetSeconds(self.player.currentItem.currentTime);
     self.progress.value = current;
     NSLog(@"当前已经播放%.2fs.",current);
}
/**
 *  给播放器添加进度更新
 */

-(void)addProgressObserver{
    AVPlayerItem *playerItem=self.player.currentItem;
   
    //这里设置每秒执行一次
    __weak typeof(self) weakSelf = self;
  timeObserver = [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1.0, 1.0) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        
        CGFloat currentSecond = playerItem.currentTime.value/playerItem.currentTime.timescale;// 计算当前在第几秒
        if (!weakSelf.isSlidering) {
        [weakSelf.progress setValue:currentSecond animated:YES];
        }
        
        NSString *timeString = [weakSelf convertTime:currentSecond];
        weakSelf.timeLabel.text = [NSString stringWithFormat:@"%@/%@",timeString,weakSelf.totalTime];

    }];
}



/**
 *  给AVPlayerItem添加监控
 *
 *  @param playerItem AVPlayerItem对象
 */
-(void)addObserverToPlayerItem:(AVPlayerItem *)playerItem{
    //监控时间
    
    [playerItem addObserver:self forKeyPath:@"time" options:NSKeyValueObservingOptionNew context:nil];
    //监控状态属性，注意AVPlayer也有一个status属性，通过监控它的status也可以获得播放状态
    [playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    //监控网络加载情况属性
    [playerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
}
-(void)removeObserverFromPlayerItem:(AVPlayerItem *)playerItem{

    [playerItem removeObserver:self forKeyPath:@"time"];
    [playerItem removeObserver:self forKeyPath:@"status"];
    [playerItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
    //记得要移除这个，不然内存会暴涨。
    [self.player removeTimeObserver:timeObserver];
}
- (void)dealloc {
    [self removeObserverFromPlayerItem:_playerItem];
    [self disMiss];
}
- (void)disMiss {
    [self.player pause];
    [self removeFromSuperview];
}
/**
 *  通过KVO监控播放器状态
 *
 *  @param keyPath 监控属性
 *  @param object  监视器
 *  @param change  状态改变
 *  @param context 上下文
 */
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    AVPlayerItem *playerItem=object;
    CGFloat totalTime ;

    if ([keyPath isEqualToString:@"status"]) {
        AVPlayerStatus status= [[change objectForKey:@"new"] intValue];
        if(status==AVPlayerStatusReadyToPlay){
            NSLog(@"正在播放...，视频总长度:%.2f",CMTimeGetSeconds(playerItem.duration));
            totalTime = CMTimeGetSeconds(playerItem.duration);
            _totalTime = [self convertTime:totalTime];
            self.progress.maximumValue = self.playerItem.duration.value / self.playerItem.duration.timescale;
            NSLog(@"self.progress.maxvalue === %f",self.progress.maximumValue);
        }else if (status == AVPlayerItemStatusUnknown) {
            NSLog(@"视频资源出现未知错误");
            self.isReadToPlay = NO;
        }else if (status == AVPlayerItemStatusFailed) {
            NSLog(@"item 有误");
            self.isReadToPlay = NO;
        }
    }else if([keyPath isEqualToString:@"loadedTimeRanges"]){
        NSTimeInterval timeInterval = [self availableDuration];// 计算缓冲进度
        NSLog(@"Time Interval:%f",timeInterval);
        CMTime duration = self.playerItem.duration;
        CGFloat totalDuration = CMTimeGetSeconds(duration);
        
        [_progress setExecuteValue:timeInterval/totalDuration ];
        //
    }else if ([keyPath isEqualToString:@"time"])
    {
        NSLog(@"object ====%@",object);
    }
}
- (NSTimeInterval)availableDuration {
    NSArray *loadedTimeRanges = [[self.playerLayer.player currentItem] loadedTimeRanges];
    CMTimeRange timeRange = [loadedTimeRanges.firstObject CMTimeRangeValue];// 获取缓冲区域
    float startSeconds = CMTimeGetSeconds(timeRange.start);
    float durationSeconds = CMTimeGetSeconds(timeRange.duration);
    NSTimeInterval result = startSeconds + durationSeconds;// 计算缓冲总进度
    return result;
}



/**
 *  描述转时间
 *
 *  @param totalSeconds 秒数
 *
 *  @return 返回时间格式
 */
//- (NSString *)timeFormatted:(int)totalSeconds
//{
// 
//    int seconds = totalSeconds % 60;
//    int minutes = (totalSeconds / 60) % 60;
//    int hours = totalSeconds / 3600;
//    
////    return [NSString stringWithFormat:@"%02d:%02d:%02d",hours, minutes, seconds];
//    return [NSString stringWithFormat:@"%02d:%02d",minutes, seconds];
//}

- (NSString *)convertTime:(CGFloat)second{
    NSDate *d = [NSDate dateWithTimeIntervalSince1970:second];
    if (second/3600 >= 1) {
        [[self dateFormatter] setDateFormat:@"HH:mm:ss"];
    } else {
        [[self dateFormatter] setDateFormat:@"mm:ss"];
    }
    NSString *showtimeNew = [[self dateFormatter] stringFromDate:d];
    return showtimeNew;
}

- (NSDateFormatter *)dateFormatter {
    if (!_dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc] init];
    }
    return _dateFormatter;
}

/**
 *  播放暂停动作
 */
- (void)playAction
{
    if (_playButton.selected) {
        _playButton.selected  = NO;
        [_player pause];
    }else
    {
        _playButton.selected = YES;
        [_player play];
    }
}
/**
 *  视频放大缩小
 */
- (void)fullScreenAction
{
    if (!self.fullButton.selected) {
        [self orientationLeftFullScreen];
    }else {
        [self smallScreen];
        [self.delegate vedioScreenWillLeaveFullScreenWithIndex:_indexPath Player:self];
    }
    
    self.fullButton.selected = self.fullButton.selected ? NO : YES;
}

- (void)orientationLeftFullScreen {
//    self.isFullScreen = YES;
//    self.zoomScreenBtn.selected = YES;
    [self.keyWindow addSubview:self];
    
    [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIDeviceOrientationLandscapeLeft] forKey:@"orientation"];
    [self updateConstraintsIfNeeded];
    
    [UIView animateWithDuration:0.3 animations:^{
//        self.transform = CGAffineTransformMakeRotation(M_PI / 2);
        self.frame = self.keyWindow.bounds;
        self.playerLayer.frame = self.frame;
//        self.bottomBar.frame = CGRectMake(0, self.keyWindow.bounds.size.width - bottomBaHeight, self.keyWindow.bounds.size.height, bottomBaHeight);
//        self.playOrPauseBtn.frame = CGRectMake((self.keyWindow.bounds.size.height - playBtnSideLength) / 2, (self.keyWindow.bounds.size.width - playBtnSideLength) / 2, playBtnSideLength, playBtnSideLength);
//        self.activityIndicatorView.center = CGPointMake(self.keyWindow.bounds.size.height / 2, self.keyWindow.bounds.size.width / 2);
    }];
    
//    [self setStatusBarHidden:YES];

}

- (void)smallScreen {
//    self.isFullScreen = NO;
//    self.zoomScreenBtn.selected = NO;
    [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIDeviceOrientationPortrait] forKey:@"orientation"];
    
//    if (self.bindTableView) {
//        UITableViewCell *cell = [self.bindTableView cellForRowAtIndexPath:self.currentIndexPath];
//        [cell.contentView addSubview:self];
//    }
    
    [UIView animateWithDuration:0.3 animations:^{
        self.transform = CGAffineTransformMakeRotation(0);
        self.frame = self.defaultFrame;
        self.playerLayer.frame = self.frame;
//        self.bottomBar.frame = CGRectMake(0, self.playerOriginalFrame.size.height - bottomBaHeight, self.self.playerOriginalFrame.size.width, bottomBaHeight);
//        self.playOrPauseBtn.frame = CGRectMake((self.playerOriginalFrame.size.width - playBtnSideLength) / 2, (self.playerOriginalFrame.size.height - playBtnSideLength) / 2, playBtnSideLength, playBtnSideLength);
//        self.activityIndicatorView.center = CGPointMake(self.playerOriginalFrame.size.width / 2, self.playerOriginalFrame.size.height / 2);
        [self updateConstraintsIfNeeded];
    }];
//    [self setStatusBarHidden:NO];
    
}

- (void)remove
{
//    [_playerLayer removeFromSuperlayer];
    [self removeFromSuperview];
    
}
@end
