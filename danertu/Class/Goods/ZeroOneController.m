//
//  DetailViewController.m
//  Tuan
//
//  Created by 夏 华 on 12-7-4.
//  Copyright (c) 2012年 无锡恩梯梯数据有限公司. All rights reserved.
//
//-----商品详细页----
#import "ZeroOneController.h"
#import <QuartzCore/QuartzCore.h>
#import "UIImageView+WebCache.h"

@interface ZeroOneController (){
    NSMutableArray *arrays;
}

@end

@implementation ZeroOneController
@synthesize dataArray;
@synthesize defaults;
@synthesize addStatusBarHeight;
@synthesize woodsTotal;
@synthesize woodsType;

@synthesize woodsName,woodsGoal;
@synthesize woodInfo;
@synthesize activityMobile;
- (void)loadView
{
    [super loadView];
    // If you create your views manually, you MUST override this method and use it to create your views.
    // If you use Interface Builder to create your views, then you must NOT override this method.
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initView];    //初始化视图
}

//视图的初始化
- (void)initView
{
//    [Waiting show];//loading  显示
    defaults =[NSUserDefaults standardUserDefaults];
    arrays = [[NSMutableArray alloc] init];//初始化
    
    self.navigationController.navigationBar.hidden = YES;
    addStatusBarHeight = [TopNaviViewController getStatusBarHeight];
    
    int scrollH = 550;//可滑动区域
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, TOPNAVIHEIGHT+addStatusBarHeight, self.view.frame.size.width, CONTENTHEIGHT+49)];//上半部分
    scrollView.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:.9 alpha:1];
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.contentSize = CGSizeMake(self.view.frame.size.width, scrollH);//staticPart高度
    [self.view addSubview:scrollView];
    
    //上半部分
    UIView *staticPart = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MAINSCREEN_WIDTH, scrollH)];
    staticPart.backgroundColor = [UIColor whiteColor];
    staticPart.userInteractionEnabled = YES;
    [scrollView addSubview:staticPart];
    
    UIImageView *danertuItem = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, MAINSCREEN_WIDTH, 300)];
    [staticPart addSubview:danertuItem];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, 300, 299.4)];
    
    //这里加判断如果可以就去下载图片
    NSURL *imageUrl = [NSURL URLWithString:[woodInfo objectForKey:@"img"]];
    [imageView sd_setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"noData"]];
    //}
    [danertuItem addSubview:imageView];//添加大图片点击事件
    UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(0, 299.4, MAINSCREEN_WIDTH, 0.6)];
    line.backgroundColor = [UIColor orangeColor];
    [danertuItem addSubview:line];
    
    //商品名称
    UIView *nameTmp = [[UIView alloc] initWithFrame:CGRectMake(0, 300, MAINSCREEN_WIDTH, 50)];
    [staticPart addSubview:nameTmp];
    UILabel *nameText = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 80, 50)];
    nameText.textAlignment = NSTextAlignmentRight;
    nameText.font = [UIFont systemFontOfSize:16];
    nameText.textColor = [UIColor grayColor];
    [nameTmp addSubview:nameText];
    nameText.text = @"商品名称:";
    
    woodsName = [[UILabel alloc] initWithFrame:CGRectMake(100, 0, 210, 50)];
    [nameTmp addSubview:woodsName];
    woodsName.textAlignment = NSTextAlignmentLeft;
    woodsName.font = [UIFont systemFontOfSize:16];
    woodsName.numberOfLines = 2;
    woodsName.text = [woodInfo objectForKey:@"name"];
    
    
    //商品售价
    UIView *priceTmp = [[UIView alloc] initWithFrame:CGRectMake(0, 350, MAINSCREEN_WIDTH, 25)];
    [staticPart addSubview:priceTmp];
    UILabel *priceText = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 80, 25)];
    [priceTmp addSubview:priceText];
    priceText.textAlignment = NSTextAlignmentRight;
    priceText.font = [UIFont systemFontOfSize:16];
    priceText.textColor = [UIColor grayColor];
    priceText.text = @"单       价:";
    
    UILabel *priceSign = [[UILabel alloc] initWithFrame:CGRectMake(100, 0, 200, 25)];
    [priceTmp addSubview:priceSign];
    priceSign.textAlignment = NSTextAlignmentLeft;
    priceSign.font = [UIFont systemFontOfSize:16];
    priceSign.text = [NSString stringWithFormat:@"¥ %@",[woodInfo objectForKey:@"price"]];
    
    //商品数量
    UILabel *numTmp = [[UILabel alloc] initWithFrame:CGRectMake(0, 350 + 25 * 1, MAINSCREEN_WIDTH, 25)];
    numTmp.userInteractionEnabled = YES;//暂时不能使用输入数字
    [staticPart addSubview:numTmp];
    UILabel *numText = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 80, 25)];
    numText.textAlignment = NSTextAlignmentRight;
    numText.font = [UIFont systemFontOfSize:16];
    numText.textColor = [UIColor grayColor];
    [numTmp addSubview:numText];
    numText.text = @"数       量:";
    
    UILabel *woodsNum = [[UILabel alloc] initWithFrame:CGRectMake(100, 0, 80, 25)];//高度--44
    [numTmp addSubview:woodsNum];
    woodsNum.text = @"1";
    
    //总价
    UIView *totalTmp = [[UIView alloc] initWithFrame:CGRectMake(0, 350 + 25 * 2, MAINSCREEN_WIDTH, 25)];
    [staticPart addSubview:totalTmp];
    UILabel *totalText = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 80, 25)];
    totalText.textAlignment = NSTextAlignmentRight;
    totalText.font = [UIFont systemFontOfSize:16];
    totalText.textColor = [UIColor grayColor];
    [totalTmp addSubview:totalText];
    totalText.text = @"总       价:";
    
    woodsTotal = [[UILabel alloc] initWithFrame:CGRectMake(100, 0, 200, 25)];
    [totalTmp addSubview:woodsTotal];
    woodsTotal.textAlignment = NSTextAlignmentLeft;
    woodsTotal.font = [UIFont systemFontOfSize:16];
    woodsTotal.textColor = [UIColor redColor];
    woodsTotal.text = [NSString stringWithFormat:@"¥ %@",[woodInfo objectForKey:@"price"]];
    
    //商品评分
    UIView *goalTmp = [[UIView alloc] initWithFrame:CGRectMake(0, 350+25*4, MAINSCREEN_WIDTH, 24)];
    [staticPart addSubview:goalTmp];
    UILabel *goalText = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 300, 25)];
    goalText.textAlignment = NSTextAlignmentLeft;
    goalText.font = TEXTFONT;
    goalText.textColor = [UIColor redColor];
    [goalTmp addSubview:goalText];
    goalText.text = @"(备注:此商品为活动商品,请尽快下单结算)";
    
    //border
    UILabel *border = [[UILabel alloc] initWithFrame:CGRectMake(0, 350+25*5-1, MAINSCREEN_WIDTH, 0.8)];
    border.backgroundColor = [UIColor grayColor];
    [staticPart addSubview: border];
    
    //导航,电话
    UIView *naviTel = [[UIView alloc] initWithFrame:CGRectMake(0, 490, MAINSCREEN_WIDTH, 50)];
    naviTel.userInteractionEnabled = YES;
    [staticPart addSubview:naviTel];//
    
    //按钮
    //加入购物车
    UIButton *addToShopList = [[UIButton alloc]initWithFrame:CGRectMake(5, 5, 150, 35)];
    [naviTel addSubview:addToShopList];
    [addToShopList.layer setMasksToBounds:YES];
    [addToShopList.layer setCornerRadius:10.0];//设置矩形四个圆角半径
    [addToShopList setTitle:@"下单结算" forState:UIControlStateNormal];
    addToShopList.titleLabel.font = [UIFont systemFontOfSize:14];
    addToShopList.backgroundColor = TOPNAVIBGCOLOR;
    [addToShopList setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [addToShopList setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [addToShopList addTarget:self action:@selector(goToPay) forControlEvents:UIControlEventTouchUpInside];
    //电话订购
    UIButton *telBtn = [[UIButton alloc]initWithFrame:CGRectMake(165, 5, 150, 35)];
    [naviTel addSubview:telBtn];
    [telBtn.layer setMasksToBounds:YES];
    [telBtn.layer setCornerRadius:10.0];//设置矩形四个圆角半径
    [telBtn setTitle:@"电话咨询" forState:UIControlStateNormal];
    telBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    telBtn.backgroundColor = TOPNAVIBGCOLOR;
    [telBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [telBtn setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [telBtn addTarget:self action:@selector(dialPhone) forControlEvents:UIControlEventTouchUpInside];
}

//-----获得商品详情数据----
-(void)getGoodsInfo{
    
}
//-----购买评论
- (void)showComment{
    [self performSegueWithIdentifier:@"commentView" sender:self];
}
//--重新父类方法
-(NSString *)getTitle{
    return @"活动特惠商品";
}
//--重新父类方法
-(void)backToHome{
    [self.navigationController popViewControllerAnimated:NO];
}
//----下单支付
-(void)goToPay{
    NSDictionary *userLoginInfo = [defaults objectForKey:@"userLoginInfo"];
    //登录是否才能下单
    if([userLoginInfo objectForKey:@"MemLoginID"]){
        if ([[woodInfo objectForKey:@"activityName"] isEqualToString:ACTIVITY_ONEYUAN]) {
            if ([[woodInfo objectForKey:@"clickIsValid"] isEqualToString:@"1"]) {
                //----当前是一元秒杀活动,并且未到活动时间
                [self.view makeToast:@"活动未到时间或返回首页重新进入活动页面" duration:1.2 position:@"center"];
            }else{
                [self isHaveProductToOrder];
            }
        }else if([[woodInfo objectForKey:@"activityName"] isEqualToString:ACTIVITY_ZEROONE]){
            
            OrderFormController *orderV = [[OrderFormController alloc] init];
            orderV.hidesBottomBarWhenPushed = YES;
            orderV.isFromActivity = YES;
            orderV.activityWood = woodInfo;
            [self.navigationController pushViewController:orderV animated:YES];
        }
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:[NSString stringWithFormat:@"下单前请登录"] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil];
        [alert addButtonWithTitle:@"登录"];
        [alert setTag:2];
        [alert show];
        
    }
}

//是否有库存
-(void)isHaveProductToOrder{
    [Waiting show];
    AFHTTPClient * client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:APIURL]];
    NSDictionary * params = @{@"apiid": @"0086",@"proguid" :[woodInfo objectForKey:@"Guid"]};
    NSURLRequest * request = [client requestWithMethod:@"POST"
                                                  path:@""
                                            parameters:params];
    AFHTTPRequestOperation * operation = [client HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [Waiting dismiss];//隐藏loading
        NSString* temp = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        int woodNum = [temp intValue];
        if(woodNum>0){
            OrderFormController *orderV = [[OrderFormController alloc] init];
            orderV.hidesBottomBarWhenPushed = YES;
            orderV.isFromActivity = YES;
            orderV.activityWood = woodInfo;
            [self.navigationController pushViewController:orderV animated:YES];
        }else{
            [self showHint:@"来晚一步,商品被抢光了!"];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [Waiting dismiss];//隐藏loading
        [self.view makeToast:@"请检查网络连接是否正常" duration:2.0 position:@"center"];
    }];
    [operation start];
}

//--拨打电话
-(void)dialPhone{
    NSString *tel = [woodInfo objectForKey:@"contactTel"];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:[NSString stringWithFormat:@"店铺电话:%@",tel] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil];
    // optional - add more buttons:
    [alert addButtonWithTitle:@"拨打"];
    [alert setTag:12];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if ([alertView tag] == 12 ) {    // it's the Error alert
        NSString *telUrl = [NSString stringWithFormat:@"tel://%@",[woodInfo objectForKey:@"contactTel"]];
        if(buttonIndex==1){
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:telUrl]];
        }
    }else if([alertView tag] ==2 ){
        //---是否去登陆
        if(buttonIndex==1){
            
            [self performSegueWithIdentifier:@"login" sender:self];
        }
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"login"]) {
        LoginViewController *loginView = [segue destinationViewController];
        loginView.hidesBottomBarWhenPushed = YES;
    }
}

//-----------内存不足报警------
-(void)didReceiveMemoryWarning
{
    [[NSUserDefaults standardUserDefaults] synchronize];
    [super didReceiveMemoryWarning];
}


-(void)dealloc
{
    
}
@end
