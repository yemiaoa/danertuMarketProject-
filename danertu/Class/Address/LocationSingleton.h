//
//  DetailViewController.h
//  Tuan
//
//  Created by 夏 华 on 12-7-4.
//  Copyright (c) 2012年 无锡恩梯梯数据有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface LocationSingleton : NSObject<CLLocationManagerDelegate>
@property (strong, nonatomic) CLLocationManager* locationmanager;
@property (strong, nonatomic) NSMutableDictionary *pos;
@property (strong, nonatomic) NSDictionary *cityFromPos;

+(LocationSingleton*) sharedInstance ;

-(void)stopLocation;

-(void)startLocation;

@end
