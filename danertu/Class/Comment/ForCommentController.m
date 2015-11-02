//
//  KKFirstViewController.m
//  Tuan
//
//  Created by 夏 华 on 12-7-3.
//  Copyright (c) 2012年 无锡恩梯梯数据有限公司. All rights reserved.
//
/*
 已经弃用
 */
#import "ForCommentController.h"

#import <QuartzCore/QuartzCore.h>
#import "DetailViewController.h"
#import "UIImageView+WebCache.h"

@interface ForCommentController (){
    NSMutableArray *addressArray;
}
@end

@implementation ForCommentController

@synthesize woodsView;
@synthesize cachedImage;
@synthesize defaults;
@synthesize backHomeIcon;
@synthesize addStatusBarHeight;
@synthesize addressView;
@synthesize payedView;
@synthesize selectAddressTagArray;
@synthesize backHomeTemp;
@synthesize isEditMode;

@synthesize userName;
@synthesize mobile;
@synthesize address;
@synthesize bottomNavi;
@synthesize maskView;
- (void)viewDidLoad
{
    addStatusBarHeight = STATUSBAR_HEIGHT;
    defaults =[NSUserDefaults standardUserDefaults];
    addressArray = [[NSMutableArray alloc]init];//订单----已支付
    selectAddressTagArray = [[NSMutableArray alloc] init];//初始化
    isEditMode = NO;//是否编辑模式
    NSLog(@"fjoefjeowgjoig---------%@----",[defaults objectForKey:@"PayedOrderList"]);
    
    [super viewDidLoad];//没有词句,会执行多次
    NSLog(@"jfoiwjfoiewjgoewj-----12");
    //--ios7 or later  添加 bar
    if (iOS7) {
        UILabel *addStatusBar = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, MAINSCREEN_WIDTH, 20)];
        addStatusBar.backgroundColor = [UIColor blackColor];
        [self.view addSubview:addStatusBar];
    }
    UIView *topNavi = [[UIView alloc]initWithFrame:CGRectMake(0, 0+addStatusBarHeight, MAINSCREEN_WIDTH, 74)];
    topNavi.backgroundColor = [UIColor colorWithRed:0.9 green:0.9  blue:0.9 alpha:1];
    topNavi.userInteractionEnabled = YES;
    [self.view addSubview:topNavi];
    //线条
    UILabel *borderLine = [[UILabel alloc] initWithFrame:CGRectMake(0, 43, MAINSCREEN_WIDTH, 1)];
    borderLine.backgroundColor = [UIColor orangeColor];
    [topNavi addSubview:borderLine];
    
    //----退回到上一页,temp扩大热区
    backHomeTemp = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 60, 44)];
    backHomeTemp.userInteractionEnabled = YES;
    backHomeTemp.backgroundColor = [UIColor clearColor];
    UITapGestureRecognizer *singleTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onClickBack)];
    [backHomeTemp addGestureRecognizer:singleTap];//---添加点击事件
    [topNavi addSubview:backHomeTemp];
    backHomeIcon = [[UIImageView alloc]initWithFrame:CGRectMake(10, 15, 15, 15)];
    backHomeIcon.image = [UIImage imageNamed:@"carat-l-orange"];
    backHomeIcon.userInteractionEnabled = YES;
    [backHomeTemp addSubview:backHomeIcon];
    //标题
    UILabel *addressTitle = [[UILabel alloc]initWithFrame:CGRectMake(60, 0, 200, 44)];
    [topNavi addSubview:addressTitle];
    addressTitle.text = @"待评论";
    addressTitle.textAlignment = NSTextAlignmentCenter;
    addressTitle.backgroundColor = [UIColor clearColor];

    //----隐藏首页的  城市按钮
    NSLog(@"bnreoibroejgoire------%f---%f",self.navigationController.view.frame.size.width,self.navigationController.view.frame.size.height);
    /*
    if (iOS7) {
        self.navigationController.navigationBar.frame = CGRectMake(0, 20, MAINSCREEN_WIDTH, 44);
    }
     */
    cachedImage = [NSMutableDictionary dictionary];
    self.view.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];


    [self createAddressView];//------未支付订单
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadAddressList:) name:@"reloadCommentWoodList" object:nil];//和 收藏 店铺,商品之间的  通信
}

//----有新的收藏,刷新数据
-(void)reloadAddressList:(NSNotification*) notification{
    [woodsView removeFromSuperview];//
    [self createAddressView];
    NSLog(@"jioefwoiwjiowoijioeefjoiw----2-------%@",[defaults objectForKey:@"PayedOrderWoodsArray"]);
}
//-----点击返回-----
-(void)onClickBack{
    [self.navigationController popViewControllerAnimated:YES];
    NSLog(@"----onClickBack---图片被点击!------");
}
//-------生成数据视图------
- (void)createAddressView{
    NSArray *itemsArray = [defaults objectForKey:@"PayedOrderWoodsArray"];
    NSInteger arraysCount = itemsArray.count;
    int totalCount = 0;
    //-------商品视图
    woodsView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 44+addStatusBarHeight, self.view.frame.size.width, [ UIScreen mainScreen ].applicationFrame.size.height-addStatusBarHeight-44-49)];//上半部分
    [self.view addSubview:woodsView];
    woodsView.userInteractionEnabled = YES;
    NSLog(@"jifojfioewjgpgopw-----------------shopView--%f--%f---%f",[ UIScreen mainScreen ].applicationFrame.size.height-addStatusBarHeight-44-49,[ UIScreen mainScreen ].applicationFrame.size.height-addStatusBarHeight,[ UIScreen mainScreen ].applicationFrame.size.height-addStatusBarHeight);//-----------
    for(int i=0;i<arraysCount;i++) {
        NSDictionary *item = [itemsArray objectAtIndex:i];
        NSArray *woodsArray = [item objectForKey:@"woodsArray"];
        NSInteger woodsCount = woodsArray.count;
        for (int j=0;j<woodsCount;j++) {
            NSDictionary *wood = [woodsArray objectAtIndex:j];
            UIView *frameImageView = [[UIView alloc] initWithFrame:CGRectMake(0, 92*totalCount, MAINSCREEN_WIDTH, 92)];
            totalCount++;//-----总数-------
            [frameImageView setBackgroundColor:[UIColor whiteColor]];
            [woodsView addSubview:frameImageView];
            frameImageView.userInteractionEnabled = YES;
            frameImageView.tag = i;//------这里是----i
            frameImageView.accessibilityIdentifier = [item objectForKey:@"tradeNO"];//------tradeNO-------
            UITapGestureRecognizer *singleTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapWoodsItemView:)];
            [frameImageView addGestureRecognizer:singleTap];//---添加点击事件
            //商品图片
            NSURL *imageUrl = [NSURL URLWithString:[wood objectForKey:@"img"]];
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(3, 5, 80, 84)];//商品图片
            [frameImageView addSubview:imageView];
            [imageView sd_setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"noData1"]];
            //商品名称
            UILabel *woodsLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, 0, 225, 45)];
            woodsLabel.font = [UIFont systemFontOfSize:16];
            woodsLabel.text = [wood objectForKey:@"name"];
            woodsLabel.numberOfLines = 2;
            woodsLabel.backgroundColor = [UIColor clearColor];
            [frameImageView addSubview:woodsLabel];//
            //市场价格
            NSLog(@"sjioewhiohiogwe-----%@----",wood);
            //价格
            UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, 45, 150, 15)];
            priceLabel.font = [UIFont systemFontOfSize:12];
            priceLabel.backgroundColor = [UIColor clearColor];
            priceLabel.text = [NSString stringWithFormat:@"金额:  ¥ %@",[wood objectForKey:@"price"]];
            [frameImageView addSubview:priceLabel];
            //订单
            UILabel *orderLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, 60, 150, 15)];
            orderLabel.font = [UIFont systemFontOfSize:12];
            orderLabel.backgroundColor = [UIColor clearColor];
            orderLabel.text = [NSString stringWithFormat:@"订单:  %@",[item objectForKey:@"tradeNO"]];
            [frameImageView addSubview:orderLabel];
            //日期
            UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, 75, 150, 15)];
            dateLabel.font = [UIFont systemFontOfSize:12];
            dateLabel.backgroundColor = [UIColor clearColor];
            //NSString *date = [[item objectForKey:@"tradeNO"] substringToIndex:8];//----201409245846384----
            NSString *date = [NSString stringWithFormat:@"%@-%@-%@",[[item objectForKey:@"tradeNO"] substringToIndex:4],[[item objectForKey:@"tradeNO"] substringWithRange:NSMakeRange(4,2)],[[item objectForKey:@"tradeNO"] substringWithRange:NSMakeRange(6,2)]];
            dateLabel.text = [NSString stringWithFormat:@"日期:  %@",date];
            [frameImageView addSubview:dateLabel];
            
            //底边线
            UILabel *bottom = [[UILabel alloc] initWithFrame:CGRectMake(0, 91.4, 350, 0.6)];
            bottom.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];
            [frameImageView addSubview:bottom];
            
            
            UIButton *catView = [[UIButton alloc] initWithFrame:CGRectMake(240, 45, 60, 30)];
            [frameImageView addSubview:catView];
            catView.layer.cornerRadius = 8;
            //catView.layer.masksToBounds = YES;
            catView.titleLabel.font = [UIFont systemFontOfSize:14];//
            [catView setTitle:@"写评论" forState:UIControlStateNormal];
            [catView setBackgroundColor:[UIColor orangeColor]];//----橙色----
            [catView setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];//
            [catView setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];//
            [catView setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];//
            catView.tag = j;
            catView.accessibilityIdentifier = [NSString stringWithFormat:@"%d",i];
            [catView addTarget:self action:@selector(addComment:) forControlEvents:UIControlEventTouchUpInside];//----点击事件
        }
    }
    woodsView.contentSize =  CGSizeMake(self.view.frame.size.width, 92*totalCount);
}
//-----点击woodsItem-----
//------点击item视图
- (void)tapWoodsItemView:(id)sender{
    //int tag = [[sender view] tag];
    //selectedM = [woodsArrays objectAtIndex:tag];
    //NSLog(@"nvowejgioewhgioehp------%d----%@---%@",tag,selectedM,[woodsArrays objectAtIndex:tag]);
    //[self performSegueWithIdentifier:@"woodsDetail" sender:self];
}
//------去评论--------
-(void)addComment:(id)sender{
    NSArray *itemsArray = [defaults objectForKey:@"PayedOrderWoodsArray"];
    NSArray *woodArray = [[itemsArray objectAtIndex:[((UIButton*)sender).accessibilityIdentifier intValue]] objectForKey:@"woodsArray"];
    NSDictionary *wood = [woodArray objectAtIndex:((UIButton*)sender).tag];
    NSDictionary  *userLoginInfo = [defaults objectForKey:@"userLoginInfo"];
    if (userLoginInfo) {
        NSLog(@"jgorepepojrhopre--------%@--%@--%ld",sender,((UIButton*)sender).accessibilityIdentifier,(long)((UIButton*)sender).tag);
        NSDictionary *woodInfo = @{@"productguid":[wood objectForKey:@"Guid"],@"agentID":[wood objectForKey:@"shopId"]};
        [defaults setObject:woodInfo forKey:@"currentWoodsInfo"];
        [self performSegueWithIdentifier:@"addComment" sender:self];
        /*
        [Waiting show];//-----loading-----
        AFHTTPClient * client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:APIURL]];
        NSDictionary * params = @{@"apiid": @"0069",@"proguid":danModle.Guid,@"memberid":[userLoginInfo objectForKey:@"MemLoginID"]};
        NSLog(@"---locationString---------:%@",params);
        NSURLRequest * request = [client requestWithMethod:@"POST"
                                                      path:@""
                                                parameters:params];
        AFHTTPRequestOperation * operation = [client HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject){
            [Waiting dismiss];
            NSString *temp = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSLog(@"tregregeryryre------%@-----",temp);
            if ([temp isEqualToString:@"true"]) {
                [self performSegueWithIdentifier:@"addComment" sender:self];
            }else{
                [self.view makeToast:@"购买该商品后才可以评论" duration:1.2 position:@"center"];//----
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"faild , error == %@ ", error);
            [Waiting dismiss];
        }];
        [operation start];//-----发起请求------
        */
    }else{
        [self.view makeToast:@"请先登录" duration:1.2 position:@"center"];
    }
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}
- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    //保存触摸起始点位置
    CGPoint point = [[touches anyObject] locationInView:self.view];
    if (point.x<60&point.y<44+addStatusBarHeight) {
        backHomeIcon.image = [UIImage imageNamed:@"carat-l-black"];
    }
}
- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    backHomeIcon.image = [UIImage imageNamed:@"carat-l-orange"];
}
- (void) touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    backHomeIcon.image = [UIImage imageNamed:@"carat-l-orange"];
}

//-----------内存不足报警------
-(void)didReceiveMemoryWarning
{
    [[NSUserDefaults standardUserDefaults] synchronize];
    [super didReceiveMemoryWarning];
    NSLog(@"memory warning,kkappdelegate---");
}
@end
