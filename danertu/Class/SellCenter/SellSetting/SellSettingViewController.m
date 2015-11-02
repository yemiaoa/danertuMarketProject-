//
//  SellSettingViewController.m
//  单耳兔
//
//  Created by yang on 15/7/1.
//  Copyright (c) 2015年 无锡恩梯梯数据有限公司. All rights reserved.
//
//卖家中心->送酒分成设置

#import "SellSettingViewController.h"
#import "Waiting.h"
#import "AFHTTPRequestOperation.h"
#import "UIView+Toast.h"

@interface SellSettingViewController ()
{
    int addStatusBarHeight;
    UIButton *topEditBtn;
    UILabel *totalTipText;
    UILabel *delegateTipText;
    UILabel *experienceTipText;
    UILabel *shopTipText;
    UILabel *delegateSign;
    UILabel *experienceSign;
    UILabel *shopSign;
    UITextField *delegateTextField;
    UITextField *experienceTextField;
    UITextField *shopTextField;
    int number;
}
@end

@implementation SellSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    number = 0;
    [self initView];
    [self loadData];
}

-(NSString*)getTitle{
    return @"送酒分成设置";
}

-(void)onClickBack{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)initView{
    addStatusBarHeight = [TopNaviViewController getStatusBarHeight];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    topEditBtn = [[UIButton alloc] initWithFrame:CGRectMake(240, addStatusBarHeight+7, 60,30)];
    [self.view addSubview:topEditBtn];
    topEditBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [topEditBtn setTitle:@"修改" forState:UIControlStateNormal];
    [topEditBtn addTarget:self action:@selector(editCellAction) forControlEvents:UIControlEventTouchUpInside];
    
    //黄色背景
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, addStatusBarHeight+TOPNAVIHEIGHT, MAINSCREEN_WIDTH, 50)];
    bgView.backgroundColor = [UIColor colorWithRed:230.0/255 green:160.0/255 blue:22.0/255 alpha:1];
    [self.view addSubview:bgView];
    
    UILabel *totalTip = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 100, 30)];
    [bgView addSubview:totalTip];
    [totalTip setBackgroundColor:[UIColor clearColor]];
    [totalTip setText:@"总提成:"];
    [totalTip setTextColor:[UIColor whiteColor]];
    [totalTip setFont:[UIFont systemFontOfSize:18]];
    
    totalTipText = [[UILabel alloc] initWithFrame:CGRectMake(220, 10, 100, 30)];
    [bgView addSubview:totalTipText];
    [totalTipText setBackgroundColor:[UIColor clearColor]];
    [totalTipText setFont:[UIFont systemFontOfSize:18]];
    [totalTipText setTextColor:[UIColor whiteColor]];
    
    UILabel *delegateTip = [[UILabel alloc] initWithFrame:CGRectMake(20, addStatusBarHeight+TOPNAVIHEIGHT +60, 100, 30)];
    [self.view addSubview:delegateTip];
    [delegateTip setText:@"总代理:"];
    [delegateTip setFont:[UIFont systemFontOfSize:16]];
    
    delegateTipText = [[UILabel alloc] initWithFrame:CGRectMake(220, addStatusBarHeight+TOPNAVIHEIGHT +60, 100, 30)];
    [self.view addSubview:delegateTipText];

    [delegateTipText setText:[NSString stringWithFormat:@"%@",@"￥2.0"]];

    
    UILabel *experienceTip = [[UILabel alloc] initWithFrame:CGRectMake(20, addStatusBarHeight+TOPNAVIHEIGHT +100, 100, 30)];
    [self.view addSubview:experienceTip];
    [experienceTip setText:@"体验店:"];
    [experienceTip setFont:[UIFont systemFontOfSize:16]];
    
    experienceTipText = [[UILabel alloc] initWithFrame:CGRectMake(220, addStatusBarHeight+TOPNAVIHEIGHT +100, 100, 30)];
    [self.view addSubview:experienceTipText];

    [experienceTipText setText:[NSString stringWithFormat:@"%@",@"￥1.0"]];

    
    UILabel *shopTip = [[UILabel alloc] initWithFrame:CGRectMake(20, addStatusBarHeight+TOPNAVIHEIGHT +140, 100, 30)];
    [self.view addSubview:shopTip];
    [shopTip setText:@"网   店:"];
    [shopTip setFont:[UIFont systemFontOfSize:16]];
    
    shopTipText = [[UILabel alloc] initWithFrame:CGRectMake(220, addStatusBarHeight+TOPNAVIHEIGHT +140, 100, 30)];
    [self.view addSubview:shopTipText];

    [shopTipText setText:[NSString stringWithFormat:@"%@",@"￥0.8"]];

    
    delegateSign = [[UILabel alloc] initWithFrame:CGRectMake(200, addStatusBarHeight+TOPNAVIHEIGHT +60, 20, 30)];
    [self.view addSubview:delegateSign];
    [delegateSign setText:@"￥"];
    [delegateSign setFont:[UIFont systemFontOfSize:16]];
    experienceSign = [[UILabel alloc] initWithFrame:CGRectMake(200, addStatusBarHeight+TOPNAVIHEIGHT +100, 20, 30)];
    [self.view addSubview:experienceSign];
    [experienceSign setText:@"￥"];
    [experienceSign setFont:[UIFont systemFontOfSize:16]];
    shopSign = [[UILabel alloc] initWithFrame:CGRectMake(200, addStatusBarHeight+TOPNAVIHEIGHT +140, 20, 30)];
    [self.view addSubview:shopSign];
    [shopSign setText:@"￥"];
    [shopSign setFont:[UIFont systemFontOfSize:16]];
    
    delegateTextField = [[UITextField alloc] initWithFrame:CGRectMake(220, addStatusBarHeight+TOPNAVIHEIGHT +60, 60, 25)];
    [self.view addSubview:delegateTextField];
    delegateTextField.text = @"1";
    delegateTextField.delegate = self;
    delegateTextField.keyboardType = UIKeyboardTypeDecimalPad;
    delegateTextField.borderStyle = UITextBorderStyleRoundedRect;
    delegateTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    delegateTextField.textAlignment = NSTextAlignmentCenter;
    
    
    experienceTextField = [[UITextField alloc] initWithFrame:CGRectMake(220, addStatusBarHeight+TOPNAVIHEIGHT +100, 60, 25)];
    [self.view addSubview:experienceTextField];
    experienceTextField.text = @"1";
    experienceTextField.delegate = self;
    experienceTextField.keyboardType = UIKeyboardTypeDecimalPad;
    experienceTextField.borderStyle = UITextBorderStyleRoundedRect;
    experienceTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    experienceTextField.textAlignment = NSTextAlignmentCenter;
    
    
    shopTextField = [[UITextField alloc] initWithFrame:CGRectMake(220, addStatusBarHeight+TOPNAVIHEIGHT +140, 60, 25)];
    [self.view addSubview:shopTextField];
    shopTextField.text = @"1";
    shopTextField.delegate = self;
    shopTextField.keyboardType = UIKeyboardTypeDecimalPad;
    shopTextField.borderStyle = UITextBorderStyleRoundedRect;
    shopTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    shopTextField.textAlignment = NSTextAlignmentCenter;
    
    
    [self setEditState:NO];
    
    //点击空白处关闭键盘
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeKeyboard)];
    tapGes.numberOfTapsRequired = 1;
    tapGes.numberOfTouchesRequired = 1;
    [self.view addGestureRecognizer:tapGes];
}

-(void)loadData{
    [Waiting show];
    NSDictionary * params  = @{@"apiid": @"0239",@"shopid" : [[[NSUserDefaults standardUserDefaults] valueForKey:@"userLoginInfo"] valueForKey:@"MemLoginID"]};
    NSURLRequest * request = [[AFOSCClient sharedClient] requestWithMethod:@"POST"
                                                                      path:nil
                                                                parameters:params];
    AFHTTPRequestOperation * operation = [[AFOSCClient sharedClient] HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [Waiting dismiss];
        NSString *respondString = operation.responseString;
        NSDictionary *dic = [respondString objectFromJSONString];
        NSDictionary *sList = [dic objectForKey:@"sList"];
        NSArray *sBean = [sList objectForKey:@"sBean"];
        NSDictionary *payDic = [sBean firstObject];
        id zongObject = [payDic objectForKey:@"zong"];
        id tydObject = [payDic objectForKey:@"tyd"];
        id wangObject = [payDic objectForKey:@"wang"];
        if ([zongObject isMemberOfClass:[NSNull class]] || zongObject == nil) {
            zongObject = @"";
        }
        if ([tydObject isMemberOfClass:[NSNull class]] || tydObject == nil) {
            tydObject = @"";
        }
        if ([wangObject isMemberOfClass:[NSNull class]] || wangObject == nil) {
            wangObject = @"";
        }
        CGFloat zong = [zongObject floatValue];
        CGFloat tyd = [tydObject floatValue];
        CGFloat wang = [wangObject floatValue];
        
        CGFloat total = zong + tyd + wang;
        
        delegateTipText.text = [NSString stringWithFormat:@"%.2f",zong];
        experienceTipText.text = [NSString stringWithFormat:@"%.2f",tyd];
        shopTipText.text = [NSString stringWithFormat:@"%.2f",wang];
        totalTipText.text = [NSString stringWithFormat:@"%.2f",total];
        
        delegateTextField.text = [NSString stringWithFormat:@"%.2f",zong];
        experienceTextField.text = [NSString stringWithFormat:@"%.2f",tyd];
        shopTextField.text = [NSString stringWithFormat:@"%.2f",wang];
        
        if (total == 0) {
            [self showHint:@"亲，你可能还没设置分成"];
        }
        else{
            [self showHint:@"加载成功!"];
        }
        
        /*
         解析数据
         数据处理
         */
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [Waiting dismiss];
        [self.view makeToast:@"请检查网络连接是否正常" duration:2.0 position:@"center"];
    }];
    
    [operation start];
}

//设置提成
- (void)setPayment
{
    CGFloat zong = [delegateTextField.text floatValue];
    NSString *zongPay = [NSString stringWithFormat:@"%.2f",zong];
    
    CGFloat tyd = [experienceTextField.text floatValue];
    NSString *tydPay = [NSString stringWithFormat:@"%.2f",tyd];
    
    CGFloat wang = [shopTextField.text floatValue];
    NSString *wangPay = [NSString stringWithFormat:@"%.2f",wang];
    
    CGFloat total = zong + tyd + wang;
    if (zong < 0 || tyd < 0 || wang < 0) {
        [self showHint:@"分成不能小于0"];
        return;
    }
    if (total > 3.80) {
        [self showHint:@"三种店铺提成总和不能大于3.8"];
        return;
    }
    [Waiting show];
    
    NSDictionary * params  = @{@"apiid": @"0238",@"zong": zongPay,@"tyd": tydPay,@"wang": wangPay,@"shopid" : [[[NSUserDefaults standardUserDefaults] valueForKey:@"userLoginInfo"] valueForKey:@"MemLoginID"]};
    NSURLRequest * request = [[AFOSCClient sharedClient] requestWithMethod:@"POST"
                                                                      path:nil
                                                                parameters:params];
    AFHTTPRequestOperation * operation = [[AFOSCClient sharedClient] HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [Waiting dismiss];
        NSString *respondString = operation.responseString;
        NSDictionary *dic = [respondString objectFromJSONString];
        NSString *result = [dic objectForKey:@"result"];
        if ([result isMemberOfClass:[NSNull class]] || result == nil) {
            result = @"";
        }
        if ([result compare:@"true" options:NSCaseInsensitiveSearch]== NSOrderedSame) {
            
            delegateTipText.text = [NSString stringWithFormat:@"%.2f",zong];
            experienceTipText.text = [NSString stringWithFormat:@"%.2f",tyd];
            shopTipText.text = [NSString stringWithFormat:@"%.2f",wang];
            totalTipText.text = [NSString stringWithFormat:@"%.2f",total];
            
            [topEditBtn setTitle:@"修改" forState:UIControlStateNormal];
            [self setEditState:NO];
            
            [self showHint:@"设置成功!"];
        }
        NSLog(@"%@",dic);
        /*
         解析数据
         数据处理
         */
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [Waiting dismiss];
        [self.view makeToast:@"请检查网络连接是否正常" duration:2.0 position:@"center"];
    }];
    
    [operation start];
}

//关闭键盘
-(void)closeKeyboard{
    if ([delegateTextField isFirstResponder]) {
        [delegateTextField resignFirstResponder];
    }else if ([experienceTextField isFirstResponder]){
        [experienceTextField resignFirstResponder];
    }else if ([shopTextField isFirstResponder]){
        [shopTextField resignFirstResponder];
    }
}

-(void)setEditState:(BOOL)isEdit{
    if (isEdit) {
        [delegateTipText setHidden:YES];
        [experienceTipText setHidden:YES];
        [shopTipText setHidden:YES];
        [delegateSign setHidden:NO];
        [experienceSign setHidden:NO];
        [shopSign setHidden:NO];
        [delegateTextField setHidden:NO];
        [experienceTextField setHidden:NO];
        [shopTextField setHidden:NO];
    }else{
        [delegateTipText setHidden:NO];
        [experienceTipText setHidden:NO];
        [shopTipText setHidden:NO];
        [delegateSign setHidden:YES];
        [experienceSign setHidden:YES];
        [shopSign setHidden:YES];
        [delegateTextField setHidden:YES];
        [experienceTextField setHidden:YES];
        [shopTextField setHidden:YES];
    }
}

-(void)editCellAction{
    if ([topEditBtn.titleLabel.text isEqualToString:@"修改"]) {
        [topEditBtn setTitle:@"完成" forState:UIControlStateNormal];
        [self setEditState:YES];
        
    } else if ([topEditBtn.titleLabel.text isEqualToString:@"完成"]){
        [self setPayment];
        
        //数据处理
        /*
         提交数据
         
         */
        NSLog(@"完成完成完成");
    }
}

#pragma mark UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    NSMutableString * futureString = [NSMutableString stringWithString:textField.text];
    [futureString  insertString:string atIndex:range.location];
    
    NSInteger flag=0;
    const NSInteger limited = 2;
    int strLength = (int)futureString.length-1;
    for (int i = strLength; i>=0; i--) {
        
        if ([futureString characterAtIndex:i] == '.') {
            
            if (flag > limited) {
                [self.view makeToast:@"小数点后最多设置两位小数" duration:2.0 position:@"center"];
                return NO;
            }
            
            break;
        }
        flag++;
    }
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField*)textField
{
    if ([delegateTextField isFirstResponder]) {
        [experienceTextField resignFirstResponder];
    }else if ([experienceTextField isFirstResponder]){
        [shopTextField resignFirstResponder];
    }
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
