//
//  manager.m
//  DBRadio
//
//  Created by pan on 14/12/4.
//  Copyright (c) 2014年 pan. All rights reserved.
//

#import "manager.h"

@implementation manager

static manager *Manager = nil;
+(manager *)sharedManager
{
    static dispatch_once_t createManager;
    dispatch_once(&createManager, ^{
        Manager = [[manager alloc]init];
        Manager.channel = [NSString stringWithFormat:@"0"];
    });
    
//    @synchronized(self)
//    {
//        if (Manager == nil)
//        {
//            Manager = [[manager alloc]init];
//            Manager.channel = [NSString stringWithFormat:@"0"];
//        }
//    }
    return Manager;
}

- (void)getMusicList
{
    NSString *url = [self getMusicUrl];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"GET"];
    NSHTTPURLResponse *response = nil;
    NSError *error = [[NSError alloc]init];
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    if (responseData)
    {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:&error];
        [_delegate musicInfo:dic];
    }
}

-(void)downloadMusic:(NSString *)url
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:url]];
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:queue
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error){
                               if (error) {
                                   NSLog(@"Httperror:%@%ld", error.localizedDescription,(long)error.code);
                               }else{
                                   NSInteger responseCode = [(NSHTTPURLResponse *)response statusCode];
                                   NSLog(@"HttpResponseCode:%ld", (long)responseCode);
                                   [_delegate music:data];
                               }
                           }];
}

-(NSString *)getMusicUrl
{
    NSLog(@"%@",_channel);
    return [NSString stringWithFormat:@"http://douban.fm/j/mine/playlist?channel=%@",_channel];
}

-(void)getChannelList
{
    NSString *url = [NSString stringWithFormat:@"http://www.douban.com/j/app/radio/channels"];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:url]];
    NSURLResponse *response = nil;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
    if (responseData)
    {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:nil];
        [_delegate channelList:dic];
    }
}
@end
