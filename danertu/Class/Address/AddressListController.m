//
//  KKFirstViewController.m
//  Tuan
//
//  Created by 夏 华 on 12-7-3.
//  Copyright (c) 2012年 无锡恩梯梯数据有限公司. All rights reserved.
//

#import "AddressListController.h"

#import <QuartzCore/QuartzCore.h>
#import "DetailViewController.h"

@interface AddressListController(){
    NSMutableArray *addressArray;
    UIView *noDataView;
    BOOL isAddressChange;//地址是否发生改变
}
@end

@implementation AddressListController

@synthesize defaults;
@synthesize addStatusBarHeight;
@synthesize addressView;
@synthesize payedView;
@synthesize deleteBtnView;
@synthesize deletePart;
@synthesize deleteAll;
@synthesize selectAddressTagArray;
@synthesize isEditMode;
@synthesize editLb;



@synthesize bottomNavi;
@synthesize maskView;
@synthesize selectedAddress;
@synthesize isFromOrderForm;
@synthesize prevAddressGuid;//之前收货地址的guid;
- (void)viewDidLoad
{
    [super viewDidLoad];//没有词句,会执行多次
   
    [self initView];
    [self getAddressData];//------收货地址
}

- (void)initView{
    addStatusBarHeight = [TopNaviViewController getStatusBarHeight];
    defaults =[NSUserDefaults standardUserDefaults];
    addressArray = [[NSMutableArray alloc]init];//订单----已支付
    selectAddressTagArray = [[NSMutableArray alloc] init];//初始化
    isEditMode = NO;//是否编辑模式
    isAddressChange = NO;//地址是否发生改变
    
    self.view.backgroundColor = [UIColor colorWithRed:248.0/255 green:248.0/255 blue:248.0/255 alpha:1];
    
    //没有数据显示的view,下方按钮高70
    noDataView = [[UIView alloc] initWithFrame:CGRectMake(0, TOPNAVIHEIGHT+addStatusBarHeight, MAINSCREEN_WIDTH, CONTENTHEIGHT + 49 - 70)];
    [self.view addSubview:noDataView];
    //默认隐藏
    noDataView.hidden = YES;
    int topDistance = (CONTENTHEIGHT+49-70-130)/2;
    UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(110, topDistance, 100, 100)];
    [noDataView addSubview:imgV];
    [imgV setImage:[UIImage imageNamed:@"noData"]];
    
    UILabel *textV = [[UILabel alloc] initWithFrame:CGRectMake(60, topDistance+100, 200, 30)];
    [noDataView addSubview:textV];
    textV.backgroundColor = [UIColor clearColor];
    textV.textAlignment = NSTextAlignmentCenter;
    textV.text = @"您还没有收货地址";
    
    UIView *bgLoginView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-100+40, MAINSCREEN_WIDTH, 60)];
    [self.view addSubview:bgLoginView];
    [bgLoginView setBackgroundColor:VIEWBGCOLOR];
    
    UILabel *bottom = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, MAINSCREEN_WIDTH, 1)];
    bottom.backgroundColor = BORDERCOLOR;
    [bgLoginView addSubview:bottom];
    
    //新增按钮
    UIButton *loginBtn = [[UIButton alloc]initWithFrame:CGRectMake(30,10, MAINSCREEN_WIDTH-60, 40)];//高度--44
    [bgLoginView addSubview:loginBtn];
    [loginBtn.layer setMasksToBounds:YES];
    [loginBtn.layer setCornerRadius:5];//设置矩形四个圆角半径
    
    loginBtn.backgroundColor = TOPNAVIBGCOLOR;
    [loginBtn setTitle:@"+新增收货地址" forState:UIControlStateNormal];
    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loginBtn setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [loginBtn addTarget:self action:@selector(addNewAddress) forControlEvents:UIControlEventTouchUpInside];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadAddressList:) name:@"reloadAddressList" object:nil];//和 收藏 店铺,商品之间的  通信
}

//----有新的地址,刷新数据
-(void)reloadAddressList:(NSNotification*) notification{
    [self getAddressData];
}
//-----修改标题,重写父类方法----
-(NSString*)getTitle{
    return @"我的收货地址";
}
//-------收藏店铺数据
-(void)getAddressData{
    if (addressArray.count) {
        [addressArray removeAllObjects];//移除之前的所有元素
    }
//    NSString *_userName = [MyKeyChainHelper getUserNameWithService:USERNAME_KEY];
//    NSString *_password = [MyKeyChainHelper getPasswordWithService:PASSWORD_KEY];
    NSString * userName = [[defaults objectForKey:@"userLoginInfo"] objectForKey:@"MemLoginID"];//本地存储
    if (userName.length>0) {
        [Waiting show];
        AFHTTPClient * client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:APIURL]];
        NSDictionary * params = @{@"apiid": @"0030",@"uId" : userName};
        NSURLRequest * request = [client requestWithMethod:@"POST"
                                                      path:@""
                                                parameters:params];
        AFHTTPRequestOperation * operation = [client HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [Waiting dismiss];//隐藏loading
            NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];//json解析
            NSArray* temp = [[jsonData objectForKey:@"adress"] objectForKey:@"adresslist"];//数组
            if(temp.count>0){
                addressArray = [temp mutableCopy];
                if (addressArray.count>0) {
                    noDataView.hidden = YES;
                    [self createAddressView];
                }else{
                    noDataView.hidden = NO;
                    if([addressView subviews].count>0){
                        [addressView removeFromSuperview];
                    }
                }
            }else{
                noDataView.hidden = NO;
                if([addressView subviews].count>0){
                    [addressView removeFromSuperview];
                }
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [Waiting dismiss];//隐藏loading
            [self.view makeToast:@"请检查网络连接是否正常" duration:2.0 position:@"center"];
        }];
        [operation start];
    }else{
        [self.view makeToast:@"请登录" duration:1.2 position:@"center"];
    }
}

- (void)createAddressView{
    int arraysCount = (int)addressArray.count;
    [addressView removeFromSuperview];
    
    //------店铺视图
    addressView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, TOPNAVIHEIGHT+addStatusBarHeight, self.view.frame.size.width, self.view.frame.size.height-TOPNAVIHEIGHT-addStatusBarHeight-100+40)];//上半部分
    addressView.showsVerticalScrollIndicator = NO;
    addressView.userInteractionEnabled = YES;
    //默认设置可以滑动
    addressView.contentSize =  CGSizeMake(self.view.frame.size.width, ADDRESSLIST_ITEMHEIGHT*arraysCount);
    [self.view addSubview:addressView];
    
    int i=0;
    int defaultAddrIndex = arraysCount - 1;
    //------是否有默认收货地址-----
    BOOL isHaveDefaultAddress = NO;
    for(NSDictionary *item in addressArray) {
        if([[item objectForKey:@"ck"] isEqualToString:@"1"]){
            isHaveDefaultAddress = YES;
            break;
        }
    }
    for(NSDictionary *item in addressArray) {
        //-------空出第一个位置留个默认------
        int indexItem = i;
        if (isHaveDefaultAddress) {
            if([[item objectForKey:@"ck"] isEqualToString:@"1"]){
                defaultAddrIndex = i;
            }else{
                if (i<defaultAddrIndex) {
                    indexItem = i+1;
                }
            }
        }
        UIView *frameImageView = [[UIView alloc] initWithFrame:CGRectMake(0, ADDRESSLIST_ITEMHEIGHT * (indexItem), MAINSCREEN_WIDTH, ADDRESSLIST_ITEMHEIGHT)];
        //[frameImageView setImage:[UIImage imageNamed:@"tab-mask.png"]];
        [frameImageView setBackgroundColor:[UIColor whiteColor]];
        [addressView addSubview:frameImageView];
        frameImageView.userInteractionEnabled = YES;
        frameImageView.tag = 100 + i;
        UITapGestureRecognizer *singleTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(managerAddress:)];
        [frameImageView addGestureRecognizer:singleTap];//---添加点击事件
        //----姓名
        UILabel *nameValue = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 150, 30)];
        [frameImageView addSubview:nameValue];
        nameValue.backgroundColor = [UIColor clearColor];
        nameValue.textAlignment = NSTextAlignmentLeft;
        nameValue.text = [item objectForKey:@"name"];//------公共使用订单编
        
        //----电话
        UILabel *priceValue = [[UILabel alloc] initWithFrame:CGRectMake(MAINSCREEN_WIDTH / 2.0, 1, 150, 30)];
        [frameImageView addSubview:priceValue];
        priceValue.backgroundColor = [UIColor clearColor];
        priceValue.textAlignment = NSTextAlignmentLeft;
        priceValue.font = TEXTFONT;
        priceValue.text = [item objectForKey:@"mobile"];
        
        
        UIImageView *chevronImage = [[UIImageView alloc] initWithFrame:CGRectMake(MAINSCREEN_WIDTH - 25, 25, 10, 15)];
        [frameImageView addSubview:chevronImage];
        [chevronImage setImage:[UIImage imageNamed:@"chevron_right"]];
        
        
        //----地址
        UILabel *contentValue = [[UILabel alloc] initWithFrame:CGRectMake(10, 30, 300-40, 40)];
        [frameImageView addSubview:contentValue];
        contentValue.backgroundColor = [UIColor clearColor];
        contentValue.textAlignment = NSTextAlignmentLeft;
        contentValue.numberOfLines = 2;
        contentValue.font = TEXTFONT;
        contentValue.text = [item objectForKey:@"adress"];
        i++;//----------butto--tag
        //-------当前的不一定是默认收货地址-------只出现在订单----
        if (isFromOrderForm&&[prevAddressGuid isEqualToString:[item objectForKey:@"guid"]]) {
            UIImageView *selectView = [[UIImageView alloc]initWithFrame:CGRectMake(300, 10, 20, 15)];
            selectView.accessibilityValue = @"default";//----区别其他imageview
            [selectView setImage:[UIImage imageNamed:@"select"]];
            [frameImageView addSubview:selectView];

        }
        //------默认地址的选中图标
        if([[item objectForKey:@"ck"] isEqualToString:@"1"]){
            selectedAddress = [item copy];
            frameImageView.frame = CGRectMake(0, 0, MAINSCREEN_WIDTH, ADDRESSLIST_ITEMHEIGHT);
            UIFont *font =  [UIFont fontWithName:@"Helvetica-Bold" size:14];
            CGSize titleSize = [@"[默认]" sizeWithFont:font constrainedToSize:CGSizeMake(MAXFLOAT, 30)];
            UILabel *defaultTextLb = [[UILabel alloc] initWithFrame:CGRectMake(10, 30, titleSize.width, 40)];
            [frameImageView addSubview:defaultTextLb];
            defaultTextLb.text = @"[默认]";
            defaultTextLb.font = font;
            defaultTextLb.textColor = [UIColor redColor];
            double leftWidth = defaultTextLb.frame.origin.x+titleSize.width;
            contentValue.frame = CGRectMake(leftWidth, 30, 300-leftWidth - 40, 40);
            /*
            UIImageView *selectView = [[UIImageView alloc]initWithFrame:CGRectMake(300, 10, 20, 19)];
            selectView.accessibilityValue = @"default";//----区别其他imageview
            [selectView setImage:[UIImage imageNamed:@"select"]];
            [frameImageView addSubview:selectView];
            */
        }
        //底线
        UILabel *bottom = [[UILabel alloc] initWithFrame:CGRectMake(0, 79-10, 320, 1)];
        bottom.backgroundColor = BORDERCOLOR;
        [frameImageView addSubview:bottom];
    }
}
//----新加地址-----
- (void)addNewAddress{
    
    AddressNewController *newV = [[AddressNewController alloc] init];
    newV.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:newV animated:YES];
}
//----消失前
-(void)viewWillDisappear:(BOOL)animated{
    //----来自订单---发送通知----收货地址-
    if (isFromOrderForm&&prevAddressGuid&&![prevAddressGuid isEqualToString:[selectedAddress objectForKey:@"guid"]]&&selectedAddress) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"getNewDefaultAddress" object:nil userInfo:selectedAddress];//刷新数据
    }
}
//----地址管理-----
- (void)managerAddress:(id)sender{
    int tag = (int)[[sender view] tag]- 100;
    selectedAddress = addressArray[tag];
    if (isFromOrderForm) {
        if([[selectedAddress objectForKey:@"ck"] isEqualToString:@"1"]){
            //延时0.5s   返回,------已经是默认不要处理了
            [self backTo];
            isAddressChange = NO;
        }else{
            [self backTo];
            isAddressChange = YES;
            //这里要更换默认城市
        }
    }else{
        
        AddressManagerController *newV = [[AddressManagerController alloc] init];
        newV.hidesBottomBarWhenPushed = YES;
        newV.address =  selectedAddress;
        [self.navigationController pushViewController:newV animated:YES];
    }
}

//返回
-(void)backTo{
    [self.navigationController popViewControllerAnimated:YES];
}
//-----------内存不足报警------
-(void)didReceiveMemoryWarning
{
    [[NSUserDefaults standardUserDefaults] synchronize];
    [super didReceiveMemoryWarning];
}
@end
