//
//  WebViewController.m
//  Tuan
//
//  Created by 夏 华 on 12-7-6.
//  Copyright (c) 2012年 无锡恩梯梯数据有限公司. All rights reserved.
//
#import "SettingsViewController.h"
#import "AFHTTPClient.h"
#import "HeSingleModel.h"
#import "AFHTTPRequestOperation.h"

@implementation SettingsViewController
@synthesize addStatusBarHeight;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    [self initView];  //界面初始化
    
}

-(void)initView{
    
    addStatusBarHeight = STATUSBAR_HEIGHT;
    
    UIView *bgView  = [[UIView alloc] initWithFrame:CGRectMake(0, addStatusBarHeight+TOPNAVIHEIGHT, MAINSCREEN_WIDTH, MAINSCREEN_HEIGHT-addStatusBarHeight-TOPNAVIHEIGHT)];
    [self.view addSubview:bgView];
    [bgView setBackgroundColor:[UIColor whiteColor]];
    
    UIImageView *logoImage = [[UIImageView alloc] initWithFrame:CGRectMake(110, 60, 100, 100)];
    [bgView addSubview:logoImage];
    [logoImage setImage:[UIImage imageNamed:@"logo_version.png"]];
    
    UIImageView *shapeImage = [[UIImageView alloc] initWithFrame:CGRectMake(100, 180, 111, 47)];
    [bgView addSubview:shapeImage];
    [shapeImage setImage:[UIImage imageNamed:@"shape_version.png"]];
    
    UILabel *versionLable = [[UILabel alloc] initWithFrame:CGRectMake(110, 250, 150, 40)];
    [bgView addSubview:versionLable];
    [versionLable setBackgroundColor:[UIColor clearColor]];
    [versionLable setTextColor:[UIColor grayColor]];
    [versionLable setTextAlignment:NSTextAlignmentLeft];
    [versionLable setFont:[UIFont fontWithName:@"Helvetica" size:16.0]];
    [versionLable setText:[NSString stringWithFormat:@"version: %@",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]]];
}

//-----点击返回
-(void)onClickBack{
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSString*)getTitle{
    return @"关于单耳兔";
}
/*
//检测版本号
- (void)checkAppVersion
{
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSLog(@"当前版本号:%@",version);
    //    NSString *mark = @""; //标记 空为正常版本 test为测试版本 shopid为定制版本
    NSDictionary *param = [[NSDictionary alloc] initWithObjectsAndKeys:@"0138",@"apiid",version,@"iosversion",UPDATEMARK,@"mark", nil];
    [[AFOSCClient sharedClient] postPath:nil parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject){
        NSString *respondstring = operation.responseString;
        id respondObj = [respondstring objectFromJSONString];
        if (respondObj) {
            
            NSString *downloadUrl = [respondObj objectForKey:@"url"];
            if (downloadUrl == nil || [downloadUrl isEqualToString:@""]) {
                //无更新
                
                UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:[NSString stringWithFormat:@"恭喜!您当前是最新版本,版本号:v%@",version] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alertview show];
                return;
            }
            
            HeSingleModel *singleModel = [HeSingleModel shareHeSingleModel];
            singleModel.versionDict = respondObj;
            //有更新，但是需要判断是否AppStore上面的版本
            NSString *checkStatus = [respondObj objectForKey:@"checkstatus"];
            if ([checkStatus isMemberOfClass:[NSNull class]]) {
                checkStatus = @"";
            }
            if ([UPDATEMARK isEqualToString:@""] && (checkStatus == nil || [checkStatus isEqualToString:@""] || [checkStatus isEqualToString:@"NO"])) {
                //表明在AppStore上面正在审核的版本，因此把自动更新给屏蔽
                
                UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:[NSString stringWithFormat:@"您当前是最新版本,版本号:v%@",version] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alertview show];
                
                return;
            }
            
            UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:[NSString stringWithFormat:@"您当前的版本号:v%@,“单耳兔商城”有新版本，现在更新？",version] delegate:self cancelButtonTitle:@"下次再说" otherButtonTitles:@"马上更新", nil];
            alertview.accessibilityIdentifier = downloadUrl;
            [alertview show];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error){
        
    }];
}
*/
-(void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
@end
