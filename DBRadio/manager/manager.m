//
//  manager.m
//  DBRadio
//
//  Created by pan on 14/12/4.
//  Copyright (c) 2014年 pan. All rights reserved.
//

#import "manager.h"

@implementation manager

- (void)getMusicList
{
    NSString *url = [self getMusicUrl];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"GET"];
    NSHTTPURLResponse *response = nil;
    NSError *error = [[NSError alloc]init];
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:&error];    
    [_delegate musicInfo:dic];
}

-(void)downloadMusic:(NSString *)url
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:url]];
    NSURLResponse *response = nil;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
    [_delegate music:responseData];
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
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:nil];
    [_delegate channelList:dic];
}
@end
