//
//  VAPlayerViewController.m
//  GUOWER
//
//  Created by ourslook on 2018/7/23.
//  Copyright © 2018年 Vanne. All rights reserved.
//

#import "VAPlayerViewController.h"
//player
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>

@interface VAPlayerViewController ()

/** player */
@property (nonatomic, strong) AVPlayerViewController *playerViewController;

@end

@implementation VAPlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    AVPlayer *avPlayer= [AVPlayer playerWithURL:self.url.mj_url];
    _playerViewController = [[AVPlayerViewController alloc] init];
    _playerViewController.player = avPlayer;
    _playerViewController.videoGravity = AVLayerVideoGravityResizeAspect;
    _playerViewController.showsPlaybackControls = YES;
    _playerViewController.view.frame = self.view.bounds;
    [self addChildViewController:_playerViewController];
    [self.view addSubview:_playerViewController.view];
    // 播放
    [_playerViewController.player play];
    
}

@end
