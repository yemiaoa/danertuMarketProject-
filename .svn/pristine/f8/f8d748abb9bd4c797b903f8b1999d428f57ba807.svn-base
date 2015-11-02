//
//  WebViewController.m
//  Tuan
//
//  Created by 夏 华 on 12-7-6.
//  Copyright (c) 2012年 无锡恩梯梯数据有限公司. All rights reserved.
//
#import "GoldCarrotController.h"
@interface GoldCarrotController(){
    AFHTTPClient * httpClient;
    NSArray *classifyDataArr;
    NSDictionary *selectTypeDic;
    
    
    UIScrollView *adsScrollView;//--------右侧广告
    UIPageControl *pageControl;//---------广告分页
    NSArray *slideImages;//---------------广告图片数组
    NSTimer *myTimer;//-------------------定时器
    
    NSString *goWoodsListKeyWord;
    int danertuWoodsSegmentNo;//---------单耳兔商城酒分类tag----
    int currentClassifyIndex;
}
@end
@implementation GoldCarrotController
@synthesize addStatusBarHeight;
@synthesize defaults;
@synthesize userInfoView;
- (void)loadView
{
    [super loadView];
    // If you create your views manually, you MUST override this method and use it to create your views.
    // If you use Interface Builder to create your views, then you must NOT override this method.
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    addStatusBarHeight = [TopNaviViewController getStatusBarHeight];
    defaults =[NSUserDefaults standardUserDefaults];
    //----------页面view-----
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, TOPNAVIHEIGHT+addStatusBarHeight, self.view.frame.size.width, self.view.frame.size.height-TOPNAVIHEIGHT-addStatusBarHeight)];//上半部分
    scrollView.backgroundColor = VIEWBGCOLOR;;//淡灰色
    [self.view addSubview:scrollView];
    httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:APIURL]];
    //----跳转泉眼温泉商品----广告图跳转,分类跳转-----
    goWoodsListKeyWord = @"泉眼温泉";
    
    //金萝卜,
    UIView *carrotView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 63)];
    [scrollView addSubview:carrotView];
    carrotView.backgroundColor = [UIColor colorWithRed:230/255.0 green:32/255.0 blue:9/255.0 alpha:1.0];
    
    //左半   UIImageView
    UIImageView *carrotImg = [[UIImageView alloc] initWithFrame:CGRectMake(20, 0, 67, 63)];
    [carrotView addSubview:carrotImg];
    carrotImg.image = [UIImage imageNamed:@"carrotGold"];
    //右半  UIView
    UIView *rightPart = [[UIView alloc] initWithFrame:CGRectMake(240, 0, 80, 63)];
    [carrotView addSubview:rightPart];
    rightPart.backgroundColor = [UIColor colorWithRed:1 green:74.0/255 blue:13.0/255 alpha:1];
    UITapGestureRecognizer *singleTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickToView)];
    [rightPart addGestureRecognizer:singleTap];//---添加点击事件
    
    //白色萝卜
    UIImageView *carrotWhite = [[UIImageView alloc] initWithFrame:CGRectMake(30, 5, 20, 33)];
    [rightPart addSubview:carrotWhite];
    carrotWhite.image = [UIImage imageNamed:@"carrotWhite"];
    //文字
    UILabel *useText = [[UILabel alloc] initWithFrame:CGRectMake(20, 37, 40, 28)];
    [rightPart addSubview:useText];
    useText.numberOfLines = 2;
    useText.textColor = [UIColor whiteColor];
    useText.backgroundColor = [UIColor clearColor];
    useText.textAlignment = NSTextAlignmentCenter;
    useText.font = [UIFont systemFontOfSize:9];
    useText.text = @"金萝卜\n使用说明";
    
    //金萝卜视图-----中间区域------分两种情况,登录和未登录  显示的内容不同
    UIView *centerPart = [[UIView alloc] initWithFrame:CGRectMake(80, 0, 160, 63)];
    [carrotView addSubview:centerPart];
    centerPart.backgroundColor = [UIColor clearColor];

    //--------------------------登录时显示的
    userInfoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 160, 63)];
    [centerPart addSubview:userInfoView];
    userInfoView.hidden = YES;
    
    //积分
    UILabel *scoreLb = [[UILabel alloc] initWithFrame:CGRectMake(10, 16, 85, 21)];
    [userInfoView addSubview:scoreLb];
    scoreLb.textColor = [UIColor whiteColor];
    scoreLb.tag = 101;
    scoreLb.backgroundColor = [UIColor clearColor];
    scoreLb.font = TEXTFONTSMALL;
    
    UILabel *memberScore = [[UILabel alloc] initWithFrame:CGRectMake(10, 33, 150, 21)];
    [userInfoView addSubview:memberScore];
    memberScore.textColor = [UIColor whiteColor];
    memberScore.tag = 102;
    memberScore.backgroundColor = [UIColor clearColor];
    memberScore.font = TEXTFONTSMALL;
    
    //------广告,活动-------
    UIView *adsView = [[UIView alloc] initWithFrame:CGRectMake(0,carrotView.frame.size.height+adsScrollView.frame.size.height,MAINSCREEN_WIDTH,90)];
    [scrollView addSubview:adsView];
    NSArray *adsImgs = @[@"adsImg_wine.jpg",@"adsImg_carrot.jpg"];
    for (int i=0;i<adsImgs.count;i++) {
        UIButton *adsItem = [[UIButton alloc] initWithFrame:CGRectMake((159+2)*i,2,159,86)];
        [adsView addSubview:adsItem];
        [adsItem setImage:[UIImage imageNamed:[adsImgs objectAtIndex:i]] forState:UIControlStateNormal];
        adsItem.tag = 100+i;
        [adsItem addTarget:self action:@selector(adsClickTo:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    //-----title--------超市分类---------超市产品分类-------
    UILabel *titleLb1 = [[UILabel alloc] initWithFrame:CGRectMake(0, carrotView.frame.size.height+adsScrollView.frame.size.height+adsView.frame.size.height, MAINSCREEN_WIDTH, 25)];
    [scrollView addSubview: titleLb1];
    titleLb1.backgroundColor = BUTTONCOLOR;
    titleLb1.font = TEXTFONT;
    titleLb1.textColor = [UIColor whiteColor];
    titleLb1.text = @"    超市产品";
    
    //-----超市分类---------超市产品分类-------
    UIView *classifyView = [[UIView alloc] initWithFrame:CGRectMake(0,carrotView.frame.size.height+adsScrollView.frame.size.height+adsView.frame.size.height+titleLb1.frame.size.height,MAINSCREEN_WIDTH,245)];
    
    [scrollView addSubview:classifyView];
    //------所有view加载完毕,可以计算总高度--------
    scrollView.contentSize = CGSizeMake(self.view.frame.size.width, carrotView.frame.size.height+adsScrollView.frame.size.height+adsView.frame.size.height+titleLb1.frame.size.height+classifyView.frame.size.height);//----滑动区域----
    
    //内容
    UIView *classifyContent = [[UIView alloc] initWithFrame:CGRectMake(0,2,MAINSCREEN_WIDTH,215)];//(10,10,300,225)
    [classifyView addSubview:classifyContent];
    
    //食品,家电,生活用品,旅游-----classifyArr,标题,备注,图片名
    NSArray *classifyArr = @[@"泉眼温泉",@"酒水",@"食品",@"家电",@"生活用品",@"旅游",@"中山•三乡",@"白酒/红酒/黄酒",@"进口美食/休闲食品",@"影音电器/生活电器",@"居家日用/美妆护肤",@"旅游路线/景点门票",@"classify_quanyan",@"classifyImg_wine_B",@"classifyImg_foodstuff_B",@"classifyImg_appliance_B",@"classifyImg_livingGoods_B",@"classifyImg_travel_B"];
    int itemCount = (int)classifyArr.count/3;
    int itemGap = 2;
    int itemWith = (classifyContent.frame.size.width-itemGap*2)/3;
    int itemHeight = (classifyContent.frame.size.height-itemGap)/2;
    for (int i=0; i<itemCount; i++) {
        int lineNo = i/3;
        UIView *item = [[UIView alloc] initWithFrame:CGRectMake((i-i/3*3)*(itemWith+itemGap),(itemHeight+itemGap)*lineNo,itemWith,itemHeight)];
        [classifyContent addSubview:item];
        item.backgroundColor = [UIColor whiteColor];
        
        item.tag = 99+i;//tag标签区分
        if ([classifyArr[i] isEqualToString:@"家电"]) {
            item.tag += 1;
        }else if ([classifyArr[i] isEqualToString:@"生活用品"]) {
            item.tag -= 1;
        }
        
        UITapGestureRecognizer *singleTap1 =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goClassifyDetail:)];
        [item addGestureRecognizer:singleTap1];//---添加大图片点击事
        
        UILabel *wineLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,5,itemWith-10,15)];
        [item addSubview:wineLabel];
        wineLabel.backgroundColor = [UIColor clearColor];
        wineLabel.font = TEXTFONTSMALL;
        wineLabel.text = classifyArr[i];
        
        UILabel *wineLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(10,20,itemWith-10,12)];
        [item addSubview:wineLabel1];
        wineLabel1.textColor = [UIColor grayColor];
        wineLabel1.backgroundColor = [UIColor clearColor];
        wineLabel1.font = [UIFont systemFontOfSize:10];
        wineLabel1.text = classifyArr[i+itemCount];
        
        UIImageView *wineImgView = [[UIImageView alloc] initWithFrame:CGRectMake(16,32,73,73)];
        [item addSubview:wineImgView];
        wineImgView.image = [UIImage imageNamed:classifyArr[i+itemCount*2]];
    }
    
    //------读取超市商品分类
    [self getClassifyData];
}

//-----修改标题,重写父类方法----
-(NSString*)getTitle{
    return @"金萝卜";
}
//------广告点击跳转----
-(void)adsClickTo:(UIButton *)sender{
    int tag = (int)[sender tag] -100;
    [defaults removeObjectForKey:@"currentShopInfo"];//---默认当前店铺
    
    if (tag==1) {
        
        GameBlareController *danController = [[GameBlareController alloc] init];
        danController.hidesBottomBarWhenPushed = YES;
        [self presentViewController:danController animated:YES completion:nil];
    }else{
        
        DanertuWoodsController *danController = [[DanertuWoodsController alloc] init];
        danController.hidesBottomBarWhenPushed = YES;
        danController.currentSegmentNo = danertuWoodsSegmentNo;
        [self.navigationController pushViewController:danController animated:YES];
    }
}
//------超市分类----
-(void)goClassifyDetail:(id)sender{
    int tag = (int)[[sender view] tag] -100;
    if (classifyDataArr.count>0) {
        if (tag>=0) {
            selectTypeDic = @{@"ID":[classifyDataArr[tag] objectForKey:@"ID"],@"Name":[classifyDataArr[tag] objectForKey:@"Name"],@"indexTag":[NSNumber numberWithInt:tag]};
            ClassifyDetailController *danController = [[ClassifyDetailController alloc] init];
            danController.selectTypeDic = selectTypeDic;
            danController.classifyDataArr = classifyDataArr;
            danController.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:danController animated:YES];
        }else{
            
            WoodDataController *woodController = [[WoodDataController alloc] init];
            woodController.hidesBottomBarWhenPushed = YES;
            woodController.searchKeyWord = goWoodsListKeyWord;
            [self.navigationController pushViewController:woodController animated:YES];
        }
    }else{
        [self getClassifyData];//再次加载分类数据
    }
}
//-----获取一级分类---
-(void)getClassifyData{
    [Waiting show];
    NSDictionary * params = @{@"apiid": @"0073"};
    NSLog(@"re0033kkFirstView------locationString---------:%@",params);
    NSURLRequest * request = [httpClient requestWithMethod:@"POST"
                                                      path:@""
                                                parameters:params];
    AFHTTPRequestOperation * operationItem = [httpClient HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operationItem, id responseObject) {
        [Waiting dismiss];
        NSString *source = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"jgorejgojroinobrt-----%@",source);
        NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        classifyDataArr = [[jsonData objectForKey:@"firstCategoryList"] objectForKey:@"firstCategorybean"];
        if (classifyDataArr.count==0) {
            [self.view makeToast:@"数据错误:0073,请稍后重试" duration:1.5 position:@"center"];
        }
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"faild , error == %@ ", error);
        [Waiting dismiss];
        [self.view makeToast:@"网络错误请重试" duration:1.5 position:@"center"];
    }];
    [operationItem start];
}
//-----每次显示页面都会执行
- (void)viewWillAppear:(BOOL)animated{
    [self showViewByLogin];//--判断是否登录显示不同view
}
//----判断是否登录
-(void)showViewByLogin{
    NSDictionary *userLoginInfo = [defaults objectForKey:@"userLoginInfo"];
    if (userLoginInfo) {
        userInfoView.hidden = NO;
        [Waiting show];
        AFHTTPClient * client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:APIURL]];
        NSDictionary * params = @{@"apiid": @"0085",@"memberid" : [userLoginInfo objectForKey:@"MemLoginID"]};
        NSURLRequest * request = [client requestWithMethod:@"POST"
                                                      path:@""
                                                parameters:params];
        AFHTTPRequestOperation * operation = [client HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [Waiting dismiss];//隐藏loadin
            NSString *score = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            if(score.length>0){
                NSArray *labelTextArr = @[[userLoginInfo objectForKey:@"MemLoginID"],[NSString stringWithFormat:@"金萝卜: %@",score],[NSString stringWithFormat:@"至少可抵 %0.2f 元",[score floatValue]/100]];
                for (UILabel *tmp in [userInfoView subviews]) {
                    if ([tmp isKindOfClass:[UILabel class]]) {
                        tmp.text = labelTextArr[tmp.tag-100];
                    }
                }
            }else{
                [self.view makeToast:@"系统错误,请稍后重试" duration:2.0 position:@"center"];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [Waiting dismiss];//隐藏loading
            [self.view makeToast:@"请检查网络连接是否正常" duration:2.0 position:@"center"];
        }];
        [operation start];
    }else{
        userInfoView.hidden = YES;
    }
}
//跳转其他页面--积分规则
- (void)clickToView
{
    
    WebViewController *danController = [[WebViewController alloc] init];
    danController.hidesBottomBarWhenPushed = YES;
    danController.webTitle = @"金萝卜活动";
    danController.webURL = @"principle.html";
    danController.webType =  @"webUrl";
    [self.navigationController pushViewController:danController animated:YES];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollViewTmp
{
    if (scrollViewTmp.tag==100) {
        CGFloat pagewidth = adsScrollView.frame.size.width;
        int page = floor((adsScrollView.contentOffset.x - pagewidth/[slideImages count])/pagewidth)+1;
        pageControl.currentPage = page;
    }
}

//-----点击广告图-----
-(void)tapAds:(id)sender{
    int tag = (int)[[sender view] tag] - 100;
    NSLog(@"jaifmbirjhtorpokwfepw-----%d",tag);
    switch (tag) {
        case 0:{
            
            WoodDataController *woodController = [[WoodDataController alloc] init];
            woodController.hidesBottomBarWhenPushed = YES;
            woodController.searchKeyWord = goWoodsListKeyWord;
            [self.navigationController pushViewController:woodController animated:YES];
            break;}
        case 1:
            [self goToSpecialShop:@"满庭湘"];
            break;
        case 2:
            [self goToSpecialShop:@"泉林旅游度假"];
            break;
        case 3:danertuWoodsSegmentNo = 2;
            [self onClickDanertuItem];
            break;
        case 4:danertuWoodsSegmentNo = 5;
            [self onClickDanertuItem];
            break;
        case 5:danertuWoodsSegmentNo = 1;
            [self onClickDanertuItem];
            break;
        default:
            break;
    }
    
}
//------跳转到  单耳兔商品
-(void)onClickDanertuItem{
    [defaults removeObjectForKey:@"currentShopInfo"];//---默认当前店铺
    
    DanertuWoodsController *danController = [[DanertuWoodsController alloc] init];
    danController.hidesBottomBarWhenPushed = YES;
    danController.currentSegmentNo = danertuWoodsSegmentNo;
    [self.navigationController pushViewController:danController animated:YES];
}
//-----页面消失时------
-(void)viewWillDisappear:(BOOL)animated{
    //---------消失-------
    [myTimer invalidate];
}
//------pageController---------广告轮播图----------
// pagecontrol 选择器的方法,-----这里没有执行-----
- (void)turnPage
{
    int scrollWidth = adsScrollView.frame.size.width;
    if (pageControl.currentPage==slideImages.count-1) {
        pageControl.currentPage = 0;
        //---------消失-------
        [myTimer invalidate];
    }else{
        pageControl.currentPage += 1; // 获取当前的page
    }
    int page = (int)pageControl.currentPage ;
    [adsScrollView scrollRectToVisible:CGRectMake(scrollWidth*page,0,scrollWidth,adsScrollView.frame.size.height) animated:YES]; // 触摸pagecontroller那个点点 往后翻一页 +1
    NSLog(@"qweqeqeq------%d",page);
}
//-----跳转特殊点评-----
-(void)goToSpecialShop:(NSString*)shopNameKeyWord{
    NSDictionary * params = @{@"apiid": @"0044",@"kword":shopNameKeyWord};
    NSString *resultDataKeyPrefix = @"supplierprocuctList";
    NSString *resultDataKeyPrefix1 = @"supplierproductbean";
    
    NSLog(@"locationString---qweq------:%@",params);
    NSURLRequest * request = [httpClient requestWithMethod:@"POST"
                                                  path:@""
                                            parameters:params];
    AFHTTPRequestOperation * operation = [httpClient HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [Waiting dismiss];//隐藏loading
        NSDictionary *jsonData = [[CJSONDeserializer deserializer]deserialize:responseObject error:nil];
        NSMutableArray *temp = [[jsonData objectForKey:resultDataKeyPrefix] objectForKey:resultDataKeyPrefix1];
        
        NSLog(@"opdjfijithui----arrayStr--------%@-----23456*3.5-%ld----",jsonData,temp.count);
        if(temp.count>0){
            
            DetailViewController *detailController = [[DetailViewController alloc] init];
            detailController.hidesBottomBarWhenPushed = YES;
            detailController.modle = [[DataModle alloc] initWithDataDic:[temp objectAtIndex:0]];
            detailController.agentid = [[DataModle alloc] initWithDataDic:[temp objectAtIndex:0]].id;
            [self.navigationController pushViewController:detailController animated:YES];
        }else{
            [self.view makeToast:@"数据读取错误" duration:1.2 position:@"center"];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [Waiting dismiss];//隐藏loading
        [self.view makeToast:@"请检查网络连接,刷新重试" duration:1.2 position:@"center"];
    }];
    [operation start];//-----发起请求------
}
//-----------内存不足报警------
-(void)didReceiveMemoryWarning
{
    [[NSUserDefaults standardUserDefaults] synchronize];
    [super didReceiveMemoryWarning];
    NSLog(@"memory warning,kkappdelegate---");
}
@end
