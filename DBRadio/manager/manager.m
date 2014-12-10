//
//  manager.m
//  DBRadio
//
//  Created by pan on 14/12/4.
//  Copyright (c) 2014年 pan. All rights reserved.
//

#import "manager.h"
#import "AFHTTPRequestOperation.h"
#import "AFHTTPRequestOperationManager.h"
#import "PlayMusic.h"
#import "FMDatabase.h"

#define KFileName @"data.sqlite3"

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
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSData *data = [[NSData alloc]initWithData:[operation.responseString dataUsingEncoding:NSUTF8StringEncoding]];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        [_delegate musicInfo:dic];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    [operation start];
//    [request setHTTPMethod:@"GET"];
//    NSHTTPURLResponse *response = nil;
//    NSError *error = [[NSError alloc]init];
//    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
//    if (responseData)
//    {
//        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:&error];
//        [_delegate musicInfo:dic];
//    }
}

-(void)downloadMusic:(NSString *)url
{
    NSString *requestUrl = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:requestUrl]];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Success: %@", operation.response);
        if (_delegate == [PlayMusic sharedPlay]) {
            [_delegate music:operation.responseData];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"faile:%@",operation.responseString);
    }];
    [operation start];
//    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
//    [NSURLConnection sendAsynchronousRequest:request
//                                       queue:queue
//                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error){
//                               if (error) {
//                                   NSLog(@"Httperror:%@%ld", error.localizedDescription,(long)error.code);
//                               }else{
//                                   NSInteger responseCode = [(NSHTTPURLResponse *)response statusCode];
//                                   NSLog(@"HttpResponseCode:%ld", (long)responseCode);
//                                   [_delegate music:data];
//                               }
//                           }];
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
    AFHTTPRequestOperation *opreation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    [opreation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"success:%@",opreation.responseString);
        NSString *str = [NSString stringWithString:operation.responseString];
        NSData *data = [[NSData alloc]initWithData:[str dataUsingEncoding:NSUTF8StringEncoding]];
        NSDictionary *dic  = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        [_delegate channelList:dic];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    [opreation start];
//    NSURLResponse *response = nil;
//    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
//    if (responseData)
//    {
//        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:nil];
//        [_delegate channelList:dic];
//    }
}

- (NSString *)dataFilePath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths firstObject];
    return [documentDirectory stringByAppendingPathComponent:KFileName];
}

- (void)saveData
{
    NSString *filePath = [self dataFilePath];
    FMDatabase *db = [FMDatabase databaseWithPath:filePath];
    if (![db open]) {
        NSLog(@"Failed to open");
    }
}
@end
