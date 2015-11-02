//
//  contentViewController.m
//  Tuan
//
//  Created by 夏 华 on 12-7-6.
//  Copyright (c) 2012年 无锡恩梯梯数据有限公司. All rights reserved.
//
#import "GameBlareController.h"
@interface GameBlareController ()
@end
@implementation GameBlareController
@synthesize addStatusBarHeight;
@synthesize backHomeIcon;
@synthesize contentView;
@synthesize scoreValue;
@synthesize gameScore;
@synthesize defaults;
@synthesize topNaviText;
@synthesize flagFromNotification;
@synthesize shopId;
- (void)loadView
{
    [super loadView];
    // If you create your views manually, you MUST override this method and use it to create your views.
    // If you use Interface Builder to create your views, then you must NOT override this method.
    defaults =[NSUserDefaults standardUserDefaults];//读取本地化存储
    gameScore = 50;//游戏得分
}
- (void)viewWillAppear:(BOOL)animated {
    self.tabBarController.tabBar.hidden = YES;
}
- (void)viewWillDisappear:(BOOL)animated {
    self.tabBarController.tabBar.hidden = NO;
}
- (void)viewDidLoad
{
    NSLog(@"jborhoprtph------");
    [super viewDidLoad];
    addStatusBarHeight = STATUSBAR_HEIGHT;
    //top
    self.view.backgroundColor = [UIColor whiteColor];//--
    UIView *topNavi = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MAINSCREEN_WIDTH, 45+addStatusBarHeight)];
    topNavi.backgroundColor = [UIColor orangeColor];
    topNavi.userInteractionEnabled = YES;
    [self.view addSubview:topNavi];
    //文字
    topNaviText = [[UILabel alloc] initWithFrame:CGRectMake(0, 0+addStatusBarHeight, MAINSCREEN_WIDTH, 44)];
    topNaviText.text = @"每天吼一次,为店铺加分";
    topNaviText.font = [UIFont systemFontOfSize:18];
    topNaviText.textAlignment = NSTextAlignmentCenter;
    topNaviText.userInteractionEnabled = YES;//这样才可以点击
    topNaviText.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];
    [topNavi addSubview:topNaviText];
    //线条
    UILabel *borderLine = [[UILabel alloc] initWithFrame:CGRectMake(0, 44+addStatusBarHeight, MAINSCREEN_WIDTH, 1)];
    borderLine.backgroundColor = [UIColor orangeColor];
    [topNavi addSubview:borderLine];
    //-------导航头部
    //退回到上一页
    //----退回到上一页,temp扩大热区
    UILabel *temp = [[UILabel alloc]initWithFrame:CGRectMake(0, 0+addStatusBarHeight, 60, 44)];
    temp.userInteractionEnabled = YES;
    temp.backgroundColor = [UIColor clearColor];
    UITapGestureRecognizer *singleTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onClickBack)];
    [temp addGestureRecognizer:singleTap];//---添加点击事件
    [topNavi addSubview:temp];
    backHomeIcon = [[UIImageView alloc] initWithFrame:CGRectMake(10, 17, 15, 15)];
    [backHomeIcon setImage:[UIImage imageNamed:@"carat-d-orange"]];
    backHomeIcon.userInteractionEnabled = YES;//这样才可以点击
    [temp addSubview:backHomeIcon];
    //----得分:
    UILabel *score = [[UILabel alloc]initWithFrame:CGRectMake(260, 0+addStatusBarHeight, 60, 44)];
    score.backgroundColor = [UIColor clearColor];
    [topNavi addSubview:score];
    
    UILabel *scoreText = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 30, 44)];
    [score addSubview:scoreText];
    scoreText.backgroundColor = [UIColor clearColor];
    scoreText.font = [UIFont systemFontOfSize:12];
    scoreText.textColor = [UIColor orangeColor];
    scoreText.text = @"得分:";
    
    scoreValue = [[UILabel alloc]initWithFrame:CGRectMake(30, 0, 30, 44)];
    [score addSubview:scoreValue];
    scoreValue.backgroundColor = [UIColor clearColor];
    scoreValue.font = [UIFont systemFontOfSize:12];
    scoreValue.textColor = [UIColor redColor];
    scoreValue.text = @"0";
    //----当中图片view
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, addStatusBarHeight + 45, MAINSCREEN_WIDTH, self.view.frame.size.height-addStatusBarHeight-45)];

    [self.view addSubview:self.imageView];
    self.imageView.image = [UIImage imageNamed:@"danertu_1"];
    [self audio];//------收音机
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showTitle:) name:@"gameBlare" object:nil];//和 Favoriteview之间的
    [self showTitle];//----根据 ---defaults----的---gameBlareShopId,,,,显示-title-----
    
    //------按钮按住吼
    UIButton *navigation = [[UIButton alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height-55, MAINSCREEN_WIDTH, 55)];
    [self.view addSubview:navigation];
    navigation.backgroundColor = [UIColor clearColor];
    [navigation addTarget:self action:@selector(onHoldToBlare) forControlEvents:UIControlEventTouchDown];
    [navigation addTarget:self action:@selector(cancleBlare) forControlEvents:UIControlEventTouchUpInside];
    [navigation addTarget:self action:@selector(cancleBlare) forControlEvents:UIControlEventTouchUpOutside];
}
-(void)showTitle{
    topNaviText.text = @"每天吼一次,积攒金萝卜";
}
//-----点击返回
-(void)onClickBack{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)cancleBlare{
    
    [recorder deleteRecording];
    [recorder stop];
    [timer invalidate];
    self.imageView.image = [UIImage imageNamed:@"danertu_1"];
    if (gameScore>=50) {
        //-------为自己吼,没有shoId,需要判断,
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [Waiting show];//----loading----
            AFHTTPClient * client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:APIURL]];
            NSDictionary * params = @{@"apiid": @"0047",@"versionNo" :[[UIDevice currentDevice] uniqueDeviceIdentifier]};
            //NSDictionary * params = @{@"apiid": @"0047",@"versionNo" :@"qwe99992",@"playdate": dateString};
            NSURLRequest * request = [client requestWithMethod:@"POST"
                                                          path:@""
                                                    parameters:params];
            AFHTTPRequestOperation * operation = [client HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
                //NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
                NSString *temp = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
                //NSArray* temp = [[jsonData objectForKey:@"infoList"] objectForKey:@"infobean"];//数组
                NSLog(@"iowioewjoifjeoiwf-----------%@------%@",params,temp);
                //------如果返回false,可以提交数据
                if([temp isEqualToString:@"false"]){
                    [self addScore];//-----添加分---,这里不用隐藏loading----接下来还要显示的-----
                }else{
                    [Waiting dismiss];//---隐藏loading---
                    [self.view makeToast:@"今天已加分" duration:1.2 position:@"center"];
                }
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [Waiting dismiss];//---隐藏loading---
                NSLog(@"faild , error == %@ ", error);
                [self.view makeToast:@"网络错误,请重试" duration:1.2 position:@"center"];
            }];
            [operation start];
        });
    }else{
        [self.view makeToast:@"声音太小了,重来吧!" duration:1.2 position:@"center"];
    }
}
//-----按住吼
-(void)onHoldToBlare{
    NSLog(@"----backLogin---图片被点击!------");
//    gameScore = 50;
    scoreValue.text = @"0";
    if ([self canRecord]&&[recorder prepareToRecord]) {
        [recorder record];//创建录音文件，准备录音
    }
    //设置定时检测
    timer = [NSTimer scheduledTimerWithTimeInterval:0 target:self selector:@selector(detectionVoice) userInfo:nil repeats:YES];
}
//-----添加分---
-(void)addScore{
    NSString * userName = [[defaults objectForKey:@"userLoginInfo"] objectForKey:@"MemLoginID"];//本地存储
    AFHTTPClient * client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:APIURL]];
    if (!shopId) {
        shopId = @"";
    }
    //NSDictionary * params = @{@"apiid": @"0046",@"uid": userName,@"versionNo" :@"qwe99992",@"score":[NSString stringWithFormat:@"%d",gameScore],@"foruid":shopId};
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:@"0046",@"apiid",userName,@"uid",[[UIDevice currentDevice] uniqueDeviceIdentifier] ,@"versionNo",[NSString stringWithFormat:@"%d",gameScore],@"score",shopId,@"foruid", nil];
    NSURLRequest * request = [client requestWithMethod:@"POST"
                                                  path:@""
                                            parameters:params];
    AFHTTPRequestOperation * operation = [client HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [Waiting dismiss];//----隐藏loading----
        NSString *temp = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        if ([temp isEqualToString:@"true"]) {
            [self.view makeToast:[NSString stringWithFormat:@"加%d分,好开心!",gameScore] duration:1.2 position:@"center"];
        }
        NSLog(@"post socore-----------%@------%@---%@",params,temp,shopId);
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [Waiting dismiss];//----隐藏loading----
        NSLog(@"faild , error == %@ ", error);
        [self.view makeToast:@"网络错误,请重试" duration:1.2 position:@"center"];
    }];
    [operation start];
}
//-----启动录音
- (void)audio
{
    //录音设置
    NSMutableDictionary *recordSetting = [[NSMutableDictionary alloc]init];
    //设置录音格式  AVFormatIDKey==kAudioFormatLinearPCM
    [recordSetting setValue:[NSNumber numberWithInt:kAudioFormatMPEG4AAC] forKey:AVFormatIDKey];
    //设置录音采样率(Hz) 如：AVSampleRateKey==8000/44100/96000（影响音频的质量）
    [recordSetting setValue:[NSNumber numberWithFloat:44100] forKey:AVSampleRateKey];
    //录音通道数  1 或 2
    [recordSetting setValue:[NSNumber numberWithInt:1] forKey:AVNumberOfChannelsKey];
    //线性采样位数  8、16、24、32
    [recordSetting setValue:[NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey];
    //录音的质量
    [recordSetting setValue:[NSNumber numberWithInt:AVAudioQualityHigh] forKey:AVEncoderAudioQualityKey];
    
    NSString *strUrl = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSURL *url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/lll.aac", strUrl]];
    urlPlay = url;

    NSError *error;
    //初始化
    recorder = [[AVAudioRecorder alloc]initWithURL:url settings:recordSetting error:&error];
    //开启音量检测
    recorder.meteringEnabled = YES;
    recorder.delegate = self;
    
    AVAudioSession * audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error: &error]; //设置音频类别，这里表示当应用启动，停掉后台其他音频
    [audioSession setActive:YES error: &error];//设置当前应用音频活跃性
    NSLog(@"fjewjiohbiohroig--------%@",error);
}
- (void)detectionVoice
{
    gameScore = 50;
    [recorder updateMeters];//刷新音量数据
    //获取音量的平均值  [recorder averagePowerForChannel:0];
    //音量的最大值  [recorder peakPowerForChannel:0];
    double lowPassResults = pow(10, (0.05 * [recorder peakPowerForChannel:0]));
    NSLog(@"ijjjjj-----%lf----   %lf",lowPassResults,[recorder peakPowerForChannel:0]);
    int tempScore = lowPassResults*100;//-----只有50,100两个值-----
    if (tempScore < 50) {
        gameScore = 0;
    }else if(50 <= tempScore && tempScore < 75){
        gameScore = 50;
    }else{
        gameScore = 100;
    }
    scoreValue.text = [NSString stringWithFormat:@"%d",gameScore];
    //图片 小-》大
    if (0<lowPassResults && lowPassResults<=0.09) {
        [self.imageView setImage:[UIImage imageNamed:@"danertu_1.png"]];
    }else if (0.09<lowPassResults && lowPassResults<=0.18) {
        [self.imageView setImage:[UIImage imageNamed:@"danertu_2.png"]];
    }else if (0.18<lowPassResults && lowPassResults<=0.27) {
        [self.imageView setImage:[UIImage imageNamed:@"danertu_3.png"]];
    }else if (0.27<lowPassResults && lowPassResults<=0.36) {
        [self.imageView setImage:[UIImage imageNamed:@"danertu_4.png"]];
    }else if (0.36<lowPassResults && lowPassResults<=0.45) {
        [self.imageView setImage:[UIImage imageNamed:@"danertu_5.png"]];
    }else if (0.45<lowPassResults && lowPassResults<=0.54) {
        [self.imageView setImage:[UIImage imageNamed:@"danertu_6.png"]];
    }else if (0.54<lowPassResults && lowPassResults<=0.63) {
        [self.imageView setImage:[UIImage imageNamed:@"danertu_7.png"]];
    }else if (0.63<lowPassResults && lowPassResults<=0.72) {
        [self.imageView setImage:[UIImage imageNamed:@"danertu_8.png"]];
    }else if (0.72<lowPassResults && lowPassResults<=0.81) {
        [self.imageView setImage:[UIImage imageNamed:@"danertu_9.png"]];
    }else if (0.81<lowPassResults && lowPassResults<=0.9) {
        [self.imageView setImage:[UIImage imageNamed:@"danertu_10.png"]];
    }else{
        [self.imageView setImage:[UIImage imageNamed:@"danertu_11.png"]];
    }
}
//-------ios7  是否允许获取  麦克风
-(BOOL)canRecord
{
    __block BOOL bCanRecord = YES;
    if ([[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending)
    {
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        if ([audioSession respondsToSelector:@selector(requestRecordPermission:)]) {
            [audioSession performSelector:@selector(requestRecordPermission:) withObject:^(BOOL granted) {
                if (granted) {
                    bCanRecord = YES;
                }
                else {
                    bCanRecord = NO;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [[[UIAlertView alloc] initWithTitle:nil
                                                     message:@"app需要访问您的麦克风。\n请启用麦克风-设置/隐私/麦克风"
                                                    delegate:nil
                                           cancelButtonTitle:@"关闭"
                                           otherButtonTitles:nil] show];
                    });
                }
            }];
        }
    }
    return bCanRecord;
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}
//----触摸事件,点击热区状态变化
- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    //保存触摸起始点位置
    CGPoint point = [[touches anyObject] locationInView:self.view];
    if (point.x<60&point.y<44+addStatusBarHeight) {
        backHomeIcon.image = [UIImage imageNamed:@"carat-d-black"];
    }
    NSLog(@"nveojoejwfojwgoehgo-----%f,%f",point.x,point.y);
}
- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    backHomeIcon.image = [UIImage imageNamed:@"carat-d-orange"];
}
- (void) touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    backHomeIcon.image = [UIImage imageNamed:@"carat-d-orange"];
}

//-----------内存不足报警------
-(void)didReceiveMemoryWarning
{
    [[NSUserDefaults standardUserDefaults] synchronize];
    [super didReceiveMemoryWarning];
    NSLog(@"memory warning,kkappdelegate---");
}
@end