//
//  ListViewController.m
//  DBRadio
//
//  Created by pan on 14/12/5.
//  Copyright (c) 2014年 pan. All rights reserved.
//

#import "ListViewController.h"

@interface ListViewController ()
@property (weak, nonatomic) IBOutlet UITableView *ListTableView;
@property (strong, nonatomic)manager *managers;
@property (strong, nonatomic)NSArray *ListArray;
@end

@implementation ListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [manager sharedManager].delegate = self;
    [[manager sharedManager] getChannelList];
    // Do any additional setup after loading the view.
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
    return [_ListArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"channelListCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    NSDictionary *channel = [_ListArray objectAtIndex:indexPath.row];
    cell.textLabel.text = [channel objectForKey:@"name"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *channelDic = [_ListArray objectAtIndex:indexPath.row];
    NSString *channel = [NSString stringWithFormat:@"%@",[channelDic objectForKey:@"channel_id"]];
    [manager sharedManager].channel = channel;
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)channelList:(NSDictionary *)dic
{
    _ListArray = [NSArray arrayWithArray:[dic objectForKey:@"channels"]];
    [_ListTableView reloadData];
}

@end
