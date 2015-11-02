//
//  ApplyRefundMentViewController.m
//  单耳兔
//
//  Created by yang on 15/7/31.
//  Copyright (c) 2015年 珠海单耳兔电子商务有限公司. All rights reserved.
//
//申请退款
#import "ApplyRefundMentViewController.h"
#import "UIView+Toast.h"
#import "AFHTTPRequestOperation.h"

@interface ApplyRefundMentViewController (){
    int addStatusBarHeight;
    UILabel *refundmentReason;
    UITextView *textView;
    UIView *reasonBgView;
}
@end

@implementation ApplyRefundMentViewController
@synthesize refundmentData;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initView];
}

-(void)initView{
    addStatusBarHeight = [TopNaviViewController getStatusBarHeight] + TOPNAVIHEIGHT;
    [self.view setBackgroundColor:[UIColor colorWithRed:248.0/255 green:248.0/255 blue:248.0/255 alpha:1]];
    
    UIFont *textFont = [UIFont fontWithName:@"Helvetica" size:17.0];
    
    UILabel *refundmentResaonTip = [[UILabel alloc] initWithFrame:CGRectMake(10, addStatusBarHeight +10, 100, 20)];
    [self.view addSubview:refundmentResaonTip];
    [refundmentResaonTip setText:@"退款原因:"];
    [refundmentResaonTip setFont:textFont];
    [refundmentResaonTip setTextColor:[UIColor grayColor]];
    
    refundmentReason = [[UILabel alloc] initWithFrame:CGRectMake(85, addStatusBarHeight+10, 200, 20)];
    [self.view addSubview:refundmentReason];
    [refundmentReason setText:@"请选择退款原因"];
    [refundmentReason setUserInteractionEnabled:YES];
    
    UITapGestureRecognizer *chooseRefundmentResaonTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(chooseRefundmentResaon)];
    [refundmentReason addGestureRecognizer:chooseRefundmentResaonTap];
    
    UIImageView *tipImageView = [[UIImageView alloc] initWithFrame:CGRectMake(MAINSCREEN_WIDTH-20, addStatusBarHeight+10, 10, 10)];
    [self.view addSubview:tipImageView];
    [tipImageView setImage:[UIImage imageNamed:@"icon_sell_jiantou"]];
    
    UILabel *refundmentCountTip = [[UILabel alloc] initWithFrame:CGRectMake(10, addStatusBarHeight+35, 100, 20)];
    [self.view addSubview:refundmentCountTip];
    [refundmentCountTip setText:@"退款金额:"];
    [refundmentCountTip setFont:textFont];
    [refundmentCountTip setTextColor:[UIColor grayColor]];
    
    UILabel *refundmentCount = [[UILabel alloc] initWithFrame:CGRectMake(85, addStatusBarHeight+35, 100, 20)];
    [self.view addSubview:refundmentCount];
    [refundmentCount setText:[NSString stringWithFormat:@"￥%@",[refundmentData valueForKey:@"ShouldPayPrice"]]];
    [refundmentCount setFont:textFont];
    [refundmentCount setTextColor:[UIColor redColor]];
    
    UILabel *refundmentInfoTip = [[UILabel alloc] initWithFrame:CGRectMake(10, addStatusBarHeight+60, 100, 20)];
    [self.view addSubview:refundmentInfoTip];
    [refundmentInfoTip setText:@"退款说明:"];
    [refundmentInfoTip setFont:textFont];
    [refundmentInfoTip setTextColor:[UIColor grayColor]];
    
    
    textView = [[UITextView alloc] initWithFrame:CGRectMake(10, addStatusBarHeight+85, 300, 60)];
    [self.view addSubview:textView];
    textView.delegate = self;
    //点击进行评语编辑，最少评论15字，最多不超多300字，您的评价将是其他用户的重要参考。
    
    UIButton *applyBtn = [[UIButton alloc]initWithFrame:CGRectMake(60, addStatusBarHeight+200, MAINSCREEN_WIDTH-120, 40)];
    [self.view addSubview:applyBtn];
    [applyBtn.layer setMasksToBounds:YES];
    [applyBtn.layer setCornerRadius:5];
    applyBtn.backgroundColor = [UIColor grayColor];
    [applyBtn setTitle:@"提交申请" forState:UIControlStateNormal];
    [applyBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [applyBtn addTarget:self action:@selector(onClickApply) forControlEvents:UIControlEventTouchUpInside];
    
    reasonBgView = [[UIView alloc] initWithFrame:CGRectMake(0, addStatusBarHeight+30, MAINSCREEN_WIDTH, 120)];
    [self.view addSubview:reasonBgView];
    [reasonBgView setBackgroundColor:[UIColor colorWithRed:50.0/255 green:198.0/255 blue:206.0/255 alpha:1.0]];
    NSArray *array = @[@"缺货",@"协商一致退款",@"未按约定时间发货",@"其他"];
    for (int i = 0; i < [array count]; i++) {
        UILabel *reasonItem = [[UILabel alloc] initWithFrame:CGRectMake(0, i*30, MAINSCREEN_WIDTH, 30)];
        [reasonBgView addSubview:reasonItem];
        reasonItem.tag = 100 + i;
        [reasonItem setText:[array objectAtIndex:i]];
        [reasonItem setFont:textFont];
        [reasonItem setTextColor:[UIColor blueColor]];
        [reasonItem setUserInteractionEnabled:YES];
        [reasonItem setTextAlignment:NSTextAlignmentCenter];
        
        UITapGestureRecognizer *resaonItemTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(resaonItemClick:)];
        [reasonItem addGestureRecognizer:resaonItemTap];
    }
    [reasonBgView setHidden:YES];
}

-(NSString*)getTitle{
    return @"申请退款";
}

-(void)onClickBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)chooseRefundmentResaon{
    
    if ([reasonBgView isHidden]) {
        [reasonBgView setHidden:NO];
    }else{
        [reasonBgView setHidden:YES];
    }
}

-(void)resaonItemClick:(id)sender{
    [reasonBgView setHidden:YES];
    UILabel *clickLb = (UILabel*)[sender view];
    [refundmentReason setText:clickLb.text];
}

-(void)onClickApply{
    if (![self canApplyRebundment]) {
        return;
    }
   
    [Waiting show];
    NSString *orderNumber = [refundmentData objectForKey:@"OrderNumber"];
    
    NSDictionary * params = @{@"apiid": @"0079",
                        @"ordernumber":orderNumber,
                           @"memberid":[[[NSUserDefaults standardUserDefaults] objectForKey:@"userLoginInfo"] objectForKey:@"MemLoginID"],
                             @"reason":refundmentReason.text,
                             @"remark":textView.text};
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:APIURL]];
    NSURLRequest * request = [httpClient requestWithMethod:@"POST"
                                                      path:@""
                                                parameters:params];
    AFHTTPRequestOperation * operation = [httpClient HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [Waiting dismiss];//隐藏loading
        NSString *source = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        if ([source  isEqualToString:@"true"]) {
            [self.view makeToast:@"申请发送成功" duration:1.2 position:@"center"];
            [self performSelector:@selector(onClickBack) withObject:nil afterDelay:1.2];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"reFreshOrderListNotification" object:nil userInfo:refundmentData];
        }else{
            [self.view makeToast:@"确认失败,请稍后重试" duration:1.2 position:@"center"];
        }
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"faild , error   == %@ ", error);
        [Waiting dismiss];
        [self.view makeToast:@"网络错误请重试" duration:1.5 position:@"center"];
    }];
    [operation start];
}

-(BOOL)canApplyRebundment{
    NSString *mes = @"";
    if ([refundmentReason.text isEqualToString:@"请选择退款原因"]) {
        mes = @"请务必选择退款原因";
    }
    if ([textView.text isEqualToString:@""]) {
        mes = @"请输入退款说明";
    }
    if ([mes isEqualToString:@""]) {
        return YES;
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:mes delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return NO;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
