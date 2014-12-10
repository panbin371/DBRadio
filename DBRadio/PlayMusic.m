//
//  PlayMusic.m
//  DBRadio
//
//  Created by pan on 14/12/6.
//  Copyright (c) 2014年 pan. All rights reserved.
//

#import "PlayMusic.h"


@implementation PlayMusic

static PlayMusic *players = nil;
+(PlayMusic *)sharedPlay
{
    static dispatch_once_t createPlayMusic;
    dispatch_once(&createPlayMusic, ^{
        players = [[PlayMusic alloc]init];
        players.musicTime = [NSTimer scheduledTimerWithTimeInterval:1 target:players selector:@selector(changeTime) userInfo:nil repeats:YES];
    });
    
//    @synchronized(self)
//    {
//        if (players == nil)
//        {
//            players = [[PlayMusic alloc]init];
//            players.musicTime = [NSTimer scheduledTimerWithTimeInterval:1 target:players selector:@selector(changeTime) userInfo:nil repeats:YES];
//        }
//    }
    return players;
}

-(void)changeTime
{
    NSTimeInterval totalTimer = players.player.duration;
    NSTimeInterval currentTime = players.player.currentTime;
    
    NSTimeInterval totalmin = (int)totalTimer/60;
    NSTimeInterval totals = (int)totalTimer%60;
    
    NSTimeInterval currentmin = (int)currentTime/60;
    NSTimeInterval currents = (int)currentTime%60;
    
    NSString *time = [NSString stringWithFormat:@"%02.0f:%02.0f/%02.0f:%02.0f",currentmin,currents,totalmin,totals];
    
    [_delegate timeChanged:time persent:(currentTime/totalTimer)];
}

-(void)music:(NSData *)data
{
    players.player = [[AVAudioPlayer alloc]initWithData:data error:nil];
    [players.player prepareToPlay];
    players.player.delegate = self;
//    self.player.numberOfLoops = -1;
    [players.player play];
    
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setActive:YES error:nil];
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    if (_delegate && [_delegate respondsToSelector:@selector(nextMusic)]) {
        [_delegate nextMusic];
    }
}

@end
