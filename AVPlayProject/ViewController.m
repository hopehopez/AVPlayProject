//
//  ViewController.m
//  AVPlayProject
//
//  Created by Elean on 16/1/9.
//  Copyright (c) 2016年 Elean. All rights reserved.
//
//当前工程实现的效果是 自己定制一个界面 用于播放视频
//通过AVPlayer定制视频播放器

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>
@interface ViewController ()

@property (nonatomic,strong)AVPlayer *player;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    //对paler做设置 主要是视频的播放相关的
    
    __weak __typeof(self)weakSelf = self;
    //主要是用于ARC下 修饰指针
    //表示的是如果weakSelf指向一个对象 原来指向的旧对象引用计数-1  指向的新对象的引用计数+1
    
    //目的是为了让指向的对象在使用结束后立即释放
    
    //在AVPler的使用中 需要将用于播放的控制器使用该方法
    
    //1.实现进度条与视频播放同步
    [self.player addPeriodicTimeObserverForInterval:CMTimeMake(30, 30) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        
        //time 播放时的时间
        //根据当前播放的时间/总播放时间 可以计算出进度
        
        //(1)获取总的播放时间
        
        float totalTime = weakSelf.player.currentItem.duration.value*1.0/weakSelf.player.currentItem.duration.timescale;
        
        //(2)获取当前的播放时间
        
        float currentTime = weakSelf.player.currentItem.currentTime.value*1.0/weakSelf.player.currentTime.timescale;
        
        //(3)设置滑动条
        weakSelf.progressSlider.value = currentTime*1.0/totalTime;
        
        
        
    }];
    
    
    
}

#pragma mark -- 实现player的懒加载 (不需要手动调用)
//如果希望当前类的某个属性实现懒加载 那么直接使用该属性名作为方法名 返回值是该属性 调用点语法时 就会自动调用该栏架在的方法 如果还没有创建过 执行懒加载方法中的代码 如果创建过 就不需要再创建
- (AVPlayer *)player{

    //判断player是否为空 如果为空的话 需要初始化设置
    
    //因此 player初始化的代码 应该写在判断语句里
    
    if(!_player){
    
        //1.获取资源路径
        NSString *path = [[NSBundle mainBundle] pathForResource:@"1" ofType:@"mp4"];
        
        //2.转换为NSURL
        NSURL *url = [NSURL fileURLWithPath:path];
        //fileURLWithPath 针对本地文件的
        
       // URLWithString 针对网络文件的
        
        //3.根据URL 将对应的视频资源转换为播放源
        AVPlayerItem *item = [[AVPlayerItem alloc]initWithURL:url];
        //通过url将视频资源转换为可播放的播放源
        
        //4.将播放源 加载到AVPlayer上
        _player = [[AVPlayer alloc]initWithPlayerItem:item];
        
        //5.对AVPlayer播放的“窗口"做设置
        
        //AVPlayer 渲染层 CALayer来实现的
        
        //(1)现获取CALayer
        AVPlayerLayer *layer = [AVPlayerLayer playerLayerWithPlayer:_player];
        
        //(2)设置背景颜色
        layer.backgroundColor = [UIColor cyanColor].CGColor;
        //【注意】背景颜色是CGColor类型
        
        //(3)设置大小(视频显示的区域)
        layer.frame = CGRectMake(50, 100, 200, 200);
        
        //(4)还可以对显示的区域裁剪成圆形的
        layer.cornerRadius = 100;
        
        //(5)边框设置
        layer.borderWidth = 5;
        layer.borderColor = [UIColor yellowColor].CGColor;
        
        //(6)将超出的区域裁剪掉
        layer.masksToBounds = YES;
        
        //(7)设置视频的拉伸 根据layer的大小 调整视频 避免变形 处理的原理 类似于停靠模式
        
        layer.videoGravity = AVLayerVideoGravityResizeAspect;
 /*
        AVLayerVideoGravityResizeAspect;
  按照layer的大小进行等比例压缩
  
        AVLayerVideoGravityResize;
  填充整个layer 容易产生形变
  
        AVLayerVideoGravityResizeAspectFill;
  按比例填充layer 不会有黑边
        
 */
        //(8)将layer添加到控制器上播放视频
        
        [self.view.layer addSublayer:layer];
        
    }
    
    
    
    return _player;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)playClick:(id)sender {
    
    [self.player play];
    //开始播放
}

- (IBAction)pauseClick:(id)sender {
    
    [self.player pause];
    //暂停播放
}
@end
