//
//  WebViewController.h
//  Tuan
//
//  Created by 夏 华 on 12-7-6.
//  Copyright (c) 2012年 无锡恩梯梯数据有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "UIView+Toast.h"
#import "AFHTTPClient.h"
#import "AFJSONRequestOperation.h"
#import "UIDevice+IdentifierAddition.h"

@interface GameBlareController : HeBaseViewController<AVAudioRecorderDelegate>
{
    AVAudioRecorder *recorder;
    NSTimer *timer;
    NSURL *urlPlay;
}
@property (nonatomic, strong) NSUserDefaults *defaults;//本地化存储
@property (nonatomic, strong)UIImageView *backHomeIcon;
@property (nonatomic, strong)UIImageView *imageView;
@property (nonatomic, strong)UIView *contentView;
@property (nonatomic, strong)UILabel *topNaviText;
@property (nonatomic, strong)UILabel *scoreValue;
@property (nonatomic, strong)NSString *flagFromNotification ;
@property (nonatomic, strong)NSString *shopId;
@property (nonatomic) int addStatusBarHeight;
@property (nonatomic) int gameScore;
@end
