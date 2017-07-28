//
//  WatchView.h
//  Watch
//
//  Created by jam on 17/7/28.
//  Copyright © 2017年 jam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WatchView : UIView

+(instancetype)defaultWatch;

+(instancetype)defaultWatchWithSize:(CGSize)size;

-(void)startRunning;
-(void)stopRunning;

@end
