//
//  WebViewController.m
//  Tuan
//
//  Created by 夏 华 on 12-7-6.
//  Copyright (c) 2012年 无锡恩梯梯数据有限公司. All rights reserved.
//
#import "AddressManagerController.h"
@implementation AddressManagerController
@synthesize addStatusBarHeight;
@synthesize address;
@synthesize setDefaultBtn;
@synthesize isDefaultAddress;
@synthesize addressView;
- (void)loadView
{
    [super loadView];
    // If you create your views manually, you MUST override this method and use it to create your views.
    // If you use Interface Builder to create your views, then you must NOT override this method.
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initView];
}

//-----修改标题,重写父类方法----
-(NSString*)getTitle{
    return @"收货地址管理";
}

- (void)initView{
    addStatusBarHeight = [TopNaviViewController getStatusBarHeight] + TOPNAVIHEIGHT;
    
    self.view.backgroundColor = [UIColor colorWithRed:248.0/255 green:248.0/255 blue:248.0/255 alpha:1];
    addressView = [[UIView alloc] initWithFrame:CGRectMake(0, addStatusBarHeight, MAINSCREEN_WIDTH, 170)];
    [self.view addSubview:addressView];
    [addressView setBackgroundColor:[UIColor whiteColor]];
    
    NSArray *textArr = @[[address objectForKey:@"name"],[address objectForKey:@"mobile"],@"姓名:",@"电话:"];
    for (NSInteger i = 0; i< textArr.count/2; i++) {
        UILabel *nameLb = [[UILabel alloc] initWithFrame:CGRectMake(10, addStatusBarHeight + 50 * i, 50, 50)];
        [self.view addSubview:nameLb];
        nameLb.text = textArr[i+2];
    
        UILabel *placeHolder = [[UILabel alloc] initWithFrame:CGRectMake(55, addStatusBarHeight + 50 * i, 250, 50)];
        [self.view addSubview:placeHolder];
        placeHolder.textColor = [UIColor grayColor];
        placeHolder.text = textArr[i];
        placeHolder.backgroundColor = [UIColor clearColor];
        
        //--边框
        UILabel *border = [[UILabel alloc] initWithFrame:CGRectMake(5, addStatusBarHeight + 50*(i+1) - 1, MAINSCREEN_WIDTH-5, 0.7)];
        [self.view addSubview:border];
        border.backgroundColor = BORDERCOLOR;
    }
    
    UILabel *addressL = [[UILabel alloc] initWithFrame:CGRectMake(10, addStatusBarHeight + 100, 50, 50)];
    [self.view addSubview:addressL];
    addressL.text = @"地址:";
    
    UILabel *addressText = [[UILabel alloc] initWithFrame:CGRectMake(55, addStatusBarHeight + 100, 250, 50)];
    [self.view addSubview:addressText];
    addressText.textColor = [UIColor grayColor];
    addressText.numberOfLines = 0;
    addressText.text = [NSString stringWithFormat:@"%@",[address objectForKey:@"adress"]];
    
    UILabel *borderLine = [[UILabel alloc] initWithFrame:CGRectMake(0, addStatusBarHeight + 170 - 1, MAINSCREEN_WIDTH, 0.7)];
    [self.view addSubview:borderLine];
    borderLine.backgroundColor = BORDERCOLOR;
    
    //---------修改默认收货地址--------
    UIView *setDefaultV = [[UIView alloc] initWithFrame:CGRectMake( 0,addStatusBarHeight + 235, MAINSCREEN_WIDTH, 50)];
    [self.view addSubview:setDefaultV];
    setDefaultV.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeDefault)];
    [setDefaultV addGestureRecognizer:tap];
    
    //选择框
    setDefaultBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 15, 20, 20)];
    [setDefaultV addSubview:setDefaultBtn];
    [setDefaultBtn.layer setMasksToBounds:YES];
    [setDefaultBtn.layer setBorderWidth:0.6];
    setDefaultBtn.enabled = NO;
    setDefaultBtn.backgroundColor = [UIColor clearColor];
    if ([[address objectForKey:@"ck"] isEqualToString:@"1"]) {
        [setDefaultBtn setBackgroundImage:[UIImage imageNamed:@"selected"] forState:UIControlStateDisabled];
        isDefaultAddress = YES;
    }else{
        isDefaultAddress = NO;
    }
    
    //文字
    UILabel *nameLb = [[UILabel alloc] initWithFrame:CGRectMake(40, 10, 250, 30)];
    [setDefaultV addSubview:nameLb];
    nameLb.backgroundColor = [UIColor clearColor];
    nameLb.text = @"设置成默认收货地址";
    
    //----------删除按钮-------------
    UIView *saveDeleteView = [[UIView alloc] initWithFrame:CGRectMake( 0,addStatusBarHeight + 185, MAINSCREEN_WIDTH, 50)];
    [self.view addSubview:saveDeleteView];
    saveDeleteView.backgroundColor = [UIColor whiteColor];
    saveDeleteView.userInteractionEnabled = YES;
    
    UILabel *border1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, MAINSCREEN_WIDTH, 0.5)];
    [saveDeleteView addSubview:border1];
    border1.backgroundColor = BORDERCOLOR;
    
    UILabel *border2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, MAINSCREEN_WIDTH, 0.5)];
    [saveDeleteView addSubview:border2];
    border2.backgroundColor = BORDERCOLOR;
    
    //垃圾桶
    UIImageView *del = [[UIImageView alloc]initWithFrame:CGRectMake(10, 14, 16, 20)];//高度--44
    [saveDeleteView addSubview:del];
    del.image = [UIImage imageNamed:@"sellgood_delete"];
    
    //文字
    UILabel *delLb = [[UILabel alloc] initWithFrame:CGRectMake(30, 15, 40, 20)];
    [saveDeleteView addSubview:delLb];
    delLb.text = @"删除";
    
    UITapGestureRecognizer *singleTapClear =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(deleteAddress)];
    [saveDeleteView addGestureRecognizer:singleTapClear];
    
    //保存按钮
    UIButton *loginBtn = [[UIButton alloc]initWithFrame:CGRectMake(30, self.view.frame.size.height-50, MAINSCREEN_WIDTH-60, 40)];
    [self.view addSubview:loginBtn];
    [loginBtn.layer setMasksToBounds:YES];
    [loginBtn.layer setCornerRadius:5];//设置矩形四个圆角半径
    
    loginBtn.backgroundColor = TOPNAVIBGCOLOR;
    [loginBtn setTitle:@"保  存" forState:UIControlStateNormal];
    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loginBtn setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [loginBtn addTarget:self action:@selector(saveResult) forControlEvents:UIControlEventTouchUpInside];
    
}

//-----是否设为默认收货地址
-(void)changeDefault{
    if (isDefaultAddress) {
        if ([[address objectForKey:@"ck"] isEqualToString:@"1"]) {
            [self.view makeToast:@"已设为默认地址,若要取消可通过设置其他地址为默认地址" duration:1.2 position:@"center"];
        }else{
            [setDefaultBtn setImage:nil forState:UIControlStateDisabled];
            isDefaultAddress = NO;
        }
    }else{
        [setDefaultBtn setImage:[UIImage imageNamed:@"selected"] forState:UIControlStateDisabled];
        isDefaultAddress = YES;
    }
}
#pragma mark --UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        {
            [Waiting show];
            AFHTTPClient * client  = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:APIURL]];
            NSDictionary * params  = @{@"apiid": @"0014",@"gid" : [address objectForKey:@"guid"]};
            NSURLRequest * request = [client requestWithMethod:@"POST"
                                                          path:@""
                                                    parameters:params];
            AFHTTPRequestOperation * operation = [client HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
                [Waiting dismiss];//隐藏loading
                NSString *temp = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
              
                if ([temp isEqualToString:@"true"]) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadAddressList" object:nil];//刷新数据
                    [self.view makeToast:@"删除成功" duration:1.2 position:@"center"];
                    //延时1s   返回
                    [self performSelector:@selector(backTo) withObject:nil afterDelay:1.0f];
                }else{
                    [self.view makeToast:@"删除失败,请稍后重试" duration:1.2 position:@"center"];
                }
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [Waiting dismiss];//隐藏loading
                [self.view makeToast:@"请检查网络连接是否正常" duration:2.0 position:@"center"];
            }];
            [operation start];
        }
    }
}
//-----删除
-(void)deleteAddress{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"确定要删除地址吗?" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
    [alert show];
}
//-----保存
-(void)saveResult{
    if (isDefaultAddress&&![[address objectForKey:@"ck"] isEqualToString:@"1"]) {
        [Waiting show];
        AFHTTPClient * client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:APIURL]];
        NSDictionary * params = @{@"apiid": @"0016",@"aid" : [address objectForKey:@"guid"]};
        NSURLRequest * request = [client requestWithMethod:@"POST"
                                                      path:@""
                                                parameters:params];
        AFHTTPRequestOperation * operation = [client HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [Waiting dismiss];//隐藏loading
            NSString *temp = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            if ([temp isEqualToString:@"true"]) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadAddressList" object:nil];//刷新数据
                [self.view makeToast:@"保存成功" duration:1.2 position:@"center"];
                //延时0.5s   返回
                [self performSelector:@selector(backTo) withObject:nil afterDelay:1.0f];
            }else{
                [self.view makeToast:@"保存失败,请稍后重试" duration:1.2 position:@"center"];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [Waiting dismiss];//隐藏loading
            [self.view makeToast:@"请检查网络连接是否正常" duration:2.0 position:@"center"];
        }];
        [operation start];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}
//--返回
-(void)backTo{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

//-----------内存不足报警------
-(void)didReceiveMemoryWarning
{
    [[NSUserDefaults standardUserDefaults] synchronize];
    [super didReceiveMemoryWarning];
}
@end
