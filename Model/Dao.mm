//
//  Dao.m
//  huobao
//
//  Created by Tony He on 14-5-13.
//  Copyright (c) 2014年 何 栋明. All rights reserved.
//

#import "Dao.h"
#import "Reachability.h"

static Dao* sharedDaoer;

@implementation Dao
@synthesize reachbility;


//外网
//NSString *baseUrl = @"http://115.28.18.130/SEMBAWEBDEVELOP/api/";

+(id)sharedDao{
    if(sharedDaoer == nil){
        sharedDaoer = [[Dao alloc] init];
        [sharedDaoer isNetWorkAvalible];
        [sharedDaoer initNetworkStateObserver];
//        sharedDaoer.isFirstLoadHomePage = YES;
    }
    return sharedDaoer;
}

-(void)initNetworkStateObserver{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reachabilityChanged:)
                                                 name:kReachabilityChangedNotification
                                               object:nil];
    
    Reachability * reach = [Reachability reachabilityForInternetConnection];
    
    switch ([reach currentReachabilityStatus]) {
        case NotReachable:
        {
            self.reachbility = NO;
            break;
        }
        case ReachableViaWWAN:
            self.reachbility = YES;
            break;
        case ReachableViaWiFi:
            self.reachbility = YES;
            break;
    }
    
    reach.reachableBlock = ^(Reachability * reachability)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            //blockLabel.text = @"Block Says Reachable";
            self.reachbility = YES;
        });
    };
    
    reach.unreachableBlock = ^(Reachability * reachability)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.reachbility = NO;
            //blockLabel.text = @"Block Says Unreachable";
        });
    };
    
    [reach startNotifier];
}

-(void)reachabilityChanged:(NSNotification*)note
{
    Reachability * reach = [note object];
    
    if([reach isReachable])
    {
        //有网
        //notificationLabel.text = @"Notification Says Reachable";
        reachbility = YES;
    }
    else
    {
        reachbility = NO;
        //断网
        //notificationLabel.text = @"Notification Says Unreachable";
    }
}

-(void)isNetWorkAvalible
{
    Reachability *reach = [Reachability reachabilityForInternetConnection];
    if([reach isReachable])
    {
        reachbility = YES;
    }
    else
    {
        reachbility = NO;
    }
}


@end
