//
//  MeiMesSettingVC.m
//  单耳兔
//
//  Created by yang on 15/7/8.
//  Copyright (c) 2015年 珠海单耳兔电子商务有限公司. All rights reserved.
//

#import "MeiMesSettingVC.h"

@interface MeiMesSettingVC ()
{
    int addStatusBarHeight;
    NSUserDefaults *defaults;
}
@end

@implementation MeiMesSettingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initView];
  
}

-(NSString*)getTitle{
    return @"消息管理";
}

-(void)onClickBack{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)initView{
    addStatusBarHeight = [TopNaviViewController getStatusBarHeight];
    [self.view setBackgroundColor:[UIColor colorWithRed:248.0/255 green:248.0/255 blue:248.0/255 alpha:1]];
    defaults =[NSUserDefaults standardUserDefaults];
    
    int topViewHeight = addStatusBarHeight + TOPNAVIHEIGHT;
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake( 0, 5+topViewHeight, MAINSCREEN_WIDTH, 90)];
    [self.view addSubview:bgView];
    bgView.backgroundColor = [UIColor whiteColor];
    
    UIFont *font = [UIFont fontWithName:@"Helvetica" size:16.0];
    
    UILabel *activeTip = [[UILabel alloc] initWithFrame:CGRectMake(10, 12, 100, 20)];
    [bgView addSubview:activeTip];
    [activeTip setText:@"活动通知"];
    [activeTip setFont:font];
    
    UISwitch *activeSwitch = [[UISwitch alloc] init];
    int switch_x = MAINSCREEN_WIDTH-activeSwitch.frame.size.width-10;
    [activeSwitch setFrame:CGRectMake(switch_x, 7, 0, 0)];
    [bgView addSubview:activeSwitch];
    activeSwitch.tag       = 1;
    activeSwitch.on        = [[defaults valueForKey:@"Key_ActiveMessageState"] boolValue];
    [activeSwitch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
    
    UILabel *exchangeTip = [[UILabel alloc] initWithFrame:CGRectMake(10, 57, 100, 20)];
    [bgView addSubview:exchangeTip];
    [exchangeTip setText:@"商品交易"];
    [exchangeTip setFont:font];
    
    UISwitch *exchangeSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(switch_x, 53, 0, 0)];
    [bgView addSubview:exchangeSwitch];
    exchangeSwitch.tag       = 2;
    exchangeSwitch.on        = [[defaults valueForKey:@"Key_GoodsExchangeState"] boolValue];
    [exchangeSwitch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
    
    UIView *offLine = [[UIView alloc] initWithFrame:CGRectMake(10, 45, MAINSCREEN_WIDTH-20, 0.3)];
    [bgView addSubview:offLine];
    offLine.backgroundColor = [UIColor blackColor];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake( 0, 100 + topViewHeight, MAINSCREEN_WIDTH, 45)];
    [self.view addSubview:view];
    view.backgroundColor = [UIColor whiteColor];
    
    UILabel *walletTip = [[UILabel alloc] initWithFrame:CGRectMake(10, 12, 100, 20)];
    [view addSubview:walletTip];
    [walletTip setText:@"钱包通知"];
    [walletTip setFont:font];
    
    UISwitch *walletSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(switch_x, 7, 0, 0)];
    [view addSubview:walletSwitch];
    walletSwitch.tag       = 3;
    walletSwitch.on        = [[defaults valueForKey:@"Key_WalletMessageState"] boolValue];
    [walletSwitch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
}

-(void)switchAction:(id)sender{
    UISwitch *switchBtn = (UISwitch*)sender;
    BOOL isBtnOn = [switchBtn isOn];
    if (isBtnOn) {
        switch (switchBtn.tag) {
            case 1:
                [defaults setObject:[NSNumber numberWithBool:YES] forKey:@"Key_ActiveMessageState"];
                NSLog(@"action is on");
                break;
            case 2:
                [defaults setObject:[NSNumber numberWithBool:YES] forKey:@"Key_GoodsExchangeState"];
                NSLog(@"exchange is on");
                break;
            case 3:
                [defaults setObject:[NSNumber numberWithBool:YES] forKey:@"Key_WalletMessageState"];
                NSLog(@"wallet is on");
                break;
            default:
                break;
        }
    }else{
        switch (switchBtn.tag) {
            case 1:
                [defaults setObject:[NSNumber numberWithBool:NO] forKey:@"Key_ActiveMessageState"];
                NSLog(@"action is off");
                break;
            case 2:
                [defaults setObject:[NSNumber numberWithBool:NO] forKey:@"Key_GoodsExchangeState"];
                NSLog(@"exchange is off");
                break;
            case 3:
                [defaults setObject:[NSNumber numberWithBool:NO] forKey:@"Key_WalletMessageState"];
                NSLog(@"wallet is off");
                break;
            default:
                break;
        }
    }
}

- (void)didReceiveMemoryWarning {
    [defaults synchronize];
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
