//
//  PlayMusic.h
//  DBRadio
//
//  Created by pan on 14/12/6.
//  Copyright (c) 2014年 pan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "manager.h"

@protocol  PlayMusicDelegate<NSObject>
-(void)nextMusic;
-(void)timeChanged:(NSString *)time persent:(float)persent;
@end

@interface PlayMusic : NSObject<managerDelegate,AVAudioPlayerDelegate>
@property(nonatomic, assign)id<PlayMusicDelegate>delegate;
@property(nonatomic, strong)AVAudioPlayer *player;
@property(nonatomic, strong)NSTimer *musicTime;
+(PlayMusic *)sharedPlay;
@end
