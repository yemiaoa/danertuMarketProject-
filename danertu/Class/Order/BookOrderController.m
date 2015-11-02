//
//  KKFirstViewController.m
//  Tuan
//
//  Created by 夏 华 on 12-7-3.
//  Copyright (c) 2012年 无锡恩梯梯数据有限公司. All rights reserved.
//

#import "BookOrderController.h"
#import <objc/message.h>
#import <QuartzCore/QuartzCore.h>
#import "DetailViewController.h"
#import "UIImageView+WebCache.h"
#import "SDRefresh.h"

@interface BookOrderController (){
    NSArray *allArray;//数组的数组----
    NSMutableArray *orderArrays;//全部
    NSMutableArray *bookedArrays;//已预订
    NSMutableArray *consumedArrays;//已消费
    AFHTTPClient * httpClient;

    NSArray *orderStatusStrArr;
    NSArray *orderBtnTitleArr;
    NSMutableDictionary *selectBookOrder;
    
    DataModle *clickModle;
    SDRefreshHeaderView *refreshHeader;
}
@end

@implementation BookOrderController
@synthesize defaults;
@synthesize addStatusBarHeight;
@synthesize segment1;
@synthesize segment2;
@synthesize segmentBlock1;
@synthesize segmentBlock2;
@synthesize topSegmentView;
@synthesize flagLb;
@synthesize currentItemTag;
@synthesize gridView;
@synthesize noOrderView;
@synthesize imageCache;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initView];
    [self setupHeader];
    [self getOrderData];
    
}
//-----修改标题,重写父类方法----
-(NSString*)getTitle{
    return @"我的预订";
}
//-----修改标题栏背景颜色
-(UIColor *)getTopNaviColor{
    return TOPNAVIBGCOLOR_G;
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
            [bself getOrderData];
            [weakRefreshHeader endRefreshing];
        });
    };
    
    // 进入页面自动加载一次数据
    [refreshHeader beginRefreshing];
}

- (void)initView{
    imageCache = [[NSCache alloc] init];
    addStatusBarHeight = [TopNaviViewController getStatusBarHeight];
    defaults =[NSUserDefaults standardUserDefaults];
    self.view.backgroundColor = [UIColor colorWithRed:242.0/255 green:242.0/255 blue:242.0/255 alpha:1.0];
    
    bookedArrays = [[NSMutableArray alloc] init];
    consumedArrays = [[NSMutableArray alloc] init];
    orderArrays = [[NSMutableArray alloc] init];    //初始化
    allArray = @[orderArrays,bookedArrays,consumedArrays];
    //currentItemTag = 0;//当前选择的item序号,这里不要初始化,这个值来自   跳转前的页面
    orderStatusStrArr = @[@"已预订",@"已交易"];
    orderBtnTitleArr = @[@[@"取消预订",@"订单详情",@"cancleOrder:",@"showDetail:"],@[@"删除订单",@"订单详情",@"cancleOrder:",@"showDetail:"]];
    httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:APIURL]];
    
    topSegmentView = [[UIView alloc] initWithFrame:CGRectMake(0, addStatusBarHeight+TOPNAVIHEIGHT, MAINSCREEN_WIDTH, 40)];
    [self.view addSubview:topSegmentView];
    topSegmentView.backgroundColor = [UIColor whiteColor];
    NSArray *titleArr_order = @[@"全部",@"已预订",@"已消费"];
    NSInteger itemNum_order = titleArr_order.count;
    for (int i = 0; i < itemNum_order; i++) {
        UILabel *text = [[UILabel alloc] initWithFrame:CGRectMake(107 * i, 0, 106, 40)];
        text.text = titleArr_order[i];
        text.userInteractionEnabled = YES;
        if (i==currentItemTag) {
            text.textColor = TOPNAVIBGCOLOR_G;
        }
        text.textAlignment = NSTextAlignmentCenter;
        text.font = TEXTFONT;
        [topSegmentView addSubview:text];//text
        text.tag = 100+i;
        UITapGestureRecognizer *singleTap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClickItem:)];
        [text addGestureRecognizer:singleTap];//---添加点击事件
    }
    UILabel *border1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 39, MAINSCREEN_WIDTH, 1)];
    [topSegmentView addSubview:border1];
    border1.backgroundColor = BORDERCOLOR;
    
    flagLb = [[UILabel alloc] initWithFrame:CGRectMake(107*currentItemTag, 39, 106, 1)];
    [topSegmentView addSubview:flagLb];
    flagLb.backgroundColor = TOPNAVIBGCOLOR_G;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = layout.minimumInteritemSpacing;
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    gridView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, addStatusBarHeight+40+TOPNAVIHEIGHT, MAINSCREEN_WIDTH, self.view.frame.size.height - 40 - TOPNAVIHEIGHT - addStatusBarHeight) collectionViewLayout:layout];
    [self.view addSubview:gridView];
    gridView.backgroundColor = VIEWBGCOLOR;
    gridView.delegate = self;
    gridView.dataSource = self;
    [gridView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    
    //没有订单的视图
    int contentHeight = self.view.frame.size.height-40-44;
    noOrderView = [[UIView alloc] initWithFrame:CGRectMake(0, addStatusBarHeight+40+44, MAINSCREEN_WIDTH, contentHeight)];
    [self.view addSubview:noOrderView];
    noOrderView.hidden = YES;
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
    noOrderText.text = @"抱歉,没有找到相关预订单";
    
    //滑动手势
    UISwipeGestureRecognizer * recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [self.view addGestureRecognizer:recognizer];
    
    recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionLeft)];
    [self.view addGestureRecognizer:recognizer];
    
    
    //注册通知,待支付完成时,通知订单中心重新加载数据
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadOrderList:) name:@"finishPayment" object:nil];
}

//----获取数据-------
-(void)getOrderData{
    //显示loading------------
    [Waiting show];
    NSString *userName = [[defaults objectForKey:@"userLoginInfo"] objectForKey:@"MemLoginID"];
    //-----------type---1(最近一个月的),2
    NSDictionary * params = @{@"apiid": @"0092",@"MemLoginID":userName,@"OrderNumber":@"",@"AgentID":@"",@"ProductName":@"",@"Mobile":@"",@"ReceiptName":@"",@"OrderStatus":@""};
    NSURLRequest * request = [httpClient requestWithMethod:@"POST"
                                                  path:@""
                                            parameters:params];
    AFHTTPRequestOperation * operation = [httpClient HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [Waiting dismiss];
//        NSString* data = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        
        NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];//json解析
        if (jsonData) {
            NSArray *tmpArray = [[jsonData objectForKey:@"offlineOrderList"] objectForKey:@"offlineOrderbean"];
            
            if (tmpArray.count>0) {
                if ([orderArrays count] > 0) {
                    [orderArrays removeAllObjects];
                }
                if ([bookedArrays count] > 0) {
                    [bookedArrays removeAllObjects];
                }
                if ([consumedArrays count] > 0) {
                    [consumedArrays removeAllObjects];
                }
                
                for (NSDictionary *woodItem in tmpArray) {
                    
                    NSMutableDictionary *itemTmp = [woodItem mutableCopy];
                    NSString *imgUrl = [itemTmp objectForKey:@"SmallImage"];
                    if ([imgUrl hasPrefix:@"/ImgUpload/Agent/"]) {
                        imgUrl = [imgUrl stringByReplacingOccurrencesOfString:@"/ImgUpload/Agent/" withString:[NSString stringWithFormat:@"%@/",MEMBERPRODUCT]];
                    }else{
                        imgUrl = [NSString stringWithFormat:@"%@%@/%@",MEMBERPRODUCT,[itemTmp objectForKey:@"AgentID"],imgUrl];
                    }
                    [itemTmp setObject:imgUrl forKey:@"SmallImage"];
                    //全部
                    [orderArrays addObject:itemTmp];
                    if ([[woodItem objectForKey:@"OrderStatus"] isEqualToString:@"未确认"]) {
                        //已预订   IsDeleted
                        if ([[woodItem objectForKey:@"IsDeleted"] isEqualToString:@"0"]) {
                            [bookedArrays addObject:itemTmp];
                        }
                    }else{
                        //已消费
                        [consumedArrays addObject:itemTmp];
                    }
                }
                [self reloadGridViewData];
            }
        }else{
            [self.view makeToast:@"数据错误请稍后重试" duration:1.5 position:@"center"];
        }
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"faild , error == %@ ", error);
        [Waiting dismiss];
        [self.view makeToast:@"网络错误请重试" duration:1.5 position:@"center"];
    }];
    [operation start];//-----发起请求-----
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSInteger cellCount = [allArray[currentItemTag] count];
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
    
    
    //--------标题view----40
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(10, 5, 300, 35)];
    [contentView addSubview:titleView];
    titleView.tag = 100 + index;
    NSArray *tmp = allArray[currentItemTag];//临时数组
    NSDictionary *dic = [tmp objectAtIndex:index];
    
    //店铺名称
    UILabel *shopName = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, 170, 25)];
    [titleView addSubview:shopName];
    shopName.font = TEXTFONT;
    shopName.text = [NSString stringWithFormat:@"超市:%@  >",[dic objectForKey:@"ShopName"] ];
    
    UITapGestureRecognizer *singleTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onClickGoShop:)];
    [titleView addGestureRecognizer:singleTap];//---添加点击事件
    
    //状态
    UILabel *orderState = [[UILabel alloc] initWithFrame:CGRectMake(200, 5, 100, 25)];
    [titleView addSubview:orderState];
    orderState.textAlignment = NSTextAlignmentRight;
    orderState.textColor = TOPNAVIBGCOLOR_G;
    
    NSInteger currentOrderTypeId = currentItemTag-1;
    orderState.font = TEXTFONT;
    //------交易成功,待付款,买家已付款,卖家已发货,待付款
    //---------商品view
    UIView *woodsView = [[UIView alloc] initWithFrame:CGRectMake(0, 40, MAINSCREEN_WIDTH, 55)];
    [contentView addSubview:woodsView];
    [woodsView setBackgroundColor:[UIColor colorWithRed:242.0/255 green:242.0/255 blue:242.0/255 alpha:1]];
    
    float ShopPrice = [[dic objectForKey:@"ProductPrice"] floatValue];
    int BuyNumber = [[dic objectForKey:@"BuyCount"] intValue];
    
    UIView *item = [[UIView alloc] initWithFrame:CGRectMake(10, 0, 300, 55)];
    [woodsView addSubview:item];
    //商品图片
    NSString *SmallImage = [dic objectForKey:@"SmallImage"];
    if ([SmallImage isMemberOfClass:[NSNull class]] || SmallImage == nil) {
        SmallImage = @"";
    }
    NSString *imageKey = [NSString stringWithFormat:@"%@%lu",SmallImage,(long)index];
    AsynImageView *image = [imageCache objectForKey:imageKey];
    if (image) {
        [item addSubview:image];
    }
    else{
        AsynImageView *woodImage = [[AsynImageView alloc] initWithFrame:CGRectMake(0, 5, 45, 45)];
        woodImage.placeholderImage = [UIImage imageNamed:@"noData1"];
        [item addSubview:woodImage];
        woodImage.imageURL = SmallImage;
        [imageCache setObject:woodImage forKey:imageKey];
    }
    
    
    //商品名称
    UILabel *woodName = [[UILabel alloc] initWithFrame:CGRectMake(60, 5, 140, 45)];
    [item addSubview:woodName];
    [woodName setBackgroundColor:[UIColor clearColor]];
    woodName.font = TEXTFONT;
    woodName.numberOfLines = 2;
    woodName.text = [dic objectForKey:@"ProductName"];
    
    //价格
    UILabel *woodPrice = [[UILabel alloc] initWithFrame:CGRectMake(200, 5, 100, 25)];
    [item addSubview:woodPrice];
    [woodPrice setBackgroundColor:[UIColor clearColor]];
    woodPrice.textAlignment = NSTextAlignmentRight;
    woodPrice.font = TEXTFONT;
    woodPrice.text = [NSString stringWithFormat:@"¥  %0.2f",ShopPrice];
    //数量
    UILabel *woodCount = [[UILabel alloc] initWithFrame:CGRectMake(200, 30, 100, 20)];
    [item addSubview:woodCount];
    [woodCount setBackgroundColor:[UIColor clearColor]];
    woodCount.textAlignment = NSTextAlignmentRight;
    woodCount.font = TEXTFONT;
    woodCount.text = [NSString stringWithFormat:@"X %d",BuyNumber];
    
    //--------商品数量,价格,按钮视图-----高度  50
    UIView *btnView = [[UIView alloc] initWithFrame:CGRectMake(0, 40+woodsView.frame.size.height, 300, 50)];
    [contentView addSubview:btnView];
    
    //商品数量,价格
    UILabel *woodInfo = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 300, 20)];
    [btnView addSubview:woodInfo];
    woodInfo.textAlignment = NSTextAlignmentRight;
    woodInfo.font = TEXTFONT;//
    woodInfo.text = [NSString stringWithFormat:@"共 %d 件商品   实付: ¥ %0.2f",BuyNumber,ShopPrice*BuyNumber];
    //边
    UILabel *border_i123 = [[UILabel alloc] initWithFrame:CGRectMake(0, 19, MAINSCREEN_WIDTH, 1)];
    [btnView addSubview:border_i123];
    border_i123.backgroundColor = VIEWBGCOLOR;
    //按钮
    
    //一系列按钮构成的数组,----currentOrderTypeId可能大于等于orderBtnTitleArr.count,状态和item没有一一对应

    NSArray *currentOrderTitleArr = [[NSArray alloc] init];
    //--------状态显示------按钮显示--------
    if (currentOrderTypeId<0) {
        if ([[dic objectForKey:@"OrderStatus"] isEqualToString:@"未确认"]) {
            orderState.text = orderStatusStrArr[0];
            currentOrderTitleArr = orderBtnTitleArr[0];
        }else{
            orderState.text = orderStatusStrArr[1];
            currentOrderTitleArr = orderBtnTitleArr[1];
        }
    }else{
        orderState.text = orderStatusStrArr[currentOrderTypeId];
        currentOrderTitleArr = orderBtnTitleArr[currentOrderTypeId];
        
        
    }
    int btnCount = (int)currentOrderTitleArr.count/2;
    for (int i = 0; i < btnCount; i++) {
        //注意--------------------按钮排序,从右往左排,右对齐-----第0个是最右边的一个
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
        [woodBtn.layer setBorderColor:BORDERCOLOR.CGColor];
        [woodBtn.layer setBorderWidth:0.6];
        woodBtn.titleLabel.font = TEXTFONT;
        woodBtn.backgroundColor = [UIColor whiteColor];
        [woodBtn setTitle:currentOrderTitleArr[btnCount-1-i] forState:UIControlStateNormal];
        woodBtn.tag = index + 100;//当前cell的   index值,便于查询对应的  数据
        woodBtn.accessibilityIdentifier = [dic objectForKey:@"Guid"];
        
        
        woodBtn.backgroundColor = [UIColor whiteColor];
        [woodBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [woodBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        
        
        SEL function = NSSelectorFromString(currentOrderTitleArr[btnCount-1-i+btnCount]);
        [woodBtn addTarget:self action:function  forControlEvents:UIControlEventTouchUpInside];
    }
    
    [Waiting dismiss];//这里隐藏
    return cell;
}
//--------点击跳转到店铺---------
-(void)onClickGoShop:(id)sender{
    NSInteger index = [[sender view] tag] - 100;
    NSDictionary *woodDic = [allArray[currentItemTag] objectAtIndex:index];
    
    clickModle = [[DataModle alloc] init];
    clickModle.id = [woodDic objectForKey:@"AgentID"];
    clickModle.s = [woodDic objectForKey:@"ShopName"];
    
    DetailViewController *detailController = [[DetailViewController alloc] init];
    detailController.agentid = clickModle.id;
    detailController.modle = clickModle;
    detailController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detailController animated:YES];
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize size = CGSizeMake(MAINSCREEN_WIDTH,145);
    return size;
}
//----点击item,待付款,待收货--------切换------
-(void)onClickItem:(id)sender{
    NSInteger tag = [[sender view] tag] - 100;
    if (tag!=currentItemTag) {
        [self removeOldViewFromBookOrder];
        currentItemTag = tag;
        [self rebulidTheBookOrder];
    }
}

//----完成支付后接受通知,刷新数据
-(void)reloadOrderList:(NSNotification*) notification{
    //获取完成支付的订单号
    NSString *payedOrderNo = [[notification userInfo] objectForKey:@"orderNo"];
    NSArray *tmpArr = [allArray[currentItemTag] copy];
    for (NSMutableDictionary *tmp in tmpArr) {
        if ([[tmp objectForKey:@"OrderNumber"] isEqualToString:payedOrderNo]) {
            //修改所属订单状态
            [tmp setObject:@"1" forKey:@"orderTypeId"];
            //将对象添加到代发货数组
            [consumedArrays insertObject:tmp atIndex:0];
            //将对象移除待付款数组
            [bookedArrays removeObject:tmp];
            break;
        }
    }
    //刷新页面
    [self reloadGridViewData];
}

//所有订单上的按钮方法
//取消订单
-(void)cancleOrder:(UIButton *)sender{
    
    NSLog(@"guid:%@",sender.accessibilityIdentifier);
    NSLog(@"sender.titleLabel.text:%@",sender.titleLabel.text);
    
    NSString *alertTitle = sender.titleLabel.text;
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:alertTitle message:[NSString stringWithFormat:@"注意:%@后将无法找回",alertTitle] delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
    [alertView show];
    objc_setAssociatedObject(alertView,"alertMessageKey",[NSString stringWithFormat:@"%@%@",[alertTitle substringWithRange:NSMakeRange(0, 2)],sender.accessibilityIdentifier],OBJC_ASSOCIATION_COPY);
}

//查看详情
-(void)showDetail:(UIButton *)sender{
    NSString *guid = sender.accessibilityIdentifier;
    for (NSDictionary *item in orderArrays) {
        if ([[item objectForKey:@"Guid"] isEqualToString:guid]) {
            selectBookOrder = [NSMutableDictionary dictionaryWithDictionary:item];
            break;
        }
    }
    [selectBookOrder setObject:@"1" forKey:@"isFromBookOrder"];
    BookDetailController *bController = [[BookDetailController alloc] init];
    bController.hidesBottomBarWhenPushed = YES;
    bController.bookOrderInfo = selectBookOrder;
    [self.navigationController pushViewController:bController animated:YES];
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
            NSArray *tmpArr = [allArray[currentItemTag] copy];
            for (NSMutableDictionary *tmp in tmpArr) {
                if ([[tmp objectForKey:@"OrderNumber"] isEqualToString:orderNumber]) {
                    
                    break;
                }
            }
             [self reloadGridViewData];
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

// 滑动手势
-(void)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer{
    NSInteger indexs = currentItemTag;
    switch (recognizer.direction) {
        case UISwipeGestureRecognizerDirectionLeft:
        {
            if (indexs == 2) return;
            [self removeOldViewFromBookOrder];
            currentItemTag++;
            [self rebulidTheBookOrder];
        }
            break;
        default:
        {
            if (indexs == 0) return;
            [self removeOldViewFromBookOrder];
            currentItemTag--;
            [self rebulidTheBookOrder];
        }
            break;
    }
}

-(void)removeOldViewFromBookOrder{
    [Waiting show];
    //移除原有界面
//    NSArray *tmp = [gridView subviews];
//    for (int i=0;i<tmp.count;i++) {
//        [tmp[i] removeFromSuperview];//---删除
//    }
    UILabel *preItem = [[topSegmentView subviews] objectAtIndex:currentItemTag];
    preItem.textColor = [UIColor blackColor];
}

-(void)rebulidTheBookOrder{
    //创建新界面
    [UIView animateWithDuration:0.4 animations:^{
        CGRect frame =  flagLb.frame;
        frame.origin.x = 107*currentItemTag;
        flagLb.frame = frame;
    } completion:^(BOOL finish){
        UILabel *preItem = [[topSegmentView subviews] objectAtIndex:currentItemTag];
        preItem.textColor = [UIColor redColor];
        [self reloadGridViewData];
        [Waiting dismiss];//---隐藏loading
    }];
}
#pragma mark UIAlerviewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 1:
                {
                    [Waiting show];
                    NSString *alertMessage = objc_getAssociatedObject(alertView, "alertMessageKey");
                    NSString *guid = [alertMessage substringFromIndex:2];
                    NSDictionary * params = @{@"apiid": @"0093",@"guid":guid};
                    NSURLRequest * request = [httpClient requestWithMethod:@"POST"
                                                                      path:@""
                                                                parameters:params];
                    AFHTTPRequestOperation * operation = [httpClient HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
                        [Waiting dismiss];//隐藏loading
                        NSString *source = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
                        NSLog(@"ewqewqwpqokopewpqokepqkpeowq------13---%@---",source);
                        if ([source  isEqualToString:@"true"]) {
                            NSString *toastStr = [alertMessage substringWithRange:NSMakeRange(0, 2)];
                            [self.view makeToast:[NSString stringWithFormat:@"%@成功",toastStr]  duration:1.2 position:@"center"];
                            //取消订单----取消全部里的
                            for (NSDictionary *item in orderArrays) {
                                if ([[item objectForKey:@"Guid"] isEqualToString:guid]) {
                                    [orderArrays removeObject:item];
                                    break;
                                }
                            }
                            //取消订单---取消已预订
                            for (NSDictionary *item in bookedArrays) {
                                if ([[item objectForKey:@"Guid"] isEqualToString:guid]) {
                                    [bookedArrays removeObject:item];
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

//刷新列表数据
-(void)reloadGridViewData{
    [gridView reloadData];
    NSInteger cellCount = [allArray[currentItemTag] count];
    if (cellCount>0) {
        noOrderView.hidden = YES;
    }else{
        noOrderView.hidden = NO;
    }
}

//-----------内存不足报警------
-(void)didReceiveMemoryWarning
{
    [[NSUserDefaults standardUserDefaults] synchronize];
    [super didReceiveMemoryWarning];
    NSLog(@"memory warning,kkappdelegate---");
}
@end
