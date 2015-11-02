//
//  KKFirstViewController.m
//  Tuan
//
//  Created by 夏 华 on 12-7-3.
//  Copyright (c) 2012年 无锡恩梯梯数据有限公司. All rights reserved.
//

#import "OrderListController.h"
#import <objc/message.h>
#import <QuartzCore/QuartzCore.h>
#import "DetailViewController.h"
#import "UIImageView+WebCache.h"
#import "ApplyRefundMentViewController.h"
#import "SDRefresh.h"
#define ORDERLOADPAGECOUNT 8

@interface OrderListController (){
    NSArray *allArray;//整理后的完整切已经分类的订单列表数据 分类顺序--[全部->待付款->待发货->待收货->待评价]
    NSMutableArray *arrays;//全部
    NSMutableArray *notPayedArrays;//待付款
    NSMutableArray *notShipArrays;//代发货
    NSMutableArray *notSignArrays;//待收货
    NSMutableArray *notEvaluateArrays;//待评价
    AFHTTPClient * httpClient;

    NSArray *orderStatusStrArr;
    NSArray *orderBtnTitleArr;
    NSMutableDictionary  *orderInfoDic;//支付参数
    
    int pageIndex;
    SDRefreshHeaderView *refreshHeader;
    SDRefreshFooterView *refreshFooter;
    
    }
@end

@implementation OrderListController

@synthesize defaults;
@synthesize addStatusBarHeight;
@synthesize topSegmentView;
@synthesize flagLb;
@synthesize currentItemTag;
@synthesize gridView;
@synthesize orderArrays;
@synthesize noOrderView;
@synthesize imageCache;

- (void)viewDidLoad
{
    [super viewDidLoad];//没有词句,会执行多次
    [self initialization]; //视图的一些初始化
    [self initOrderList];
    [self setupHeader];
    [self setupFooter];
}

- (void)setupHeader
{
    refreshHeader = [SDRefreshHeaderView refreshView];
    // 默认是在navigationController环境下，如果不是在此环境下，请设置 refreshHeader.isEffectedByNavigationController = NO;
    [refreshHeader addToScrollView:gridView];
    __weak SDRefreshHeaderView *weakRefreshHeader = refreshHeader;
    __block typeof(self) bself = self;
    refreshHeader.beginRefreshingOperation = ^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [bself refreshOrderList];
            [weakRefreshHeader endRefreshing];
        });
    };
    
    // 进入页面自动加载一次数据
    [refreshHeader beginRefreshing];
}

-(void)refreshOrderList{
    pageIndex = 0;
    if (currentItemTag == 0) {
        [self getOrderData];
    }else{
        [self getWoodOrdersData];
    }
}

-(void)setupFooter{
    refreshFooter = [SDRefreshFooterView refreshView];
    [refreshFooter addToScrollView:gridView];
    [refreshFooter addTarget:self refreshAction:@selector(footerRefresh)];
}

- (void)footerRefresh
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [refreshFooter endRefreshing];
        int orderCount = (pageIndex + 1)*ORDERLOADPAGECOUNT;
        if ([allArray[currentItemTag] count] <= orderCount) {
            //无下一页
            return;
        }else{
            //------超出底部加载更多----
            pageIndex++;
            [self getWoodOrdersData];
        }
    });
}

- (void)initialization
{
    imageCache = [[NSCache alloc] init];
    addStatusBarHeight = [TopNaviViewController getStatusBarHeight];
    defaults =[NSUserDefaults standardUserDefaults];
    self.view.backgroundColor = [UIColor colorWithRed:242.0/255 green:242.0/255 blue:242.0/255 alpha:1.0];
    
    httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:APIURL]];
    topSegmentView = [[UIView alloc] initWithFrame:CGRectMake(0, addStatusBarHeight + TOPNAVIHEIGHT, MAINSCREEN_WIDTH, 40)];
    [self.view addSubview:topSegmentView];
    topSegmentView.backgroundColor = [UIColor whiteColor];
    NSArray *titleArr_order = @[@"全部",@"待付款",@"待发货",@"待收货",@"待评价"];
    NSInteger itemNum_order = titleArr_order.count;
    for (int i = 0; i < itemNum_order; i++) {
        UILabel *text = [[UILabel alloc] initWithFrame:CGRectMake(64 * i, 0, 64, 40)];
        text.text = titleArr_order[i];
        text.userInteractionEnabled = YES;
        if (i == currentItemTag) {
            text.textColor = [UIColor redColor];
        }
        text.textAlignment = NSTextAlignmentCenter;
        text.font = TEXTFONT;
        [topSegmentView addSubview:text];//text
        text.tag = 100 + i;
        UITapGestureRecognizer *singleTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onClickItem:)];
        [text addGestureRecognizer:singleTap];//---添加点击事件
    }
    
    UILabel *border1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 39, MAINSCREEN_WIDTH, 1)];
    [topSegmentView addSubview:border1];
    border1.backgroundColor = BORDERCOLOR;
    
    flagLb = [[UILabel alloc] initWithFrame:CGRectMake(64*currentItemTag, 39, 64, 1)];
    [topSegmentView addSubview:flagLb];
    flagLb.backgroundColor = [UIColor redColor];
    //隐藏首页的  城市按钮
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = layout.minimumInteritemSpacing;
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    gridView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, addStatusBarHeight+40+TOPNAVIHEIGHT, MAINSCREEN_WIDTH, self.view.frame.size.height-40-TOPNAVIHEIGHT-addStatusBarHeight) collectionViewLayout:layout];
    [self.view addSubview:gridView];
    gridView.backgroundColor = VIEWBGCOLOR;
    gridView.delegate = self;
    gridView.dataSource = self;
    [gridView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    
    //----没有订单的视图----
    int contentHeight = self.view.frame.size.height-40-44;
    noOrderView = [[UIView alloc] initWithFrame:CGRectMake(0, addStatusBarHeight+40+44, MAINSCREEN_WIDTH, contentHeight)];
    [self.view addSubview:noOrderView];
    noOrderView.hidden = YES;//隐藏
    
    UIView *noOrderContent = [[UIView alloc] initWithFrame:CGRectMake(0, (contentHeight - 150)/2, MAINSCREEN_WIDTH, 150)];
    [noOrderView addSubview:noOrderContent];
    
    //----图片----
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(110, 0, 100, 100)];
    [noOrderContent addSubview:imgView];
    imgView.image = [UIImage imageNamed:@"noOrder"];
    //----文字----
    UILabel *noOrderText = [[UILabel alloc] initWithFrame:CGRectMake(60, 110, 200, 40)];
    [noOrderContent addSubview:noOrderText];
    noOrderText.backgroundColor = [UIColor clearColor];
    noOrderText.textAlignment = NSTextAlignmentCenter;
    noOrderText.textColor = [UIColor grayColor];
    noOrderText.text = @"抱歉,没有找到相关订单";
    
    //滑动手势
    UISwipeGestureRecognizer * recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [self.view addGestureRecognizer:recognizer];
    
    recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionLeft)];
    [self.view addGestureRecognizer:recognizer];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(initOrderList) name:@"initOrderList" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reFreshOrderList:) name:@"reFreshOrderListNotification" object:nil];
    //支付成功后,刷新整个列表
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getOrderData) name:@"OrderListPaySuccessNotification" object:nil];
}

//初始化订单列表
-(void)initOrderList{
    pageIndex = 0;
    arrays            = [[NSMutableArray alloc] init];//初始化
    notPayedArrays    = [[NSMutableArray alloc] init];
    notShipArrays     = [[NSMutableArray alloc] init];
    notSignArrays     = [[NSMutableArray alloc] init];
    notEvaluateArrays = [[NSMutableArray alloc] init];
    allArray = @[arrays,notPayedArrays,notShipArrays,notSignArrays,notEvaluateArrays];
//    currentItemTag = 0;
    orderStatusStrArr = @[@"待付款",@"已付款",@"待收货",@"交易成功",@"已取消"];
    orderBtnTitleArr = @[@[@"取消订单",@"付款",@"cancleOrder:",@"gotoPayOff:"],@[@"申请退款",@"drawback:"],@[@"查看物流",@"确认收货",@"viewLogistics:",@"confirmReceiving:"],@[@"申请退款",@"查看物流",@"评价订单",@"drawback:",@"viewLogistics:",@"commentOrder:"]];
    orderArrays = [[NSMutableArray alloc] init];//初始化
    pageIndex = 0;//----分页,页数-----
    [self getOrderData];//获取数据---加载view
}

//-----修改标题,重写父类方法----
-(NSString*)getTitle{
    return @"订单中心";
}
//----获取数据-------
-(void)getOrderData{
    //显示loading
    [Waiting show];
    NSString *userName = [[defaults objectForKey:@"userLoginInfo"] objectForKey:@"MemLoginID"];
    //-----------type---1(最近一个月的),2
    NSDictionary * params = @{@"apiid": @"0033",@"uId":userName,@"type":@"2"};
    NSURLRequest * request = [httpClient requestWithMethod:@"POST"
                                                  path:@""
                                            parameters:params];
    AFHTTPRequestOperation * operation = [httpClient HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];//json解析
        if (jsonData) {
            [Waiting dismiss];
            orderArrays = [[jsonData objectForKey:@"orderlist"] objectForKey:@"orderbean"];
            if (orderArrays.count>0) {
                //若有缓存数据,先移除
                if ([arrays count] > 0) {
                    [arrays removeAllObjects];
                    [notPayedArrays removeAllObjects];
                    [notShipArrays removeAllObjects];
                    [notSignArrays removeAllObjects];
                    [notEvaluateArrays removeAllObjects];
                }
                
                for (int i = 0; i < orderArrays.count; i++) {
                    NSString *OderStatus     = [[orderArrays objectAtIndex:i] objectForKey:@"OderStatus"];
                    NSString *ShipmentStatus = [[orderArrays objectAtIndex:i] objectForKey:@"ShipmentStatus"];
                    NSString *PaymentStatus  = [[orderArrays objectAtIndex:i] objectForKey:@"PaymentStatus"];
                    NSString *orderNumber    = [[orderArrays objectAtIndex:i] objectForKey:@"OrderNumber"];
                    NSString *shouldPayPrice = [[orderArrays objectAtIndex:i] objectForKey:@"ShouldPayPrice"];
                    NSString *createTime     = [[orderArrays objectAtIndex:i] objectForKey:@"CreateTime"];
                    NSString *mobile         = [[orderArrays objectAtIndex:i] objectForKey:@"Mobile"];
                    NSString *name           = [[orderArrays objectAtIndex:i] objectForKey:@"Name"];
                    NSString *address        = [[orderArrays objectAtIndex:i] objectForKey:@"Address"];
                    NSString *agentId        = [[orderArrays objectAtIndex:i] objectForKey:@"AgentId"];
                    
                    NSMutableDictionary *tempDic = [NSMutableDictionary dictionaryWithDictionary: @{@"OrderNumber":orderNumber,
                                                                                                     @"OderStatus":OderStatus,
                                                                                                 @"ShipmentStatus":ShipmentStatus,
                                                                                                  @"PaymentStatus":PaymentStatus,
                                                                                                 @"ShouldPayPrice":shouldPayPrice,
                                                                                                     @"CreateTime":createTime,
                                                                                                         @"Mobile":mobile,
                                                                                                           @"Name":name,
                                                                                                        @"Address":address,
                                                                                                        @"AgentId":agentId}];
                    
                    //将数组分门别类----,tempDic添加属性orderTypeId以便在全部里识别
                    if ([PaymentStatus isEqualToString:@"0"]) {
                        [tempDic setObject:@"0" forKey:@"orderTypeId"];
                        [notPayedArrays addObject:tempDic];//--待付款
                    }else if ([PaymentStatus isEqualToString:@"2"]&&[ShipmentStatus isEqualToString:@"0"]){
                        [tempDic setObject:@"1" forKey:@"orderTypeId"];
                        [notShipArrays addObject:tempDic];//--待发货
                    }else if ([PaymentStatus isEqualToString:@"2"]&&[ShipmentStatus isEqualToString:@"1"]&&![OderStatus isEqualToString:@"5"]){
                        [tempDic setObject:@"2" forKey:@"orderTypeId"];
                        [notSignArrays addObject:tempDic];//--待收货
                    }else if ([PaymentStatus isEqualToString:@"2"]&&[ShipmentStatus isEqualToString:@"2"]){
                        [tempDic setObject:@"3" forKey:@"orderTypeId"];
                        [notEvaluateArrays addObject:tempDic];//--待评价
                    }
                    //区别以上两字段单独判断
                    if ([OderStatus isEqualToString:@"2"]){
                        [tempDic setObject:@"4" forKey:@"orderTypeId"];//--已取消
                    }else if([OderStatus isEqualToString:@"5"]){
                        [tempDic setObject:@"3" forKey:@"orderTypeId"];
                        [notEvaluateArrays addObject:tempDic];//--待评价--
                    }
                     [arrays addObject:tempDic];//所有数组保存的对象,在arrays也有一份,并且相同
                }
                [self getWoodOrdersData];
            }else{
                [Waiting dismiss];
                noOrderView.hidden = NO;
            }
        }else{
            [Waiting dismiss];
            [self.view makeToast:@"数据错误请稍后重试" duration:1.5 position:@"center"];
        }
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"faild , error == %@ ", error);
        [Waiting dismiss];
        [self.view makeToast:@"网络错误请重试" duration:1.5 position:@"center"];
    }];
    [operation start];//-----发起请求------
}

//分别获取分页数据
-(void)getWoodOrdersData{
    int orderCount = (pageIndex + 1)*ORDERLOADPAGECOUNT;
    if ([allArray[currentItemTag] count] <= orderCount) {
        //无下一页
        orderCount = (int)[allArray[currentItemTag] count];
    }
    
    if (orderCount == 0) {
        //移除原有界面
//        NSArray *tmp = [gridView subviews];
//        for (int i=0;i<tmp.count;i++) {
//            [tmp[i] removeFromSuperview];
//        }
        [gridView reloadData];
         noOrderView.hidden = NO;
        return;
    }
    
    [Waiting show];
    for (int i = pageIndex*ORDERLOADPAGECOUNT ; i < orderCount; i++) {
        
        NSDictionary *item = [allArray[currentItemTag] objectAtIndex:i];
        NSString *orderNumber = [item objectForKey:@"OrderNumber"];
        NSLog(@"订单号:%d:%@",i,orderNumber);
        NSDictionary * params = @{@"apiid": @"0072",@"ordernumber":orderNumber};
        NSURLRequest * request = [httpClient requestWithMethod:@"POST"
                                                          path:@""
                                                    parameters:params];
        AFHTTPRequestOperation * operation = [httpClient HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSError *error;
            NSDictionary *jsonData = [[CJSONDeserializer deserializer]deserialize:responseObject error:&error];
            if (jsonData) {
                NSArray *tempArr = [[jsonData objectForKey:@"orderproductlist"] objectForKey:@"orderproductbean"];
                
                NSMutableArray *tempArr_copy = [[NSMutableArray alloc] initWithCapacity:tempArr.count];
                NSString *body = @"";//订单所有商品构成的字符串
                
                for (NSDictionary *woodItem in tempArr) {
                    NSMutableDictionary *tmp = [woodItem mutableCopy];
                    NSString *imgUrl;
                    if ([[woodItem objectForKey:@"SupplierLoginID"] length]>0) {
                        imgUrl = [NSString stringWithFormat:@"%@%@/%@",SUPPLIERPRODUCT,[woodItem objectForKey:@"SupplierLoginID"],[woodItem objectForKey:@"SmallImage"]];
                    }else if ([[woodItem objectForKey:@"AgentID"] length]>0){
                        imgUrl = [NSString stringWithFormat:@"%@%@/%@",MEMBERPRODUCT,[woodItem objectForKey:@"AgentID"],[woodItem objectForKey:@"SmallImage"]];
                    }else{
                        imgUrl = [woodItem objectForKey:@"SmallImage"];
                        if ([imgUrl hasPrefix:@"/ImgUpload/"]) {
                            imgUrl = [imgUrl stringByReplacingOccurrencesOfString:@"/ImgUpload/" withString:DANERTUPRODUCT];
                        }else{
                            imgUrl = [NSString stringWithFormat:@"%@%@",DANERTUPRODUCT,imgUrl];
                        }
                    }
                    
                    
                    NSString *itemStr = [NSString stringWithFormat:@"%@(X%@);",[woodItem objectForKey:@"Name"],[woodItem objectForKey:@"BuyNumber"]];
                    body = [body stringByAppendingString:itemStr];
                    [tmp setObject:imgUrl forKey:@"SmallImage"];
                    [tempArr_copy addObject:tmp];
                }

                [[allArray[currentItemTag] objectAtIndex:i] setValue:tempArr_copy forKey:@"orderproductbean"];
                [[allArray[currentItemTag] objectAtIndex:i] setValue:body forKey:@"body"];
                
                //全部订单数据获取结束
                if (orderCount == i+1) {
                    //刷新列表数据
                    [Waiting dismiss];
                    [gridView reloadData];
                }
            }else{
                [Waiting dismiss];
                [self.view makeToast:@"网络错误请重试" duration:1.5 position:@"center"];
            }
            
        }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"faild , error   %d== %@ ",i, error);
            [Waiting dismiss];
            [self.view makeToast:@"网络错误请重试" duration:1.5 position:@"center"];
        }];
        [operation start];//-----发起请求------
    }
}

#pragma mark ---UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    NSLog(@"kgopkogerpgpkre----");
    return 1;
}
//--------判断滑到最后加载------
//- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
//    //----------是否滑到底部加载数据--------
//    if(gridView.contentOffset.y>=fmaxf(.0f, gridView.contentSize.height - gridView.frame.size.height)){
//
//        int orderCount = (pageIndex + 1)*ORDERLOADPAGECOUNT;
//        if ([allArray[currentItemTag] count] <= orderCount) {
//            //无下一页
//            return;
//        }else{
//            //------超出底部加载更多----
//            pageIndex++;
//            [self getWoodOrdersData];
//        }
//        
//    }
//}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    int cellCount = (pageIndex + 1)*ORDERLOADPAGECOUNT; //到本页的最大数量
    if ([allArray[currentItemTag] count] <= cellCount) {
        //无下一页
        cellCount = (int)[allArray[currentItemTag] count];
    }

    return cellCount;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger index = indexPath.item;//小标
    
    //NSArray *lalt = [coordinate componentsSeparatedByString:@","];
    static NSString *cellIdentifier = @"cell";
    UICollectionViewCell *cell = [gridView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    //大的cell会显示一部分,当前cell的尺寸是小的,,所以大cell的图像还会被当前cell之后的cell遮住
    for (id t in [cell subviews]) {
        [t removeFromSuperview];
    }
    //---------最大整个view
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MAINSCREEN_WIDTH, 145)];
    contentView.backgroundColor = [UIColor whiteColor];
    [cell addSubview:contentView];
    
    //边
    UILabel *border_top = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, MAINSCREEN_WIDTH, 1)];
    [contentView addSubview:border_top];
    border_top.backgroundColor = VIEWBGCOLOR;
    //边
    UILabel *border_bottom = [[UILabel alloc] initWithFrame:CGRectMake(0, 144, MAINSCREEN_WIDTH, 1)];
    [contentView addSubview:border_bottom];
    border_top.backgroundColor = VIEWBGCOLOR;
    
    
    //标题view
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(10, 5, 300, 35)];
    [contentView addSubview:titleView];
    
    NSArray *tmp = nil;
    NSDictionary *dic = nil;
    @try {
        tmp = allArray[currentItemTag];//临时数组
        dic = [tmp objectAtIndex:index];
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    
    //状态
    UILabel *orderState = [[UILabel alloc] initWithFrame:CGRectMake(200, 5, 100, 25)];
    [titleView addSubview:orderState];
    orderState.textAlignment = NSTextAlignmentRight;
    orderState.font = TEXTFONT;
    orderState.textColor = [UIColor redColor];
    int currentOrderTypeId = [[dic objectForKey:@"orderTypeId"] intValue];
    orderState.text = orderStatusStrArr[currentOrderTypeId];
    
    //----订单号---
    UILabel *orderNo = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 20)];
    [titleView addSubview:orderNo];
    orderNo.font = TEXTFONT;
    orderNo.textColor = [UIColor orangeColor];

    
    orderNo.text = [NSString stringWithFormat:@"订单号: %@", [dic objectForKey:@"OrderNumber"]] ;
    //----订单时间---
    UILabel *orderTime = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, 200, 15)];
    [titleView addSubview:orderTime];
    orderTime.font = TEXTFONTSMALL;
    orderTime.textColor = [UIColor grayColor];
    orderTime.text = [NSString stringWithFormat:@"创建时间: %@", [dic objectForKey:@"CreateTime"]];
    
    //------交易成功,待付款,买家已付款,卖家已发货,待付款
    //底线
//    UILabel *border_t = [[UILabel alloc] initWithFrame:CGRectMake(0, 34, 300, 1)];
//    [titleView addSubview:border_t];
//    border_t.backgroundColor = VIEWBGCOLOR;
    
    //---------商品view
    NSArray *woodArray = [dic objectForKey:@"orderproductbean"];
    NSInteger woodsNo = woodArray.count;
    

    UIView *woodsView = [[UIView alloc] initWithFrame:CGRectMake(0, 40, 300, 55 * woodsNo)];
    [contentView addSubview:woodsView];
    contentView.frame = CGRectMake(0, 0, MAINSCREEN_WIDTH, 90+55*woodsNo);
    
    float totalPay = 0;
    for (int i = 0; i < woodsNo; i++) {
        NSDictionary *itemDic = nil;
        @try {
            itemDic = woodArray[i];
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
        float ShopPrice = [[itemDic objectForKey:@"ShopPrice"] floatValue];
        int BuyNumber = [[itemDic objectForKey:@"BuyNumber"] intValue];
        
//        int iSGive = 0;
//        if ([[itemDic objectForKey:@"iSGive"] intValue] != 0) {
//            iSGive = BuyNumber / ([[itemDic objectForKey:@"iSGive"] intValue]);
//        }
        totalPay+= ShopPrice*BuyNumber;
        
        UIView *item = [[UIView alloc] initWithFrame:CGRectMake(0, 55*i, MAINSCREEN_WIDTH, 55)];
        item.accessibilityIdentifier = [NSString stringWithFormat:@"%ld/%d",(long)index,i];
        [woodsView addSubview:item];
        [item setBackgroundColor:[UIColor colorWithRed:242.0/255 green:242.0/255 blue:242.0/255 alpha:1]];
        
//        //商品图片
        NSString *SmallImage = [itemDic objectForKey:@"SmallImage"];
        if ([SmallImage isMemberOfClass:[NSNull class]] || SmallImage == nil) {
            SmallImage = @"";
        }
        NSString *imageKey = [NSString stringWithFormat:@"%@%ld%d",SmallImage,(long)index,i];
        
        AsynImageView *image = [imageCache objectForKey:imageKey];
        if (image) {
            [item addSubview:image];
        }
        else{
            AsynImageView *woodImage = [[AsynImageView alloc] initWithFrame:CGRectMake(10, 5, 45, 45)];
            [imageCache setObject:woodImage forKey:imageKey];
            woodImage.placeholderImage = [UIImage imageNamed:@"noData1"];
            woodImage.imageURL = SmallImage;
            [item addSubview:woodImage];
        }
        
        
        //商品名称
        UILabel *woodName = [[UILabel alloc] initWithFrame:CGRectMake(70, 5, 140, 45)];
        [item addSubview:woodName];
        [woodName setBackgroundColor:[UIColor clearColor]];
        woodName.font = TEXTFONT;
        woodName.numberOfLines = 2;
        woodName.text = [itemDic objectForKey:@"Name"];
        
        //价格
        UILabel *woodPrice = [[UILabel alloc] initWithFrame:CGRectMake(210, 5, 100, 25)];
        [item addSubview:woodPrice];
        [woodPrice setBackgroundColor:[UIColor clearColor]];
        woodPrice.textAlignment = NSTextAlignmentRight;
        woodPrice.font = TEXTFONT;
        woodPrice.text = [NSString stringWithFormat:@"¥  %0.2f",ShopPrice];
        //数量
        UILabel *woodCount = [[UILabel alloc] initWithFrame:CGRectMake(210, 30, 100, 20)];
        [item addSubview:woodCount];
        [woodCount setBackgroundColor:[UIColor clearColor]];
        woodCount.textAlignment = NSTextAlignmentRight;
        woodCount.font = TEXTFONT;
        woodCount.text = [NSString stringWithFormat:@"X %d",BuyNumber];
        
        //商品底边线
        UILabel *border_i = [[UILabel alloc] initWithFrame:CGRectMake(0, 54, MAINSCREEN_WIDTH, 2)];
        [item addSubview:border_i];
        border_i.backgroundColor = [UIColor whiteColor];
        
        item.userInteractionEnabled = YES;
    }
    //--------商品数量,价格,按钮视图-----高度  50
    UIView *btnView = [[UIView alloc] initWithFrame:CGRectMake(10, 40+woodsView.frame.size.height, 300, 50)];
    [contentView addSubview:btnView];
    
    //商品数量,价格
    
    int totallNums = 0;
    for (int i = 0; i < woodsNo; i++) {
        int BuyNumber = [[[woodArray objectAtIndex:i] objectForKey:@"BuyNumber"] intValue];
        int iSGive = 0;
//        if ([[[woodArray objectAtIndex:i] objectForKey:@"iSGive"] intValue] != 0) {
//            iSGive = BuyNumber / ([[[woodArray objectAtIndex:i] objectForKey:@"iSGive"] intValue]);
//        }
        totallNums += (iSGive + BuyNumber);
    }
    
    UILabel *woodInfo = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 20)];
    [btnView addSubview:woodInfo];
    woodInfo.textAlignment = NSTextAlignmentRight;
    woodInfo.font = TEXTFONT;//
    woodInfo.text = [NSString stringWithFormat:@"共 %d 件商品   实付: ¥ %0.2f",totallNums,[[dic objectForKey:@"ShouldPayPrice"] doubleValue]];
    //边
    UILabel *border_i = [[UILabel alloc] initWithFrame:CGRectMake(0, 19, 300, 1)];
    [btnView addSubview:border_i];
    border_i.backgroundColor = VIEWBGCOLOR;
    //按钮
    
    //一系列按钮构成的数组,currentOrderTypeId可能大于等于orderBtnTitleArr.count,状态和item没有一一对应
    if (currentOrderTypeId<orderBtnTitleArr.count) {
        NSArray *currentOrderTitleArr = nil;
        @try {
            currentOrderTitleArr = orderBtnTitleArr[currentOrderTypeId];
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
        NSInteger btnCount = currentOrderTitleArr.count/2;
        for (int i = 0;i < btnCount; i++) {
            //按钮排序,从右往左排,右对齐
            CGFloat buttonDistance = 5;  //按钮间距
            CGFloat buttonW = 80;
            CGFloat buttonH = 25;
            CGFloat buttonY = 22;
            CGFloat buttonX = btnView.bounds.size.width - buttonW * (i + 1) - buttonDistance * i;
            UIButton *woodBtn = [[UIButton alloc] initWithFrame:CGRectMake(buttonX, buttonY, buttonW, buttonH)];
            [btnView addSubview:woodBtn];
            [woodBtn.layer setMasksToBounds:YES];
            [woodBtn.layer setCornerRadius:2];//设置矩形四个圆角半径
            [woodBtn.layer setBorderColor:[UIColor grayColor].CGColor];
            [woodBtn.layer setBorderWidth:0.6];
            woodBtn.titleLabel.font = TEXTFONT;
            woodBtn.backgroundColor = [UIColor whiteColor];
            [woodBtn setTitle:currentOrderTitleArr[btnCount-1-i] forState:UIControlStateNormal];
            woodBtn.tag = index + 100;//当前cell的   index值,便于查询对应的  数据
            woodBtn.accessibilityIdentifier = currentOrderTitleArr[btnCount-1-i+btnCount];
            [woodBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [woodBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
            [woodBtn addTarget:self action:@selector(clickOrderBtn:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    [Waiting dismiss];//这里隐藏
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger index = indexPath.item;

    NSArray *tmp = allArray[currentItemTag];//临时数组
    NSArray *woodArray = [tmp[index] objectForKey:@"orderproductbean"];
    NSInteger height = woodArray.count * 55 + 90;
    CGSize size = CGSizeMake(MAINSCREEN_WIDTH,height);
    
    return size;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%ld",(long)currentItemTag);
    NSInteger row = indexPath.row;
    NSMutableDictionary *dict = nil;
    @try {
        
        dict = [NSMutableDictionary dictionaryWithDictionary:[allArray[currentItemTag] objectAtIndex:row]];
        [dict setValue:[NSNumber numberWithBool:YES] forKey:@"isAllSpringGoods"];
        for (int i = 0; i < (int)[[dict valueForKey:@"orderproductbean"] count]; i++) {
            if (![[[[dict valueForKey:@"orderproductbean"] objectAtIndex:i] objectForKey:@"SupplierLoginID"] isEqualToString:SPRINGSUPPLIERID]) {
               [dict setValue:[NSNumber numberWithBool:NO] forKey:@"isAllSpringGoods"];
                break;
            }
        }
        BookDetailController *bookDetailVC = [[BookDetailController alloc] initWithBookDict:dict];
        bookDetailVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:bookDetailVC animated:YES];
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    
}

//浏览商品详情
//- (void)gotoGoodsDetailGes:(UITapGestureRecognizer *)ges
//{
//    NSString *viewIdentifier = [ges view].accessibilityIdentifier;
//    NSArray *array = [viewIdentifier componentsSeparatedByString:@"/"];
//    NSInteger section = [[array objectAtIndex:0] integerValue];
//    NSInteger row = [[array objectAtIndex:1] integerValue];
//    NSArray *tmp = allArray[currentItemTag];//临时数组
//    NSDictionary *dic = [tmp objectAtIndex:section];
//    NSArray *woodArray = [dic objectForKey:@"orderproductbean"];
//    NSDictionary *itemDic = woodArray[row];
//    NSString *guid = [itemDic objectForKey:@"Guid"];
//    GoodsDetailController *woodsDettail = [[GoodsDetailController alloc] initGoodsWithShopDict:nil];
//    woodsDettail.danModleGuid = guid;
//    [self.navigationController pushViewController:woodsDettail animated:YES];
//}

//----点击item,待付款,待收货--------切换------
-(void)onClickItem:(id)sender{
    NSInteger tag = [[sender view] tag] - 100;
    if (tag != currentItemTag) {
        [self removeOldViewFromOrderList];
        currentItemTag = tag;
        [self rebulidTheOrderList];
    }
}

//点击订单的按钮
-(void)clickOrderBtn:(UIButton *)sender{
    NSString *functionName = sender.accessibilityIdentifier;
    SEL f = NSSelectorFromString(functionName);
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    [self performSelector:f withObject:sender];
#pragma clang diagnostic pop
}
//----完成支付后接受通知,刷新数据
//-(void)reloadOrderList:(NSNotification*) notification{
//    //获取完成支付的订单号
//    NSString *payedOrderNo = [[notification userInfo] objectForKey:@"orderNo"];
//    NSArray *tmpArr = [allArray[currentItemTag] copy];
//    for (NSMutableDictionary *tmp in tmpArr) {
//        if ([[tmp objectForKey:@"OrderNumber"] isEqualToString:payedOrderNo]) {
//            //修改所属订单状态
//            [tmp setObject:@"1" forKey:@"orderTypeId"];
//            //将对象添加到代发货数组
//            [notShipArrays insertObject:tmp atIndex:0];
//            //将对象移除待付款数组
//            [notPayedArrays removeObject:tmp];
//        }
//    }
//    //刷新页面
//    [self reloadGridViewData];
//}

//----------------------------------所有订单上的按钮方法------------------------
//-(void)goToOrderDetialPanel:(UIButton *)sender{
//     NSInteger tag = [sender tag] - 100;
//    NSLog(@"[allArray[currentItemTag] objectAtIndex:tag]:%@",[allArray[currentItemTag] objectAtIndex:tag]);
//    NSLog(@"orderArrays:%@",[orderArrays objectAtIndex:tag]);
//    
//    NSMutableDictionary *dict= [NSMutableDictionary dictionaryWithDictionary:[allArray[currentItemTag] objectAtIndex:tag]];
//    [dict setValue:[[orderArrays objectAtIndex:tag] valueForKey:@"Mobile"] forKey:@"Mobile"];
//    [dict setValue:[[orderArrays objectAtIndex:tag] valueForKey:@"Name"] forKey:@"Name"];
//    [dict setValue:[[orderArrays objectAtIndex:tag] valueForKey:@"Address"] forKey:@"Address"];
//    BookDetailController *bookDetailVC = [[BookDetailController alloc] initWithBookDict:dict];
//    bookDetailVC.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:bookDetailVC animated:YES];
//}

//取消订单
-(void)cancleOrder:(UIButton *)sender{
    
    NSInteger tag = [sender tag] - 100;
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"取消订单" message:@"注意:订单取消后将无法找回" delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
    [alertView show];
    
    objc_setAssociatedObject(alertView,"alertNeedTagKey",[NSNumber numberWithInteger:tag],OBJC_ASSOCIATION_COPY);
}

//根据选择的支付方式支付
-(void)gotoPayOff:(UIButton *)sender{
    NSInteger tag = [sender tag] - 100;
    NSDictionary *item = [allArray[currentItemTag] objectAtIndex:tag];
    NSLog(@"jhjothjtriohjitor-----%@",item);
    orderInfoDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:[item objectForKey:@"OrderNumber"],@"tradeNO",[item objectForKey:@"body"],@"subject",[item objectForKey:@"body"] ,@"body",[item objectForKey:@"ShouldPayPrice"],@"price", nil];
    NSLog(@"unionPay--------%@",orderInfoDic);
    
    RealPayController *payController = [[RealPayController alloc] init];
    payController.hidesBottomBarWhenPushed = YES;
    payController.orderInfoDic = orderInfoDic;
    payController.productsArr = [item objectForKey:@"orderproductbean"];
    payController.isFromPayOff = NO;
    [self.navigationController pushViewController:payController animated:YES];
}
//----申请退款
-(void)drawback:(UIButton *)sender{
    NSInteger tag = [sender tag] - 100;
    ApplyRefundMentViewController *applyVC = [[ApplyRefundMentViewController alloc] init];
    applyVC.refundmentData = [allArray[currentItemTag] objectAtIndex:tag];
    applyVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:applyVC animated:YES];
}

//成功申请退款后刷新全部列表
-(void)reFreshOrderList:(NSNotification *)notification{
    /*
     由于申请退款后,列表中的订单的状态不会改变(只有在商家同意退款时,订单状态才会改变),
     所以对本地数据做,移除处理,用户下次就来就列表依然显示"可以退款的状态",但是用户如果再次申请退款则不会成功!
     */
    NSString *orderNumber = [[notification userInfo] objectForKey:@"OrderNumber"];
    NSLog(@"OrderNumber:%@",orderNumber);
    NSArray *tmpArr = [allArray[currentItemTag] copy];
    for (NSMutableDictionary *tmp in tmpArr) {
        if ([[tmp objectForKey:@"OrderNumber"] isEqualToString:orderNumber]) {
            
            //将对象移除    全部
            [arrays removeObject:tmp];
            
            int orderTypeId = [[tmp objectForKey:@"orderTypeId"] intValue];
            switch (orderTypeId) {
                case 1:
                    //将对象移除    待发货
                    [notShipArrays removeObject:tmp];
                    break;
                case 2:
                    //将对象移除    待收货
                    [notSignArrays removeObject:tmp];
                case 3:
                    //将对象移除    待评价
                    [notEvaluateArrays removeObject:tmp];
                    break;
                default:
                    break;
            }
        }
    }
    
    [self getWoodOrdersData];
}

//----查看物流
-(void)viewLogistics:(UIButton *)sender{
    [self.view makeToast:@"暂未实现该功能" duration:1.2 position:@"center"];
}
//----确认收货
-(void)confirmReceiving:(UIButton *)sender{
    [Waiting show];
    NSInteger tag = [sender tag] - 100;
    NSDictionary *item = [allArray[currentItemTag] objectAtIndex:tag];
    NSString *orderNumber = [item objectForKey:@"OrderNumber"];
    NSDictionary * params = @{@"apiid": @"0076",@"ordernumber":orderNumber};
    NSURLRequest * request = [httpClient requestWithMethod:@"POST"
                                                      path:@""
                                                parameters:params];
    AFHTTPRequestOperation * operation = [httpClient HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [Waiting dismiss];//隐藏loading
        NSString *source = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        if ([source  isEqualToString:@"true"]) {
            [self.view makeToast:@"确认成功" duration:1.2 position:@"center"];
            //刷新列表
            [self getOrderData];
        }else{
            [self.view makeToast:@"确认失败,请稍后重试" duration:1.2 position:@"center"];
        }
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"faild , error   == %@ ", error);
        [Waiting dismiss];
        [self.view makeToast:@"网络错误请重试" duration:1.5 position:@"center"];
    }];
    [operation start];//-----发起请求------
}
//----评价订单
-(void)commentOrder:(UIButton *)sender{
    [self.view makeToast:@"暂未实现该功能" duration:1.2 position:@"center"];
}

#pragma mark UIAlerviewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 1:
                {
                    [Waiting show];
                    
                    NSNumber *tag = objc_getAssociatedObject(alertView, "alertNeedTagKey");
                    
                    NSDictionary *item = [allArray[currentItemTag] objectAtIndex:[tag intValue]];
                    NSString *orderNumber = [item objectForKey:@"OrderNumber"];
                    NSDictionary * params = @{@"apiid": @"0075",@"ordernumber":orderNumber};
                    NSURLRequest * request = [httpClient requestWithMethod:@"POST"
                                                                      path:@""
                                                                parameters:params];
                    AFHTTPRequestOperation * operation = [httpClient HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
                        [Waiting dismiss];//隐藏loading
                        NSString *source = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
                        NSLog(@"wpqokopewpqokepqkpeowq------13---%@---",source);
                        if ([source  isEqualToString:@"true"]) {
                            [self.view makeToast:@"取消成功" duration:1.2 position:@"center"];
                            //取消订单
                            NSLog(@"grejgiojiohtjhioyihoy---1--%@",allArray[currentItemTag]);
                            for (NSMutableDictionary *tmp in allArray[currentItemTag]) {
                                if ([[tmp objectForKey:@"OrderNumber"] isEqualToString:orderNumber]) {
                                    //修改所属订单状态
                                    [tmp setObject:@"4" forKey:@"orderTypeId"];
                                    break;
                                }
                            }
                            NSLog(@"grejgiojiohtjhioyihoy---2--%@",allArray[currentItemTag]);
                            [self reloadGridViewData];
                        }else{
                            [self.view makeToast:@"取消失败,请稍后重试" duration:1.2 position:@"center"];
                        }
                    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                        NSLog(@"faild , error   == %@ ", error);
                        [Waiting dismiss];
                        [self.view makeToast:@"网络错误请重试" duration:1.5 position:@"center"];
                    }];
                    [operation start];//-----发起请求------
                }
            break;
        case 0:
            return;
            break;
            
        default:
            break;
    }
}
// 滑动手势
-(void)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer{
    NSInteger indexs = currentItemTag;
    switch (recognizer.direction) {
        case UISwipeGestureRecognizerDirectionLeft:
                {
                    if (indexs == 4) return;
                    [self removeOldViewFromOrderList];
                    currentItemTag++;
                    [self rebulidTheOrderList];
                }
            break;
        default:
                {
                    if (indexs == 0) return;
                    [self removeOldViewFromOrderList];
                    currentItemTag--;
                    [self rebulidTheOrderList];
                }
            break;
    }
}

-(void)removeOldViewFromOrderList{
    //移除原有界面
//    NSArray *tmp = [gridView subviews];
//    for (int i=0;i<tmp.count;i++) {
//        [tmp[i] removeFromSuperview];//---删除
//    }
    UILabel *preItem = [[topSegmentView subviews] objectAtIndex:currentItemTag];
    preItem.textColor = [UIColor blackColor];
}

-(void)rebulidTheOrderList{
     pageIndex = 0;
    //创建新界面
    [UIView animateWithDuration:0.4 animations:^{
        CGRect frame =  flagLb.frame;
        frame.origin.x = 64*currentItemTag;
        flagLb.frame = frame;
    } completion:^(BOOL finish){
        UILabel *preItem = [[topSegmentView subviews] objectAtIndex:currentItemTag];
        preItem.textColor = [UIColor redColor];
        [self reloadGridViewData];
        [Waiting dismiss];//---隐藏loading
    }];
}

//刷新列表数据
-(void)reloadGridViewData{
    
    [self getWoodOrdersData];
    
    NSInteger cellCount = [allArray[currentItemTag] count];
    if (cellCount>0) {
        noOrderView.hidden = YES;
    }else{
        noOrderView.hidden = NO;
    }
}

- (void)dealloc
{
    [refreshHeader removeFromSuperview];
    [refreshFooter removeFromSuperview];
}

//-----------内存不足报警------
-(void)didReceiveMemoryWarning
{
    [[NSUserDefaults standardUserDefaults] synchronize];
    [super didReceiveMemoryWarning];
    NSLog(@"memory warning,kkappdelegate---");
}
@end
