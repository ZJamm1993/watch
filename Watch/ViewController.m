//
//  ViewController.m
//  Watch
//
//  Created by jam on 17/7/28.
//  Copyright © 2017年 jam. All rights reserved.
//

#import "ViewController.h"
#import "WatchView.h"

@interface ViewController ()
{
    WatchView* watch;
}
@property (weak, nonatomic) IBOutlet UIView *watchBg;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor blackColor];
    
    watch=[WatchView defaultWatchWithSize:self.watchBg.frame.size];
    watch.frame=self.watchBg.bounds;
    [self.watchBg addSubview:watch];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [watch startRunning];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [watch stopRunning];
}

@end
