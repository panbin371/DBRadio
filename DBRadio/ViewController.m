//
//  ViewController.m
//  DBRadio
//
//  Created by pan on 14/12/4.
//  Copyright (c) 2014年 pan. All rights reserved.
//

#import "ViewController.h"
#import "manager.h"
#import "ListViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *musicImage;
@property (weak, nonatomic) IBOutlet UITableView *musicTableView;
@property (weak, nonatomic) IBOutlet UIProgressView *progress;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) NSTimer *musicTime;
@property (strong, nonatomic)manager *managers;
@property (strong, nonatomic)NSMutableArray *musicInfo;
@property (strong, nonatomic)AVAudioPlayer *player;
@property (assign, nonatomic)NSIndexPath *musicRow;
@property (strong, nonatomic)NSDictionary *musicDic;
@end

@implementation ViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    _managers.channel = [[NSUserDefaults standardUserDefaults] objectForKey:@"channel"];
    [_managers getMusicList];
    _musicDic = [_musicInfo objectAtIndex:0];
    _musicImage.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[_musicDic objectForKey:@"picture"]]]];
    
    _musicTime = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(time) userInfo:nil repeats:YES];
    self.progress.progress = 0;
    [self performSelectorInBackground:@selector(task) withObject:nil];
//    dispatch_async(getDataQueue,^{
//        //获取数据,获得一组后,刷新UI.
//        dispatch_aysnc (mainQueue, ^{
//            //UI的更新需在主线程中进行
//        });
//    });

    
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = YES;
    if (_managers == nil)
    {
        _managers = [[manager alloc]init];
        _managers.channel = @"0";
    }
    _managers.delegate = self;

    _musicTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)task
{
    [_managers downloadMusic:[_musicDic objectForKey:@"url"]];
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
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSDictionary *musicDic = [_musicInfo objectAtIndex:indexPath.row];
    cell.textLabel.text = [musicDic objectForKey:@"title"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _musicRow = indexPath;
    _musicDic = [_musicInfo objectAtIndex:indexPath.row];
    _musicImage.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[_musicDic objectForKey:@"picture"]]]];
    
    _musicTime = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(time) userInfo:nil repeats:YES];
    self.progress.progress = 0;
    [self.player stop];
    [self performSelectorInBackground:@selector(task) withObject:nil];

}

-(void)musicInfo:(NSDictionary *)dic
{
    _musicInfo = [dic objectForKey:@"song"];
    [_musicTableView reloadData];
}

-(void)music:(NSData *)data
{
    AVAudioPlayer *player = [[AVAudioPlayer alloc]initWithData:data error:nil];
    _player = player;
    [_player prepareToPlay];
    _player.delegate = self;
//    self.player.numberOfLoops = -1;
    [_player play];
}

- (IBAction)stopOrPlay:(id)sender
{
    if (self.player.playing)
    {
        [self.player pause];
    }
    else
    {
        [self.player play];
    }
}

- (IBAction)changeList:(id)sender
{
    [_player stop];
//    
//    ListViewController *list = [[ListViewController alloc]init];
//    [self.navigationController pushViewController:list animated:YES];
}

-(void)time
{
    NSTimeInterval totalTimer = self.player.duration;
    NSTimeInterval currentTime = self.player.currentTime;
    self.progress.progress = (currentTime/totalTimer);
    
    NSTimeInterval totalmin = (int)totalTimer/60;
    NSTimeInterval totals = (int)totalTimer%60;
    
    NSTimeInterval currentmin = (int)currentTime/60;
    NSTimeInterval currents = (int)currentTime%60;
    
    NSString *time = [NSString stringWithFormat:@"%02.0f:%02.0f/%02.0f:%02.0f",currentmin,currents,totalmin,totals];
    self.timeLabel.text = time;
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    NSLog(@"%d",flag);
    if (flag && _musicRow.row < [_musicInfo count] - 1)//播放下一首
    {
        NSIndexPath *index = [NSIndexPath indexPathForRow:_musicRow.row+1 inSection:_musicRow.section];
        [_musicTableView selectRowAtIndexPath:index animated:NO scrollPosition:UITableViewScrollPositionNone];
        [self tableView:_musicTableView didSelectRowAtIndexPath:index];
    }
}

@end
