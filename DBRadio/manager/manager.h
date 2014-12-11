//
//  manager.h
//  DBRadio
//
//  Created by pan on 14/12/4.
//  Copyright (c) 2014年 pan. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol managerDelegate <NSObject>
@optional

-(void)musicInfo:(NSDictionary *)dic;
-(void)music:(NSData *)data;
-(void)channelList:(NSDictionary *)dic;

@end

@interface manager : NSObject

@property(nonatomic, strong)NSString *channel;
@property(nonatomic, assign)id<managerDelegate>delegate;

+(manager *)sharedManager;

-(void)getMusicListByAFHTTPRequestOperation;
-(void)getMusicListByNSURLConnection;

-(void)downloadMusicByAFHTTPRequestOperation:(NSString *)url name:(NSString *)name;
-(void)downloadMusicByNSURLConnection:(NSString *)url name:(NSString *)name;

-(void)getChannelListByAFHTTPRequestOperation;
-(void)getChannelListByNSURLConnection;

- (void)saveData:(NSData *)data name:(NSString *)name;

@end
