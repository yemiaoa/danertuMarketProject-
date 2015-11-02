//
//  WebViewController.m
//  Tuan
//
//  Created by 夏 华 on 12-7-6.
//  Copyright (c) 2012年 无锡恩梯梯数据有限公司. All rights reserved.
//
#import "AddressNewController.h"
@interface AddressNewController()
{
    UIView *datePickerView;
    UIPickerView *datePicker;
    
    NSDictionary *pickerDic;
    NSArray *provinceArray;
    NSArray *cityArray;
    NSArray *townArray;
    NSArray *selectedArray;
    BOOL isPickerShow;
}
@end
@implementation AddressNewController
@synthesize addStatusBarHeight;
@synthesize setDefaultBtn;
@synthesize isDefaultAddress;
@synthesize userName;
@synthesize telphone;
@synthesize preAddress;
@synthesize address;
@synthesize defaults;
@synthesize isFromOrderForm;

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
    [self getPickerData];
}

//-----修改标题,重写父类方法----
-(NSString*)getTitle{
    return @"新增收货地址";
}

//--返回
-(void)backTo{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)initView{
    
    defaults =[NSUserDefaults standardUserDefaults];
    addStatusBarHeight = [TopNaviViewController getStatusBarHeight] + TOPNAVIHEIGHT;
    self.view.backgroundColor = [UIColor whiteColor];
    isDefaultAddress = NO;
    
    NSArray *textArr = @[@"姓名:",@"电话:",@"地区:",@"地址:"];
    for (NSInteger i = 0; i< textArr.count; i++) {
        UILabel *nameLb = [[UILabel alloc] initWithFrame:CGRectMake(10, addStatusBarHeight + 50 * i, 50, 50)];
        [self.view addSubview:nameLb];
        nameLb.text = textArr[i];
    }
    
    userName = [[UITextField alloc] initWithFrame:CGRectMake(55, addStatusBarHeight, 250, 49)];//高度--44
    [self.view addSubview:userName];
    userName.delegate = self;
    userName.placeholder = @"请输入至少2个字";
    userName.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;;
    userName.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    UILabel *border1 = [[UILabel alloc] initWithFrame:CGRectMake(0, addStatusBarHeight + 48, MAINSCREEN_WIDTH,  0.7)];
    [self.view addSubview:border1];
    border1.backgroundColor = BORDERCOLOR;
    
    telphone = [[UITextField alloc] initWithFrame:CGRectMake(55, addStatusBarHeight + 50, 250, 49)];
    [self.view addSubview:telphone];
    telphone.delegate = self;
    telphone.placeholder = @"请输入手机号码";
    telphone.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;;
    telphone.clearButtonMode = UITextFieldViewModeWhileEditing;
    telphone.keyboardType = UIKeyboardTypeNumberPad;
    
    UILabel *border2 = [[UILabel alloc] initWithFrame:CGRectMake(0, addStatusBarHeight + 98, MAINSCREEN_WIDTH,  0.7)];
    [self.view addSubview:border2];
    border2.backgroundColor = BORDERCOLOR;
    
    preAddress = [[UILabel alloc] initWithFrame:CGRectMake(55, addStatusBarHeight + 100, MAINSCREEN_WIDTH-50, 49)];
    [self.view addSubview:preAddress];
    preAddress.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tapAddress = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showPicker)];
    [preAddress addGestureRecognizer:tapAddress];
    
    UIImageView *chevronImage = [[UIImageView alloc] initWithFrame:CGRectMake(MAINSCREEN_WIDTH - 20, addStatusBarHeight + 100 + 17, 10, 15)];
    [self.view addSubview:chevronImage];
    [chevronImage setBackgroundColor:[UIColor clearColor]];
    [chevronImage setImage:[UIImage imageNamed:@"chevron_right"]];
    
    UILabel *border3 = [[UILabel alloc] initWithFrame:CGRectMake(0, addStatusBarHeight + 148, MAINSCREEN_WIDTH,  0.7)];
    [self.view addSubview:border3];
    border3.backgroundColor = BORDERCOLOR;
    
    address = [[UITextField alloc] initWithFrame:CGRectMake(55, addStatusBarHeight + 150, 250, 49)];//高度--44
    [self.view addSubview:address];
    address.delegate = self;
    address.placeholder = @"请输入详细地址";
    address.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;;
    address.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    UILabel *border4 = [[UILabel alloc] initWithFrame:CGRectMake(0, addStatusBarHeight + 199, MAINSCREEN_WIDTH, 0.7)];
    [self.view addSubview:border4];
    border4.backgroundColor = BORDERCOLOR;
    
    //---------修改默认收货地址--------
    UIView *setDefaultV = [[UIView alloc] initWithFrame:CGRectMake( 0,addStatusBarHeight + 200, 240, 50)];
    [self.view addSubview:setDefaultV];
    setDefaultV.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeDefault)];
    [setDefaultV addGestureRecognizer:tap];
    //------是否直接来自orderform---如果没有地址,提交订单时,就会直接过来
    if (!isFromOrderForm) {
        //选择框
        setDefaultBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 15, 20, 20)];
        [setDefaultV addSubview:setDefaultBtn];
        setDefaultBtn.layer.cornerRadius = 2;
        setDefaultBtn.layer.borderColor = [UIColor grayColor].CGColor;
        [setDefaultBtn.layer setBorderWidth:0.6];
        setDefaultBtn.enabled = NO;
        setDefaultBtn.backgroundColor = [UIColor clearColor];
        
        //文字
        UILabel *nameLb = [[UILabel alloc] initWithFrame:CGRectMake(40, 10, 200, 30)];
        [setDefaultV addSubview:nameLb];
        nameLb.backgroundColor = [UIColor clearColor];
        nameLb.text = @"设置成默认收货地址";
    }
    //新增按钮
    UIButton *loginBtn = [[UIButton alloc]initWithFrame:CGRectMake(30, self.view.frame.size.height-100+50, MAINSCREEN_WIDTH-60, 40)];//高度--44
    [self.view addSubview:loginBtn];
    [loginBtn.layer setMasksToBounds:YES];
    [loginBtn.layer setCornerRadius:5];//设置矩形四个圆角半径
    
    loginBtn.backgroundColor = TOPNAVIBGCOLOR;
    [loginBtn setTitle:@"保  存" forState:UIControlStateNormal];
    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loginBtn setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [loginBtn addTarget:self action:@selector(addNewAddress) forControlEvents:UIControlEventTouchUpInside];
    
    
    datePickerView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 210 + 210, MAINSCREEN_WIDTH, 210)];
    [datePickerView setBackgroundColor:[UIColor whiteColor]];
    
    //按钮视图
    UIView *btnView = [[UIView alloc] initWithFrame:CGRectMake(0, 5, MAINSCREEN_WIDTH, 40)];
    [datePickerView addSubview:btnView];
    btnView.backgroundColor = [UIColor colorWithRed:242.0/255 green:242.0/255 blue:242.0/255 alpha:1];
    //取消
    UIButton *cancleBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 0, 60, 40)];
    [btnView addSubview:cancleBtn];
    [cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancleBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [cancleBtn addTarget:self action:@selector(hidePicker) forControlEvents:UIControlEventTouchUpInside];
    //确定
    UIButton *confirmBtn = [[UIButton alloc] initWithFrame:CGRectMake(MAINSCREEN_WIDTH-70, 0, 60, 40)];
    [btnView addSubview:confirmBtn];
    [confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
    [confirmBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [confirmBtn addTarget:self action:@selector(okClickButton) forControlEvents:UIControlEventTouchUpInside];
    
    datePicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 50, MAINSCREEN_WIDTH, 200)];
    [datePickerView addSubview:datePicker];
    datePicker.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    datePicker.dataSource = self;
    datePicker.delegate   = self;
    isPickerShow = NO;
    
    //点击空白处关闭键盘
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeKeyboard)];
    tapGes.numberOfTapsRequired = 1;
    tapGes.numberOfTouchesRequired = 1;
    [self.view addGestureRecognizer:tapGes];
}

//-----是否设为默认收货地址
-(void)changeDefault{
    if (isDefaultAddress) {
        [setDefaultBtn setImage:nil forState:UIControlStateDisabled];
        isDefaultAddress = NO;
    }else{
        [setDefaultBtn setImage:[UIImage imageNamed:@"selected"] forState:UIControlStateDisabled];
        isDefaultAddress = YES;
    }
}

-(void)addNewAddress{
    NSString *userNameVal = userName.text;
    NSString *telphoneVal = telphone.text;
    NSString *addressVal = address.text;
    NSString * regex_userName = @"^1[3|4|5|8|6][0-9][0-9]{8}$";//手机号
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex_userName];
    if (userNameVal.length<2) {
        [userName becomeFirstResponder];//获取焦点
        [self.view makeToast:@"姓名至少两个字" duration:2.0 position:@"center"];
    }else if(![pred evaluateWithObject:telphoneVal]){
        [telphone becomeFirstResponder];//获取焦点
        [self.view makeToast:@"请填写正确手机号" duration:2.0 position:@"center"];
    }else if(addressVal.length<6 || [preAddress.text isEqualToString:@""]){
        [address becomeFirstResponder];//获取焦点
        [self.view makeToast:@"请填写正确地址" duration:2.0 position:@"center"];
    }else{
        [Waiting show];
        NSString *isDefault = @"";
        if (isFromOrderForm||isDefaultAddress) {
            isDefault = @"1";
        }else{
            isDefault = @"0";
        }
        AFHTTPClient * client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:APIURL]];
        NSDictionary * params = @{@"apiid": @"0015",@"uId" : [[defaults objectForKey:@"userLoginInfo"] objectForKey:@"MemLoginID"],@"name":userName.text,@"adress":[NSString stringWithFormat:@"%@%@",preAddress.text,address.text],@"mobile":telphone.text,@"isdefault":isDefault};
        NSURLRequest * request = [client requestWithMethod:@"POST"
                                                      path:@""
                                                parameters:params];
        AFHTTPRequestOperation * operation = [client HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [Waiting dismiss];//隐藏loading
            NSString *temp = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
         
            if ([temp isEqualToString:@"true"]) {
                if (isFromOrderForm) {
                    //发个orderform
                    NSDictionary *addressDic = @{@"name":userName.text,@"mobile":telphone.text,@"adress":address.text};
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"getNewDefaultAddress" object:nil userInfo:addressDic];
                }else{
                    //发个addressmanager
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadAddressList" object:nil];//刷新数据
                }
                
                [self.view makeToast:@"添加成功" duration:1.2 position:@"center"];
                //延时0.5s   返回
                [self performSelector:@selector(backTo) withObject:nil afterDelay:1.0f];
            }else{
                [self.view makeToast:@"添加失败,请稍后重试" duration:1.2 position:@"center"];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [Waiting dismiss];//隐藏loading
            [self.view makeToast:@"请检查网络连接是否正常" duration:2.0 position:@"center"];
        }];
        [operation start];
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    // i0S6 UITextField的bug
    if (!textField.window.isKeyWindow) {
        [textField.window makeKeyAndVisible];
    }
}

- (void)okClickButton{
    [self hidePicker];

    [preAddress setText:[NSString stringWithFormat:@"%@%@%@",[provinceArray objectAtIndex:[datePicker selectedRowInComponent:0]],[cityArray objectAtIndex:[datePicker selectedRowInComponent:1]],[townArray objectAtIndex:[datePicker selectedRowInComponent:2]]]];
}

- (void)showPicker{
    //先隐藏键盘
    if ([preAddress isFirstResponder]) {
        [preAddress resignFirstResponder];
    }else if ([userName isFirstResponder]){
        [userName resignFirstResponder];
    }else if ([telphone isFirstResponder]){
        [telphone resignFirstResponder];
    }else if ([address isFirstResponder]){
        [address resignFirstResponder];
    }
    
    [self.view addSubview:datePickerView];
    isPickerShow = YES;
    [UIView animateWithDuration:0.3 animations:^{
        [datePickerView setFrame:CGRectMake(0, self.view.frame.size.height - 210, MAINSCREEN_WIDTH, 210)];
    }];
}

- (void)hidePicker{
    isPickerShow = NO;
    [UIView animateWithDuration:0.3 animations:^{
        [datePickerView setFrame:CGRectMake(0, self.view.frame.size.height, MAINSCREEN_WIDTH, 210)];
    } completion:^(BOOL finished) {
        [datePickerView removeFromSuperview];
    }];
    
}

- (void)getPickerData {
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Address" ofType:@"plist"];
    pickerDic = [[NSDictionary alloc] initWithContentsOfFile:path];
    provinceArray = [pickerDic allKeys];
    selectedArray = [pickerDic objectForKey:[[pickerDic allKeys] objectAtIndex:0]];
    
    if (selectedArray.count > 0) {
       cityArray = [[selectedArray objectAtIndex:0] allKeys];
    }
    
    if (cityArray.count > 0) {
        townArray = [[selectedArray objectAtIndex:0] objectForKey:[cityArray objectAtIndex:0]];
    }
    
}

#pragma mark - UIPicker Delegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return provinceArray.count;
    } else if (component == 1) {
        return cityArray.count;
    } else {
        return townArray.count;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (component == 0) {
        return [provinceArray objectAtIndex:row];
    } else if (component == 1) {
        return [cityArray objectAtIndex:row];
    } else {
        return [townArray objectAtIndex:row];
    }
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    if (component == 0) {
        return 110;
    } else if (component == 1) {
        return 100;
    } else {
        return 110;
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (component == 0) {
        selectedArray = [pickerDic objectForKey:[provinceArray objectAtIndex:row]];
        if (selectedArray.count > 0) {
            cityArray = [[selectedArray objectAtIndex:0] allKeys];
        } else {
            cityArray = nil;
        }
        if (cityArray.count > 0) {
            townArray = [[selectedArray objectAtIndex:0] objectForKey:[cityArray objectAtIndex:0]];
        } else {
            townArray = nil;
        }
    }
    [pickerView selectedRowInComponent:1];
    [pickerView reloadComponent:1];
    [pickerView selectedRowInComponent:2];
    
    if (component == 1) {
        if (selectedArray.count > 0 && cityArray.count > 0) {
            townArray = [[selectedArray objectAtIndex:0] objectForKey:[cityArray objectAtIndex:row]];
        } else {
            townArray = nil;
        }
        [pickerView selectRow:1 inComponent:2 animated:YES];
    }
    
    [pickerView reloadComponent:2];
}

- (void)closeKeyboard{
    
    if ([preAddress isFirstResponder]) {
        [preAddress resignFirstResponder];
    }else if ([userName isFirstResponder]){
        [userName resignFirstResponder];
    }else if ([telphone isFirstResponder]){
        [telphone resignFirstResponder];
    }else if ([address isFirstResponder]){
        [address resignFirstResponder];
    }
    
    if (isPickerShow) {
        [self hidePicker];
    }
}

//-----------内存不足报警------
-(void)didReceiveMemoryWarning
{
    [[NSUserDefaults standardUserDefaults] synchronize];
    [super didReceiveMemoryWarning];
}
@end
