//
//  WatchView.m
//  Watch
//
//  Created by jam on 17/7/28.
//  Copyright © 2017年 jam. All rights reserved.
//

#import "WatchView.h"

@implementation WatchView
{
    UIView* hourBg;
    UIView* minuBg;
    UIView* secoBg;
    UIView* dotBg;
    
    UILabel* dayLab;
    UILabel* weeLab;
    
    NSTimer* timer;
}

+(instancetype)defaultWatch
{
    return [self defaultWatchWithSize:CGSizeMake(200, 200)];
}

+(instancetype)defaultWatchWithSize:(CGSize)size
{
    WatchView* w=[[WatchView alloc]initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    w.backgroundColor=[UIColor whiteColor];
    [w configureScales];
    [w configurePointers];
    w.layer.cornerRadius=w.frame.size.height/2;
    w.layer.shouldRasterize=YES;
    w.layer.rasterizationScale = [[UIScreen mainScreen] scale];
    return w;
}

-(void)startRunning{
    [timer setFireDate:[NSDate date]];
}

-(void)stopRunning{
    [timer setFireDate:[NSDate distantFuture]];
}

-(void)configureScales
{
    UIView * watchBG=self;
    CGFloat w=watchBG.frame.size.width;
    CGFloat h=watchBG.frame.size.height;
    
    CGPoint center=CGPointMake(w/2, h/2);
    CGSize sizeHour=CGSizeMake(2, 20);
    CGSize sizeMinu=CGSizeMake(0.5, 6);
    UIColor* color=[UIColor blackColor];
    
    CGFloat rh=h/2-sizeHour.height/2-4;
    CGFloat rm=h/2-sizeMinu.height/2-4;
    
    for (int i=0; i<12; i++) {
        CGFloat rotation=i/12.0*M_PI*2;
        CGFloat cx=center.x+rh*sin(rotation);
        CGFloat cy=center.y-rh*cos(rotation);
        CGPoint scent=CGPointMake(cx, cy);
        
        UIView* scale=[self createScaleCenter:scent size:sizeHour color:color rotation:rotation number:-1];
        [watchBG addSubview:scale];
    }
    
    for (int i=0; i<60; i++) {
        CGFloat rotation=i/60.0*M_PI*2;
        CGFloat cx=center.x+rm*sin(rotation);
        CGFloat cy=center.y-rm*cos(rotation);
        CGPoint scent=CGPointMake(cx, cy);
        
        UIView* scale=[self createScaleCenter:scent size:sizeMinu color:color rotation:rotation number:-1];
        [watchBG addSubview:scale];
    }
}

-(void)configureCalendar
{
    
}

-(void)configurePointers
{
    UIView * watchBG=self;
    CGFloat w=watchBG.frame.size.width;
    CGFloat h=watchBG.frame.size.height;
    
    CGPoint center=CGPointMake(w/2, h/2);
    
    hourBg=[self createPointerCenter:center size:CGSizeMake(4, h*0.5) color:[UIColor colorWithWhite:0 alpha:1]];
    [watchBG addSubview:hourBg];
    
    minuBg=[self createPointerCenter:center size:CGSizeMake(4, h*0.7) color:[UIColor colorWithWhite:0 alpha:1]];
    [watchBG addSubview:minuBg];
    
    secoBg=[self createPointerCenter:center size:CGSizeMake(1, h*0.8) color:[UIColor redColor]];
    [watchBG addSubview:secoBg];
    
    dotBg=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 1, 1)];
    dotBg.center=center;
    dotBg.backgroundColor=[UIColor lightGrayColor];
    [watchBG addSubview:dotBg];
    
    timer=[NSTimer scheduledTimerWithTimeInterval:0.02 target:self selector:@selector(watchRunning) userInfo:nil repeats:YES];
}


-(UIView*)createScaleCenter:(CGPoint)center size:(CGSize)size color:(UIColor*)color rotation:(CGFloat)rotation number:(NSInteger)number
{
    if(number==0)
    {
        number=12;
    }
    UILabel* sc=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    sc.backgroundColor=color;
    sc.center=center;
    
    if (number>=0) {
        sc.text=[NSString stringWithFormat:@"%d",(int)number];
        sc.textColor=[UIColor blueColor];
        sc.textAlignment=NSTextAlignmentCenter;
        sc.font=[UIFont systemFontOfSize:12];
    }
    else
    {
        sc.transform=CGAffineTransformMakeRotation(rotation);
    }
    
    return sc;
}

//-(UILabel*)createWeekDaySize

-(UIView*)createPointerCenter:(CGPoint)center size:(CGSize)size color:(UIColor*)color
{
    UIView* bg=[[UIView alloc]initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    bg.center=center;
    
    UIView* rou=[[UIView alloc]initWithFrame:CGRectMake(0, 0, size.width+4, size.width+4)];
    rou.center=CGPointMake(size.width/2, size.height/2);
    rou.backgroundColor=color;
    rou.layer.cornerRadius=rou.frame.size.width/2;
    [bg addSubview:rou];
    
    UIView* pointer=[[UIView alloc]initWithFrame:CGRectMake(0, 0, bg.frame.size.width, bg.frame.size.height*0.6)];
    pointer.backgroundColor=color;
    [bg addSubview:pointer];
    
    return bg;
}

-(void)watchRunning
{
    NSDate *now = [NSDate date];
    //    NSLog(@"now date is: %@", now);
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:now];
    
    double timeInterval=now.timeIntervalSince1970;
    
    NSInteger year = [dateComponent year];
    NSInteger month =  [dateComponent month];
    NSInteger day = [dateComponent day];
    NSInteger hour =  [dateComponent hour];
    NSInteger minute =  [dateComponent minute];
    NSInteger second = [dateComponent second];
    
    CGFloat secs=second+timeInterval-(NSInteger)timeInterval;
    secoBg.transform=CGAffineTransformMakeRotation(secs/60.0*M_PI*2);
    
    CGFloat mins=minute+secs/60.0;
    minuBg.transform=CGAffineTransformMakeRotation(mins/60.0*M_PI*2);
    
    CGFloat hous=hour+mins/60.0;
    hourBg.transform=CGAffineTransformMakeRotation(hous/12.0*M_PI*2);
}

@end
