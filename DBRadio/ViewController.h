//
//  ViewController.h
//  DBRadio
//
//  Created by pan on 14/12/4.
//  Copyright (c) 2014年 pan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "manager.h"
#import <AVFoundation/AVFoundation.h>

@interface ViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,managerDelegate,AVAudioPlayerDelegate>


@end

