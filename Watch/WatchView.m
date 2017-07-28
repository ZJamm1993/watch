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
    
    UIColor* plateColor;
    UIColor* scaleColor;
    UIColor* pointerColor;
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
    [self configureColors];
    [self configurePlate];
    [self configureBrand];
    [self configureScales];
//    [self configureCalendar];
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

-(void)configureColors
{
    plateColor=[UIColor colorWithRed:211/255.0 green:211/255.0 blue:197/255.0 alpha:1];
    scaleColor=[UIColor colorWithRed:55/255.0 green:52/255.0 blue:49/255.0 alpha:1];
    pointerColor=[UIColor colorWithRed:55/255.0 green:52/255.0 blue:49/255.0 alpha:1];
}

-(void)configurePlate
{
    plateBg=[[UIView alloc]initWithFrame:self.bounds];
    plateBg.layer.cornerRadius=plateBg.frame.size.height/2;
    plateBg.backgroundColor=plateColor;
    
    [self addSubview:plateBg];
}

-(void)dealloc
{
    [timer invalidate];
}

-(void)configureScales
{
    UIView * watchBG=self;
    CGFloat w=watchBG.frame.size.width;
    CGFloat h=watchBG.frame.size.height;
    
    CGPoint center=CGPointMake(w/2, h/2);
    CGSize sizeHour=CGSizeMake(2, 16);
    CGSize sizeMinu=CGSizeMake(0.5, 9);
    
    UIColor* color=scaleColor;
    
    CGFloat rh=h/2-sizeHour.height/2-4;
    CGFloat rm=h/2-sizeMinu.height/2-4;
    
    for (int i=0; i<12; i++) {
        CGFloat rotation=i/12.0*M_PI*2;
        CGFloat cx=center.x+rh*sin(rotation);
        CGFloat cy=center.y-rh*cos(rotation);
        CGPoint scent=CGPointMake(cx, cy);
        
        NSString* num=[NSString stringWithFormat:@"%d",(int)i];
        if (i==0) {
            num=@"12";
        }
        
        UIView* scale=[self createScaleCenter:scent size:sizeHour color:color rotation:rotation title:num];
        [watchBG addSubview:scale];
    }
    
    for (int i=0; i<60; i++) {
        CGFloat rotation=i/60.0*M_PI*2;
        CGFloat cx=center.x+rm*sin(rotation);
        CGFloat cy=center.y-rm*cos(rotation);
        CGPoint scent=CGPointMake(cx, cy);
        
        UIView* scale=[self createScaleCenter:scent size:sizeMinu color:color rotation:rotation title:@""];
        [watchBG addSubview:scale];
    }
}

-(void)configureBrand
{
    UIView * watchBG=self;
    CGFloat w=watchBG.frame.size.width;
    CGFloat h=watchBG.frame.size.height/2;
    
    CGFloat ttw=60;
    CGFloat tth=11;
    
    CGFloat offy=7;
    
    UILabel* title=[[UILabel alloc]initWithFrame:CGRectMake(w/2-ttw/2, h/2-tth+offy, ttw, tth)];
    title.text=@"SEIKO";
    title.textAlignment=NSTextAlignmentCenter;
    title.textColor=scaleColor;
    title.font=[UIFont systemFontOfSize:11];
    [self addSubview:title];
    
    UILabel* detail=[[UILabel alloc]initWithFrame:CGRectMake(w/2-ttw/2, h/2+offy, ttw, tth)];
    detail.text=@"QUARTZ";
    detail.textAlignment=NSTextAlignmentCenter;
    detail.textColor=scaleColor;
    detail.font=[UIFont systemFontOfSize:8];
    [self addSubview:detail];
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
    
    CGFloat h_2=h/2;
    
    hourBg=[self createPointerCenter:center size:CGSizeMake(8, h_2*0.6) color:pointerColor tailSize:CGSizeZero];
    [watchBG addSubview:hourBg];
    
    minuBg=[self createPointerCenter:center size:CGSizeMake(3, h_2*0.83) color:pointerColor tailSize:CGSizeZero];
    [watchBG addSubview:minuBg];
    
    secoBg=[self createPointerCenter:center size:CGSizeMake(1, h_2*0.7) color:pointerColor tailSize:CGSizeMake(2, h_2*0.3)];
    [watchBG addSubview:secoBg];
    
    dotBg=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 1, 1)];
    dotBg.center=center;
    dotBg.backgroundColor=[UIColor blackColor];
    [watchBG addSubview:dotBg];
    
    timer=[NSTimer scheduledTimerWithTimeInterval:0.02 target:self selector:@selector(watchRunning) userInfo:nil repeats:YES];
}


-(UIView*)createScaleCenter:(CGPoint)center size:(CGSize)size color:(UIColor*)color rotation:(CGFloat)rotation title:(NSString*)title
{
    UIView* sc=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    
    sc.backgroundColor=color;
    sc.transform=CGAffineTransformMakeRotation(rotation);
    sc.center=center;

    if (title.length>0) {
        UILabel* lab=[[UILabel alloc]initWithFrame:CGRectMake(0, size.height, 30, 20)];
        lab.center=CGPointMake(size.width/2, lab.center.y);
        lab.textColor=color;
        lab.text=title;
        lab.textAlignment=NSTextAlignmentCenter;
        lab.font=[UIFont boldSystemFontOfSize:16];
        [sc addSubview:lab];
        
        lab.transform=CGAffineTransformMakeRotation(-rotation);
    }
    
    return sc;
}

-(UIView*)createPointerCenter:(CGPoint)center size:(CGSize)size color:(UIColor*)color tailSize:(CGSize)tailSize
{
    UIView* bg=[[UIView alloc]initWithFrame:CGRectMake(0, 0, size.width, size.height*2)];
    bg.layer.shouldRasterize=YES;
    bg.layer.rasterizationScale = [[UIScreen mainScreen] scale];
    bg.center=center;
    
    UIView* pointer=[[UIView alloc]initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    pointer.backgroundColor=color;
    pointer.layer.cornerRadius=size.width/2;
    [bg addSubview:pointer];
    
    UIView* tail=[[UIView alloc]initWithFrame:CGRectMake(size.width*0.5-tailSize.width*0.5, size.height, tailSize.width, tailSize.height)];
    tail.backgroundColor=color;
    tail.layer.cornerRadius=tailSize.width/2;
    [bg addSubview:tail];
    
    UIView* rou=[[UIView alloc]initWithFrame:CGRectMake(0, 0, size.width+5, size.width+5)];
    rou.center=CGPointMake(size.width/2, size.height);
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
