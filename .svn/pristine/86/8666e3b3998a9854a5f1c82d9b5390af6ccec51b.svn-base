//
//  WebViewController.m
//  Tuan
//
//  Created by 夏 华 on 12-7-6.
//  Copyright (c) 2012年 无锡恩梯梯数据有限公司. All rights reserved.
//
#import "ShopCatController.h"
#import "TabBarController.h"
#import "DanModle.h"
#import "UIImageView+WebCache.h"
enum currentType{
    EDIT,NORMAL
};

#define ITEMTOTALTEXT @"共计 %@ 件商品    合计: "
#define ITEMTOTALTEXT_int @"共计 %d 件商品    合计: "
#define ITEMTOTALTEXT_replace1 @"共计 "
#define ITEMTOTALTEXT_replace2 @" 件商品    合计: "

#define ITEMTOTALRICE @"¥ %0.2f"
#define ITEMTOTALRICE_replace @"¥ "

#define SHOCATTOTALPRICE @"合计: ¥ %0.2f"
#define SHOCATTOTALPRICE_replace @"合计: ¥ "

@interface ShopCatController (){
    UIButton *topEditBtn;//编辑按钮
    enum currentType editType;
    UICollectionView *gridView;
    NSMutableArray *arraysShopCat;
    NSArray *hotelGuidArr;
    NSArray *springGuidArr;
    double totalMoney;//所有商品总价,保存,无需每次计算
    UIView *datePickerView;//日期选择
    UILabel *currentDateLb;//当前操作的cell里的时间
    NSMutableArray *selectedArr;//保存了  商品view的tag,10000,10001,20000,30000,,,,
    UIButton *payBtn;
    AFHTTPClient * httpClient;//网络访问
    NSTimer *_timer;
}
@end
@implementation ShopCatController
@synthesize defaults;
@synthesize addStatusBarHeight;
@synthesize noOrderView;
@synthesize woodsArrByShop;
@synthesize isFirstToLoad;
@synthesize haveOrderView;
@synthesize totalPayLb;
@synthesize bottomSelectAll;
@synthesize subViewDict;

- (void)loadView
{
    [super loadView];
    // If you create your views manually, you MUST override this method and use it to create your views.
    // If you use Interface Builder to create your views, then you must NOT override this method.
}
//-------页面显示时------
- (void)viewDidLoad
{
    [super viewDidLoad];
    lastSelectDataString = @"点击选择时间";
    addStatusBarHeight = [TopNaviViewController getStatusBarHeight];
    subViewDict = [[NSMutableDictionary alloc] initWithCapacity:0];
    isFirstToLoad = YES;//第一次加载
    defaults =[NSUserDefaults standardUserDefaults];
    arraysShopCat = [[NSMutableArray alloc] init];//初始化
    woodsArrByShop = [[NSMutableArray alloc] init];//初始化
    selectedArr = [[NSMutableArray alloc] init];//初始
    httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:APIURL]];
    
    NSString *path=[[NSBundle mainBundle] pathForResource:@"springHotelGuid" ofType:@"plist"];
    //取得sortednames.plist绝对路径
    //sortednames.plist本身是一个NSDictionary,以键-值的形式存储字符串数组
    
    NSDictionary *guidDic=[[NSDictionary alloc] initWithContentsOfFile:path];
    
    //温泉,客房的guid写到这里
    hotelGuidArr = [guidDic objectForKey:@"hotelGuidArr"];
    springGuidArr = [guidDic objectForKey:@"springGuidArr"];
    
    haveOrderView = [[UIView alloc] initWithFrame:CGRectMake(0, addStatusBarHeight+TOPNAVIHEIGHT, MAINSCREEN_WIDTH,CONTENTHEIGHT)];
    [self.view addSubview:haveOrderView];
    
    self.view.backgroundColor = VIEWBGCOLOR;
    
    //编辑完成按钮
    editType = NORMAL;
    topEditBtn = [[UIButton alloc] initWithFrame:CGRectMake(240, addStatusBarHeight+7, 60,30)];
    [self.view addSubview:topEditBtn];
    topEditBtn.layer.cornerRadius = 2;
    topEditBtn.layer.borderColor = [UIColor colorWithRed:180.0/255 green:0 blue:0 alpha:1].CGColor;
    topEditBtn.layer.borderWidth = 1;
    topEditBtn.titleLabel.font = TEXTFONT;
    [topEditBtn setTitle:@"编辑" forState:UIControlStateNormal];
    [topEditBtn addTarget:self action:@selector(editShopCat) forControlEvents:UIControlEventTouchUpInside];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    //layout.itemSize = [CollectionViewCell sizeWithDataItem:nil];
    //layout.minimumInteritemSpacing = [CollectionViewCell margin];
    layout.minimumLineSpacing = layout.minimumInteritemSpacing;
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    gridView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, MAINSCREEN_WIDTH,CONTENTHEIGHT-50) collectionViewLayout:layout];//中间区域

    gridView.delegate = self;
    gridView.dataSource = self;
    gridView.backgroundColor = VIEWBGCOLOR;
    [gridView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    [haveOrderView addSubview:gridView];//加在  scrollView  里
    
    //底部结算条
    UIView *bottomFloatView = [[UIView alloc] initWithFrame:CGRectMake(0, CONTENTHEIGHT - 50, MAINSCREEN_WIDTH,50)];//中间区
    [haveOrderView addSubview:bottomFloatView];
    if (self.hidesBottomBarWhenPushed) {
        bottomFloatView.frame = CGRectMake(0, CONTENTHEIGHT + 10, MAINSCREEN_WIDTH,50-10);
    }
    bottomFloatView.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1];
    
    //选择---左
    UIView *clickView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 70, 50)];
    [bottomFloatView addSubview:clickView];
    clickView.userInteractionEnabled = YES;
    clickView.tag = 100;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeSelect:)];
    [clickView addGestureRecognizer:tap];
    
    //选择框
    bottomSelectAll = [[UIImageView alloc] initWithFrame:CGRectMake(10, 15, 20, 20)];
    [clickView addSubview:bottomSelectAll];
    bottomSelectAll.layer.cornerRadius = 2;
    bottomSelectAll.layer.borderColor = [UIColor grayColor].CGColor;
    [bottomSelectAll.layer setBorderWidth:0.6];
    
    UILabel *selectText = [[UILabel alloc] initWithFrame:CGRectMake(40, 15, 40, 20)];
    [clickView addSubview:selectText];
    selectText.backgroundColor = [UIColor clearColor];
    selectText.text = @"全选";
    
    //合计,结算----中
    UIView *totalPayView = [[UIView alloc] initWithFrame:CGRectMake(80, 0, 140, 50)];
    [bottomFloatView addSubview:totalPayView];
    totalPayView.tag = 66;
    
    //所有店铺购买商品的总价格
    totalPayLb = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, 140, 20)];
    [totalPayView addSubview:totalPayLb];
    totalPayLb.textAlignment = NSTextAlignmentRight;
    totalPayLb.textColor = [UIColor redColor];
    totalPayLb.backgroundColor = [UIColor clearColor];
    totalPayLb.text = @"合计: ¥ 0.00";
    totalPayLb.font = TEXTFONT;
    [subViewDict setObject:totalPayLb forKey:@"totalPayLb"];
    
    UILabel *additional = [[UILabel alloc] initWithFrame:CGRectMake(0, 25, 140, 15)];
    [totalPayView addSubview:additional];
    additional.font = TEXTFONTSMALL;
    additional.textAlignment = NSTextAlignmentRight;
    additional.backgroundColor = [UIColor clearColor];
    additional.text = @"不含运费";
    
    //结算按钮-----右
    payBtn = [[UIButton alloc] initWithFrame:CGRectMake(230, 0, 90, 50)];
    [bottomFloatView addSubview:payBtn];
    //    [payBtn.layer setMasksToBounds:YES];
    //    [payBtn.layer setCornerRadius:5];//设置矩形四个圆角半径
    payBtn.backgroundColor = [UIColor grayColor];;
    payBtn.tag = 77;
    payBtn.enabled = YES;
    [payBtn setTitle:@"结算" forState:UIControlStateNormal];
    [payBtn setTitleColor:[UIColor whiteColor ] forState:UIControlStateNormal];
    [payBtn setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [payBtn addTarget:self action:@selector(onClickPayOff) forControlEvents:UIControlEventTouchUpInside];
    
    //----没商品的--------的视图----
    noOrderView = [[UIView alloc] initWithFrame:CGRectMake(0, addStatusBarHeight+TOPNAVIHEIGHT, MAINSCREEN_WIDTH,CONTENTHEIGHT)];
    [self.view addSubview:noOrderView];
    noOrderView.hidden = YES;//隐藏
    //距离顶部高度
    int startY = (CONTENTHEIGHT - 200)/2;
    //内容view,保证显示居中
    UIView *noOrderContent = [[UIView alloc] initWithFrame:CGRectMake(0, startY, MAINSCREEN_WIDTH, 200)];
    [noOrderView addSubview:noOrderContent];
    
    //----图片----
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(110, 0, 100, 100)];
    [noOrderContent addSubview:imgView];
    imgView.image = [UIImage imageNamed:@"noData"];
    //----文字----
    UILabel *noOrderText = [[UILabel alloc] initWithFrame:CGRectMake(60, 110, 200, 50)];
    [noOrderContent addSubview:noOrderText];
    noOrderText.backgroundColor = [UIColor clearColor];
    noOrderText.textAlignment = NSTextAlignmentCenter;
    noOrderText.textColor = [UIColor grayColor];
    noOrderText.text = @"购物车还是空的,去逛逛吧!";
    //按钮呢
    UIButton *loginBtn = [[UIButton alloc] initWithFrame:CGRectMake(60, 160, 200, 40)];
    [noOrderContent addSubview:loginBtn];
    [loginBtn.layer setMasksToBounds:YES];
    [loginBtn.layer setCornerRadius:5];//设置矩形四个圆角半径
    loginBtn.backgroundColor = TOPNAVIBGCOLOR;
    [loginBtn setTitle:@"去首页逛逛" forState:UIControlStateNormal];
    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loginBtn setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [loginBtn addTarget:self action:@selector(onClickBack) forControlEvents:UIControlEventTouchUpInside];
    
    //比较耗时异步加载
    [Waiting show];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            //-----绘制datepicker
            //            [self didFinshRequestDanData];
            //            [self createDatePicker];
        });
    });
    
    [self didFinshRequestDanData];
    [self createDatePicker];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadShopCat) name:@"reloadShopCat" object:nil];//添加物品view 之间的消息传递
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deletePayedWoods) name:@"orderSubmitToPay" object:nil];//和 哪些不能访问到tabbar的view之间的消息传递
}

-(void)viewWillAppear:(BOOL)animated
{
    [self didFinshRequestDanData];
}

//修改标题,重写父类方法
-(NSString*)getTitle
{
    return @"购物车";
}

//重写父类方法
-(void)onClickBack
{
    [self.tabBarController setSelectedIndex:0];
    [self setBarItemSelectedIndex:0];
}

-(void)setBarItemSelectedIndex:(NSUInteger)selectedIndex{
    for (int i = 0; i < 5; i++) {
        UIColor *rightColor = (i==selectedIndex) ? TABBARSELECTEDCOLOR : TABBARDEFAULTCOLOR;
        [(UITabBarItem *)[self.tabBarController.tabBar.items objectAtIndex:i] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:rightColor, UITextAttributeTextColor, nil] forState:UIControlStateNormal];
    }
}

//重新加载
-(void)reloadShopCat{
    isFirstToLoad = YES;
    [self didFinshRequestDanData];
}

//编辑按钮
-(void)editShopCat{
    UIView *bottomTextView = [totalPayLb superview];
    if (editType==NORMAL){
        //--点击时---正常模式
        editType = EDIT;
        [topEditBtn setTitle:@"完成" forState:UIControlStateNormal];
        bottomTextView.hidden = YES;
        [payBtn setTitle:@"删除" forState:UIControlStateNormal];
    }else if (editType==EDIT) {
        //--点击时---编辑模式
        editType = NORMAL;
        [topEditBtn setTitle:@"编辑" forState:UIControlStateNormal];
        bottomTextView.hidden = NO;
        [payBtn setTitle:@"结算" forState:UIControlStateNormal];
    }
}
//-----绘制datepicker
-(void)createDatePicker{
    UIView *maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MAINSCREEN_WIDTH, WINDOWHEIGHT)];
    [self.view addSubview:maskView];
    maskView.hidden = YES;
    maskView.backgroundColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0.4];
    maskView.userInteractionEnabled = YES;
    /*
     UITapGestureRecognizer *sTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideDateView:)];
     [maskView addGestureRecognizer:sTap];//---添加点击事件
     */
    //按钮选择器的视图
    datePickerView = [[UIView alloc] initWithFrame:CGRectMake(0, WINDOWHEIGHT, MAINSCREEN_WIDTH, 250)];
    [maskView addSubview:datePickerView];
    datePickerView.backgroundColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.7];
    //按钮视图
    UIView *btnView = [[UIView alloc] initWithFrame:CGRectMake(0, 5, MAINSCREEN_WIDTH, 30)];
    [datePickerView addSubview:btnView];
    btnView.backgroundColor = [UIColor clearColor];
    //取消
    UIButton *cancleBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 10, 60, 30)];
    [btnView addSubview:cancleBtn];
    [cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cancleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [cancleBtn setBackgroundColor:TOPNAVIBGCOLOR];
    cancleBtn.layer.cornerRadius = 3;
    cancleBtn.tag = 0;
    [cancleBtn addTarget:self action:@selector(hideDateView:) forControlEvents:UIControlEventTouchUpInside];
    //重置
    UIButton *resetBtn = [[UIButton alloc] initWithFrame:CGRectMake(130, 10, 60, 30)];
    [btnView addSubview:resetBtn];
    [resetBtn setTitle:@"重置" forState:UIControlStateNormal];
    [resetBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [resetBtn setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [resetBtn setBackgroundColor:TOPNAVIBGCOLOR];
    resetBtn.layer.cornerRadius = 3;
    resetBtn.tag = 0;
    [resetBtn addTarget:self action:@selector(resetDateView:) forControlEvents:UIControlEventTouchUpInside];
    //确定
    UIButton *confirmBtn = [[UIButton alloc] initWithFrame:CGRectMake(250, 10, 60, 30)];
    [btnView addSubview:confirmBtn];
    [confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
    [confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [confirmBtn setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [confirmBtn setBackgroundColor:TOPNAVIBGCOLOR];
    confirmBtn.layer.cornerRadius = 3;
    confirmBtn.tag = 1;
    [confirmBtn addTarget:self action:@selector(hideDateView:) forControlEvents:UIControlEventTouchUpInside];
    //时间选择
    UIDatePicker *datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 50, MAINSCREEN_WIDTH, 200)];
    [datePickerView addSubview:datePicker];
    //设置背景色,ios7,8
    [[[datePicker subviews] firstObject] setBackgroundColor:[UIColor grayColor]];
    datePicker.tag = 8888;
}
-(void)onClickPayOff__{
    OrderFormController *orderV = [[OrderFormController alloc] init];
    orderV.hidesBottomBarWhenPushed = YES;
    [self presentViewController:orderV animated:YES completion:nil];
}
//-----去下单-----,下单时还原Guid-----
-(void) onClickPayOff{
    if (editType==NORMAL) {
        //-----当前模式是正常模式-------
        NSDictionary *userLoginInfo = [defaults objectForKey:@"userLoginInfo"];
        //登录是否才能下单
        if([userLoginInfo objectForKey:@"MemLoginID"]){
            [Waiting show];//loading
            //这里生成新的商品数组,当前勾选的商品数组
            NSMutableArray *selectWoodArr = [[NSMutableArray alloc] init];
            NSDecimalNumber *totalPay = [NSDecimalNumber decimalNumberWithString:@"0"];
            for (NSString *indexStr in selectedArr) {
                int tmpInt = [indexStr intValue];
                int index = tmpInt/10000;//第几个商品
                int i = tmpInt - index*10000;//第几件商品
                NSMutableDictionary *woodDic = [[[woodsArrByShop objectAtIndex:index-1] objectForKey:@"woodsArr"] objectAtIndex:i];
                //------提交订单时还原------Guid
                NSString *Guid = [[woodDic objectForKey:@"Guid"] substringToIndex:36];
                [woodDic setObject:Guid forKey:@"Guid"];
                
                NSString *arriveTime=@"",*leaveTime=@"";
                if ([woodDic objectForKey:@"arriveTime"]) {
                    arriveTime = [woodDic objectForKey:@"arriveTime"];
                }
                if ([woodDic objectForKey:@"leaveTime"]) {
                    leaveTime = [woodDic objectForKey:@"leaveTime"];
                }
                
                [selectWoodArr addObject:woodDic];
                
                //计算总价
                NSDecimalNumber *itemPrice = [NSDecimalNumber decimalNumberWithString:[woodDic objectForKey:@"price"]];
                NSDecimalNumber *itemCount = [NSDecimalNumber decimalNumberWithString:[woodDic objectForKey:@"count"]];
                NSDecimalNumber *itempay = [itemPrice decimalNumberByMultiplyingBy:itemCount];
                
                totalPay = [totalPay decimalNumberByAdding:itempay];
            }
            
            __block NSString *remindInfo = @"请确认温泉客房商品,是否选择抵达离开时间(红色线框标注)";
            if (selectWoodArr.count>0) {
                //只要是泉眼的商品，都是需要选择到达还有离开时间
                BOOL isSetTime = YES;
                __block BOOL isHaveStore = YES;
                for (NSDictionary *wood in selectWoodArr) {
                    //原来的判断条件[hotelGuidArr indexOfObject:[wood objectForKey:@"Guid"]]!=NSNotFound
                    NSString *guid = [wood objectForKey:@"Guid"];
                    if ([Tools isSpringGoodsWithDic:wood] && [Tools isSpringHotelWithGuid:guid]) {
                        if ([[wood objectForKey:@"arriveTime"] length]<=0) {
                            
                            isSetTime = NO;
                            break;
                        }else if ([[wood objectForKey:@"leaveTime"] length]<=0){
                            isSetTime = NO;
                            break;
                        }
                    }else if ([Tools isSpringGoodsWithDic:wood]){
                        if ([[wood objectForKey:@"arriveTime"] length]<=0) {
                            isSetTime = NO;
                            break;
                        }
                    }
                    //-----同步请求------检测库存-----
                    NSURL *url                   = [NSURL URLWithString:APIURL];
                    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
                    NSString *daoDateStr         = @"";
                    for (NSString *keyStr in [wood allKeys]) {
                        if ([keyStr isEqualToString:@"arriveTime"]) {
                            daoDateStr = [wood objectForKey:@"arriveTime"];
                            break;
                        }
                    }
                    [request setHTTPMethod:@"post"];
                    [request setHTTPBody:[[NSString stringWithFormat:@"apiid=0086&&proguid=%@&&daoDate=%@",[wood objectForKey:@"Guid"],daoDateStr] dataUsingEncoding:NSUTF8StringEncoding]] ;
                    
                    NSURLResponse * response = nil;
                    NSError * error          = nil;
                    NSData * data            = [NSURLConnection sendSynchronousRequest:request
                                                                     returningResponse:&response
                                                                                 error:&error];
                    NSString *temp           = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                    if (error == nil)
                    {
                        if ([temp intValue]<[[wood objectForKey:@"count"] intValue]) {
                            remindInfo = [NSString stringWithFormat:@"商品:%@,库存不足,仅剩:%@",[wood objectForKey:@"name"],temp];
                            isHaveStore = NO;
                            break;
                        }
                    }else{
                        [self.view makeToast:@"网络错误" duration:1.2 position:@"center"];
                    }
                }
                //-----价格计算校验----
                BOOL calculateRight = YES;
                //-----这里增加一步校验------当前显 示的总价和 通过勾选商品累加的总价  不一致,不能提交
                if (![totalPay isEqual:[NSDecimalNumber decimalNumberWithString:[totalPayLb.text stringByReplacingOccurrencesOfString:SHOCATTOTALPRICE_replace withString:@""]]]) {
                    calculateRight = NO;
                    remindInfo = @"商品总价计算有误,请多次点击全选或删除所有商品重新添加购物车";
                    
                };
                
                if (isSetTime&&isHaveStore&&calculateRight) {
                    //-----是否有库存-----
                    //存储勾选的商品
                    [defaults setObject:selectWoodArr forKey:PAYOFFWOODSARR];
                    
                    OrderFormController *orderV = [[OrderFormController alloc] init];
                    orderV.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:orderV animated:YES];
                }else{
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:remindInfo delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil];
                    [alert setTag:222];
                    [alert show];
                }
            }else{
                [self.view makeToast:@"您未勾选任何商品,不能下单" duration:1.2 position:@"center"];
            }
            [Waiting dismiss];
        }else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:[NSString stringWithFormat:@"下单前请登录"] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [alert addButtonWithTitle:@"登录"];
            [alert setTag:2];
            [alert show];
        }
    }else if (editType==EDIT){
        if (selectedArr.count>0) {
            //---------当前模式是编辑模式----------
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"删除商品" message:@"确定要从购物车删除所有选中商品?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [alert addButtonWithTitle:@"确定"];
            [alert setTag:1];
            [alert show];
        }else{
            [self.view makeToast:@"请选择您要删除的商品" duration:1.2 position:@"center"];
        }
    }
}
//----------确定清空
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if ([alertView tag] == 1) {
        if(buttonIndex==1){
            [self deleteSelectWoods];//-----去清空
        }
    }else if([alertView tag] == 2){
        if(buttonIndex==1){
            LoginViewController *loginV = [[LoginViewController alloc] init];
            loginV.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:loginV animated:YES];
            
        }
    }
}

//删除所选商品
-(void)deleteSelectWoods{
    //根据底部选框确定是否删除全部
    if (bottomSelectAll.image==nil) {
        //没有删除全部
        int deleteWoodsCount = 0;
        for (NSString *indexStr in selectedArr) {
            int tmpInt = [indexStr intValue];
            int index = tmpInt/10000;//第几个商品
            int i = tmpInt - index*10000;//第几件商品
            NSMutableArray *woodsArr = [[woodsArrByShop objectAtIndex:index-1] objectForKey:@"woodsArr"];
            NSDictionary *woodObj = [woodsArr objectAtIndex:i];
            //----累加数量,用于修改badge-----
            deleteWoodsCount += [[woodObj objectForKey:@"count"] intValue];
            //这里不能使用  [arraysShopCat removeObject:woodObj],如果使用那么温泉酒店两个一摸一样的商品会都被删除
            int arraysShopCatCount = (int)arraysShopCat.count;
            for (int j = 0; j < arraysShopCatCount; j++) {
                if ([[arraysShopCat[j] objectForKey:@"Guid"] isEqualToString:[woodObj objectForKey:@"Guid"]]) {
                    [arraysShopCat removeObjectAtIndex:j];
                    break;
                }
            }
        }
        [defaults setObject:arraysShopCat forKey:SHOPCATWOODSARR];
        //-----修改badge--------
        int currentWoodsCount = [[[[[[self tabBarController] viewControllers] objectAtIndex: SHOPCATINDEX] tabBarItem] badgeValue] intValue];
        //-----删除之后当前的购物车数量
        int newCount = currentWoodsCount-deleteWoodsCount;
        if (newCount>0) {
            [defaults setObject:[NSString stringWithFormat:@"%d",newCount] forKey:SHOPCATWOODSCOUNT];
            [[[[[self tabBarController] viewControllers] objectAtIndex: SHOPCATINDEX] tabBarItem] setBadgeValue:[NSString stringWithFormat:@"%d",newCount]];
            //----清空所选tag----
            [selectedArr removeAllObjects];
            //----重新加载-------
            [self didFinshRequestDanData];
        }else{
            if (newCount<0) {
                [self.view makeToast:@"系统错误" duration:1.5 position:@"center"];
            }
            //清空删除购物车数据,购物车数量,要支付数据
            [defaults removeObjectForKey:SHOPCATWOODSARR];
            [defaults removeObjectForKey:SHOPCATWOODSCOUNT];
            [defaults removeObjectForKey:PAYOFFWOODSARR];
            //显示无数据页面
            haveOrderView.hidden = YES;
            topEditBtn.hidden = YES;
            noOrderView.hidden = NO;
            [[[[[self tabBarController] viewControllers] objectAtIndex: SHOPCATINDEX] tabBarItem] setBadgeValue:nil];
        }
    }else{
        //清空删除购物车数据,购物车数量,要支付数据
        [defaults removeObjectForKey:SHOPCATWOODSARR];
        [defaults removeObjectForKey:SHOPCATWOODSCOUNT];
        [defaults removeObjectForKey:PAYOFFWOODSARR];
        //显示无数据页面
        haveOrderView.hidden = YES;
        topEditBtn.hidden = YES;
        noOrderView.hidden = NO;
        [[[[[self tabBarController] viewControllers] objectAtIndex: SHOPCATINDEX] tabBarItem] setBadgeValue:nil];
    }
    //----删除了勾选的商品后,所有商品处于未勾选,所有,总价合计  0;
    totalPayLb.text = @"合计: 0.00";
    [subViewDict setObject:totalPayLb forKey:@"totalPayLb"];
}

//-----删除下单的商品数据----,
-(void) deletePayedWoods{
    //----这里下单的数据和勾选的数据完全对应---
    [self deleteSelectWoods];
    //删除支付数据
    [defaults removeObjectForKey:PAYOFFWOODSARR];
    [selectedArr removeAllObjects];
    totalPayLb.text = @"合计: 0.00";
    isFirstToLoad = NO;
    [self didFinshRequestDanData];
}
//-----加载数据
-(void)didFinshRequestDanData{
    [arraysShopCat removeAllObjects];
    [woodsArrByShop removeAllObjects];
    float countPrice = 0;//总价
    NSArray *temp = [defaults objectForKey:SHOPCATWOODSARR];//初始化
    NSLog(@"-----------didFinshRequestDanData----postNOti-------%ld:----%@",temp.count,temp);
    int dataCount = (int)temp.count;
    for (int i=0; i<dataCount; i++) {
        NSMutableDictionary *woodDic = [[temp objectAtIndex:i] mutableCopy];
        /*
         //------线下产品(自营产品)----不计总价,不能购买-----
         if (![[woodDic objectForKey:@"woodFrom"] isEqualToString:@"agent"]) {
         countPrice += [[woodDic objectForKey:@"price"] doubleValue]*[[woodDic objectForKey:@"count"] intValue];
         }
         */
        countPrice += [[woodDic objectForKey:@"price"] doubleValue]*[[woodDic objectForKey:@"count"] intValue];
        
        //woodsCount += [model.woodsCount intValue];
        [arraysShopCat addObject:woodDic];//追加到数组
        
        //------将数组安装店铺分类-------------
        if (woodsArrByShop.count>0) {
            BOOL isShopExist = NO;
            for (NSMutableDictionary *item in woodsArrByShop) {
                if ([[item objectForKey:@"shopId"] isEqualToString:[woodDic objectForKey:@"shopId"]]) {
                    NSMutableArray *tmpArr = [[item objectForKey:@"woodsArr"] mutableCopy];
                    [tmpArr addObject:woodDic];
                    [item setObject:tmpArr forKey:@"woodsArr"];//替换原数组
                    isShopExist = YES;
                    break;
                }
            }
            if (!isShopExist) {
                NSArray *tmpArr = [NSArray arrayWithObject:woodDic];
                NSMutableDictionary *tmpDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:[woodDic objectForKey:@"shopId"],@"shopId",[woodDic objectForKey:@"shopName"],@"shopName",tmpArr,@"woodsArr", nil];
                [woodsArrByShop addObject:tmpDic];
            }
        }else{
            NSArray *tmpArr = [NSArray arrayWithObject:woodDic];
            NSMutableDictionary *tmpDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:[woodDic objectForKey:@"shopId"],@"shopId",[woodDic objectForKey:@"shopName"],@"shopName",tmpArr,@"woodsArr", nil];
            [woodsArrByShop addObject:tmpDic];
        }
    }
    //总价钱,所有商品的总和,和是否勾选没关系
    totalMoney = countPrice;
    for (NSMutableDictionary *tmp in woodsArrByShop) {
        NSArray *woodsArr = [tmp objectForKey:@"woodsArr"];
        double shopPay = 0;//总价钱
        int woodsCount = 0;//总数量
        for (NSDictionary *woodDic in woodsArr) {
            int itemCount = [[woodDic objectForKey:@"count"] intValue];
            shopPay += [[woodDic objectForKey:@"price"] doubleValue]*itemCount;
            woodsCount+= itemCount;
        }
        [tmp setObject:[NSNumber numberWithInt:woodsCount] forKey:@"woodsTotalCount"];
        [tmp setObject:[NSNumber numberWithDouble:shopPay] forKey:@"shopPay"];
    }
    NSLog(@"jgiorejigerogjo-----%@",woodsArrByShop);
    if (isFirstToLoad) {
        //第一次加载,或有新商品添加,添加所有标签到数组
        [self selectAllTag];
        totalPayLb.text = [NSString stringWithFormat:SHOCATTOTALPRICE,totalMoney];
    }
    NSLog(@"gregegthtrh------%@",woodsArrByShop);
    
    int woodsCount = (int)[arraysShopCat count];
    
    //-----判断是否有商品----,没有商品隐藏编辑按钮
    if(woodsCount>0){
        haveOrderView.hidden = NO;
        topEditBtn.hidden = NO;
        noOrderView.hidden = YES;
    }else{
        haveOrderView.hidden = YES;
        topEditBtn.hidden = YES;
        noOrderView.hidden = NO;
        //购物车数量为0
        [defaults removeObjectForKey:SHOPCATWOODSCOUNT];
        [[[[[self tabBarController] viewControllers] objectAtIndex: SHOPCATINDEX] tabBarItem] setBadgeValue:nil];
    }
    //重新计算总价格
    CGFloat totalpay = 0;
    for (int i = 0; i < [woodsArrByShop count]; i++) {
        NSDictionary *dic = [woodsArrByShop objectAtIndex:i];
        NSArray *woodsArr = [dic objectForKey:@"woodsArr"];
        for (int j = 0; j < [woodsArr count]; j++) {
            NSDictionary *goodsDict = [woodsArr objectAtIndex:j];
            NSInteger index = (i + 1) * 10000 + j;
            if ([self isWoodsSelectWithIndex:index]) {
                CGFloat price = [[goodsDict objectForKey:@"price"] floatValue];
                NSInteger count = [[goodsDict objectForKey:@"count"] integerValue];
                totalpay = totalpay + price * count;
            }
        }
    }
    totalMoney = totalpay;
    totalPayLb.text = [NSString stringWithFormat:SHOCATTOTALPRICE,totalMoney];
    [gridView reloadData];//获取  arraysShopCat  数据重新加载
    //[[self tabBarItem] setBadgeValue:[NSString stringWithFormat:@"%d",woodsCount]];
    payBtn.enabled = YES;
    payBtn.backgroundColor = TOPNAVIBGCOLOR;
    
    [Waiting dismiss];//隐藏loading------
}

- (BOOL)isWoodsSelectWithIndex:(NSInteger)selectIndex
{
    for (NSString *str in selectedArr) {
        NSInteger index = [str integerValue];
        if (selectIndex == index) {
            return YES;
        }
    }
    return NO;
}

//-----代理方法----------
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [woodsArrByShop count];
}
//---------这个方法里要根据  tag 修改商品的Guid----使得删除操作时可以区分相同的商品,-----在支付时还原Guid
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    int index = (int)indexPath.item;//小标
    NSDictionary *currentDic = [woodsArrByShop objectAtIndex:index];
    NSArray *itemArr = [currentDic objectForKey:@"woodsArr"];
    int itemCount = (int)itemArr.count;
    
    static NSString *cellIdentifier = @"cell";
    UICollectionViewCell *cell = [gridView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    cell.tag = index;
    //很重要,不删除就会出现  cell叠在cell上,
    //高度小的cell复用之前高度大的cell时,小的cell全部显示,它之下是大的cell,小的cell不足以遮住所以
    //大的cell会显示一部分,当前cell的尺寸是小的,,所以大cell的图像还会被当前cell之后的cell遮住
    for (id t in [cell subviews]) {
        [t removeFromSuperview];
    }
    
    int woodItemHeight = 90;
    
    UIView *mainView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MAINSCREEN_WIDTH, 60+woodItemHeight*itemCount)];
    [mainView setBackgroundColor:[UIColor whiteColor]];
    [cell addSubview:mainView];
    
    //头部
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MAINSCREEN_WIDTH, 30)];
    [mainView addSubview:topView];
    topView.userInteractionEnabled = YES;
    topView.tag = 1000;
    topView.accessibilityIdentifier = [currentDic objectForKey:@"shopId"];//标示--
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeSelect:)];
    [topView addGestureRecognizer:tap];
    
    //选择框
    UIImageView *selectShop = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 20, 20)];
    [topView addSubview:selectShop];
    selectShop.layer.cornerRadius = 2;
    selectShop.layer.borderColor = [UIColor grayColor].CGColor;
    [selectShop.layer setBorderWidth:0.6];
    
    UILabel *shopName = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, 270, 30)];
    [topView addSubview:shopName];//
    shopName.text = [NSString stringWithFormat:@"超市:  %@",[currentDic objectForKey:@"shopName"]];
    
    UILabel *border = [[UILabel alloc] initWithFrame:CGRectMake(10, 29, 300, 0.6)];
    [topView addSubview:border];//
    border.backgroundColor = BORDERCOLOR;
    
    double itemArrPrice = 0.0;
    int itemArrCount = 0;
    BOOL isSelectAll = YES;//是否全选
    
    for (int i=0; i < itemCount;i++) {
        NSMutableDictionary *woodDic = itemArr[i];
        NSLog(@"kfopwekgpjitrh----1-%@",woodDic);
        //NSArray *lalt = [coordinate componentsSeparatedByString:@","];
        UIView *itemView = [[UIView alloc] initWithFrame:CGRectMake(10, 30+woodItemHeight*i, 300, woodItemHeight)];
        [mainView addSubview:itemView];
        itemView.tag = 3000;
        
        //头部
        UIView *clickView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, woodItemHeight)];
        [itemView addSubview:clickView];
        clickView.userInteractionEnabled = YES;
        clickView.tag = 10000*(index+1)+i;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeSelect:)];
        [clickView addGestureRecognizer:tap];
        
        //--这里修改guid(_*_加clickView.tag)---使得---两个相同的商品,在删除可以区分,---这里要判断不能多次添加 _*_
        NSString *woodGuid = [woodDic objectForKey:@"Guid"];
        if (woodGuid.length == 36) {
            NSString *Guid = [NSString stringWithFormat:@"%@_*_%ld",woodGuid,(long)clickView.tag];
            [woodDic setObject:Guid forKey:@"Guid"];
        }
        
        //选择框
        UIImageView *setDefaultBtn = [[UIImageView alloc] initWithFrame:CGRectMake(0, 35, 20, 20)];
        [clickView addSubview:setDefaultBtn];
        setDefaultBtn.layer.cornerRadius = 2;
        setDefaultBtn.layer.borderColor = [UIColor grayColor].CGColor;
        [setDefaultBtn.layer setBorderWidth:0.6];
        //保存有   guid和shopId  都正确,如果selectShopArr存了多个同样的shopid,那么
        //[selectGuidArr indexOfObject:newModle.Guid]取最小的,所以下面条件写法是错的
        //existIndex!= NSNotFound&&[selectGuidArr indexOfObject:newModle.Guid]== [selectShopArr indexOfObject:newModle.shopId]
        //是否第一次加载------,第一次加载默认全选
        if (isFirstToLoad) {
            [setDefaultBtn setImage:[UIImage imageNamed:@"selected"]];
            [bottomSelectAll setImage:[UIImage imageNamed:@"selected"]];
            isSelectAll = YES;
        }else{
            if ([selectedArr indexOfObject:[NSString stringWithFormat:@"%ld",(long)clickView.tag]] != NSNotFound) {
                [setDefaultBtn setImage:[UIImage imageNamed:@"selected"]];
                int itemCount = [[woodDic objectForKey:@"count"] intValue];
                itemArrPrice += [[woodDic objectForKey:@"price"] doubleValue] *itemCount;
                itemArrCount += itemCount;
            }else{
                //只要存在一个没有选择的就是  没全选
                [setDefaultBtn setImage:nil];
                isSelectAll = NO;
            }
        }
        //商品图片
        CGFloat imageX = 25+3-5;//25
        CGFloat imageY = 5;//3
        CGFloat imageW = 80-20;//80
        CGFloat imageH = 84 - 24;//84
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(imageX, imageY, imageW, imageH)];//商品图片
        [itemView addSubview:imageView];
        imageView.layer.borderColor = BORDERCOLOR.CGColor;
        imageView.layer.borderWidth = 0.6;
        [imageView sd_setImageWithURL:[NSURL URLWithString:[woodDic objectForKey:@"img"]]];
        //商品名称
        CGFloat labelX = imageX + imageW + 5;
        CGFloat labelY = 0;
        CGFloat labelW = 120 - 5;
        CGFloat labelH = 36;
        UILabel *woodsLabel = [[UILabel alloc] initWithFrame:CGRectMake(labelX, labelY, labelW, labelH)];
        [itemView addSubview:woodsLabel];
        [woodsLabel setBackgroundColor:[UIColor clearColor]];
        woodsLabel.font = TEXTFONTSMALL;
        woodsLabel.numberOfLines = 2;
        woodsLabel.text = [woodDic objectForKey:@"name"];
        
        CGFloat countX = MAINSCREEN_WIDTH - 120; //labelX 310-100
        CGFloat countH = 30;//30
        CGFloat countY = 5;//imageY + imageH - countH
        CGFloat countW = 100;//labelX, labelH, 70,
        
        //控制商品数量的视图,加减按钮,数字
        UIView *countControlV = [[UIView alloc] initWithFrame:CGRectMake(countX, countY, countW, countH)];
        [itemView addSubview:countControlV];
        countControlV.tag = 4000;
        
        UIColor *lineColor = [UIColor colorWithRed:150 / 255.0 green:150 / 255.0 blue:150 / 255.0 alpha:1.0];
        countControlV.backgroundColor = [UIColor whiteColor];
        countControlV.layer.cornerRadius = 2;
        countControlV.clipsToBounds = YES;
        countControlV.layer.borderWidth = 0.5;
        countControlV.layer.borderColor = [lineColor CGColor];
        
        CGFloat lineX = countW * 0.3;
        CGFloat lineH = countH;
        CGFloat lineY = 0;
        CGFloat lineW = 0.5;
        
        UIView *_oneLine = [[UIView alloc] initWithFrame:CGRectMake(lineX, lineY, lineW, lineH)];
        _oneLine.backgroundColor = lineColor;
        [countControlV addSubview:_oneLine];
        
        UIView *_twoLine = [[UIView alloc] initWithFrame:CGRectMake(7 * lineX / 3.0, lineY, lineW, lineH)];
        _twoLine.backgroundColor = lineColor;
        [countControlV addSubview:_twoLine];
        
        //"-"
        CGFloat buttonX = 0;
        CGFloat buttonY = 0;
        CGFloat buttonH = countH;
        CGFloat buttonW = countW * 0.3;
        
        UIButton *minusBtn = [[UIButton alloc] initWithFrame:CGRectMake(buttonX, buttonY, buttonW, buttonH)];
        [countControlV addSubview:minusBtn];
        [self setupButton:minusBtn normalImage:@"decrease.png" HighlightImage:@"decrease_A.png"];
        minusBtn.accessibilityIdentifier = @"m";
        minusBtn.tag = 10000 * (index + 1) + i;
        
        //数字
        UILabel *countText = [[UILabel alloc] initWithFrame:CGRectMake(lineX, buttonY, 4 * lineX / 3.0, buttonH)];
        [countControlV addSubview:countText];
        [countText setBackgroundColor:[UIColor clearColor]];
        countText.text = [woodDic objectForKey:@"count"];
        countText.textAlignment = NSTextAlignmentCenter;
        countText.tag = 2000;
        
        //"+"
        UIButton *addBtn = [[UIButton alloc] initWithFrame:CGRectMake(7 * lineX / 3.0, buttonY, buttonW, buttonH)];
        [countControlV addSubview:addBtn];//
        [self setupButton:addBtn normalImage:@"increase.png" HighlightImage:@"increase_A.png"];
        addBtn.accessibilityIdentifier = @"a";
        addBtn.tag = 10000*(index+1)+i;
        
        //温泉客房商品
        if([[woodDic objectForKey:@"SupplierLoginID"] isEqualToString:SPRINGSUPPLIERID]){
            UIView *timeView = [[UIView alloc] initWithFrame:CGRectMake(labelX, labelH+20, 105*2+5, 25)];
            [itemView addSubview:timeView];//
            
            UILabel *arriveTimeValueLb = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 105, 25)];
            [timeView addSubview:arriveTimeValueLb];
            arriveTimeValueLb.userInteractionEnabled = YES;
            arriveTimeValueLb.font = TEXTFONTSMALL;
            arriveTimeValueLb.textAlignment = NSTextAlignmentCenter;
            arriveTimeValueLb.layer.borderWidth = 0.6;
            arriveTimeValueLb.tag = 10000 * (index + 1) + i;
            
            
            NSDateFormatter *dateFormat1 = [[NSDateFormatter alloc] init];
            [dateFormat1 setDateFormat:@"yyyy-MM-dd"];
            
            NSString *guidTmp = [woodDic objectForKey:@"Guid"];
            if ([guidTmp isMemberOfClass:[NSNull class]] || guidTmp == nil) {
                guidTmp = @"";
            }
            
            if ([[woodDic objectForKey:@"arriveTime"] length] > 0) {
                
                NSString *theDate = [woodDic objectForKey:@"arriveTime"];
                if ([Tools isSpringHotelWithGuid:guidTmp]) {
                    //当前时间
                    NSDate *nowDateArriveDate = [NSDate date];
                    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
                    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm"];
                    NSDate *arriveDate = [dateFormat dateFromString:theDate];
                    if ([nowDateArriveDate compare:arriveDate] == NSOrderedDescending) {
                        theDate = [dateFormat stringFromDate:nowDateArriveDate];
                    }
                    
                    NSString *subtheDate = @"";
                    @try {
                        subtheDate = [theDate substringFromIndex:11];
                    }
                    @catch (NSException *exception) {
                        subtheDate = @"14:00";
                    }
                    @finally {
                        
                    }
                    if (!([subtheDate compare:@"13:59" options:NSCaseInsensitiveSearch] == NSOrderedDescending && [subtheDate compare:@"24:00" options:NSCaseInsensitiveSearch] == NSOrderedAscending)) {
                        subtheDate = @"14:00";
                        
                        NSString *subtheDate1 = @"";
                        @try {
                            subtheDate1 = [theDate substringToIndex:11];
                        }
                        @catch (NSException *exception) {
                            subtheDate1 = [dateFormat1 stringFromDate:nowDateArriveDate];
                            subtheDate1 = [NSString stringWithFormat:@"%@ ",subtheDate1];
                        }
                        @finally {
                            
                        }
                        
                        NSDateFormatter *dateFormat1 = [[NSDateFormatter alloc] init];
                        [dateFormat1 setDateFormat:@"yyyy-MM-dd"];
                        NSString *nowDate = [NSString stringWithFormat:@"%@ ",[dateFormat1 stringFromDate:[NSDate date]]];
                        if ([subtheDate1 compare:nowDate options:NSCaseInsensitiveSearch] == NSOrderedAscending) {
                            subtheDate1 = nowDate;
                        }
                        
                        theDate = [NSString stringWithFormat:@"%@%@",subtheDate1,subtheDate];
                    }
                }
                
                [woodDic setObject:theDate forKey:@"arriveTime"];
                
                arriveTimeValueLb.text = theDate;
                arriveTimeValueLb.layer.borderColor = [UIColor blackColor].CGColor;
            }else{
                arriveTimeValueLb.text = @"点击选择抵达时间";
                arriveTimeValueLb.layer.borderColor = [UIColor redColor].CGColor;
            }
            arriveTimeValueLb.accessibilityIdentifier = @"arriveTime";//数据里的  key,不能随意
            UITapGestureRecognizer *sasTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showDatePicker:)];
            [arriveTimeValueLb addGestureRecognizer:sasTap];//---添加点击事件
            //现在只要是泉眼的商品都需要离开时间
            
            if ([Tools isSpringHotelWithGuid:guidTmp]) {
                UILabel *leaveTimeValueLb = [[UILabel alloc] initWithFrame:CGRectMake(110, 0, 105, 25)];
                [timeView addSubview:leaveTimeValueLb];
                leaveTimeValueLb.userInteractionEnabled = YES;
                leaveTimeValueLb.font = TEXTFONTSMALL;
                leaveTimeValueLb.textAlignment = NSTextAlignmentCenter;
                leaveTimeValueLb.layer.borderWidth = 0.6;
                leaveTimeValueLb.tag = 10000*(index+1)+i;
                
                //---------
                if ([[woodDic objectForKey:@"leaveTime"] length] > 0) {
                    
                    NSString *theDate = [woodDic objectForKey:@"arriveTime"];
                    //当前时间
                    NSDate *nowDateArriveDate = [NSDate date];
                    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
                    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm"];
                    NSDate *arriveDate = [dateFormat dateFromString:theDate];
                    if ([nowDateArriveDate compare:arriveDate] == NSOrderedDescending) {
                        theDate = [dateFormat stringFromDate:nowDateArriveDate];
                    }
                    
                    NSString *subtheDate = [theDate substringFromIndex:11];
                    if (!([subtheDate compare:@"13:59" options:NSCaseInsensitiveSearch] == NSOrderedDescending && [subtheDate compare:@"24:00" options:NSCaseInsensitiveSearch] == NSOrderedAscending)) {
                        subtheDate = @"14:00";
                        
                        NSString *subtheDate1 = [theDate substringToIndex:11];
                        
                        NSDateFormatter *dateFormat1 = [[NSDateFormatter alloc] init];
                        [dateFormat1 setDateFormat:@"yyyy-MM-dd"];
                        NSString *nowDate = [NSString stringWithFormat:@"%@ ",[dateFormat1 stringFromDate:[NSDate date]]];
                        if ([subtheDate1 compare:nowDate options:NSCaseInsensitiveSearch] == NSOrderedAscending) {
                            subtheDate1 = nowDate;
                        }
                        
                        theDate = [NSString stringWithFormat:@"%@%@",subtheDate1,subtheDate];
                    }
                    
                    arriveDate = [dateFormat dateFromString:theDate];
                    NSDate *myLeaveDate = [NSDate dateWithTimeInterval:24 * 60 * 60 sinceDate:arriveDate];
                    NSDateFormatter *dateFormat1 = [[NSDateFormatter alloc] init];
                    [dateFormat1 setDateFormat:@"yyyy-MM-dd"];
                    NSString *myLeaveString = [dateFormat1 stringFromDate:myLeaveDate];
                    myLeaveString = [NSString stringWithFormat:@"%@ 12:00",myLeaveString];
                    NSDate *compareLeaveDate = [dateFormat dateFromString:myLeaveString];
                    
                    NSString *leaveTime = [woodDic objectForKey:@"leaveTime"];
                    NSDate *leaveDate = [dateFormat dateFromString:leaveTime];
                    if ([leaveDate compare:compareLeaveDate] == NSOrderedAscending) {
                        leaveDate = compareLeaveDate;
                    }
                    NSString *leaveString = [dateFormat1 stringFromDate:leaveDate];
                    leaveString = [NSString stringWithFormat:@"%@ 12:00",leaveString];
                    leaveDate = [dateFormat dateFromString:leaveString];
                    [woodDic setObject:leaveString forKey:@"leaveTime"];
                    
                    leaveTimeValueLb.text = leaveString;
                    leaveTimeValueLb.layer.borderColor = [UIColor blackColor].CGColor;
                }else{
                    leaveTimeValueLb.text = @"点击选择离开时间";
                    leaveTimeValueLb.layer.borderColor = [UIColor redColor].CGColor;
                }
                leaveTimeValueLb.accessibilityIdentifier = @"leaveTime";//数据里的  key,不能随意
                UITapGestureRecognizer *saTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showDatePicker:)];
                [leaveTimeValueLb addGestureRecognizer:saTap];//---添加点击事件
                
                //隐藏
                countControlV.hidden = YES;
            }
        }else{
            //不隐藏
            countControlV.hidden = NO;
        }
        
        //单价符号,-----这里作为父标签的最后一个子标签,便于寻找
        UILabel *unitPriceSign = [[UILabel alloc] initWithFrame:CGRectMake(labelX, labelH, 70, 18)];
        [itemView addSubview:unitPriceSign];//230, 0, 70, 18
        unitPriceSign.font = TEXTFONTSMALL;
        unitPriceSign.textColor = [UIColor redColor];
        unitPriceSign.text = [NSString stringWithFormat:@"¥ %@",[woodDic objectForKey:@"price"]];
        unitPriceSign.backgroundColor = [UIColor clearColor];
        
        UILabel *border1 = [[UILabel alloc] initWithFrame:CGRectMake(0, woodItemHeight, 300, 0.6)];
        [itemView addSubview:border1];
        border1.backgroundColor = BORDERCOLOR;
    }
    //底部
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(10, 30+woodItemHeight*itemCount, 300, 30)];
    [mainView addSubview:bottomView];
    bottomView.tag = 5000;
    
    //每家店铺的总共购买的商品数量
    UILabel *totalTextLb = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];
    [bottomView addSubview:totalTextLb];//
    totalTextLb.backgroundColor = [UIColor clearColor];
    totalTextLb.textAlignment = NSTextAlignmentRight;
    
    //每家店铺的总共购买的商品价格
    UILabel *totalPriceLb = [[UILabel alloc] initWithFrame:CGRectMake(200, 0, 100, 30)];
    [bottomView addSubview:totalPriceLb]; //
    totalPriceLb.textColor = [UIColor redColor];
    totalPriceLb.backgroundColor = [UIColor clearColor];
    [totalPriceLb setNumberOfLines:1];
   
//    UILabel *border1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 1)];
//    [bottomView addSubview:border1];//
//    border1.backgroundColor = BORDERCOLOR;
    
    //--是否全选的   shop,第一次加载也是全选,没有计算价钱,数量,直接用  最大值
    
    UILabel *temptotalPayLb = [subViewDict objectForKey:@"totalPayLb"];
    if (!temptotalPayLb) {
        temptotalPayLb = totalPayLb;
    }
    
    if (isSelectAll) {
        selectShop.image = [UIImage imageNamed:@"selected"];
        totalTextLb.text = [NSString stringWithFormat:ITEMTOTALTEXT,[currentDic objectForKey:@"woodsTotalCount"]];
        totalPriceLb.text = [NSString stringWithFormat:ITEMTOTALRICE,[[currentDic objectForKey:@"shopPay"] doubleValue]];
        //校正总价格
        temptotalPayLb.text = [NSString stringWithFormat:SHOCATTOTALPRICE,totalMoney];
        
        //调整UILabel大小
        [totalPriceLb sizeToFit];
        CGRect frame1 = CGRectMake(300 - totalPriceLb.frame.size.width, 0, totalPriceLb.frame.size.width, 30);
        totalPriceLb.frame = frame1;
        CGRect frame2 = CGRectMake(0, 0, 300 - totalPriceLb.frame.size.width, 30);
        totalTextLb.frame = frame2;
    }else{
        selectShop.image = nil;
        totalTextLb.text = [NSString stringWithFormat:ITEMTOTALTEXT_int,itemArrCount];
        totalPriceLb.text = [NSString stringWithFormat:ITEMTOTALRICE,itemArrPrice];
        //校正总价格
        temptotalPayLb.text = [NSString stringWithFormat:SHOCATTOTALPRICE,totalMoney];
        
        //调整UILabel大小
        [totalPriceLb sizeToFit];
        CGRect frame1 = CGRectMake(300 - totalPriceLb.frame.size.width, 0, totalPriceLb.frame.size.width, 30);
        totalPriceLb.frame = frame1;
        CGRect frame2 = CGRectMake(0, 0, 300 - totalPriceLb.frame.size.width - 10, 30);
        totalTextLb.frame = frame2;
    }
    //每家店铺独自购买的总价格
    [subViewDict setObject:totalPriceLb forKey:@"totalPriceLb"];
    return cell;
}

- (void)setupButton:(UIButton *)btn normalImage:(NSString *)norImage HighlightImage:(NSString *)highImage{
    [btn setImage:[UIImage imageNamed:norImage] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:highImage] forState:UIControlStateHighlighted];
    [btn addTarget:self action:@selector(btnTouchDown:) forControlEvents:UIControlEventTouchDown];
    [btn addTarget:self action:@selector(btnTouchUp:) forControlEvents:UIControlEventTouchUpOutside|UIControlEventTouchUpInside|UIControlEventTouchCancel];
}

- (void)btnTouchDown:(UIButton *)btn{
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(changeWoodCount) userInfo:btn repeats:YES];
    [_timer fire];
}

- (void)btnTouchUp:(UIButton *)btn{
    [self cleanTimer];
}

- (void)cleanTimer{
    if (_timer.isValid) {
        [_timer invalidate];
        _timer = nil;
    }
}

//改变数字,加减按钮,
-(void)changeWoodCount{
    
    UIButton *sender =  (UIButton*)_timer.userInfo;
    NSString *flag = sender.accessibilityIdentifier;
    int index = (int)[sender tag]/10000 ;
    int i = (int)[sender tag] - index*10000;
    NSMutableDictionary *currentDic = [woodsArrByShop objectAtIndex:index-1];
    NSMutableArray *itemArr = [currentDic objectForKey:@"woodsArr"];//可以改变的
    NSMutableDictionary *woodDic = itemArr[i];//可以改变的副本
    
    UILabel *countLb = (UILabel *)[[sender superview] viewWithTag:2000];
    int currentCount = [[woodDic objectForKey:@"count"] intValue];
    double changePrice = [[woodDic objectForKey:@"price"] doubleValue];
    int changeCount = 1;
    if ([flag isEqualToString:@"a"]) {
        if (currentCount >= [[woodDic valueForKey:@"woodsLeftNums"] intValue]) {
            [self.view makeToast:@"抱歉,库存数量不足!" duration:1.2 position:@"center"];
            return;
        }
        currentCount +=1;
    }else{
        currentCount -=1;
        //变化量
        changeCount = -changeCount;
        changePrice = -changePrice;
    }
    //dibuview
    UIView *bottomView = [[[[sender superview] superview] superview] viewWithTag:5000];
    UILabel *totalTextLb = [[bottomView subviews] firstObject];
    UILabel *totalPriceLb = [[bottomView subviews] objectAtIndex:1];
    
    NSString *tagStr = [NSString stringWithFormat:@"%d",(int)[sender tag]];
    //加减操作之后的当前商品数量
    if (currentCount>0) {
        //修改角标数量,如果当前数量大于0,,,再去修改----否则给出提示
        int woodsCount = [[[[[[self tabBarController] viewControllers] objectAtIndex: SHOPCATINDEX] tabBarItem] badgeValue] intValue] + changeCount;
        NSString *woodsCountStr = [NSString stringWithFormat:@"%d",woodsCount];
        [defaults setObject:woodsCountStr forKey:SHOPCATWOODSCOUNT];
        [[[[[self tabBarController] viewControllers] objectAtIndex: SHOPCATINDEX] tabBarItem] setBadgeValue:woodsCountStr];
        
        //修改显示的数量
        countLb.text = [NSString stringWithFormat:@"%d",currentCount];
        //修改显示的  店铺合计,跳转ui大小位置,---这里不能从显示的数据取值,显示的可能有问题,
        double itemTotal = [[currentDic objectForKey:@"shopPay"] doubleValue];
        int itemTotalText = [[currentDic objectForKey:@"woodsTotalCount"] intValue];
        
        //修改存储数据----woodsArrByShop--dictionary
        [currentDic setObject:[NSString stringWithFormat:@"%0.2f",itemTotal+changePrice] forKey:@"shopPay"];
        [currentDic setObject:[NSString stringWithFormat:@"%d",itemTotalText+changeCount] forKey:@"woodsTotalCount"];
        //目前显示的购物车总价
        double totalPayMoney = [[totalPayLb.text stringByReplacingOccurrencesOfString:SHOCATTOTALPRICE_replace withString:@""] doubleValue];
        
        //底部总价的存储
        totalMoney = totalMoney + changePrice;//及时更新总价
        //当前操作的商品处于勾选状态才去改写 店铺总计 的显示,否则无效
        if ([selectedArr indexOfObject:tagStr]!= NSNotFound) {
            NSString *tmpStr = [totalTextLb.text stringByReplacingOccurrencesOfString:ITEMTOTALTEXT_replace1 withString:@""];
            NSInteger currentShopCount = [[tmpStr stringByReplacingOccurrencesOfString: ITEMTOTALTEXT_replace2  withString:@""] intValue];
            double currentShopPayMoney = [[totalPriceLb.text stringByReplacingOccurrencesOfString:ITEMTOTALRICE_replace withString:@""] doubleValue];
            
            //-----本店总计-------
            totalPriceLb.text = [NSString stringWithFormat:ITEMTOTALRICE,(float)currentShopPayMoney+changePrice];
            totalTextLb.text = [NSString stringWithFormat:ITEMTOTALTEXT_int,(int)currentShopCount+changeCount];
            //调整UILabel大小
            [totalPriceLb sizeToFit];
            CGRect frame1 = CGRectMake(300-totalPriceLb.frame.size.width, 0, totalPriceLb.frame.size.width, 30);
            totalPriceLb.frame = frame1;
            CGRect frame2 = CGRectMake(0, 0, 300-totalPriceLb.frame.size.width, 30);
            totalTextLb.frame = frame2;
            
            //修改显示的  底部合计
            totalPayLb.text = [NSString stringWithFormat:SHOCATTOTALPRICE,totalPayMoney+changePrice];
        }
        //woodDic存储,woodsArrByShop保存,上下拉动不会变,defaults存储永久存储
        //商品数量存储,本次操作商品数量变化-----
        [woodDic setObject:countLb.text forKey:@"count"];
        [defaults setObject:arraysShopCat forKey:SHOPCATWOODSARR];
    }else{
        [self.view makeToast:@"商品数量至少是1" duration:1.2 position:@"center"];
    }
}
//选中所有,添加tag到数组  selectedArr
-(void)selectAllTag{
    //清空所有数据
    [selectedArr removeAllObjects];
    //循环遍历 woodsArrByShop,添加数组selectedArr
    int shopCount = (int)woodsArrByShop.count;
    for (int i=0;i<shopCount;i++) {
        int woodsCount = (int)[[[woodsArrByShop objectAtIndex:i] objectForKey:@"woodsArr"] count];
        for (int j=0;j<woodsCount;j++) {
            NSString *tagStr = [NSString stringWithFormat:@"%d",(i+1)*10000+j];
            [selectedArr addObject:tagStr];
        }
    }
    //所有总计
    CGFloat totalpay = 0;
    for (int i = 0 ; i < [woodsArrByShop count]; i++) {
        NSDictionary *dict = [woodsArrByShop objectAtIndex:i];
        NSArray *woodsArr = [dict objectForKey:@"woodsArr"];
        for (int j = 0; j < [woodsArr count]; j++) {
            NSDictionary *dic = [woodsArr objectAtIndex:j];
            NSInteger count = [[dic objectForKey:@"count"] integerValue];
            CGFloat price = [[dic objectForKey:@"price"] floatValue];
            totalpay = totalpay + price * count;
        }
    }
    totalMoney = totalpay;
}

//点击修改商品的选择
-(void)changeSelect:(id)sender{
    isFirstToLoad = NO;
    UIView *clickV = [sender view];
    UIImageView *tmp = [[clickV subviews] firstObject];
    UIImage *tmpImg = [[UIImage alloc] init];
    if (tmp.image) {
        tmpImg = nil;
    }else{
        tmpImg = [UIImage imageNamed:@"selected"];
    }
    tmp.image = tmpImg;//点击的自己的选框首先改变---------
    if (clickV.tag==100) {
        //点击最底部选择全部
        if (tmp.image) {
            //添加所有标签
            [self selectAllTag];
            
            totalPayLb.text = [NSString stringWithFormat:SHOCATTOTALPRICE,totalMoney];
        }else{
            //删除所有标签
            [selectedArr removeAllObjects];
            totalMoney = 0;
            totalPayLb.text = @"合计: ¥ 0.00";
        }
        //为所有cell勾选
        for (UIView  *cell in [gridView subviews]) {
            //判定是cell,再找到  选框,这里的cell只是一部分(UICollection的复用机制)
            if (cell.hidden==NO&&[cell isKindOfClass:[UICollectionViewCell class]]) {
                NSArray *cellSubV = [[[cell subviews] firstObject] subviews];
                for (UIView *v in cellSubV) {
                    if (v.tag==1000) {
                        //商店的选框
                        UIImageView *selectV = [[v subviews] firstObject];
                        selectV.image = tmpImg;
                    }else if(v.tag==3000) {
                        //商品的选框
                        UIImageView *woodSelectV = [[[[v subviews] firstObject]subviews] firstObject];
                        woodSelectV.image = tmpImg;
                    }else if(v.tag==5000) {
                        //共计 %d 件商品    合计:¥
                        //商品的选框
                        UILabel *totalTextLb = [[v subviews] firstObject];
                        UILabel *totalPriceLb = [[v subviews] objectAtIndex:1];
                        if (tmp.image) {
                            int shopIndex = (int)cell.tag;
                            totalPriceLb.text = [NSString stringWithFormat:ITEMTOTALRICE,[[[woodsArrByShop objectAtIndex:shopIndex] objectForKey:@"shopPay"] floatValue]];
                            
                            totalTextLb.text = [NSString stringWithFormat:ITEMTOTALTEXT,[[woodsArrByShop objectAtIndex:shopIndex] objectForKey:@"woodsTotalCount"]];
                        }else{
                            totalPriceLb.text = @"¥ 0.00";
                            totalTextLb.text = [NSString stringWithFormat:ITEMTOTALTEXT,@"0"];
                        }
                        //调整UILabel大小
                        [totalPriceLb sizeToFit];
                        CGRect frame1 = CGRectMake(300-totalPriceLb.frame.size.width, 0, totalPriceLb.frame.size.width, 30);
                        totalPriceLb.frame = frame1;
                        
                        CGRect frame2 = CGRectMake(0, 0, 300-totalPriceLb.frame.size.width, 30);
                        totalTextLb.frame = frame2;
                    }
                }
            }
        }
    }else if(clickV.tag==1000){
        //点击每一家店铺的选择商品总开关
        UIView *mainView = [clickV superview];
        UIView *bottomView = [mainView viewWithTag:5000];//bottomView
        UILabel *totalTextLb = [[bottomView subviews] firstObject];
        UILabel *totalPriceLb = [[bottomView subviews] objectAtIndex:1];//第二个
        int shopIndex = (int)[[mainView superview] tag];
        float shopTotalPay = [[[woodsArrByShop objectAtIndex:shopIndex] objectForKey:@"shopPay"] floatValue];
        double currentTotal = [[totalPayLb.text stringByReplacingOccurrencesOfString:SHOCATTOTALPRICE_replace withString:@""] doubleValue];
        //其余商品的总价,如果这时要勾选店铺,那就是已勾选的所有商品;
        double otherPrice = 0;
        //遍历多个mainView 子item,所有商品勾选
        for (UIView *item in [mainView subviews]) {
            NSLog(@"gjroejgiore----%@",item);
            //cell
            if (item.tag==3000) {
                //clickView
                for (UIView *clickV in [item subviews]) {
                    //imageView
                    if (clickV.tag >= 10000) {
                        UIImageView* imgV = [[clickV subviews] firstObject];
                        NSString *tag = [NSString stringWithFormat:@"%ld",clickV.tag];
                        [imgV setImage:tmpImg];
                        if (tmp.image) {
                            if ([selectedArr indexOfObject:tag]==NSNotFound) {
                                //为勾选的添加到勾选数组
                                [selectedArr addObject:tag];
                            }else{
                                //已经勾选的,累加
                                UILabel *unitPrice = (UILabel *)[[[clickV superview] subviews] lastObject];
                                //可能不存在(温泉酒店)就是  1
                                int woodCount = 1;
                                UILabel *woodCountLb = (UILabel *)[[[clickV superview] viewWithTag:4000] viewWithTag:2000];
                                if (woodCountLb) {
                                    woodCount = [woodCountLb.text intValue];
                                }
                                otherPrice += [[unitPrice.text stringByReplacingOccurrencesOfString:ITEMTOTALRICE_replace withString:@""] doubleValue]*woodCount;
                            }
                            //所有商店  勾选,最下边的全选,
                            if (arraysShopCat.count==selectedArr.count) {
                                bottomSelectAll.image = tmpImg;
                            }
                        }else{
                            
                            if ([selectedArr indexOfObject:tag]!=NSNotFound) {
                                [selectedArr removeObject:tag];
                            }
                            //有一个商店没选,最下边的取消选中
                            bottomSelectAll.image = tmpImg;
                        }
                    }
                }
            }
        }
        if (tmp.image) {
            //本店总计
            totalPriceLb.text = [NSString stringWithFormat:ITEMTOTALRICE,shopTotalPay];
            totalTextLb.text = [NSString stringWithFormat:ITEMTOTALTEXT,[[woodsArrByShop objectAtIndex:shopIndex] objectForKey:@"woodsTotalCount"]];
            //所有总计------除去已经勾选的商品的总价
            currentTotal = currentTotal + shopTotalPay - otherPrice;
            totalMoney = currentTotal;
            totalPayLb.text = [NSString stringWithFormat:SHOCATTOTALPRICE,currentTotal];
            
        }else{
            //本地总计
            totalPriceLb.text = @"¥ 0.00";
            totalTextLb.text = [NSString stringWithFormat:ITEMTOTALTEXT,@"0"];
            //所有总计
            currentTotal = currentTotal - shopTotalPay;
            totalMoney = currentTotal;
            totalPayLb.text = [NSString stringWithFormat:SHOCATTOTALPRICE,currentTotal];
        }
        //调整UILabel大小
        [totalPriceLb sizeToFit];
        CGRect frame1 = CGRectMake(300-totalPriceLb.frame.size.width, 0, totalPriceLb.frame.size.width, 30);
        totalPriceLb.frame = frame1;
        CGRect frame2 = CGRectMake(0, 0, 300-totalPriceLb.frame.size.width, 30);
        totalTextLb.frame = frame2;
    }else{
        //点击某一家店铺商品选择的开关
        NSString *tag = [NSString stringWithFormat:@"%ld",clickV.tag];
        UIView *mainView = [[clickV superview] superview];
        int shopIndex = (int)[[mainView superview] tag];
        UIView *bottomView = [mainView viewWithTag:5000];
        UILabel *totalTextLb = [[bottomView subviews] firstObject];
        UILabel *totalPriceLb = [[bottomView subviews] objectAtIndex:1];
        
        if (tmp.image) {
            //-----这里勾选---------||
            //------------------------||
            if ([selectedArr indexOfObject:tag]==NSNotFound) {
                [selectedArr addObject:tag];
            }
            int index = (int)clickV.tag/10000;//当前商品对应  商店数据  的数组下表,计算tag时加1
            //当前商店  商品数量,index-1,之前有加1的  处理
            int itemCount =(int)[[[woodsArrByShop objectAtIndex:index-1] objectForKey:@"woodsArr"] count];
            int itemInArr = 0;//当前商店选中的数量
            for (id item in selectedArr) {
                int itemValue = [item intValue];
                NSLog(@"jgiorejgoirejogre----   %@   %d",item,itemValue);
                if (itemValue>index*10000-1&&itemValue<(index+1)*10000) {
                    itemInArr++;
                    NSLog(@"jgiore---%d",itemValue);
                }
            }
            //判断两个值是否相等,相等说明   都已勾选
            if (itemCount==itemInArr) {
                UIImageView *topV = [[[[[[clickV superview] superview] subviews] firstObject] subviews] firstObject];
                //-----这里偶尔-----点击结算再退回购物车,,,这个topV为nil-----
                if (topV) {
                    topV.image = tmpImg;//商铺的  选矿选中
                }
            }
            //两个数量一直,所有商品勾选
            if (arraysShopCat.count==selectedArr.count) {
                bottomSelectAll.image = tmpImg;
                //本店总计
                totalPriceLb.text = [NSString stringWithFormat:ITEMTOTALRICE,[[[woodsArrByShop objectAtIndex:shopIndex] objectForKey:@"shopPay"] floatValue]];
                totalTextLb.text = [NSString stringWithFormat:ITEMTOTALTEXT,[[woodsArrByShop objectAtIndex:shopIndex] objectForKey:@"woodsTotalCount"]];
                //所有总计
                CGFloat totalpay = 0;
                for (int i = 0 ; i < [woodsArrByShop count]; i++) {
                    NSDictionary *dict = [woodsArrByShop objectAtIndex:i];
                    NSArray *woodsArr = [dict objectForKey:@"woodsArr"];
                    for (int j = 0; j < [woodsArr count]; j++) {
                        NSDictionary *dic = [woodsArr objectAtIndex:j];
                        NSInteger count = [[dic objectForKey:@"count"] integerValue];
                        CGFloat price = [[dic objectForKey:@"price"] floatValue];
                        totalpay = totalpay + price * count;
                    }
                }
                totalMoney = totalpay;
                totalPayLb.text = [NSString stringWithFormat:SHOCATTOTALPRICE,totalMoney];
            }else{
                //没有全部勾选,在总价基础上   加  当前选中的商品价格
                //数量
                int woodCount = 1;
                UILabel *woodCountLb = (UILabel *)[[[clickV superview] viewWithTag:4000] viewWithTag:2000];
                if (woodCountLb) {
                    woodCount = [woodCountLb.text intValue];
                }
                //当前商品价格
                UILabel *priceLb = [[[clickV superview] subviews] lastObject];
                double price = [[priceLb.text stringByReplacingOccurrencesOfString:ITEMTOTALRICE_replace withString:@""] doubleValue]*woodCount;
                //修改价钱
                double currentShopPrice = [[totalPriceLb.text stringByReplacingOccurrencesOfString:ITEMTOTALRICE_replace withString:@""] doubleValue];
                totalPriceLb.text = [NSString stringWithFormat:ITEMTOTALRICE,currentShopPrice+price];
                //修改数量
                NSString *tmpStr = [totalTextLb.text stringByReplacingOccurrencesOfString:ITEMTOTALTEXT_replace1 withString:@""];
                int currentShopCount = [[tmpStr stringByReplacingOccurrencesOfString: ITEMTOTALTEXT_replace2  withString:@""] intValue];
                
                totalTextLb.text = [NSString stringWithFormat:ITEMTOTALTEXT_int,currentShopCount+woodCount];
                //所有总计
                double currentTotal = [[totalPayLb.text stringByReplacingOccurrencesOfString:SHOCATTOTALPRICE_replace withString:@""] doubleValue];
                totalMoney = currentTotal+price;
                totalPayLb.text = [NSString stringWithFormat:SHOCATTOTALPRICE,currentTotal+price];
            }
            //调整UILabel大小
            [totalPriceLb sizeToFit];
            CGRect frame1 = CGRectMake(300-totalPriceLb.frame.size.width, 0, totalPriceLb.frame.size.width, 30);
            totalPriceLb.frame = frame1;
            CGRect frame2 = CGRectMake(0, 0, 300-totalPriceLb.frame.size.width, 30);
            totalTextLb.frame = frame2;
        }else{
            //-----这里取消勾选---------||
            //------------------------||
            if ([selectedArr indexOfObject:tag]!=NSNotFound) {
                [selectedArr removeObject:tag];
            }
            //只要取消一个,,全选框就取消,
            UIImageView *topV = [[[[[[clickV superview] superview] subviews] firstObject] subviews] firstObject];
            //----这里偶尔-----点击结算,----再退回购物车后为空 nil-----
            if (topV) {
                topV.image = tmpImg;//商铺的  选矿选中
            }
            
            //有一个商品取消勾选,最底部的全选就取消
            bottomSelectAll.image = tmpImg;
            
            //-----
            int currentWoodCount = 1;
            UILabel *countView = (UILabel *)[[[clickV superview] viewWithTag:4000] viewWithTag:2000];
            if (countView) {
                currentWoodCount = [countView.text intValue];
            }
            //在总价基础上   减  当前选中的商品价格
            UILabel *priceLb = [[[clickV superview] subviews] lastObject];
            double price = [[priceLb.text stringByReplacingOccurrencesOfString:ITEMTOTALRICE_replace withString:@""] doubleValue]*currentWoodCount;
            
            double currentTotal = [[totalPayLb.text stringByReplacingOccurrencesOfString:SHOCATTOTALPRICE_replace withString:@""] doubleValue];
            totalMoney = currentTotal-price;
            totalPayLb.text = [NSString stringWithFormat:SHOCATTOTALPRICE,currentTotal-price];
            
            //商铺总计,修改总计,商品数量
            double currentShopTotal = [[totalPriceLb.text stringByReplacingOccurrencesOfString:ITEMTOTALRICE_replace withString:@""] doubleValue];
            totalPriceLb.text = [NSString stringWithFormat:ITEMTOTALRICE,currentShopTotal-price];
            //int shopItemCount =
            NSString *tmpStr = [totalTextLb.text stringByReplacingOccurrencesOfString:ITEMTOTALTEXT_replace1 withString:@""];
            int currentShopCount = [[tmpStr stringByReplacingOccurrencesOfString: ITEMTOTALTEXT_replace2  withString:@""] intValue];
            currentShopCount = currentShopCount - currentWoodCount;
            totalTextLb.text = [NSString stringWithFormat:ITEMTOTALTEXT_int,currentShopCount];
            
            //调整UILabel大小
            [totalPriceLb sizeToFit];
            CGRect frame1 = CGRectMake(300-totalPriceLb.frame.size.width, 0, totalPriceLb.frame.size.width, 30);
            totalPriceLb.frame = frame1;
            CGRect frame2 = CGRectMake(0, 0, 300-totalPriceLb.frame.size.width, 30);
            totalTextLb.frame = frame2;
        }
    }
    //重新计算总价格
    CGFloat totalpay = 0;
    for (int i = 0; i < [woodsArrByShop count]; i++) {
        NSDictionary *dic = [woodsArrByShop objectAtIndex:i];
        NSArray *woodsArr = [dic objectForKey:@"woodsArr"];
        for (int j = 0; j < [woodsArr count]; j++) {
            NSDictionary *goodsDict = [woodsArr objectAtIndex:j];
            NSInteger index = (i + 1) * 10000 + j;
            if ([self isWoodsSelectWithIndex:index]) {
                CGFloat price = [[goodsDict objectForKey:@"price"] floatValue];
                NSInteger count = [[goodsDict objectForKey:@"count"] integerValue];
                totalpay = totalpay + price * count;
            }
        }
    }
    totalMoney = totalpay;
    totalPayLb.text = [NSString stringWithFormat:SHOCATTOTALPRICE,totalMoney];
    [gridView reloadData];
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    int index = (int)indexPath.item;
    //CGFloat aFloat = 0;
    //UIImage* image = self.imagesArr[indexPath.item];
    //aFloat = self.imagewidth/image.size.width;
    NSDictionary *tmp = woodsArrByShop[index];//临时数组
    NSArray *woodArray = [tmp objectForKey:@"woodsArr"];
    int height = (int)woodArray.count * 90 + 60 + 5;
    CGSize size = CGSizeMake(MAINSCREEN_WIDTH,height);
    //[self getTextViewHeight:indexPath];
    //size = CGSizeMake(self.imagewidth, image.size.height*aFloat+self.textViewHeight);
    return size;
}

//点击重置
-(void)resetDateView:(id)sender{
    NSDate *senddate=[NSDate date];
    UIDatePicker *dpicker = (UIDatePicker *)[datePickerView viewWithTag:8888];
    dpicker.date = senddate;
}

- (NSDate *)getNowDayArriveTime
{
    NSDate *currentDate = [[NSDate alloc] init];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    
    NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
    [dateFormatter1 setDateFormat:@"yyyy-MM-dd"];
    NSString *strDate = [dateFormatter1 stringFromDate:[NSDate date]];
    NSString *mystrDate = [NSString stringWithFormat:@"%@ 14:00",strDate];  //理论要求最早到达时间，当天14:00
    
    NSDate *myDate = [dateFormatter dateFromString:mystrDate];
    NSDate *lateDate = [myDate laterDate:currentDate];
    return lateDate;
}

//点击确定,取消---隐藏view
-(void)hideDateView:(UIButton *)sender{
    if ([sender tag]==1) {
        
        //这里只修改woodsArrByShop的数据----注意tag
        int index = (int)[currentDateLb tag] / 10000;
        int i = (int)[currentDateLb tag] - index * 10000;
        NSMutableDictionary *currentDic = [woodsArrByShop objectAtIndex:index-1];
        NSMutableArray *itemArr = [currentDic objectForKey:@"woodsArr"];//可以改变的
        NSMutableDictionary *woodDic = itemArr[i];//可以改变的副本
        NSString *guid = [woodDic objectForKey:@"Guid"];
        
        //如果是---按钮,tag==1,那么是确定按钮,否则点击的是取消按钮或者是  mask view层
        UIDatePicker *dpicker = (UIDatePicker *)[datePickerView viewWithTag:8888];
        
        NSDate *selected = [dpicker date];
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm"];
        
        NSDateFormatter *dateFormat1 = [[NSDateFormatter alloc] init];
        [dateFormat1 setDateFormat:@"yyyy-MM-dd"];
        NSString *theDate1 = [dateFormat1 stringFromDate:selected];
        
        NSString *theDate = theDate1;
        
        //中午十二点退房
        NSDate *minDate = dpicker.minimumDate;
        NSDate *nowDateArriveDate = [self getNowDayArriveTime];
        
        
        if ([minDate compare:nowDateArriveDate] == NSOrderedSame || [minDate compare:nowDateArriveDate] == NSOrderedAscending) {
            theDate = [dateFormat stringFromDate:selected];
            
            if ([Tools isSpringHotelWithGuid:guid]) {
                NSString *subtheDate = @"";
                @try {
                    subtheDate = [theDate substringFromIndex:11];
                }
                @catch (NSException *exception) {
                    subtheDate = @"14:00";
                }
                @finally {
                    
                }
                
                if (!([subtheDate compare:@"13:59" options:NSCaseInsensitiveSearch] == NSOrderedDescending && [subtheDate compare:@"24:00" options:NSCaseInsensitiveSearch] == NSOrderedAscending)) {
                    subtheDate = @"14:00";
                    
                    NSString *subtheDate1 = @"";
                    @try {
                        subtheDate1 = [theDate substringToIndex:11];
                    }
                    @catch (NSException *exception) {
                        subtheDate1 = [dateFormat1 stringFromDate:nowDateArriveDate];
                        subtheDate1 = [NSString stringWithFormat:@"%@ ",subtheDate1];
                    }
                    @finally {
                        
                    }
                    
                    theDate = [NSString stringWithFormat:@"%@%@",subtheDate1,subtheDate];
                    
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"入住时间必须是:14:00 ~ 24:00" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
                    [alert show];
                }
            }
            
            
        }   
        else{
            //如果设置的是离开时间，需要写死设置为12:00，也就是说用户只能设置日期，不能设置退房的具体时间是什么时候
            theDate = [NSString stringWithFormat:@"%@ 12:00",theDate1];
        }
        
        currentDateLb.text = theDate;
        currentDateLb.layer.borderColor = [UIColor blackColor].CGColor;
        
        
        //woodDic存储,woodsArrByShop保存,上下拉动不会变,defaults存储永久存储
        //到达离开时间存储
        [woodDic setObject:theDate forKey:currentDateLb.accessibilityIdentifier];
        [defaults setObject:arraysShopCat forKey:SHOPCATWOODSARR];
        
        
        guid = [Tools deleStringWithGuid:guid];
        NSString *shopId = [woodDic objectForKey:@"shopId"];
        NSString *arriveTime=@"",*leaveTime=@"";
        if ([woodDic objectForKey:@"arriveTime"]) {
            arriveTime = [woodDic objectForKey:@"arriveTime"];
        }
        if ([woodDic objectForKey:@"leaveTime"]) {
            leaveTime = [woodDic objectForKey:@"leaveTime"];
        }
        NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:@"0229",@"apiid",guid,@"productGuid",@"",@"imei",@"",@"mac",[Tools getDeviceUUid],@"deviceid",shopId,@"shopid",arriveTime,@"arriveTime", leaveTime,@"leaveTime",nil];
        if ([Tools isSpringHotelWithGuid:guid]) {
            if (arriveTime.length >= 10 && leaveTime.length >= 10) {
                [self updatePriceWithDict:dict itemIndex:index arrIndex:i currentLabel:currentDateLb];
            }
        }
        else{
            if (arriveTime.length >= 10) {
                [self updatePriceWithDict:dict itemIndex:index arrIndex:i currentLabel:currentDateLb];
            }
        }
    }
    [[datePickerView superview] setHidden:YES];
    CGRect frame = CGRectMake(0, WINDOWHEIGHT, MAINSCREEN_WIDTH, 250);
    datePickerView.frame = frame;
}

//更新价格
-(void)updatePriceWithDict:(NSDictionary *)param itemIndex:(int)itemIndex arrIndex:(int)arrIndex currentLabel:(UILabel *)label
{
    BOOL select = NO;
    UIImageView *image = nil;
    UIView *superview = label.superview.superview;
    NSArray *subviews = superview.subviews;
    for (UIView *subview in subviews) {
        if ([subview isMemberOfClass:[UIImageView class]]) {
            image = (UIImageView *)subview;
            break;
        }
    }
    NSLog(@"%@",image.image);
    if (image.image) {
        select = YES;
    }
    [[AFOSCClient sharedClient] postPath:nil parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject){
        [self hideHud];
        NSString *respondstring = operation.responseString;
        NSDictionary *respondDict = [respondstring objectFromJSONString];
        
        NSString *ShopPrice = [respondDict objectForKey:@"result"];
        if ([ShopPrice isMemberOfClass:[NSNull class]] || ShopPrice == nil) {
            ShopPrice = @"";
        }
        if ([ShopPrice floatValue] == 0) {
            if ([lastSelectDataString isEqualToString:@"点击选择时间"]) {
                currentDateLb.text = lastSelectDataString;
            }
            else{
                NSString *prefixStirng = @"";
                if ([lastSelectDataString hasPrefix:@"arriveTime:"]) {
                    prefixStirng = @"arriveTime:";
                }
                else if ([lastSelectDataString hasPrefix:@"leaveTime:"]) {
                    prefixStirng = @"leaveTime:";
                }
                NSRange range = [lastSelectDataString rangeOfString:prefixStirng];
                if (range.length != 0) {
                    NSString *datestring = [lastSelectDataString substringFromIndex:range.length];
                    currentDateLb.text = datestring;
                }
                
            }
            [self showHint:@"价格修改失败"];
            return;
        }
        [self changePriceWithPrice:ShopPrice itemIndex:itemIndex arrIndex:arrIndex select:select];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error){
        [self hideHud];
        if ([lastSelectDataString isEqualToString:@"点击选择时间"]) {
            currentDateLb.text = lastSelectDataString;
        }
        else{
            NSString *prefixStirng = @"";
            if ([lastSelectDataString hasPrefix:@"arriveTime:"]) {
                prefixStirng = @"arriveTime:";
            }
            else if ([lastSelectDataString hasPrefix:@"leaveTime:"]) {
                prefixStirng = @"leaveTime:";
            }
            NSRange range = [lastSelectDataString rangeOfString:prefixStirng];
            if (range.length != 0) {
                NSString *datestring = [lastSelectDataString substringFromIndex:range.length];
                currentDateLb.text = datestring;
            }
            
        }
        [self showHint:REQUESTERRORTIP];
    }];
    
}

//修改价格
- (void)changePriceWithPrice:(NSString *)ShopPrice itemIndex:(int)itemIndex arrIndex:(int)arrIndex select:(BOOL)select
{
    NSMutableDictionary *currentDic = [woodsArrByShop objectAtIndex:itemIndex - 1];
    NSMutableArray *itemArr = [currentDic objectForKey:@"woodsArr"];//可以改变的
    NSMutableDictionary *woodDic = itemArr[arrIndex];//可以改变的副本
    //woodDic存储,woodsArrByShop保存,上下拉动不会变,defaults存储永久存储
    //到达离开时间存储
    CGFloat orignalPrice = [[woodDic objectForKey:@"price"] floatValue];
    [woodDic setObject:ShopPrice forKey:@"price"];
    
    NSInteger count = [[woodDic objectForKey:@"count"] integerValue];
    CGFloat offsetPrice = ([ShopPrice floatValue]- orignalPrice) * count;
    if (select) {
        totalMoney = totalMoney + offsetPrice;
    }
    
    
    CGFloat totalPrice = 0;
    for (int i = 0; i < [itemArr count]; i++) {
        NSDictionary *dic = [itemArr objectAtIndex:i];
        NSString *guid = [dic objectForKey:@"Guid"];
        if ([guid isMemberOfClass:[NSNull class]] || guid == nil) {
            guid = @"";
        }
        NSInteger selectIndex = itemIndex * 10000 + i;
        if ([self isWoodsSelectWithIndex:selectIndex]) {
            int count = [[dic objectForKey:@"count"] intValue];
            CGFloat price = [[dic objectForKey:@"price"] floatValue];
            totalPrice = count * price + totalPrice;
        }
        
    }
    [currentDic setObject:[NSString stringWithFormat:@"%.2f",totalPrice] forKey:@"shopPay"];
    [defaults setObject:arraysShopCat forKey:SHOPCATWOODSARR];
    [gridView reloadData];
    UILabel *totalTextLb = [subViewDict objectForKey:@"totalPayLb"];
    UILabel *totalPriceLb = [subViewDict objectForKey:@"totalPriceLb"];;
    totalTextLb.text = [NSString stringWithFormat:SHOCATTOTALPRICE,totalMoney];
    totalPriceLb.text = [NSString stringWithFormat:ITEMTOTALRICE,totalPrice];
}

- (BOOL)isGoodsSelectWithGuid:(NSString *)guid
{
    for (NSString *key in selectedArr) {
        if ([guid
             hasSuffix:key]) {
            return YES;
        }
    }
    return NO;
}

//显示时间选择
-(void)showDatePicker:(id)sender
{
    NSDate *currentDate = [[NSDate alloc] init];
    UIDatePicker *dpicker = (UIDatePicker *)[datePickerView viewWithTag:8888];

    currentDateLb = (UILabel *)[sender view];
    currentDateLb.tag = [[sender view] tag];//cell的tag
    
    NSInteger shopIndex = currentDateLb.tag / 10000 - 1;
    NSInteger goodsIndex = currentDateLb.tag % 10000;
    NSDictionary *currentDic = [woodsArrByShop objectAtIndex:shopIndex];
    NSArray *itemArr = [currentDic objectForKey:@"woodsArr"];
    NSDictionary *goodsDict = [itemArr objectAtIndex:goodsIndex];
    NSLog(@"%@",goodsDict);
    NSString *Guid = [goodsDict objectForKey:@"Guid"];
    if ([Guid isMemberOfClass:[NSNull class]] || Guid == nil) {
        Guid = @"";
    }
    NSString *idStr = currentDateLb.accessibilityIdentifier;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    if ([idStr isEqualToString:@"arriveTime"]) {
        if (![currentDateLb.text isEqualToString:@"点击选择时间"] && ![currentDateLb.text isEqualToString:@"点击选择抵达时间"]) {
            lastSelectDataString = [NSString stringWithFormat:@"arriveTime:%@",currentDateLb.text];
            NSString *selectDateString = [lastSelectDataString substringFromIndex:[@"arriveTime:" length]];
            NSDate *nowSelectDate = [dateFormatter dateFromString:selectDateString];
            dpicker.date = nowSelectDate;
        }
        
        dpicker.minimumDate = currentDate;
        dpicker.datePickerMode = UIDatePickerModeDateAndTime;
        if ([Tools isSpringHotelWithGuid:Guid]) {
            //如果是客房，抵达时间应该是在当天时间14:00以后
            NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
            [dateFormatter1 setDateFormat:@"yyyy-MM-dd"];
            NSString *strDate = [dateFormatter1 stringFromDate:[NSDate date]];
            NSString *mystrDate = [NSString stringWithFormat:@"%@ 14:00",strDate];  //理论要求最早到达时间，当天14:00
            
            NSDate *myDate = [dateFormatter dateFromString:mystrDate];
            NSDate *lateDate = [myDate laterDate:currentDate];
            dpicker.minimumDate = lateDate;
            
            
        }
        NSArray *subViewArr = [[[sender view] superview] subviews];
        if (subViewArr.count>1) {
            UILabel *leaveTimeLb = (UILabel *)[subViewArr lastObject];
            //如果离开时间还没有填写,那么这里的转换为 null,minimumDate设置无效,
            NSDate *maxDate = [dateFormatter dateFromString:leaveTimeLb.text];
            if (maxDate) {
                dpicker.maximumDate = maxDate;//最大值
            }
            //这里要判断是否有leaveTime,如果有的话设置最大值
        }
    }else if ([idStr isEqualToString:@"leaveTime"]){
        if (![currentDateLb.text isEqualToString:@"点击选择时间"] && ![currentDateLb.text isEqualToString:@"点击选择离开时间"]) {
            lastSelectDataString = [NSString stringWithFormat:@"leaveTime:%@",currentDateLb.text];
            NSString *selectDateString = [lastSelectDataString substringFromIndex:[@"leaveTime:" length]];
            NSDate *nowSelectDate = [dateFormatter dateFromString:selectDateString];
            dpicker.date = nowSelectDate;
        }
        
        UILabel *arriveTimeLb = (UILabel *)[[[[sender view] superview] subviews] firstObject];
        if ([arriveTimeLb.text isEqualToString:@"点击选择时间"] || [arriveTimeLb.text isEqualToString:@"点击选择抵达时间"]) {
            [self showHint:@"请选择预计抵达时间"];
            return;
        }
        NSString *arrivestring = arriveTimeLb.text;
        NSDate *miniDate = [dateFormatter dateFromString:arrivestring];
        
        NSTimeInterval  interval = 24 * 60 * 60;
        NSDate *date1 = [[NSDate alloc] initWithTimeInterval:interval sinceDate:miniDate]; //後1天的日期
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSString *strDate = [dateFormatter stringFromDate:date1];
        strDate = [NSString stringWithFormat:@"%@ 12:00:00",strDate];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDate *date2 = [dateFormatter dateFromString:strDate];
        
        //        [miniDate da]
        if (date2) {
            dpicker.minimumDate = date2;//最小值
        }else{
            dpicker.minimumDate = [[NSDate alloc] init];//当前时间
        }
        dpicker.maximumDate = nil;
        dpicker.datePickerMode = UIDatePickerModeDate;
    }
    [[datePickerView superview] setHidden:NO];
    [UIView animateWithDuration:0.4 animations:^{
        CGRect frame = CGRectMake(0, WINDOWHEIGHT - 250, MAINSCREEN_WIDTH, 250);
        datePickerView.frame = frame;
    }];
}

//-----------内存不足报警------
-(void)didReceiveMemoryWarning
{
    [[NSUserDefaults standardUserDefaults] synchronize];
    [super didReceiveMemoryWarning];
    NSLog(@"memory warning,kkappdelegate---");
    //NSLog(@"ShopCat~~~~~~~~~~~~~~level~~~~~~~~~~~~~~~ %d",OSMemoryNotificationCurrentLevel());
}
@end
