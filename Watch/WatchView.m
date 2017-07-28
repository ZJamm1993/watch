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
    UIView* plateBg;
    
    UIView* hourBg;
    UIView* minuBg;
    UIView* secoBg;
    UIView* dotBg;
    
    
    NSArray* weekStr;
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
    size.width=200;
    size.height=200;
    WatchView* w=[[WatchView alloc]initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    [w defaultConfigure];
    return w;
}

-(void)defaultConfigure
{
    [self configurePlate];
    [self configureScales];
    [self configureCalendar];
    [self configurePointers];
    self.layer.shouldRasterize=YES;
    self.layer.rasterizationScale = [[UIScreen mainScreen] scale];
    [self watchRunning];
}

-(void)startRunning{
    [timer setFireDate:[NSDate date]];
}

-(void)stopRunning{
    [timer setFireDate:[NSDate distantFuture]];
}

-(void)configurePlate
{
    plateBg=[[UIView alloc]initWithFrame:self.bounds];
    plateBg.layer.cornerRadius=plateBg.frame.size.height/2;
    plateBg.backgroundColor=[UIColor colorWithRed:0.1 green:0.3 blue:0.8 alpha:1];
    
    [self addSubview:plateBg];
}

-(void)configureScales
{
    UIView * watchBG=self;
    CGFloat w=watchBG.frame.size.width;
    CGFloat h=watchBG.frame.size.height;
    
    CGPoint center=CGPointMake(w/2, h/2);
    CGSize sizeHour=CGSizeMake(2, 20);
//    CGSize sizeMinu=CGSizeMake(0.5, 6);
    
    UIColor* color=[UIColor greenColor];
    
    CGFloat rh=h/2-sizeHour.height/2-4;
//    CGFloat rm=h/2-sizeMinu.height/2-4;
    
    for (int i=0; i<12; i++) {
        CGFloat rotation=i/12.0*M_PI*2;
        CGFloat cx=center.x+rh*sin(rotation);
        CGFloat cy=center.y-rh*cos(rotation);
        CGPoint scent=CGPointMake(cx, cy);
        
        UIView* scale=[self createScaleCenter:scent size:sizeHour color:color rotation:rotation title:@""];
        [watchBG addSubview:scale];
    }
    
//    for (int i=0; i<60; i++) {
//        CGFloat rotation=i/60.0*M_PI*2;
//        CGFloat cx=center.x+rm*sin(rotation);
//        CGFloat cy=center.y-rm*cos(rotation);
//        CGPoint scent=CGPointMake(cx, cy);
//        
//        UIView* scale=[self createScaleCenter:scent size:sizeMinu color:color rotation:rotation title:@""];
//        [watchBG addSubview:scale];
//    }
}

-(void)configureCalendar
{
    UIView * watchBG=self;
    CGFloat w=watchBG.frame.size.width;
    CGFloat h=watchBG.frame.size.height;
    
    UIColor * bgColor=[UIColor greenColor];
    UIColor * textColor=[UIColor blackColor];
    
    weekStr=@[@"SUN",@"MON",@"TUE",@"WED",@"THU",@"FRI",@"SAT"];
    
    CGPoint center=CGPointMake(w/2, h/2);
    
    CGFloat ch=14;
    
    CGFloat cdw=20;
    CGFloat cww=32;
    
    dayLab=[[UILabel alloc]initWithFrame:CGRectMake(w-20-cdw, center.y-ch/2, cdw, ch)];
    dayLab.textColor=textColor;
    dayLab.backgroundColor=bgColor;
    dayLab.font=[UIFont systemFontOfSize:13];
    dayLab.textAlignment=NSTextAlignmentCenter;
    [watchBG addSubview:dayLab];
    
    weeLab=[[UILabel alloc]initWithFrame:CGRectMake(dayLab.frame.origin.x-cww, center.y-ch/2, cww, ch)];
    weeLab.textColor=textColor;
    weeLab.backgroundColor=bgColor;
    weeLab.font=[UIFont systemFontOfSize:13];
    weeLab.textAlignment=NSTextAlignmentCenter;
    [watchBG addSubview:weeLab];
}

-(void)configurePointers
{
    UIView * watchBG=self;
    CGFloat w=watchBG.frame.size.width;
    CGFloat h=watchBG.frame.size.height;
    
    CGPoint center=CGPointMake(w/2, h/2);
    
    hourBg=[self createPointerCenter:center size:CGSizeMake(5, h*0.5) color:[UIColor whiteColor]];
    [watchBG addSubview:hourBg];
    
    minuBg=[self createPointerCenter:center size:CGSizeMake(5, h*0.7) color:[UIColor whiteColor]];
    [watchBG addSubview:minuBg];
    
    secoBg=[self createPointerCenter:center size:CGSizeMake(1, h*0.8) color:[UIColor greenColor]];
    [watchBG addSubview:secoBg];
    
    dotBg=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 1, 1)];
    dotBg.center=center;
    dotBg.backgroundColor=[UIColor lightGrayColor];
    [watchBG addSubview:dotBg];
    
    timer=[NSTimer scheduledTimerWithTimeInterval:0.02 target:self selector:@selector(watchRunning) userInfo:nil repeats:YES];
}


-(UIView*)createScaleCenter:(CGPoint)center size:(CGSize)size color:(UIColor*)color rotation:(CGFloat)rotation title:(NSString*)title
{
    UILabel* sc=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    
//    if (title.length>0) {
//        sc.text=title;
//        sc.textColor=color;
//        sc.textAlignment=NSTextAlignmentCenter;
//        sc.font=[UIFont systemFontOfSize:14];
//        sc.frame=CGRectMake(0, 0, 30, 30);
//    }
//    else
//    {
        sc.backgroundColor=color;
        sc.transform=CGAffineTransformMakeRotation(rotation);
//    }
    
    sc.center=center;
    
    return sc;
}

-(UIView*)createPointerCenter:(CGPoint)center size:(CGSize)size color:(UIColor*)color
{
    UIView* bg=[[UIView alloc]initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    
    bg.layer.shouldRasterize=YES;
    bg.layer.rasterizationScale = [[UIScreen mainScreen] scale];
    bg.center=center;
    
    
    
    UIView* pointer=[[UIView alloc]initWithFrame:CGRectMake(0, 0, bg.frame.size.width, bg.frame.size.height*0.6)];
    pointer.backgroundColor=color;
    if (size.width>1) {
        pointer.layer.borderColor=[UIColor grayColor].CGColor;
        pointer.layer.borderWidth=0.5;
    }
    [bg addSubview:pointer];
    
    UIView* rou=[[UIView alloc]initWithFrame:CGRectMake(0, 0, size.width+4, size.width+4)];
    rou.center=CGPointMake(size.width/2, size.height/2);
    rou.backgroundColor=color;
    rou.layer.cornerRadius=rou.frame.size.width/2;
    [bg addSubview:rou];
    
    return bg;
}

-(void)watchRunning
{
    NSDate *now = [NSDate date];
    //    NSLog(@"now date is: %@", now);
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond | NSCalendarUnitWeekday;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:now];
    
    double timeInterval=now.timeIntervalSince1970;
    
//    NSInteger year = [dateComponent year];
//    NSInteger month =  [dateComponent month];
    NSInteger day = [dateComponent day];
    NSInteger hour =  [dateComponent hour];
    NSInteger minute =  [dateComponent minute];
    NSInteger second = [dateComponent second];
    NSInteger weekk= [dateComponent weekday]-1;
    
    CGFloat secs=second+timeInterval-(NSInteger)timeInterval;
    secoBg.transform=CGAffineTransformMakeRotation(secs/60.0*M_PI*2);
    
    CGFloat mins=minute+secs/60.0;
    minuBg.transform=CGAffineTransformMakeRotation(mins/60.0*M_PI*2);
    
    CGFloat hous=hour+mins/60.0;
    hourBg.transform=CGAffineTransformMakeRotation(hous/12.0*M_PI*2);
    
    dayLab.text=[NSString stringWithFormat:@"%d",(int)day];

    if (weekk>=0&&weekk<weekStr.count) {
        weeLab.text=[weekStr objectAtIndex:weekk];
    }
}

@end
