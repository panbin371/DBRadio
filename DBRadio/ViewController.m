//
//  ViewController.m
//  DBRadio
//
//  Created by pan on 14/12/4.
//  Copyright (c) 2014年 pan. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *musicImage;
@property (weak, nonatomic) IBOutlet UITableView *musicTableView;
@property (weak, nonatomic) IBOutlet UIProgressView *progress;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
//@property (weak, nonatomic) NSTimer *musicTime;
@property (strong, nonatomic)manager *managers;
@property (strong, nonatomic)NSMutableArray *musicInfo;
@property (assign, nonatomic)NSIndexPath *musicRow;
@property (strong, nonatomic)NSDictionary *musicDic;
@end

@implementation ViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [manager sharedManager].delegate = self;
    [[manager sharedManager] getMusicList];
//    _musicDic = [_musicInfo objectAtIndex:0];
    
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//       
//        UIImage *img = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[_musicDic objectForKey:@"picture"]]]];
//        
//        dispatch_async(dispatch_get_main_queue(), ^{
//            _musicImage.image = img;
//        });
//    });

//    _musicImage.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[_musicDic objectForKey:@"picture"]]]];
    
//    [self performSelectorInBackground:@selector(downLoadImg) withObject:nil];
    
//    NSThread *thread = [[NSThread alloc]initWithTarget:self selector:@selector(downLoadImg) object:nil];
//    [thread start];
    
//    NSInvocationOperation *opera = [[NSInvocationOperation alloc]initWithTarget:self selector:@selector(downLoadImg) object:nil];
//    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
//    [queue addOperation:opera];
//    
//    self.progress.progress = 0;
    
//    NSIndexPath *index = [NSIndexPath indexPathForRow:0 inSection:0];
//    [_musicTableView selectRowAtIndexPath:index animated:NO scrollPosition:UITableViewScrollPositionNone];
//    [self tableView:_musicTableView didSelectRowAtIndexPath:index];
}

- (void)downLoadImg
{
    UIImage *img = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[_musicDic objectForKey:@"picture"]]]];
    
    [self performSelectorOnMainThread:@selector(refreshImg:) withObject:img waitUntilDone:NO];
}

- (void)refreshImg:(UIImage *)img
{
    _musicImage.image = img;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = YES;

    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_musicInfo count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"musicCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSDictionary *musicDic = [_musicInfo objectAtIndex:indexPath.row];
    cell.textLabel.text = [musicDic objectForKey:@"title"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath == _musicRow)
    {
        return;
    }
    _musicRow = indexPath;
    _musicDic = [_musicInfo objectAtIndex:indexPath.row];
//    _musicImage.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[_musicDic objectForKey:@"picture"]]]];
    [self performSelectorInBackground:@selector(downLoadImg) withObject:nil];
//    _musicTime = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(time) userInfo:nil repeats:YES];
    self.progress.progress = 0;
    [[PlayMusic sharedPlay].player stop];
    [PlayMusic sharedPlay].delegate = self;
    
//    dispatch_queue_t serialQueue = dispatch_queue_create("MusicQueue", NULL);
//    dispatch_async(serialQueue,^{
//        //获取数据,获得一组后,刷新UI.
//        [[manager sharedManager] downloadMusic:[_musicDic objectForKey:@"url"]];
////        dispatch_async(dispatch_get_main_queue(), ^{
////            //UI的更新需在主线程中进行
////        });
//    });
//    [self performSelectorInBackground:@selector(downLoadMic) withObject:nil];
    [NSThread detachNewThreadSelector:@selector(downLoadMic) toTarget:self withObject:nil];
}

- (void)downLoadMic
{
    [[manager sharedManager] downloadMusic:[_musicDic objectForKey:@"url"]];
}

-(void)musicInfo:(NSDictionary *)dic
{
    _musicInfo = [dic objectForKey:@"song"];
    [_musicTableView reloadData];
    _musicDic = [_musicInfo objectAtIndex:0];
    [self performSelectorInBackground:@selector(downLoadImg) withObject:nil];
    [manager sharedManager].delegate = [PlayMusic sharedPlay];
    NSIndexPath *index = [NSIndexPath indexPathForRow:0 inSection:0];
    [_musicTableView selectRowAtIndexPath:index animated:NO scrollPosition:UITableViewScrollPositionNone];
    [self tableView:_musicTableView didSelectRowAtIndexPath:index];
    _musicRow = nil;
}

- (IBAction)stopOrPlay:(id)sender
{
    if ([PlayMusic sharedPlay].player.playing)
    {
        [[PlayMusic sharedPlay].player pause];
    }
    else
    {
        [[PlayMusic sharedPlay].player play];
    }
}

- (IBAction)changeList:(id)sender
{
    [[PlayMusic sharedPlay].player stop];
}

-(void)timeChanged:(NSString *)time persent:(float)persent
{
    self.progress.progress = persent;
    self.timeLabel.text = time;
}

- (void)nextMusic
{
    if (_musicRow.row < [_musicInfo count] - 1)//播放下一首
    {
        NSIndexPath *index = [NSIndexPath indexPathForRow:_musicRow.row+1 inSection:_musicRow.section];
        [_musicTableView selectRowAtIndexPath:index animated:NO scrollPosition:UITableViewScrollPositionNone];
        [self tableView:_musicTableView didSelectRowAtIndexPath:index];
    }
}

@end
