//
//  WebViewController.m
//  Tuan
//  网络请求先后执行顺序
//  收货地址,计算金萝卜抵扣,买几赠几,运费
//

/*
 view 结构层级----括号里是tag标签-----
 contentView---->woodsListView(WOODSLISTVIEWTAG)------>payView(goldView,goldView_(COUPONVIEWTAG))
 
 温泉门票,酒店需要选择时间,,,,,如果没有选择时间是不能提交订单的----------
 
 
 
 收货地址逻辑:
 初始加载当前地址是 默认收货地址,如果更换不会改变默认收货地址
 */

#import "OrderFormController.h"
#import "UIImageView+WebCache.h"
#import "BookFinishController.h"

#define TOTALPAYPREFIX @"合计:  ¥ "
#define TIMEPREFIX @"点击选择时间"
#define WOODSLISTVIEWTAG 2002
//------优惠券抵扣view-----
#define COUPONVIEWTAG 3003
#define COUPONSUBVIEWTAG 4004
#define COUPONSUBVIEWTAG_ 4004
enum payType{
    DANERTUPAY,
    ALIPAY,
    DAOFU,             //此处的"到付"应该是已弃用,(暂时还不确定)
    WEBCHATPAY,
    UNIONPAY,
    CASHPAY,  //货到付款
};
/*
 金额计算:
 金萝卜,优惠券,更换地址(引起运费变化)-----这些改变能够改变总金额的勾选
 操作前---禁掉 "确认" 按钮
 计算总金额完毕
 回复 "确认按钮"
 防止 两个手指同时点击勾选和 确认,,,,导致提交的金额错误------
 */
@interface OrderFormController (){
    NSMutableArray *addressArray;
    NSMutableArray *woodShipParamsArr;//需要计算邮费的商品信息,包含  商品数量(这里是含赠送的总数量)
    BOOL isGoldCarrotPay;
    enum payType payOffType;
    NSMutableArray *woodsArrByShop;
    
    NSDecimalNumber *realGoldPay;//金萝卜实际抵扣的价钱
    NSDecimalNumber *shipPay;//运费总和
    NSDecimalNumber *netPay;//商品总价钱,不计算金萝卜抵扣,不计算运费
    NSDecimalNumber *couponPay;//优惠券抵扣的价钱
    NSString *realMobile;//实际生成订单的手机号,如果是活动那么收货信息的手机号有变
    UILabel *activityMobileLb;
    UILabel *strikeoutLine;
    BOOL isExistActivityMobile;//是否是  0.1元购  活动,有两个活动,0.1元购和1元专区
    NSMutableArray *woodsArrToPay;
    
    UIView *datePickerView;//日期选择
    UILabel *currentDateLb;//当前操作的cell里的时间
    
    UILabel *arriveTimeValueLb;
    UILabel *leaveTimeValueLb;
    
    NSMutableArray *shipItemTotalLbArr;
    NSString *postJsonStr;
    BOOL isHaveAgentProduct;//是否有线下支付的产品,,,有无决定了支付方式--,含有线下产品只能通过账户支付
    BOOL isAllSpringGoods;//是否全部是温泉商品,,,
    NSString *memberId;
    NSMutableArray *shopTicketsArr;//店铺的tickets
    NSInteger getTicketsNum;
    NSMutableArray *selectedTicketsArr;//选择的代金券
    NSString *danertuPayPriceData;//账户支付的额外参数
    BOOL canSpecialBuySubmit;//是否可以提交
    
    NSInteger currentPayWays;      //当前支付方式的总数
    BOOL isShowAlert;              //完成支付提示框的现实与否
    
    int isFinishPay;              //成功支付为2,放弃支付为1,与订单中心tag相对应
}
@end
@implementation NSMutableArray (convertToDic)
//数据拼凑
-(NSMutableArray *)convertToDic:(NSString *)keyName{
    NSMutableArray *result = [[NSMutableArray alloc] init];
    if ([self isKindOfClass:[NSMutableArray class]]&&self.count>0) {
        //是字典
        for (NSDictionary *woodItem in self) {
            if ([woodItem objectForKey:keyName]) {
                if (result.count>0) {
                    BOOL isExist = NO;//当前是否存在
                    for (NSMutableDictionary *shopItem in result) {
                        if ([[shopItem objectForKey:keyName] isEqualToString:[woodItem objectForKey:keyName]]) {
                            NSMutableArray *woodsArr = [[shopItem objectForKey:@"woodsArr"] mutableCopy];
                            [woodsArr addObject:woodItem];
                            [shopItem setObject:woodsArr forKey:@"woodsArr"];
                            isExist = YES;
                            break;
                        }
                    }
                    if (!isExist) {
                        NSMutableDictionary *shopItem = [[NSMutableDictionary alloc] init];
                        [shopItem setObject:[woodItem objectForKey:keyName] forKey:keyName];
                        [shopItem setObject:[woodItem objectForKey:@"shopName"] forKey:@"shopName"];
                        [shopItem setObject:@[woodItem] forKey:@"woodsArr"];
                        [result addObject:shopItem];
                    }
                }else{
                    //-------
                    NSMutableDictionary *shopItem = [[NSMutableDictionary alloc] init];
                    [shopItem setObject:[woodItem objectForKey:keyName] forKey:keyName];
                    [shopItem setObject:[woodItem objectForKey:@"shopName"] forKey:@"shopName"];
                    [shopItem setObject:@[woodItem] forKey:@"woodsArr"];
                    [result addObject:shopItem];
                }
            }else{
                break;
            }
        }
    }
    return result;
}
@end

@implementation OrderFormController
@synthesize defaults;
@synthesize totalLbPart;
@synthesize contentView;
@synthesize clickAdd;

@synthesize itemSelect;
@synthesize userNameLb;
@synthesize mobileLb;
@synthesize adrLb;
@synthesize backHomeIcon;

@synthesize productInfo;
@synthesize productInfoStr;
@synthesize addStatusBarHeight;
@synthesize isAddAddress;
@synthesize payBtn;
@synthesize orderInfoDic;
@synthesize isFromActivity;
@synthesize activityWood;
@synthesize addressInfo;
@synthesize canGoAddressView;

@synthesize shouldPayTextLb;
@synthesize isFromDirectlyPay;
@synthesize subViewDict;

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

//-----点击返回
-(void)onClickBack{
    [self.navigationController popViewControllerAnimated:YES];
}

//-----修改标题,重写父类方法----
-(NSString*)getTitle{
    return @"确认订单";
}

- (void)initView{
    lastSelectDataString = @"点击选择时间";
    subViewDict = [[NSMutableDictionary alloc] init];
    isAddAddress = NO;
    //------支付方式----使用金萝卜抵扣----
    payOffType = DANERTUPAY;  //普通商家默认单耳兔支付
    
    isGoldCarrotPay = YES;
    
    getTicketsNum = 0;
    self.view.backgroundColor = [UIColor whiteColor];
    
    addStatusBarHeight = [TopNaviViewController getStatusBarHeight];//--默认是0 ,ios6
    defaults =[NSUserDefaults standardUserDefaults];
    addressArray = [[NSMutableArray alloc] init];//初始化
    woodShipParamsArr = [[NSMutableArray alloc] init];//初始化
    shipItemTotalLbArr = [[NSMutableArray alloc] init];//初始化
    selectedTicketsArr = [[NSMutableArray alloc] init];//代金券
    productInfoStr = @"";//初始化,订单内容
    canGoAddressView = YES;
    isAllSpringGoods = YES;//----是否全部温泉客房----
    //---店铺优惠券---
    shopTicketsArr = [[NSMutableArray alloc] init];
    memberId = [[defaults objectForKey:@"userLoginInfo"] objectForKey:@"MemLoginID"];//本地存储
    if (!memberId) {
        [self.view makeToast:@"请先登录" duration:1.2 position:@"center"];
        [self performSelector:@selector(onClickBack) withObject:nil afterDelay:1];
        canGoAddressView = NO;
    }else{
        realGoldPay = [NSDecimalNumber decimalNumberWithString:@"0"];
        shipPay = [NSDecimalNumber decimalNumberWithString:@"0"];
        couponPay = [NSDecimalNumber decimalNumberWithString:@"0"];
        //----中间滑动区域-------125-----之后是商品列表------
        contentView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, addStatusBarHeight+TOPNAVIHEIGHT, MAINSCREEN_WIDTH, CONTENTHEIGHT)];//上半部分
        contentView.backgroundColor = [UIColor colorWithRed:248.0/255 green:248.0/255 blue:248.0/255 alpha:1];
        [self.view addSubview:contentView];
        
        //送货地址信息部分
        [self createAddressInfoView];
        
        //底部支付部分
        [self createBottomView];
        
        isShowAlert = NO;
        
        //获取默认收货人地址
        [self getAddressData];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getAddress:) name:@"getNewDefaultAddress" object:nil];//选中地址view 之间的消息传递
        //        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //            dispatch_async(dispatch_get_main_queue(), ^{
        //                [self createContentView];//中部区域
        //            });
        //        });
    }
    
}

-(void)createAddressInfoView{
    //81
    UIView *addressLb = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MAINSCREEN_WIDTH, 81)];
    addressLb.backgroundColor = [UIColor colorWithRed:230.0/255 green:160.0/255 blue:22.0/255 alpha:1];
    addressLb.userInteractionEnabled = YES;
    [contentView addSubview:addressLb];
    UITapGestureRecognizer *singleTap1 =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onClickAddPlace)];
    [addressLb addGestureRecognizer:singleTap1];//---添加大图片点击事
    //230  160   22
    //送货地址 --点击添加
    clickAdd = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, MAINSCREEN_WIDTH, 80)];
    clickAdd.backgroundColor = [UIColor grayColor];
    clickAdd.text = @"点击添加收货信息";
    clickAdd.textAlignment = NSTextAlignmentCenter;
    clickAdd.textColor = [UIColor redColor];
    [addressLb addSubview:clickAdd];//
    
    //送货地址 --当前选择的地址
    itemSelect = [[UIView alloc] initWithFrame:CGRectMake(0,0, MAINSCREEN_WIDTH, 80)];
    [itemSelect setHidden:YES];//----首先隐藏
    [addressLb addSubview:itemSelect];
    
    //标题
    userNameLb = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 170, 40)];
    userNameLb.textColor = [UIColor whiteColor];
    userNameLb.backgroundColor = [UIColor clearColor];
    [itemSelect addSubview:userNameLb];
    //电话
    mobileLb = [[UILabel alloc] initWithFrame:CGRectMake(190, 0, 98, 40)];
    mobileLb.font = TEXTFONT;
    mobileLb.textColor = [UIColor whiteColor];
    mobileLb.backgroundColor = [UIColor clearColor];
    [itemSelect addSubview:mobileLb];
    if (isFromActivity&&[defaults objectForKey:@"activityMobile"]) {
        realMobile = [defaults objectForKey:@"activityMobile"];
        [defaults removeObjectForKey:@"activityMobile"];
        //-----存在参加活动的手机号------
        isExistActivityMobile = YES;
        //删除线
        strikeoutLine = [[UILabel alloc] initWithFrame:CGRectMake(190, 20, 90, 1)];
        strikeoutLine.backgroundColor = [UIColor redColor];
        [itemSelect addSubview:strikeoutLine];
        //参加活动电话--------
        activityMobileLb = [[UILabel alloc] initWithFrame:CGRectMake(80, 30, 200, 20)];
        [itemSelect addSubview:activityMobileLb];
        activityMobileLb.font = TEXTFONT;
        activityMobileLb.textColor = [UIColor whiteColor];
        activityMobileLb.backgroundColor = [UIColor clearColor];
        activityMobileLb.text = [NSString stringWithFormat:@"%@(参加活动手机号)",realMobile];
    }else{
        isExistActivityMobile = NO;
    }
    //-----商品是否来自活动----获得待付商品数组------
    woodsArrToPay = [[defaults objectForKey:PAYOFFWOODSARR] mutableCopy];
    if (isFromActivity) {
        woodsArrToPay = [NSMutableArray arrayWithObject:activityWood];
    }
    
    //地址图标----
    UIImageView *locationImg = [[UIImageView alloc] initWithFrame:CGRectMake(10, 46, 20, 27)];
    [locationImg setImage:[UIImage imageNamed:@"addressLocation"]];
    [itemSelect addSubview:locationImg];
    //地址
    adrLb = [[UILabel alloc] initWithFrame:CGRectMake(40, 40, 248, 40)];
    adrLb.font = TEXTFONT;
    adrLb.textColor = [UIColor whiteColor];
    adrLb.backgroundColor = [UIColor clearColor];
    adrLb.numberOfLines = 2;
    [itemSelect addSubview:adrLb];
    //向右箭头
    UIImageView *right2 = [[UIImageView alloc] initWithFrame:CGRectMake(298, 30, 12, 19)];
    [right2 setImage:[UIImage imageNamed:@"arrowRight"]];
    [itemSelect addSubview:right2];
    //线条
    UILabel *borderLine1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 80, MAINSCREEN_WIDTH, 1)];
    borderLine1.backgroundColor = BORDERCOLOR;
    [addressLb addSubview:borderLine1];
}

-(void)createBottomView{
    //45
    UIView *bottomNavi = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-45, MAINSCREEN_WIDTH, 45)];
    bottomNavi.backgroundColor = [UIColor whiteColor];
    bottomNavi.userInteractionEnabled = YES;
    [self.view addSubview:bottomNavi];
    
    UILabel *border = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, MAINSCREEN_WIDTH, 0.7)];
    [bottomNavi addSubview:border];
    border.backgroundColor = BORDERCOLOR;
    
    //应付金额
    shouldPayTextLb = [[UILabel alloc] initWithFrame:CGRectMake(MAINSCREEN_WIDTH-270, 0, 160, 45)];
    shouldPayTextLb.backgroundColor = [UIColor clearColor];
    shouldPayTextLb.textColor = [UIColor redColor];
    shouldPayTextLb.font = [UIFont fontWithName:@"Helvetica-Bold" size:18];
    shouldPayTextLb.text = @"合计:  -- ";
    shouldPayTextLb.textAlignment = NSTextAlignmentRight;
    [bottomNavi addSubview:shouldPayTextLb];
    [subViewDict setObject:shouldPayTextLb forKey:@"shouldPayPriceView"];
    
    //------支付
    payBtn = [[UIButton alloc]initWithFrame:CGRectMake(MAINSCREEN_WIDTH-100, 0, 100, 45)];//高度--44
    [self setPayBtnUnEnadled];
    [payBtn setTitle:@"确认" forState:UIControlStateNormal];
    [payBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [payBtn setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [payBtn addTarget:self action:@selector(onClickCreateOrder) forControlEvents:UIControlEventTouchUpInside];
    [bottomNavi addSubview:payBtn];
}

//-----初次加载地址信息------加载  获取 默认收货人地址
-(void)getDefaultAddress{
    NSDictionary *addressDic = [addressArray firstObject];
    if (addressArray.count>1) {
        for (NSDictionary *tempDic in addressArray) {
            if([[tempDic objectForKey:@"ck"] isEqualToString:@"1"]){
                addressDic = [tempDic copy];
                break;
            }
        }
    }
    [clickAdd setHidden:YES];
    [itemSelect setHidden:NO];
    //    isAddAddress = YES;//添加了地址
    userNameLb.text = [NSString stringWithFormat:@"收货人: %@",[addressDic objectForKey:@"name"]];
    //----这里保存gid--,传值给addressList,比较新选择的地址是不是之前的地址,决定是否重新计算运费-----
    userNameLb.accessibilityIdentifier = [addressDic objectForKey:@"guid"];
    NSLog(@"fofhieoigheoige------guid------%@",addressDic);
    mobileLb.text = [addressDic objectForKey:@"mobile"];
    adrLb.text = [NSString stringWithFormat:@"收货地址: %@",[addressDic objectForKey:@"adress"]];
    //    if (isAllSpringGoods) {
    //        adrLb.text = @"注意:此商品请直接到店消费";
    //        adrLb.textColor = [UIColor redColor];
    //    }
    addressInfo = addressDic;
    //----没有参加活动的手机号---检测真实提交的手机号-----
    if (!isExistActivityMobile) {
        realMobile = [addressInfo objectForKey:@"mobile"];
    }
}
//-----通过消息  获取 收货人地址,地址没有变化时不执行-----
-(void)getAddress:(NSNotification *) notification{
    NSLog(@"ajifoejigorehruthiopokp--------");
    [clickAdd setHidden:YES];
    [itemSelect setHidden:NO];
    isAddAddress = YES;//添加了地址
    NSDictionary *tempDic = [notification userInfo];
    userNameLb.text = [NSString stringWithFormat:@"收货人: %@",[tempDic objectForKey:@"name"]];
    userNameLb.accessibilityIdentifier = [tempDic objectForKey:@"guid"];//没有值
    NSLog(@"fofhieoigheoige------guid------1%@",tempDic);
    mobileLb.text = [tempDic objectForKey:@"mobile"];
    adrLb.text = [NSString stringWithFormat:@"收货地址: %@",[tempDic objectForKey:@"adress"]];
    if (isAllSpringGoods) {
        adrLb.text = @"注意:此商品请直接到店消费";
        adrLb.textColor = [UIColor redColor];
    }
    addressInfo = tempDic;
    //----没有参加活动的手机号---检测真实提交的手机号-----
    if (!isExistActivityMobile) {
        realMobile = [addressInfo objectForKey:@"mobile"];
    }
    [self calculateShipPay];//-----计算邮费,重新
}
//-------获取地址
-(void)getAddressData{
    
    [Waiting show];
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:@"0030",@"apiid",memberId,@"uId", nil];
    [[AFOSCClient sharedClient] postPath:nil parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject){
        NSString *respondString = operation.responseString;
        NSDictionary *jsonData = [respondString objectFromJSONString];
        NSArray* temp = [[jsonData objectForKey:@"adress"] objectForKey:@"adresslist"];//数组
        if(temp.count>0){
            addressArray = [temp mutableCopy];
            isAddAddress = YES;//添加了地址
            [self getDefaultAddress];
            canGoAddressView = YES;
        }else{
            [self.view makeToast:@"还没有添加收货信息" duration:2.0 position:@"center"];
        }
        
        [self createContentView];//中部区域
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error){
        [Waiting dismiss];//隐藏loading
        [self.view makeToast:@"请检查网络连接是否正常" duration:2.0 position:@"center"];
    }];
}

//-----计算运费
//--params--woodShipInfoArr,数组(supplierId,sproductidlist,buynumberList)
//-(void)calculateShipPay:(UILabel *)targetLb{
-(void)calculateShipPay{
    //计算邮费,如果这个数组不为空,
    if (woodShipParamsArr.count>0) {
        [Waiting show];//loading------
        //-----已经计算过运费-------
        if (shipItemTotalLbArr.count>0) {
            NSLog(@"ajfewjgireothurhkopqdkop---------%@",shipItemTotalLbArr);
            //-----这里要消除前一次计算运费的结果------
            for (NSDictionary *shipItemDic in shipItemTotalLbArr) {
                //-----修改底部总金额-----
                UILabel *bottomV = [shipItemDic objectForKey:@"labelObj"];
                NSRange range = [bottomV.text rangeOfString:@"件商品  合计: ¥ "];
                NSString *sourceStr = [bottomV.text substringFromIndex:1];
                NSString *oldCount = [sourceStr substringToIndex:range.location-1];
                double oldPrice = [[sourceStr substringFromIndex:(range.location+range.length-1)] doubleValue] - [[shipItemDic objectForKey:@"shipPay"] floatValue];
                bottomV.text = [NSString stringWithFormat:@"共%@件商品  合计: ¥ %0.2f",oldCount,oldPrice];
            }
            //----计算完成,所有数据失效,删除ok------
            [shipItemTotalLbArr removeAllObjects];
        }
        double shipTotalPay = 0;
        BOOL isCalculateRight = YES;
        for (NSDictionary *woodItem in woodShipParamsArr) {
            NSURL *url = [NSURL URLWithString:APIURL];
            NSString *addr =  [adrLb.text stringByReplacingOccurrencesOfString:@"收货地址: " withString:@""];
            NSLog(@"jgioerjgioejgroie---%@---%@",addr,woodItem);
            //第二步，创建请求
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
            [request setHTTPMethod:@"POST"];//设置请求方式为POST，默认为GET
            NSString *str = [NSString stringWithFormat:@"apiid=0088&&supplierId=%@&&area=%@&&sproductidlist=%@&&buynumberList=%@",[woodItem objectForKey:@"supplierId"],addr,[woodItem objectForKey:@"sproductidlist"],[woodItem objectForKey:@"buynumberList"]];
            NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
            [request setHTTPBody:data];
            
            NSError *error;
            //第三步，连接服务器
            NSData *received = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
            NSString *source = [[NSString alloc]initWithData:received encoding:NSUTF8StringEncoding];
            if (!error) {
                double itemShipPay = [source doubleValue];
                if (itemShipPay > 0) {
                    shipTotalPay += itemShipPay;
                    
                    UILabel *shipLb = [woodItem objectForKey:@"shipLabel"];
                    shipLb.text = [NSString stringWithFormat:@"¥ %0.2f",itemShipPay];
                    
                    //-----修改底部总金额-----
                    UILabel *bottomV = (UILabel *)[[[[shipLb superview] superview] superview] viewWithTag:6000];
                    NSDictionary *shipItemDic = @{@"labelObj":bottomV,@"shipPay":[NSString stringWithFormat:@"%0.2f",itemShipPay]};
                    [shipItemTotalLbArr addObject:shipItemDic];
                    
                    NSRange range = [bottomV.text rangeOfString:@"件商品  合计: ¥ "];
                    NSString *sourceStr = [bottomV.text substringFromIndex:1];
                    NSString *oldCount = [sourceStr substringToIndex:range.location-1];
                    double oldPrice = [[sourceStr substringFromIndex:(range.location+range.length-1)] doubleValue] + itemShipPay;
                    bottomV.text = [NSString stringWithFormat:@"共%@件商品  合计: ¥ %0.2f",oldCount,oldPrice];
                    
                }else{
                    isCalculateRight = NO;
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"信息提示" message:@"部分商品不能送达当前的地址,或地址信息没有包含省,市,区无法识别" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                    [alert setTag:1001];
                    [alert show];
                    break;//只要有一个是  0,那么就停止循环
                }
            }else{
                [self.view makeToast:@"网络错误,请稍后重试" duration:1.2 position:@"center"];
            }
        }
        
        
        
        //-----油费计算是否正确-----
        if (isCalculateRight) {
            [self setPayBtnEnabled];
        }else{
            [self setPayBtnUnEnadled];
        }
        shipPay = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%0.2f",shipTotalPay]];
        [Waiting dismiss];//隐藏
    }else{
        [self setPayBtnEnabled];
    }
    NSLog(@"fjaiojriogjrhutrhht-----1--%@,%@,%@",shipPay,netPay,shouldPayTextLb);
    //---计算总价-----
    [self calculateTotalShouldPay];
    NSLog(@"fjaiojriogjrhutrhht-----2--%@,%@,%@",shipPay,netPay,shouldPayTextLb);
}

//payBtn
-(void)setPayBtnEnabled{
    payBtn.enabled = YES;
    payBtn.backgroundColor = BUTTONCOLOR;
}

//payBtn 灰化
-(void)setPayBtnUnEnadled{
    payBtn.enabled = NO;
    payBtn.backgroundColor = VIEWBGCOLOR;
}

//-----中间区域,商品信息
-(void)createContentView{
    isHaveAgentProduct = NO;
    //loading--------
    //---------数据转换------,按照shopId来分组------
    woodsArrByShop = [woodsArrToPay convertToDic:@"shopId"];
    NSLog(@"ajfopgjirothujqowdjopwq----2---%@",woodsArrByShop);
    
    //----这里清除,下面需要重组-----
    [woodsArrToPay removeAllObjects];
    double totalPrice = 0;
    double payByScorePrice = 0;//可以使用金萝卜抵扣的总金额
    productInfo = [[NSMutableArray alloc] init];
    NSString *guidStr = @"";//提交的guid连在一起的字符串
    int itemHeight = 50;
    NSMutableArray *donateNumArr = [[NSMutableArray alloc] init];
    int itemCount = (int)woodsArrByShop.count;
    //-----地址信息-----高度90------
    UIView *woodsListView = [[UIView alloc] initWithFrame:CGRectMake(0, 90, MAINSCREEN_WIDTH, itemCount * itemHeight + 280)];
    woodsListView.tag = WOODSLISTVIEWTAG;
    [contentView addSubview:woodsListView];
    contentView.contentSize = CGSizeMake(self.view.frame.size.width, woodsListView.frame.size.height + 90);
    
    CGFloat woodItemHeight = 150;    //每个的商品高度
    CGFloat shopViewHeight = 0;  //每家店铺的高度
    CGFloat heightDistance = 0;
    CGFloat lastShopHeight = 0;
    CGFloat startShopY = 0;
    for (int i = 0; i < itemCount; i++) {
        NSDictionary *tempDic = [woodsArrByShop objectAtIndex:i];
        //--------计算店铺的优惠券-------
        [self calculateCouponPay:[tempDic objectForKey:@"shopId"]];
        
        NSArray *woodsItemArr = [tempDic objectForKey:@"woodsArr"];
        int woodsItemCount = (int)[woodsItemArr count];
        //---每家超市---的view
        for (int i = 0; i < [woodsItemArr count]; i++) {
            NSString *other1 = [[woodsItemArr objectAtIndex:i] objectForKey:@"arriveTime"];
            NSString *other2 = [[woodsItemArr objectAtIndex:i] objectForKey:@"leaveTime"];
            if (!([other1 isEqualToString:@""] || other1 == nil) && !([other2 isEqualToString:@""] || other2 == nil)) {
                woodItemHeight = 210;
            }
            else if (!([other1 isEqualToString:@""] || other1 == nil)){
                woodItemHeight = 180;
            }
            else if (!([other2 isEqualToString:@""] || other2 == nil)){
                woodItemHeight = 180;
            }
            else{
                woodItemHeight = 150;
            }
            if (isFromDirectlyPay) {
                NSString *guidTmp = [[woodsItemArr objectAtIndex:i] objectForKey:@"Guid"];
                if ([Tools isSpringTicketWithGuid:guidTmp]) {
                    woodItemHeight = 180;
                }
                else if([Tools isSpringHotelTicketWithInfo:[woodsItemArr objectAtIndex:i]]){
                    woodItemHeight = 210;
                }
            }
            
            shopViewHeight = shopViewHeight + woodItemHeight;
        }
        shopViewHeight = shopViewHeight + 30;
        startShopY = startShopY + lastShopHeight + 10;
        UIView *shopItemView = [[UIView alloc] initWithFrame:CGRectMake(0, startShopY , MAINSCREEN_WIDTH, shopViewHeight)];
        [woodsListView addSubview:shopItemView];//
        shopItemView.backgroundColor = [UIColor whiteColor];
        heightDistance = shopItemView.frame.size.height + heightDistance;
        
        //超市名称
        UILabel *shopName = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 270, 30)];
        [shopItemView addSubview:shopName];//
        shopName.text = [NSString stringWithFormat:@"超市:  %@",[tempDic objectForKey:@"shopName"]];
        
        //线条
        UILabel *borderLine1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, MAINSCREEN_WIDTH, 1)];
        borderLine1.backgroundColor = BORDERCOLOR;
        [shopItemView addSubview:borderLine1];
        
        UILabel *border = [[UILabel alloc] initWithFrame:CGRectMake(10, 29, 300, 2)];
        [shopItemView addSubview:border];
        border.backgroundColor = [UIColor whiteColor];
        
        //每个店铺的商品总和,价格总和
        int shopWoodsCount = 0;
        double shopTotalPrice = 0;
        //循环每个店铺的商品
        
        CGFloat lastItemHeight = 0; //上一个商品的高度
        CGFloat startOffsetY = 30;  //从Y坐标30开始计算商品Y轴的位置
        CGFloat goodsY = startOffsetY;
        for (int j = 0;j < woodsItemCount;j++) {
            NSMutableDictionary *woodDic = woodsItemArr[j];
            
            NSString *other1 = [woodDic objectForKey:@"arriveTime"];
            NSString *other2 = [woodDic objectForKey:@"leaveTime"];
            if (!([other1 isEqualToString:@""] || other1 == nil) && !([other2 isEqualToString:@""] || other2 == nil)) {
                woodItemHeight = 210;
            }
            else if (!([other1 isEqualToString:@""] || other1 == nil)){
                woodItemHeight = 180;
            }
            else if (!([other2 isEqualToString:@""] || other2 == nil)){
                woodItemHeight = 180;
            }
            else{
                woodItemHeight = 150;
            }
            if (isFromDirectlyPay) {
                NSString *guidTmp = [woodDic objectForKey:@"Guid"];
                if ([Tools isSpringTicketWithGuid:guidTmp]) {
                    woodItemHeight = 180;
                }
                else if([Tools isSpringHotelTicketWithInfo:[woodsItemArr objectAtIndex:i]]){
                    woodItemHeight = 210;
                }
            }
            //----是否温泉商品---------
            //----有线下产品只能     单耳兔账户支付
            if ([[woodDic objectForKey:@"AgentId"] length]>5||[[woodDic objectForKey:@"agentID"] length]>5) {
                isHaveAgentProduct = YES;
            }
            NSLog(@"kfopwekgpjitrh----1-%@",woodDic);
            //-------根据guid---price---获取提交的priceData----单耳兔账号支付需要的参数------;
            [self getPriceDataStr:[woodDic objectForKey:@"Guid"] price:[woodDic objectForKey:@"price"]];
            
            //------检测购买合法性----
            [self checkSpecialBuy:[woodDic objectForKey:@"Guid"] price:[woodDic objectForKey:@"price"]];
            
            //NSArray *lalt = [coordinate componentsSeparatedByString:@","];
            //每件商品的item
            goodsY = goodsY + lastItemHeight;
            UIView *itemView = [[UIView alloc] initWithFrame:CGRectMake(0, goodsY, 300, woodItemHeight)];
            [shopItemView addSubview:itemView];
            itemView.userInteractionEnabled = YES;
            itemView.tag = 3000;
            
            lastItemHeight = woodItemHeight;
            
            //商品信息背景
            UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MAINSCREEN_WIDTH, 60)];
            [itemView addSubview:bgView];
            [bgView setBackgroundColor:[UIColor colorWithRed:242.0/255 green:242.0/255 blue:242.0/255 alpha:1]];
            
            //商品图片
            NSString *imageUrl = [woodDic objectForKey:@"img"];
            if ([imageUrl isMemberOfClass:[NSNull class]] || imageUrl == nil) {
                imageUrl = @"";
            }
            AsynImageView *imageView = [[AsynImageView alloc] initWithFrame:CGRectMake(10, 9, 40, 42)];//商品图片
            imageView.placeholderImage = [UIImage imageNamed:@"noData1"];
            [itemView addSubview:imageView];
            imageView.imageURL = imageUrl;
            //商品名称
            UILabel *woodsLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 10, 130, 36)];
            [itemView addSubview:woodsLabel];
            woodsLabel.backgroundColor = [UIColor clearColor];
            woodsLabel.font = TEXTFONTSMALL;
            woodsLabel.numberOfLines = 2;
            woodsLabel.text = [woodDic objectForKey:@"name"];
            
            //单价符号,-----这里作为父标签的最后一个子标签,便于寻找
            UILabel *unitPriceSign = [[UILabel alloc] initWithFrame:CGRectMake(210, 10, 100, 18)];
            [itemView addSubview:unitPriceSign];
            unitPriceSign.font = TEXTFONTSMALL;
            unitPriceSign.textAlignment = NSTextAlignmentRight;
            unitPriceSign.text = [NSString stringWithFormat:@"¥ %@",[woodDic objectForKey:@"price"]];
            unitPriceSign.backgroundColor = [UIColor clearColor];
            NSString *viewKey = [NSString stringWithFormat:@"singlePriceView%d",j];
            [subViewDict setObject:unitPriceSign forKey:viewKey];
            
            
            //数量-----
            int woodItemCount = [[woodDic objectForKey:@"count"] intValue];
            UILabel *woodCountLb = [[UILabel alloc] initWithFrame:CGRectMake(240, 30, 70, 18)];
            [itemView addSubview:woodCountLb];
            woodCountLb.font = TEXTFONTSMALL;
            woodCountLb.textAlignment = NSTextAlignmentRight;
            woodCountLb.text = [NSString stringWithFormat:@"X %d",woodItemCount];
            woodCountLb.backgroundColor = [UIColor clearColor];
            //---累加商品数量----累加商品价格
            shopWoodsCount += woodItemCount;
            shopTotalPrice += woodItemCount*[[woodDic objectForKey:@"price"] doubleValue];
            //---计算可以积分抵扣的金额---------计算金萝卜抵扣-----
            if ([[woodDic objectForKey:@"AgentId"] length]<=0&&[[woodDic objectForKey:@"agentID"] length]<=0&&[[woodDic objectForKey:@"SupplierLoginID"] length]<=0){
                payByScorePrice += [[woodDic objectForKey:@"price"] doubleValue]*[[woodDic objectForKey:@"count"] intValue];
            }
            
            //-------购买数量-----
            UILabel *variableCountLb = [[UILabel alloc] initWithFrame:CGRectMake(10, 60, 300, 30)];
            [itemView addSubview:variableCountLb];
            variableCountLb.userInteractionEnabled = YES;
            variableCountLb.text = @"购买数量";
            variableCountLb.font = TEXTFONT;
            
            //数字
            UILabel *countText = [[UILabel alloc] initWithFrame:CGRectMake(260, 5, 40, 20)];
            [variableCountLb addSubview:countText];//
            countText.text = [woodDic objectForKey:@"count"];
            countText.font = TEXTFONT;
            countText.textAlignment = NSTextAlignmentRight;
            countText.tag = 2000;
            //            }
            
            NSArray *labelTextArr = @[@"赠送数量",@"配送运费",@"0",@"--"];
            int additionItemCount = (int)labelTextArr.count/2;
            //赠送数量,运费
            for (int m = 0;m<additionItemCount;m++) {
                UILabel *variableCountLb = [[UILabel alloc] initWithFrame:CGRectMake(10, 90+30*m, 300, 30)];
                [itemView addSubview:variableCountLb];
                variableCountLb.text = labelTextArr[m];
                variableCountLb.font = TEXTFONT;
                
                UILabel *valueLb = [[UILabel alloc] initWithFrame:CGRectMake(150, 0, 150, 30)];
                [variableCountLb addSubview:valueLb];
                valueLb.font = TEXTFONT;
                valueLb.textAlignment = NSTextAlignmentRight;
                valueLb.text = labelTextArr[m+additionItemCount];
                
                //-----后加线条----
                UILabel *border = [[UILabel alloc] initWithFrame:CGRectMake(10, 90+30*m, SCREENWIDTH - 20, 0.7)];
                [itemView addSubview:border];
                border.backgroundColor = BORDERCOLOR;
                if (m==0) {
                    //-----赠送数量----添加到数组----
                    [donateNumArr addObject:valueLb];
                }else if (m==additionItemCount-1) {
                    //运费的计算
                    NSString *SupplierLoginID = [woodDic objectForKey:@"SupplierLoginID"];
                    
                    if ([SupplierLoginID length]>0&&![SupplierLoginID isEqualToString:SPRINGSUPPLIERID]) {
                        //要计算运费
                        [woodShipParamsArr addObject:[NSMutableDictionary dictionaryWithDictionary:@{@"supplierId":SupplierLoginID,@"sproductidlist":[woodDic objectForKey:@"Guid"],@"shipLabel":valueLb}]];
                    }else{
                        //免运费
                        valueLb.text = @"免运费";
                    }
                }
            }
            //按照当前排列顺序重组  woodItem,,,,
            [woodsArrToPay addObject:woodDic];
            //用来计算邮费,计算买几赠几
            guidStr = [NSString stringWithFormat:@"%@,%@",guidStr,[woodDic objectForKey:@"Guid"]];
            //来自直接购买
            //            NSString *path=[[NSBundle mainBundle] pathForResource:@"springHotelGuid" ofType:@"plist"];
            //取得sortednames.plist绝对路径
            //sortednames.plist本身是一个NSDictionary,以键-值的形式存储字符串数组
            
            //            NSDictionary *guidDic=[[NSDictionary alloc] initWithContentsOfFile:path];
            //温泉,客房的guid写到这里
            //            NSArray *hotelGuidArr = [guidDic objectForKey:@"hotelGuidArr"];
            //温泉客房商品
            if([[woodDic objectForKey:@"SupplierLoginID"] isEqualToString:SPRINGSUPPLIERID]){
                //创建时间选择器
                [self createDatePicker];
                
                //                itemView.frame = CGRectMake(10, 30 + woodItemHeight*j, 300, 180);
                //                woodItemHeight = 180;
                
                arriveTimeValueLb = [[UILabel alloc] initWithFrame:CGRectMake(10, 150, 300, 30)];
                arriveTimeValueLb.tag = j;
                [itemView addSubview:arriveTimeValueLb];
                arriveTimeValueLb.userInteractionEnabled = YES;
                arriveTimeValueLb.font = TEXTFONT;
                arriveTimeValueLb.textAlignment = NSTextAlignmentRight;
                arriveTimeValueLb.textColor = [UIColor redColor];
                NSString *timeInfoStr = [woodDic objectForKey:@"arriveTime"];
                if (!timeInfoStr) {
                    timeInfoStr = @"点击选择时间";
                }
                arriveTimeValueLb.text = timeInfoStr;
                //---------
                UILabel *arriveTimeText = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
                [arriveTimeValueLb addSubview:arriveTimeText];
                arriveTimeText.font = TEXTFONT;
                arriveTimeText.text = @"预计抵达时间";
                
                //分割线
                UILabel *borderLast = [[UILabel alloc] initWithFrame:CGRectMake(10, 180-0.7-30, 300, 0.7)];
                [itemView addSubview:borderLast];//
                borderLast.backgroundColor = BORDERCOLOR;
                
                arriveTimeValueLb.accessibilityIdentifier = @"arriveTime";//数据里的  key,不能随意
                UITapGestureRecognizer *sasTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showDatePicker:)];
                [arriveTimeValueLb addGestureRecognizer:sasTap];//---添加点击事件
                
                //                shopItemView.frame = CGRectMake(0, shopItemView.frame.origin.y, MAINSCREEN_WIDTH, woodItemHeight*woodsItemCount+60);
                //现在只要是泉眼的商品都需要离开时间
                NSString *guidTmp = [woodDic objectForKey:@"Guid"];
                if ([guidTmp isMemberOfClass:[NSNull class]] || guidTmp == nil) {
                    guidTmp = @"";
                }
                //加上离开的时间
                if ([Tools isSpringHotelWithGuid:guidTmp]) {
                    //                    itemView.frame = CGRectMake(10, 30+woodItemHeight*j, 300, 210);
                    //                    woodItemHeight = 210;
                    leaveTimeValueLb = [[UILabel alloc] initWithFrame:CGRectMake(10, 180, 300, 30)];
                    [itemView addSubview:leaveTimeValueLb];
                    leaveTimeValueLb.userInteractionEnabled = YES;
                    leaveTimeValueLb.font = TEXTFONT;
                    leaveTimeValueLb.textAlignment = NSTextAlignmentRight;
                    leaveTimeValueLb.textColor = [UIColor redColor];
                    NSString *timeInfoStr = [woodDic objectForKey:@"leaveTime"];
                    if (!timeInfoStr) {
                        timeInfoStr = @"点击选择时间";
                        
                    }
                    leaveTimeValueLb.text = timeInfoStr;
                    //---------
                    UILabel *leaveTimeText = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
                    [leaveTimeValueLb addSubview:leaveTimeText];
                    leaveTimeText.font = TEXTFONT;
                    leaveTimeText.text = @"预计离开时间";
                    
                    //分割线
                    UILabel *borderLast123 = [[UILabel alloc] initWithFrame:CGRectMake(10, 210 - 0.7 - 30, 300, 0.7)];
                    [itemView addSubview:borderLast123];//
                    borderLast123.backgroundColor = BORDERCOLOR;
                    
                    leaveTimeValueLb.accessibilityIdentifier = @"leaveTime";//数据里的  key,不能随意
                    UITapGestureRecognizer *saTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showDatePicker:)];
                    [leaveTimeValueLb addGestureRecognizer:saTap];//---添加点击事件
                    
                    //                    shopItemView.frame = CGRectMake(0, shopItemView.frame.origin.y, MAINSCREEN_WIDTH, woodItemHeight*woodsItemCount+60);
                }
                
                //                heightDistance = shopItemView.frame.size.height;
            }else{
                isAllSpringGoods = NO;//不全都是温泉客房的产品----有其他产品---不能使用  到付
            }
        }
        CGRect shopRect = shopItemView.frame;
        shopRect.size.height = goodsY + lastItemHeight + 30;
        shopItemView.frame = shopRect;
        lastShopHeight = shopRect.size.height;
        
        UILabel *borderLast123 = [[UILabel alloc] initWithFrame:CGRectMake(0, shopItemView.frame.size.height - 30 - 0.7, MAINSCREEN_WIDTH, 0.7)];
        [shopItemView addSubview:borderLast123];//
        borderLast123.backgroundColor = BORDERCOLOR;
        
        //-------底部统计-----共多少商品,,,,,合计多少钱-------
        UILabel *bottomView = [[UILabel alloc] initWithFrame:CGRectMake(10, shopItemView.frame.size.height - 30, 300, 30)];
        [shopItemView addSubview:bottomView];
        bottomView.tag = 6000;//------特殊tag-------
        bottomView.textAlignment = NSTextAlignmentRight;
        //shopWoodsCount----shopTotalPrice
        bottomView.text = [NSString stringWithFormat:@"共%d件商品  合计: ¥ %0.2f",shopWoodsCount,shopTotalPrice];
        [subViewDict setObject:bottomView forKey:@"totalPriceView"];
        totalPrice += shopTotalPrice;
    }
    
    heightDistance = startShopY + lastShopHeight;
    
    NSArray *payTypeArr = nil;
    NSArray *tagArray = nil;
    if (isAllSpringGoods) {
        payTypeArr = @[@"到付",@"货到付款有利于亲的验货",@"ArriveIcon",@"单耳兔账户支付",@"推荐单耳兔会员使用",@"icon",@"支付宝支付",@"推荐已安装支付宝快捷支付的用户使用",@"aliPay"];
        tagArray = @[@"102",@"100",@"101"];
        payOffType = CASHPAY;
    }
    else{
        payTypeArr = @[@"单耳兔账户支付",@"推荐单耳兔会员使用",@"icon",@"支付宝支付",@"推荐已安装支付宝快捷支付的用户使用",@"aliPay"];
    }
    //    NSArray *payTypeArr = @[@"单耳兔账户支付",@"推荐单耳兔会员使用",@"icon",@"支付宝支付",@"推荐已安装支付宝快捷支付的用户使用",@"aliPay",@"货到付款",@"货到付款有利于亲的验货",@"ArriveIcon"];
    //------包含了线下产品,,,只能使用账户支付-----
    if (isHaveAgentProduct) {
        payTypeArr = @[@"单耳兔账户支付",@"推荐单耳兔会员使用",@"icon"];
    }
    
    currentPayWays = [payTypeArr count] / 3;
    
    //----修正商铺商铺列表
    woodsListView.frame = CGRectMake(0, 90, MAINSCREEN_WIDTH, heightDistance + 280 + 100 - 150 + 50*currentPayWays);
    //heightDistance+90
    contentView.contentSize = CGSizeMake(MAINSCREEN_WIDTH, 90 + heightDistance + 280 + 100 - 150 + 50*currentPayWays);
    contentView.showsVerticalScrollIndicator = NO;
    
    //-------woodsListView-------支付方式选择------
    UIView *payView = [[UIView alloc] initWithFrame:CGRectMake(0, heightDistance + 10, MAINSCREEN_WIDTH, 20 + 50 * currentPayWays)];
    [woodsListView addSubview:payView];
    payView.backgroundColor = [UIColor whiteColor];
    
    //-----上边线
    UILabel *borderLine1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, MAINSCREEN_WIDTH, 1)];
    borderLine1.backgroundColor = BORDERCOLOR;
    [payView addSubview:borderLine1];
    
    UILabel *payTypeTextLb = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 300, 20)];
    [payView addSubview:payTypeTextLb];
    payTypeTextLb.textColor = [UIColor grayColor];
    payTypeTextLb.text = @"支付方式:";
    //-----下边线
    UILabel *borderLine2 = [[UILabel alloc] initWithFrame:CGRectMake(10, 24.3, 300, 0.7)];
    borderLine2.backgroundColor = BORDERCOLOR;
    [payView addSubview:borderLine2];
    
    //NSArray *payTypeArr = @[@"支付宝支付",@"微信支付",@"银联支付",@"推荐已安装支付宝快捷支付的用户使用",@"推荐已安装微信的用户使用",@"有银行卡就可支付,无需开通网银",@"aliPay",@"webChatPay",@"unPay",];
    
    NSInteger payTypeCount = payTypeArr.count / 3;
    int payItemheight = 50;
    
    //支付方式
    UIView *selectPayType = [[UIView alloc] initWithFrame:CGRectMake(10, 30, 300, payItemheight * payTypeCount)];
    [payView addSubview:selectPayType];
    selectPayType.userInteractionEnabled = YES;
    
    
    for (int i=0; i < payTypeCount; i++) {
        
        UIView *selectView = [[UIView alloc] initWithFrame:CGRectMake(0, 50 * i, 300, 50)];
        [selectPayType addSubview:selectView];
        selectView.tag = 100 + i;
        if (isAllSpringGoods) {
            selectView.tag = [tagArray[i] integerValue];
        }
        UITapGestureRecognizer *singleTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectPayType:)];
        [selectView addGestureRecognizer:singleTap];//---添加点击事件
        
        //选择框
        UIButton *setDefaultBtn = [[UIButton alloc] initWithFrame:CGRectMake(260, 5, 20, 20)];
        [selectView addSubview:setDefaultBtn];
        setDefaultBtn.layer.cornerRadius = 2;
        setDefaultBtn.layer.borderColor = [UIColor grayColor].CGColor;
        [setDefaultBtn.layer setBorderWidth:0.6];
        setDefaultBtn.enabled = NO;//这里不使用按钮的点击事件,禁用,防止截获事件响应
        setDefaultBtn.backgroundColor = [UIColor clearColor];
        if (i==0) {
            [setDefaultBtn setImage:[UIImage imageNamed:@"selected"] forState:UIControlStateDisabled];
        }
        //icon
        UIImageView *payIcon = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, 30, 30)];
        [selectView addSubview:payIcon];
        payIcon.image = [UIImage imageNamed:payTypeArr[i*3+2]];
        
        //文字
        UILabel *nameLb = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, 220, 18)];
        [selectView addSubview:nameLb];
        nameLb.backgroundColor = [UIColor clearColor];
        nameLb.font = TEXTFONT;
        nameLb.text = payTypeArr[i*3];
        if (isAllSpringGoods) {
            
        }
        //详细说明文字
        UILabel *addtionLb = [[UILabel alloc] initWithFrame:CGRectMake(50,18,220,12)];
        [selectView addSubview:addtionLb];
        addtionLb.backgroundColor = [UIColor clearColor];
        addtionLb.textColor = [UIColor grayColor];
        addtionLb.font = TEXTFONTSMALL;
        addtionLb.text = payTypeArr[i*3+1];
    }
    
    UILabel *borderLine3 = [[UILabel alloc] initWithFrame:CGRectMake(0, 20 + selectPayType.frame.size.height - 1, MAINSCREEN_WIDTH, 1)];
    borderLine3.backgroundColor = BORDERCOLOR;
    [payView addSubview:borderLine3];
    
    //是否使用金萝卜抵扣
    UIView *goldView = [[UIView alloc] initWithFrame:CGRectMake(0, heightDistance + payView.frame.size.height + 10 + 20, MAINSCREEN_WIDTH, 80)];
    [woodsListView addSubview:goldView];
    goldView.backgroundColor = [UIColor whiteColor];
    
    UILabel *goldTitleLb = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 290, 20)];
    [goldView addSubview:goldTitleLb];
    goldTitleLb.textColor = [UIColor grayColor];
    goldTitleLb.text = @"金萝卜抵扣:";
    //-----上边线
    UILabel *_borderLine = [[UILabel alloc] initWithFrame:CGRectMake(10, 24.3, 300, 0.7)];
    _borderLine.backgroundColor = BORDERCOLOR;
    [goldView addSubview:_borderLine];
    //-----金萝卜----
    UILabel *goldInfoLb = [[UILabel alloc] initWithFrame:CGRectMake(10, 25, 300, 20)];
    [goldView addSubview:goldInfoLb];
    goldInfoLb.font = TEXTFONT;
    goldInfoLb.text = @"可用--金萝卜抵扣金额: ¥ --";
    
    //---商品总数量,这时显示的是不计算 "买几送几"的情况下,,,下边在得到有赠送数量时改写这个数据
    netPay = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%0.2f",totalPrice]];
    
    //判断是否   可用金萝卜支付
    if (payByScorePrice>0) {
        NSDecimalNumber *scorePay = [[NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%0.2f",payByScorePrice]] decimalNumberByDividingBy:[NSDecimalNumber decimalNumberWithString:@"10"]];
        
        //-----显示金萝卜抵扣------这里也要-----卡主,,,,,同步请求----
        BOOL isHaveGold = [self getGoldCarrotPay:goldInfoLb scorePay:scorePay];
        if (isHaveGold) {
            //--------抵扣选择框
            UIView *selectGoldPayView = [[UIView alloc] initWithFrame:CGRectMake(10, 45, 300, 30)];
            [goldView addSubview:selectGoldPayView];
            for (int i=0; i<2; i++) {
                NSString *str;
                UIImage *img;
                if (i==0) {
                    str = @"抵扣";
                    img = [UIImage imageNamed:@"selected"];
                }else{
                    str = @"不抵扣";
                    img = nil;
                }
                UIView *selectView = [[UIView alloc] initWithFrame:CGRectMake(150*i, 0, 150, 30)];
                [selectGoldPayView addSubview:selectView];
                selectView.tag = 100+i;
                selectView.userInteractionEnabled = YES;
                
                UITapGestureRecognizer *singleTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectGoldPay:)];
                [selectView addGestureRecognizer:singleTap];//---添加点击事件
                
                UIButton *setDefaultBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 5, 20, 20)];
                [selectView addSubview:setDefaultBtn];
                setDefaultBtn.layer.cornerRadius = 2;
                setDefaultBtn.layer.borderColor = [UIColor grayColor].CGColor;
                [setDefaultBtn.layer setBorderWidth:0.6];
                setDefaultBtn.enabled = NO;
                setDefaultBtn.backgroundColor = [UIColor clearColor];
                [setDefaultBtn setImage:img forState:UIControlStateDisabled];
                //文字
                UILabel *nameLb = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, 120, 30)];
                [selectView addSubview:nameLb];
                nameLb.backgroundColor = [UIColor clearColor];
                nameLb.font = TEXTFONT;
                nameLb.text = str;
            }
        }else{
            goldInfoLb.frame = CGRectMake(10, 40, 300, 20);
            goldInfoLb.textAlignment = NSTextAlignmentCenter;
            goldInfoLb.text = @"当前账户没有金萝卜";
            if (totalPrice <0.01) {
                totalPrice = 0.01;
            }
        }
    }else{
        goldInfoLb.frame = CGRectMake(10, 40, 300, 20);
        goldInfoLb.textAlignment = NSTextAlignmentCenter;
        goldInfoLb.text = @"本订单您不可以使用金萝卜抵扣";
        if (totalPrice <0.01) {
            totalPrice = 0.01;
        }
    }
    //-----上边线
    UILabel *_borderLine1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, MAINSCREEN_WIDTH, 1)];
    _borderLine1.backgroundColor = BORDERCOLOR;
    [goldView addSubview:_borderLine1];
    
    //-----下边线
    UILabel *_borderLine2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 79, MAINSCREEN_WIDTH, 1)];
    _borderLine2.backgroundColor = BORDERCOLOR;
    [goldView addSubview:_borderLine2];
    
    //-------优惠券使用------------
    UIView *goldView_ = [[UIView alloc] initWithFrame:CGRectMake(0, heightDistance+payView.frame.size.height+goldView.frame.size.height+50, MAINSCREEN_WIDTH, 80)];
    goldView_.tag = COUPONVIEWTAG;
    [woodsListView addSubview:goldView_];
    goldView_.backgroundColor = [UIColor whiteColor];
    
    UILabel *goldTitleLb_ = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 290, 20)];
    [goldView_ addSubview:goldTitleLb_];
    goldTitleLb_.textColor = [UIColor grayColor];
    goldTitleLb_.text = @"优惠券抵扣:";
    //-----上边线
    UILabel *_borderLine_ = [[UILabel alloc] initWithFrame:CGRectMake(10, 24.3, 300, 0.7)];
    _borderLine_.backgroundColor = BORDERCOLOR;
    [goldView_ addSubview:_borderLine_];
    //-----金萝卜----
    UILabel *goldInfoLb_ = [[UILabel alloc] initWithFrame:CGRectMake(10, 25, 300, 20)];
    [goldView_ addSubview:goldInfoLb_];
    goldInfoLb_.font = TEXTFONT;
    
    goldInfoLb_.frame = CGRectMake(10, 40, 300, 20);
    goldInfoLb_.textAlignment = NSTextAlignmentCenter;
    goldInfoLb_.text = @"没有可以使用的优惠券";
    goldInfoLb_.tag = COUPONSUBVIEWTAG;
    
    //-----上边线
    UILabel *_borderLine1_ = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, MAINSCREEN_WIDTH, 1)];
    _borderLine1_.backgroundColor = BORDERCOLOR;
    [goldView_ addSubview:_borderLine1_];
    
    //-----下边线
    UILabel *_borderLine2_ = [[UILabel alloc] initWithFrame:CGRectMake(0, 79, MAINSCREEN_WIDTH, 1)];
    _borderLine2_.backgroundColor = BORDERCOLOR;
    _borderLine2_.tag = COUPONSUBVIEWTAG_;
    [goldView_ addSubview:_borderLine2_];
    
    
    
    //---------删除第一个逗号------
    guidStr = [guidStr substringFromIndex:1];
    [Waiting show];//
    //---------读取   买几赠几    --------,在这里顺便计算  邮费------
    NSDictionary * params = @{@"apiid": @"0083",@"pguid" : guidStr};
    NSURLRequest * request = [[AFOSCClient sharedClient] requestWithMethod:@"POST"
                                                                      path:@""
                                                                parameters:params];
    AFHTTPRequestOperation * operation = [[AFOSCClient sharedClient] HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [Waiting dismiss];//隐藏loading
        NSString *jsonData = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        //删除末尾  ,
        if ([jsonData hasSuffix:@","]) {
            jsonData = [jsonData substringToIndex:jsonData.length-1];
        }
        NSMutableArray* tempDonate = [[jsonData componentsSeparatedByString:@","] mutableCopy];//数组
        //[tempDonate replaceObjectAtIndex:0 withObject:@"2"];
        //NSLog(@"qqkhotrpkpojytpj----%@---%@",jsonData,tempDonate);
        int tempCount = (int)tempDonate.count;
        //NSArray *guidArr = [guidStr componentsSeparatedByString:@","];
        if(tempCount>0){
            int donateTotal = 0;
            int i = 0;
            for (NSDictionary *tempDic in woodsArrToPay) {
                UILabel *countLb = donateNumArr[i];
                int donate = 0;
                int donateM = [tempDonate[i] intValue];
                if (donateM==0) {
                    donate = 0;
                    countLb.text = @"0";
                }else{
                    int payCount = [[tempDic objectForKey:@"count"] intValue];
                    donate = payCount/donateM;
                    countLb.text = [NSString stringWithFormat:@"%d",donate];
                    donateTotal += donate;
                    
                    UILabel *bottomV = (UILabel *)[[[[countLb superview] superview] superview] viewWithTag:6000];
                    NSRange range = [bottomV.text rangeOfString:@"件商品  合计: ¥ "];
                    NSString *sourceStr = [bottomV.text substringFromIndex:1];
                    int oldCount = [[sourceStr substringToIndex:range.location-1] intValue] + donate;
                    NSString *oldPrice = [sourceStr substringFromIndex:(range.location+range.length-1)];
                    
                    bottomV.text = [NSString stringWithFormat:@"共%d件商品  合计: ¥ %@",oldCount,oldPrice];
                    
                }
                /*
                 此处购买数量和下单总数量是两个概念
                 总数量包括赠送数量,是不需要支付的
                 */
                self.giveNumber = donate;
                int itemTotalCount = [[tempDic objectForKey:@"count"] intValue]+donate;
                
                /*catShop----字符串说明,每条数据以;,分割字段名,一条数据和另一条数据之间以;:分割
                 祛痛神;,/ImgUpload/201311231321313.jpg;,2;,1781.00;,酒仙商店;,18926113931;,2;:
                 商铺名称,商品显示的图片,商品的oId,商品的价格,店铺的名称,店铺的id(手机号),购买的数量
                 */
                //实际数量,包括赠送,sring类型
                NSString *itemShopId = [tempDic objectForKey:@"shopId"];
                if (!itemShopId) {
                    itemShopId = @"chunkang";
                }
                //giveNum赠送数量
                NSString *itemTotalCountStr = [NSString stringWithFormat:@"%d",itemTotalCount];
                NSString *isGiveCountStr = [NSString stringWithFormat:@"%d",donate];
                NSDictionary *productItem = [NSDictionary dictionaryWithObjectsAndKeys:[tempDic objectForKey:@"Guid"],@"productID",[tempDic objectForKey:@"name"],@"name",[tempDic objectForKey:@"price"],@"price",itemTotalCountStr,@"num",isGiveCountStr,@"giveNum",itemShopId,@"shopID",[tempDic objectForKey:@"arriveTime"],@"arriveTime",[tempDic objectForKey:@"leaveTime"],@"leaveTime", nil];
                if (isFromDirectlyPay&&woodsArrToPay.count==1) {
                    NSMutableDictionary *woodToPay = [woodsArrToPay[0] mutableCopy];
                    [woodToPay setObject:itemTotalCountStr forKey:@"count"];
                    [woodToPay setObject:isGiveCountStr forKey:@"giveNum"];
                    [woodsArrToPay replaceObjectAtIndex:0 withObject:woodToPay];
                }
                
                [productInfo addObject:productItem];
                
                //有SupplierLoginID,供应商商品,但是不能是 SPRINGSUPPLIERID(温泉客房)
                NSString *SupplierLoginID = [tempDic objectForKey:@"SupplierLoginID"];
                if ([SupplierLoginID length]>0&&![SupplierLoginID isEqualToString:SPRINGSUPPLIERID]) {
                    for (NSMutableDictionary *shipWoodItem in woodShipParamsArr) {
                        if ([SupplierLoginID isEqualToString:[shipWoodItem objectForKey:@"supplierId"]]) {
                            [shipWoodItem setObject:itemTotalCountStr forKey:@"buynumberList"];
                            break;
                        }
                    }
                }
                NSString *woodItemStr = [NSString stringWithFormat:@"%@%@",[tempDic objectForKey:@"name"],itemTotalCountStr];
                
                NSString *itemStr = [NSString stringWithFormat:@"%@;",woodItemStr];
                productInfoStr = [itemStr stringByAppendingString:productInfoStr];
                i++;
            }
            //发送的订单数据
            productInfoStr = [productInfoStr substringToIndex:productInfoStr.length - 1];
            
            if (donateTotal>0) {
                //                int total = [countTextLb.text intValue] + donateTotal;
                //                countTextLb.text = [NSString stringWithFormat:@"%d",total];
            }
            //判断是否读取了  收货信息,有了收货信息才可以计算邮费
            if (isAddAddress) {
                [self calculateShipPay];//-------计算
            }
        }else{
            [Waiting dismiss];
            [self.view makeToast:@"系统错误:0083,请稍后重试" duration:2.0 position:@"center"];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [Waiting dismiss];//隐藏loading
        [self.view makeToast:@"网络错误,或系统错误" duration:2.0 position:@"center"];
    }];
    [operation start];
    
    /*
     重新设定地址
     */
    if (isAllSpringGoods) {
        adrLb.text = @"注意:此商品请直接到店消费";
        adrLb.textColor = [UIColor redColor];
    }
}
//-------优惠券抵扣-----
-(void)drawCouponView{
    
    
    UIView *woodsListView = [contentView viewWithTag:WOODSLISTVIEWTAG];
    UIView *couponView = [woodsListView viewWithTag:COUPONVIEWTAG];
    NSInteger itemCount = shopTicketsArr.count;
    if (itemCount>0) {
        //删除不用的view------重新绘制
        [[couponView viewWithTag:COUPONSUBVIEWTAG] removeFromSuperview];
        [[couponView viewWithTag:COUPONSUBVIEWTAG_] removeFromSuperview];
        NSInteger ticketsItemCount = 0;
        NSInteger itemHeight = 30;
        NSInteger gapTitleHeight = 40;
        for (NSInteger i = 0;i<itemCount;i++) {
            NSDictionary *shopDic = shopTicketsArr[i];
            NSArray *ticketesArr = [shopDic objectForKey:@"ticketList"] ;
            NSInteger j = 0;
            for (NSDictionary *ticketItem in ticketesArr) {
                //-----每一个
                /////////-----------
                UIView *selectView = [[UIView alloc] initWithFrame:CGRectMake(10, gapTitleHeight+ticketsItemCount*itemHeight, 280, itemHeight)];
                [couponView addSubview:selectView];
                selectView.tag = 100*i+j;//i是店铺的下标--------j是店铺里优惠券的下标
                selectView.userInteractionEnabled = YES;
                ticketsItemCount++;
                
                UITapGestureRecognizer *singleTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectCouponPay:)];
                [selectView addGestureRecognizer:singleTap];//---添加点击事件
                //----------
                UIButton *setDefaultBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 5, 20, 20)];
                [selectView addSubview:setDefaultBtn];
                setDefaultBtn.enabled = NO;
                setDefaultBtn.tag = 1001;
                setDefaultBtn.layer.cornerRadius = 2;
                setDefaultBtn.layer.borderColor = [UIColor grayColor].CGColor;
                [setDefaultBtn.layer setBorderWidth:0.6];
                setDefaultBtn.backgroundColor = [UIColor clearColor];
                [setDefaultBtn setImage:nil forState:UIControlStateDisabled];
                
                
                
                //文字
                UILabel *nameLb = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, 240, 30)];
                [selectView addSubview:nameLb];
                nameLb.backgroundColor = [UIColor clearColor];
                nameLb.font = TEXTFONT;
                nameLb.text = [NSString stringWithFormat:@"%@元代金券",[ticketItem objectForKey:@"ticketMoney"]];
            }
        }
        
    }
}
//-----是否使用金萝卜抵扣
-(void)selectCouponPay:(id)sender{
    UIView *selectView = [sender view];
    NSInteger tag = [selectView tag];
    NSInteger shopIndex = tag/100;
    NSInteger ticketesIndex = tag%100;
    NSLog(@"opregjekpfsbjg-----");
    UIButton *otherBtn = (UIButton *)[selectView viewWithTag:1001];
    
    NSDictionary *shopDic = shopTicketsArr[shopIndex];
    NSArray *ticketesArr = [shopDic objectForKey:@"ticketList"] ;
    NSDictionary *ticketDic = ticketesArr[ticketesIndex];
    NSDecimalNumber *ticketMoney = [NSDecimalNumber decimalNumberWithString:[ticketDic objectForKey:@"ticketMoney"]];
    
    if([otherBtn.accessibilityIdentifier isEqualToString:@"checked"]){
        //---目前是选取的,,,,,点击----处理成取消选择
        otherBtn.accessibilityIdentifier = nil;
        [otherBtn setImage:nil forState:UIControlStateDisabled];
        [selectedTicketsArr removeObject:[ticketDic objectForKey:@"ticketNumber"]];
    }else{
        [selectedTicketsArr addObject:[ticketDic objectForKey:@"ticketNumber"]];
        //-----ticketMoney-----变成负值-------
        ticketMoney = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"-%@",[ticketDic objectForKey:@"ticketMoney"]]];
        //选择  不  抵扣
        otherBtn.accessibilityIdentifier = @"checked";
        [otherBtn setImage:[UIImage imageNamed:@"selected"] forState:UIControlStateDisabled];
    }
    couponPay = [couponPay decimalNumberByAdding:ticketMoney];
    //-----计算总价----
    [self calculateTotalShouldPay];
}

/*
 //-----选择框-----
 -(void)selectCouponPay:(UIButton *)btn{
 if (btn.selected) {
 NSLog(@"jgjiogre----1");
 [btn setSelected:NO];
 }else{
 NSLog(@"jgjiogre----2");
 [btn setSelected:YES];
 }
 NSLog(@"jgoejgoie-kopkoppkp----%d--%d---%d",btn.selected,btn.state,UIControlStateNormal);
 
 }
 */
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
/*
 -(void)onClickBack{
 }
 */
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
        
        NSMutableDictionary *woodDic = [woodsArrToPay[0] mutableCopy];//可以改变的副本
        
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
            NSString *guid = [woodDic objectForKey:@"Guid"];
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
        [woodsArrToPay replaceObjectAtIndex:0 withObject:woodDic];
        NSString *arriveTime=@"",*leaveTime=@"";
        if ([woodDic objectForKey:@"arriveTime"]) {
            arriveTime = [woodDic objectForKey:@"arriveTime"];
        }
        if ([woodDic objectForKey:@"leaveTime"]) {
            leaveTime = [woodDic objectForKey:@"leaveTime"];
        }
        if ([leaveTime isMemberOfClass:[NSNull class]] || leaveTime == nil) {
            leaveTime = @"";
        }
        NSDictionary *productItem = [NSDictionary dictionaryWithObjectsAndKeys:[woodDic objectForKey:@"Guid"],@"productID",[woodDic objectForKey:@"name"],@"name",[woodDic objectForKey:@"price"],@"price",[woodDic objectForKey:@"count"],@"num",[woodDic objectForKey:@"shopId"],@"shopID",arriveTime,@"arriveTime",leaveTime,@"leaveTime", nil];
        if(productInfo.count > 1){
            [productInfo removeObjectAtIndex:currentDateLb.tag];
            [productInfo insertObject:productItem atIndex:currentDateLb.tag];
        }else if(productInfo.count==1){
            [productInfo replaceObjectAtIndex:0 withObject:productItem];
        }else{
            [productInfo addObject:productItem];
        }
        
        NSString *guid = [woodDic objectForKey:@"Guid"];
        guid = [Tools deleStringWithGuid:guid];
        NSString *shopId = [woodDic objectForKey:@"shopId"];
        
        NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:@"0229",@"apiid",guid,@"productGuid",@"",@"imei",@"",@"mac",[Tools getDeviceUUid],@"deviceid",shopId,@"shopid",arriveTime,@"arriveTime", leaveTime,@"leaveTime",nil];
        if ([Tools isSpringHotelWithGuid:guid]) {
            if (arriveTime.length >= 10 && leaveTime.length >= 10) {
                [self updatePriceWithDict:dict currentLabel:currentDateLb];
            }
        }
        else{
            if (arriveTime.length >= 10) {
                [self updatePriceWithDict:dict currentLabel:currentDateLb];
            }
        }
    }
    [[datePickerView superview] setHidden:YES];
    CGRect frame = CGRectMake(0, WINDOWHEIGHT, MAINSCREEN_WIDTH, 250);
    datePickerView.frame = frame;
}

//更新价格
-(void)updatePriceWithDict:(NSDictionary *)param currentLabel:(UILabel *)label
{
    [self showHudInView:self.view hint:@"价格更新中..."];
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
        [self changePriceWithPrice:ShopPrice];
        
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
- (void)changePriceWithPrice:(NSString *)ShopPrice
{
    NSDictionary *dic = [woodsArrToPay objectAtIndex:currentDateLb.tag];
    NSMutableDictionary *mydic = [[NSMutableDictionary alloc] initWithDictionary:dic];
    [mydic setObject:ShopPrice forKey:@"price"];
    [woodsArrToPay removeObjectAtIndex:currentDateLb.tag];
    [woodsArrToPay insertObject:mydic atIndex:currentDateLb.tag];
    
    dic = [productInfo objectAtIndex:currentDateLb.tag];
    mydic = [[NSMutableDictionary alloc] initWithDictionary:dic];
    [mydic setObject:ShopPrice forKey:@"price"];
    [productInfo removeObjectAtIndex:currentDateLb.tag];
    [productInfo insertObject:mydic atIndex:currentDateLb.tag];
    
    NSInteger count = [woodsArrToPay count];
    
    CGFloat totalPrice = 0;
    
    for (int i = 0; i < [woodsArrToPay count] ; i++) {
        NSDictionary *dict = [woodsArrToPay objectAtIndex:i];
        int count = [[dict objectForKey:@"count"] intValue];
        CGFloat price = [[dict objectForKey:@"price"] floatValue];
        totalPrice = totalPrice + price * count;
        
    }
    
    
    [defaults setObject:woodsArrToPay forKey:PAYOFFWOODSARR];
    woodsArrByShop = [woodsArrToPay convertToDic:@"shopId"];
    
    CGFloat singlePrice = [ShopPrice floatValue];
    
    NSString *viewKey = [NSString stringWithFormat:@"singlePriceView%ld",(long)currentDateLb.tag];
    
    UILabel *totalPriceView = [subViewDict objectForKey:@"totalPriceView"];
    totalPriceView.text = [NSString stringWithFormat:@"共%ld件商品 合计:¥ %.2f",(long)count,totalPrice];
    
    UILabel *singlePriceView = [subViewDict objectForKey:viewKey];
    singlePriceView.text = [NSString stringWithFormat:@"¥ %.2f",singlePrice];
    
    UILabel *shouldPayPriceView = [subViewDict objectForKey:@"shouldPayPriceView"];
    shouldPayPriceView.text = [NSString stringWithFormat:@"合计:¥ %.2f",totalPrice];
}

//显示时间选择
-(void)showDatePicker:(id)sender{
    NSDate *currentDate = [[NSDate alloc] init];
    UIDatePicker *dpicker = (UIDatePicker *)[datePickerView viewWithTag:8888];
    
    currentDateLb = (UILabel *)[sender view];
    currentDateLb.tag = [[sender view] tag];//cell的tag
    
    NSMutableDictionary *woodDic = [woodsArrToPay[0] mutableCopy];//可以改变的副本
    
    NSString *Guid = [woodDic objectForKey:@"Guid"];
    if ([Guid isMemberOfClass:[NSNull class]] || Guid == nil) {
        Guid = @"";
    }
    
    NSString *idStr = currentDateLb.accessibilityIdentifier;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    if ([idStr isEqualToString:@"arriveTime"]) {
        //选择到达时间
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
            //            这里要判断是否有leaveTime,如果有的话设置最大值
        }
    }else if ([idStr isEqualToString:@"leaveTime"]){
        //如果到达时间还没有填写,那么这里的转换为 null,minimumDate设置无效,
        if (![currentDateLb.text isEqualToString:@"点击选择时间"] && ![currentDateLb.text isEqualToString:@"点击选择离开时间"]) {
            lastSelectDataString = [NSString stringWithFormat:@"leaveTime:%@",currentDateLb.text];
            
            NSString *selectDateString = [lastSelectDataString substringFromIndex:[@"leaveTime:" length]];
            NSDate *nowSelectDate = [dateFormatter dateFromString:selectDateString];
            dpicker.date = nowSelectDate;
            
        }
        if ([arriveTimeValueLb.text isEqualToString:@"点击选择时间"] || [arriveTimeValueLb.text isEqualToString:@"点击选择抵达时间"]) {
            [self showHint:@"请选择预计抵达时间"];
            return;
        }
        NSString *arrivestring = arriveTimeValueLb.text;
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
        CGRect frame = CGRectMake(0, WINDOWHEIGHT- 250, MAINSCREEN_WIDTH, 250);
        datePickerView.frame = frame;
    }];
    
    NSLog(@"weqerrjorjapokaopgjihjioy----%@",datePickerView);
}

//改变数字,加减按钮,
-(void)changeWoodCount:(UIButton*)sender{
    NSLog(@"kgpogkorpeitn------");
    if (isFromDirectlyPay&&woodsArrToPay.count==1) {
        NSString *flag = sender.accessibilityIdentifier;
        NSInteger index = [sender tag]/10000 ;
        NSInteger i = [sender tag] - index*10000;
        NSMutableDictionary *currentDic = [woodsArrByShop objectAtIndex:index-1];
        NSMutableArray *itemArr = [currentDic objectForKey:@"woodsArr"];//可以改变的
        NSMutableDictionary *woodDic = itemArr[i];//可以改变的副本
        NSLog(@"fjeiojgiojgithiojtioh---%ld--%ld--%@--%@--%@",(long)index,(long)i,woodDic,flag,woodsArrByShop);
        
        UILabel *countLb = (UILabel *)[[sender superview] viewWithTag:2000];
        int currentCount = [[woodDic objectForKey:@"count"] intValue];
        double changePrice = [[woodDic objectForKey:@"price"] doubleValue];
        int changeCount = 1;
        if ([flag isEqualToString:@"a"]) {
            currentCount +=1;
        }else{
            currentCount -=1;
            //变化量
            changeCount = -changeCount;
            changePrice = -changePrice;
        }
        
        NSLog(@"fjejgiorjeiogt---%d--%f----",currentCount,changePrice);
        
        if (currentCount>0) {
            countLb.text = [NSString stringWithFormat:@"%d",currentCount];
            
        }else{
            [self.view makeToast:@"商品数量至少是1" duration:1.2 position:@"center"];
        }
    }
    
}
//-----计算应支付总价-----
//--每次的金萝卜,优惠券勾选都要调用--
-(void)calculateTotalShouldPay{
    BOOL tmpNowPayBtnEnable = payBtn.enabled;//-----保存当前值
    [self setPayBtnUnEnadled];
    [Waiting show];
    NSDecimalNumber *realOrderPay = [netPay decimalNumberByAdding:shipPay];
    //-----优惠券的----
    realOrderPay = [realOrderPay decimalNumberByAdding:couponPay];
    //-----金萝卜-----这里是减减减减减减减减减减减减
    if (isGoldCarrotPay) {
        realOrderPay = [realOrderPay decimalNumberBySubtracting:realGoldPay];
    }
    
    if ([realOrderPay doubleValue]<0.01) {
        realOrderPay = [NSDecimalNumber decimalNumberWithString:@"0.01"];
    }
    shouldPayTextLb.text = [NSString stringWithFormat:@"%@%0.2f",TOTALPAYPREFIX,[realOrderPay doubleValue]];
    payBtn.enabled = tmpNowPayBtnEnable;//---------恢复之前值
    if (tmpNowPayBtnEnable) {
        payBtn.backgroundColor = BUTTONCOLOR;
    }
    [Waiting dismiss];
}
//-----是否使用金萝卜抵扣
-(void)selectGoldPay:(id)sender{
    UIView *selectView = [sender view];
    int tag = (int)[selectView tag] - 100;
    NSLog(@"opregjekpfsbjg-----");
    if (tag==1&&isGoldCarrotPay) {
        //选择  不  抵扣
        isGoldCarrotPay = NO;
        UIButton *otherBtn = [[[[[selectView superview] subviews] firstObject] subviews] firstObject];
        [otherBtn setImage:nil forState:UIControlStateDisabled];
        //被点击按钮
        UIButton *selfBtn = [[selectView subviews] firstObject];
        [selfBtn setImage:[UIImage imageNamed:@"selected"] forState:UIControlStateDisabled];
    }else if (tag==0&&!isGoldCarrotPay){
        //选择抵扣
        isGoldCarrotPay = YES;
        UIButton *clickBtn = [[[[[selectView superview] subviews] objectAtIndex:1] subviews] firstObject];
        [clickBtn setImage:nil forState:UIControlStateDisabled];
        //被点击按钮
        UIButton *selfBtn = [[selectView subviews] firstObject];
        [selfBtn setImage:[UIImage imageNamed:@"selected"] forState:UIControlStateDisabled];
    }
    
    
    //----重新计算总价-----
    [self calculateTotalShouldPay];
    
}
//----获取金萝卜,抵扣消费金额
-(BOOL)getGoldCarrotPay:(UILabel *)carrotPayLb scorePay:(NSDecimalNumber*)scorePayNumber{
    BOOL result = NO;
    if (memberId.length>0) {
        [Waiting show];
        
        NSURL *url = [NSURL URLWithString:APIURL];
        //第二步，创建请求
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
        [request setHTTPMethod:@"POST"];//设置请求方式为POST，默认为GET
        NSString *str = [NSString stringWithFormat:@"apiid=0085&&memberid=%@",memberId];
        NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
        [request setHTTPBody:data];
        
        NSError *error;
        //第三步，连接服务器
        NSData *received = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
        if (!error) {
            [Waiting dismiss];//隐藏loading
            NSString *score = [[NSString alloc] initWithData:received encoding:NSUTF8StringEncoding];
            if(score.length>0){
                NSDecimalNumber *scoreValue = [[NSDecimalNumber decimalNumberWithString:score] decimalNumberByDividingBy:[NSDecimalNumber decimalNumberWithString:@"100"]];
                if ([scoreValue compare:scorePayNumber] == NSOrderedAscending) {
                    realGoldPay = scoreValue;
                }else{
                    realGoldPay = scorePayNumber;
                }
                double realGoldPayD = [realGoldPay doubleValue];
                //-----账户有金萝卜可用
                if (realGoldPayD > 0) {
                    result = YES;
                    carrotPayLb.text = [NSString stringWithFormat:@"可用%@金萝卜抵扣金额: ¥ %0.2f",[realGoldPay decimalNumberByMultiplyingBy:[NSDecimalNumber decimalNumberWithString:@"100"]],realGoldPayD];
                    isGoldCarrotPay = YES;//-----是否金萝卜抵扣-----默认抵扣----
                    //-----这里初次计算,防止没有售后地址无法读取到邮费,总价也没计算扣除金萝卜的-----
                    [self calculateTotalShouldPay];
                }
            }else{
                [self.view makeToast:@"系统错误,请稍后重试:0085" duration:2.0 position:@"center"];
            }
        }else{
            [Waiting dismiss];//隐藏loading
            [self.view makeToast:@"请检查网络连接是否正常" duration:2.0 position:@"center"];
        }
    }else{
        [self.view makeToast:@"请登录才可以支付" duration:1.2 position:@"center"];
    }
    return result;
}

-(void)ResetPayButtonState:(id)clickView{
    
    UIView *selectView = [clickView view];
    UIButton *clickBtn;
    for (int i = 0; i < currentPayWays; i++) {
        clickBtn = [[[[[selectView superview] subviews] objectAtIndex:i] subviews] firstObject];
        [clickBtn setImage:nil forState:UIControlStateDisabled];
    }
    
    //被点击按钮
    UIButton *selfBtn = [[selectView subviews] firstObject];
    [selfBtn setImage:[UIImage imageNamed:@"selected"] forState:UIControlStateDisabled];
    
}

//-----支付方式选择
-(void)selectPayType:(id)sender{
    UIView *selectView = [sender view];
    int tag = (int)[selectView tag] - 100;
    if (tag==0 && payOffType!=DANERTUPAY) {
        //单耳兔
        payOffType = DANERTUPAY;
        [self ResetPayButtonState:sender];
    }else if (tag==1&&payOffType!=ALIPAY) {
        //支付宝
        payOffType = ALIPAY;
        [self ResetPayButtonState:sender];
    }else if (tag== 2&& payOffType != CASHPAY){
        //选择货到付款
        payOffType = CASHPAY;
        [self ResetPayButtonState:sender];
    }else if (tag==3 && payOffType != UNIONPAY){
        
    }else if (tag==2&&payOffType!=DAOFU){
        //到付----
        payOffType = DAOFU;
    }else if (tag==3 && payOffType!=WEBCHATPAY){
        [self.view makeToast:@"微信支付暂未开通,请使用其他支付方式" duration:1.2 position:@"center"];
        /*
         //选择  微信
         payOffType = WEBCHATPAY;
         UIButton *clickBtn = [[[[[selectView superview] subviews] firstObject] subviews] firstObject];
         [clickBtn setImage:nil forState:UIControlStateDisabled];
         UIButton *clickBtn_ = [[[[[selectView superview] subviews] objectAtIndex:2] subviews] firstObject];
         [clickBtn_ setImage:nil forState:UIControlStateDisabled];
         //被点击按钮
         UIButton *selfBtn = [[selectView subviews] firstObject];
         [selfBtn setImage:[UIImage imageNamed:@"selected"] forState:UIControlStateDisabled];
         */
    }else if (tag==4&&payOffType!=UNIONPAY){
        
        //选择  银联
        payOffType = UNIONPAY;
        
        [self ResetPayButtonState:sender];
        //        UIButton *otherBtn = [[[[[selectView superview] subviews] firstObject] subviews] firstObject];
        //        [otherBtn setImage:nil forState:UIControlStateDisabled];
        //        UIButton *clickBtn_ = [[[[[selectView superview] subviews] objectAtIndex:1] subviews] firstObject];
        //        [clickBtn_ setImage:nil forState:UIControlStateDisabled];
        //        //被点击按钮
        //        UIButton *selfBtn = [[selectView subviews] firstObject];
        //        [selfBtn setImage:[UIImage imageNamed:@"selected"] forState:UIControlStateDisabled];
    }
}
//-----点击添加收货地址---
-(void)onClickAddPlace{
    //更换默认地址
    if (canGoAddressView) {
        if (isAddAddress) {
            AddressListController *alist = [[AddressListController alloc]init];
            alist.hidesBottomBarWhenPushed = YES;
            alist.isFromOrderForm = YES;
            alist.prevAddressGuid = userNameLb.accessibilityIdentifier;
            [self.navigationController pushViewController:alist animated:YES];
        }else{
            //没有地址,弹出提示
            AddressNewController *alist = [[AddressNewController alloc]init];
            alist.hidesBottomBarWhenPushed = YES;
            alist.isFromOrderForm = YES;
            [self.navigationController pushViewController:alist animated:YES];
        }
    }
}
//----代金券---------
-(void)calculateCouponPay:(NSString *)shopId{
    [Waiting show];
    NSDictionary * params = @{@"apiid": @"0202",@"memberid":memberId,@"shopid" : shopId};
    NSURLRequest * request = [[AFOSCClient sharedClient] requestWithMethod:@"POST"
                                                                      path:@""
                                                                parameters:params];
    AFHTTPRequestOperation * operation = [[AFOSCClient sharedClient] HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [Waiting dismiss];//隐藏loadin
        NSString *score = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        if (score.length > 0) {
            NSError *error;
            NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:&error];
            if (!error) {
                [shopTicketsArr addObject:resultDic];
            }else{
                [self.view makeToast:@"数据解析错误0202" duration:1.2 position:@"center"];
            }
            //-----加载完毕----
            if (shopTicketsArr.count>=woodsArrByShop.count) {
                [self drawCouponView];
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //-----加载完毕----
        if (shopTicketsArr.count>=woodsArrByShop.count) {
            [self drawCouponView];
        }
        [Waiting dismiss];//隐藏loading
        [self.view makeToast:@"请检查网络连接是否正常202" duration:2.0 position:@"center"];
    }];
    [operation start];
}

- (void)onClickCreateOrder
{
    //-----首特产品是否可以购买------
    if (canSpecialBuySubmit) {
        if ([arriveTimeValueLb.text isEqualToString:TIMEPREFIX]) {
            [self.view makeToast:@"请选择预计抵达时间" duration:1.2 position:@"center"];
        }
        else if ([leaveTimeValueLb.text isEqualToString:TIMEPREFIX]){
            [self.view makeToast:@"请选择预计离开时间" duration:1.2 position:@"center"];
        }
        else{
            if (orderInfoDic) {
                return;
            }
            [self showHudInView:self.view hint:@"正在为您下单..."];
            [self performSelector:@selector(createOrder) withObject:nil afterDelay:0.1];
            
        }
    }
}

//只有全部是自营店不能支付的  商品这里下单,否则跳转
-(void)createOrder{
    CGFloat totalPrice = 0;
    for (int i = 0; i < [woodsArrToPay count] ; i++) {
        NSDictionary *dict = [woodsArrToPay objectAtIndex:i];
        int count = [[dict objectForKey:@"count"] intValue];
        CGFloat price = [[dict objectForKey:@"price"] floatValue];
        int giveNum = [[dict objectForKey:@"giveNum"] intValue];
        
        totalPrice = totalPrice + price * (count - giveNum);
        
    }
    totalPrice = totalPrice + [shipPay floatValue]; //记得加上邮费
    //减去金萝卜的钱
    if(isGoldCarrotPay && [realGoldPay floatValue]>0){
        totalPrice = totalPrice - [realGoldPay floatValue];
    }
    //优惠券
    totalPrice = totalPrice - [couponPay floatValue];
    NSString *realOrderPay = [NSString stringWithFormat:@"%.2f",totalPrice];
    
    //生成订单
    NSString *orderShopId = [[productInfo lastObject] objectForKey:@"shopID"];
    NSString *orderRemark = @"";
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *appVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSString *payWay = @"";
    if (payOffType == DANERTUPAY) {
        //单耳兔支付
        payWay = @"Danertupay";
    }else if (payOffType == ALIPAY) {
        //支付宝支付
        payWay = @"Alipay";
    }else if (payOffType == DAOFU) {
        payWay = @"ArrivedPay";
    }else if (payOffType == UNIONPAY) {
        //银联支付
        payWay = @"Unionpay";
    }else if (payOffType == CASHPAY){
        //货到付款
        payWay = @"ArrivedPay";
    }
    else{
        //确保必须选择某种的支付方式
        [self hideHud];
        [self showHint:@"请选择支付方式"];
        return;
    }
    
    NSMutableDictionary *tempDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:[addressInfo objectForKey:@"name"],@"name",[addressInfo objectForKey:@"adress"],@"address",realMobile,@"mobile",orderShopId,@"agentID",memberId,@"uid",realOrderPay, @"payMoney", @"", @"ivTitle", @"", @"ivContent", orderRemark, @"remark",shipPay,@"yunfei",appVersion,@"appVersion",@"ios",@"deviceType",payWay,@"mobilePayWay",nil];
    if (isAllSpringGoods) {
        [tempDic setObject:@"" forKey:@"address"];
    }
    NSArray *info = [NSArray arrayWithObjects:tempDic, nil];
    
    NSDictionary *dictionaryData = [NSDictionary dictionaryWithObjectsAndKeys:info,@"info",productInfo,@"productInfo", nil];
    
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictionaryData options:NSJSONWritingPrettyPrinted error:&error];
    if ([jsonData length] > 0 && error == nil){
        postJsonStr = [dictionaryData JSONString];
    }else{
        [self hideHud];
        [self showHint:@"数据有误"];
    }
    //检测库存
    __block BOOL isHaveStore = YES;
    if(isFromActivity&&[[activityWood objectForKey:@"activityName"] isEqualToString:ACTIVITY_ONEYUAN]){
        //------------来自活动----一元秒杀-----不判断库存,后台判断-----
        NSDictionary * params = @{@"apiid": @"0096",@"jsonstr" :postJsonStr,@"uid":memberId,@"pid":[activityWood objectForKey:@"Guid"]};
        NSURLRequest * request = [[AFOSCClient sharedClient] requestWithMethod:@"POST"
                                                                          path:@""
                                                                    parameters:params];
        AFHTTPRequestOperation * operation = [[AFOSCClient sharedClient] HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSError *error;
            NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:&error];
            if(!error&&[[jsonData objectForKey:@"result"] isEqualToString:@"true"]){
                
                NSString *tradeNO = [jsonData objectForKey:@"info"];
                /////////!!!!!!////////////////
                //                payBtn.enabled = NO;//----点了之后不可以再次点击-------
                //                payBtn.backgroundColor = VIEWBGCOLOR;
                [self setPayBtnUnEnadled];
                
                if(isGoldCarrotPay&&[realGoldPay floatValue]>0){
                    //扣除积分
                    [self reduceScore:memberId];
                }
                [self useTickets];//-----使用抵扣券-----
                NSDictionary *orderWoods = @{@"tradeNO":tradeNO,@"orderStatus":@"WAIT_BUYER_PAY",@"woodsArray":woodsArrToPay};
                NSMutableArray *orderWoodsArray = [[defaults objectForKey:@"NotPayedOrderWoodsArray"] mutableCopy];
                if (!orderWoodsArray) {
                    orderWoodsArray = [[NSMutableArray alloc] init];
                }
                [orderWoodsArray addObject:orderWoods];//-----添加待评论物品,
                [defaults setObject:orderWoodsArray forKey:@"NotPayedOrderWoodsArray"];
                [orderInfoDic setObject:tradeNO forKey:@"tradeNO"];
                //-------支付-----
                //////////////////
                [self onClickPay];
                //////////////////
                //-------支付-----
                NSArray *tempArray = [defaults objectForKey:@"NotPayedOrderList"];//订单--------本地存储
                NSMutableArray *tempArray1  = [[NSMutableArray alloc] init];
                if(tempArray){
                    tempArray1 = [tempArray mutableCopy];
                }
                NSMutableDictionary *orderItem = [NSMutableDictionary dictionaryWithDictionary:orderInfoDic];
                [orderItem removeObjectForKey:@"body"];//-----删除body字段,body和subject字段重复
                //订单状态WAIT_BUYER_PAY,TRADE_FINISHED
                [orderItem setObject:@"WAIT_BUYER_PAY" forKey:@"orderStatus"];
                [tempArray1 addObject:orderItem];//ClienWoodsArray没值 或 数组中不存在oId,//添加  新的
                NSArray *tempArray2 = [tempArray1  mutableCopy];
                [defaults setObject:tempArray2 forKey:@"NotPayedOrderList"];
                NSDictionary *orderType = [NSDictionary dictionaryWithObjectsAndKeys:@"notPayed",@"orderType",nil];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadOrderList" object:nil userInfo:orderType];//发送通知,重新加载未支付订单
                [self hideHud];
            }else if (error) {
                [self hideHud];
                [self showHint:@"数据有误"];
                
            }else{
                [self hideHud];
                NSString *errorInfo = [jsonData objectForKey:@"info"];
                if ([errorInfo isMemberOfClass:[NSNull class]] || [errorInfo isEqualToString:@""] || errorInfo == nil) {
                    errorInfo = REQUESTERRORTIP;
                }
                [self showHint:errorInfo];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [self hideHud];
            [self showHint:REQUESTERRORTIP];
        }];
        [operation start];
        orderInfoDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:productInfoStr,@"subject",productInfoStr ,@"body",realOrderPay,@"price", nil];
    }else{
        for (NSDictionary *wood in productInfo) {
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
            [request setHTTPBody:[[NSString stringWithFormat:@"apiid=0086&&proguid=%@&&daoDate=%@",[wood objectForKey:@"productID"],daoDateStr] dataUsingEncoding:NSUTF8StringEncoding]] ;
            
            NSURLResponse * response = nil;
            NSError * error = nil;
            NSData * data = [NSURLConnection sendSynchronousRequest:request
                                                  returningResponse:&response
                                                              error:&error];
            NSString *temp = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            if (error == nil)
            {
                [self hideHud];
                if ([temp intValue]<[[wood objectForKey:@"num"] intValue]) {
                    isHaveStore = NO;
                    [Waiting dismiss];
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:[NSString stringWithFormat:@"商品:%@,库存不足,仅剩:%@",[wood objectForKey:@"name"],temp] delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil];
                    [alert setTag:222];
                    [alert show];
                    break;
                }
            }else{
                [self hideHud];
                [self showHint:REQUESTERRORTIP];
            }
        }
        //-----如果有库存才去下单,否则不去下单-----
        if (isHaveStore) {
            //可以用金菠萝支付的商品,提交订单前,判断是否选中抵扣金萝卜
            if (!isGoldCarrotPay) {
                realGoldPay = [NSDecimalNumber decimalNumberWithString:@"0"];
            }
//            金萝卜抵扣(共0，可抵扣0.0元) 用：0金萝卜;代金券抵扣：" + money
//            NSString *orderRemark = [NSString stringWithFormat:@"运费:%@,金萝卜抵扣:%@,优惠券抵扣:%@",shipPay,realGoldPay,couponPay];
            CGFloat realPayMoney = [realGoldPay floatValue]; //金萝卜抵扣的价格
            NSInteger realGoldNum = realPayMoney * 100;
//            CGFloat couponPayMoney = [couponPay floatValue]; //代金券抵扣
            NSString *orderRemark = [NSString stringWithFormat:@"金萝卜抵扣(共%ld，可抵扣%.2f元) 用：%ld金萝卜;",(long)realGoldNum,realPayMoney,realGoldNum];
            NSDictionary * params = @{@"apiid": @"0097",@"jsonstr" :postJsonStr,@"remark":orderRemark,@"imei":@"",@"mac":@"",@"deviceid":[Tools getDeviceUUid]};
            NSURLRequest * request = [[AFOSCClient sharedClient] requestWithMethod:@"POST"
                                                                              path:@""
                                                                        parameters:params];
            AFHTTPRequestOperation * operation = [[AFOSCClient sharedClient] HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
                
                //----点了之后不可以再次点击
                [self setPayBtnUnEnadled];
                
                NSError *error;
                NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:&error];
                if(!error&&[[jsonData objectForKey:@"result"] isEqualToString:@"true"]){
                    
                    NSString *tradeNO = [jsonData objectForKey:@"info"];
                    if(isGoldCarrotPay && [realGoldPay floatValue] > 0){
                        //扣除积分
                        [self reduceScore:memberId];
                    }
                    [self useTickets];//-----使用抵扣券-----
                    //-----减去库存----
                    [self reduceStore];
                    NSDictionary *orderWoods = @{@"tradeNO":tradeNO,@"orderStatus":@"WAIT_BUYER_PAY",@"woodsArray":woodsArrToPay};
                    NSMutableArray *orderWoodsArray = [[defaults objectForKey:@"NotPayedOrderWoodsArray"] mutableCopy];
                    if (!orderWoodsArray) {
                        orderWoodsArray = [[NSMutableArray alloc] init];
                    }
                    [orderWoodsArray addObject:orderWoods];//-----添加待评论物品,
                    [defaults setObject:orderWoodsArray forKey:@"NotPayedOrderWoodsArray"];
                    
                    [orderInfoDic setObject:tradeNO forKey:@"tradeNO"];
                    //-------支付-----
                    //////////////////
                    [self onClickPay];
                    //////////////////
                    //-------支付-----
                    NSArray *tempArray = [defaults objectForKey:@"NotPayedOrderList"];//订单--------本地存储
                    NSMutableArray *tempArray1  = [[NSMutableArray alloc] init];
                    if(tempArray){
                        tempArray1 = [tempArray mutableCopy];
                    }
                    NSMutableDictionary *orderItem = [NSMutableDictionary dictionaryWithDictionary:orderInfoDic];
                    [orderItem removeObjectForKey:@"body"];//-----删除body字段,body和subject字段重复
                    //订单状态WAIT_BUYER_PAY,TRADE_FINISHED
                    [orderItem setObject:@"WAIT_BUYER_PAY" forKey:@"orderStatus"];
                    [tempArray1 addObject:orderItem];//ClienWoodsArray没值 或 数组中不存在oId,//添加  新的
                    NSArray *tempArray2 = [tempArray1  mutableCopy];
                    [defaults setObject:tempArray2 forKey:@"NotPayedOrderList"];
                    NSDictionary *orderType = [NSDictionary dictionaryWithObjectsAndKeys:@"notPayed",@"orderType",nil];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadOrderList" object:nil userInfo:orderType];//发送通知,重新加载未支付订单
                    [self hideHud];
                }else if (error) {
                    [self hideHud];
                    [self showHint:@"数据有误"];
                }else{
                    [self hideHud];
                    NSString *errorStr = [jsonData objectForKey:@"info"];
                    if ([errorStr rangeOfString:@"最新版本"].length != 0) {
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:errorStr delegate:self cancelButtonTitle:@"下次再说" otherButtonTitles:@"马上更新", nil];
                        alert.tag = 100;
                        [alert show];
                        
                    }
                    else{
                        [self hideHud];
                        NSString *errorInfo = [jsonData objectForKey:@"info"];
                        if ([errorInfo isMemberOfClass:[NSNull class]] || [errorInfo isEqualToString:@""] || errorInfo == nil) {
                            errorInfo = REQUESTERRORTIP;
                        }
                        [self showHint:errorInfo];
                    }
                    
                }
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [self hideHud];
                [self showHint:@"网络错误,订单提交失败,请稍后重试"];
            }];
            [operation start];//----发起请求-------
            //这里是支付宝需要的数据-----
            orderInfoDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:productInfoStr,@"subject",productInfoStr ,@"body",realOrderPay,@"price", nil];
        }
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ( alertView.tag == 100) {
        if (buttonIndex == 1) {
            [self checkAppVersion];
        }
    }
    if (alertView.tag == 1001) {
        if (buttonIndex == 0) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

//检测版本更新
- (void)checkAppVersion
{
    [self showHudInView:self.view hint:@"正在检测更新..."];
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSDictionary *param = [[NSDictionary alloc] initWithObjectsAndKeys:@"0138",@"apiid",version,@"iosversion",UPDATEMARK,@"mark", nil];
    [[AFOSCClient sharedClient] postPath:nil parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject){
        [self hideHud];
        NSString *respondstring = operation.responseString;
        id respondObj = [respondstring objectFromJSONString];
        if (respondObj) {
            NSString *downloadUrl = [respondObj objectForKey:@"url"];
            if (downloadUrl == nil || [downloadUrl isEqualToString:@""]) {
                return;
            }
            if ([UPDATEMARK isEqualToString:@""]) {
                //如果是AppStore上面的版本，分享出去的是AppStore上的下载连接地址
                HeSingleModel *singleModel = [HeSingleModel shareHeSingleModel];
                singleModel.versionDict = respondObj;
                downloadUrl = [respondObj objectForKey:@"url"];
                if ([downloadUrl isMemberOfClass:[NSNull class]] || downloadUrl == nil || [downloadUrl isEqualToString:@""]) {
                    downloadUrl = SHAREURL;
                }
                
            }
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:downloadUrl]];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error){
        [self hideHud];
        [self showHint:REQUESTERRORTIP];
    }];
}

//使用代金券
-(void)useTickets{
    NSInteger ticketCount = selectedTicketsArr.count;
    if (ticketCount > 0) {
        for (NSString *number in selectedTicketsArr) {
            [Waiting show];
            NSString *strTmp = [NSString stringWithFormat:@"'%@'",number];
            NSDictionary * params = @{@"apiid": @"0208",@"memLoginID" : memberId,@"ticketNumber":strTmp};
            NSURLRequest * request = [[AFOSCClient sharedClient] requestWithMethod:@"POST"
                                                                              path:@""
                                                                        parameters:params];
            AFHTTPRequestOperation * operation = [[AFOSCClient sharedClient] HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
                [Waiting dismiss];//隐藏loadin
                NSString *score = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
                if(score.length > 0){
                    
                }else{
                    [self showHint:REQUESTERRORTIP];
                }
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [Waiting dismiss];//隐藏loading
                [self showHint:REQUESTERRORTIP];
            }];
            [operation start];
        }
    }
}
//----------扣除积分
-(void)reduceScore:(NSString *)userName{
    [Waiting show];
    int scoreNo = [[realGoldPay decimalNumberByMultiplyingBy:[NSDecimalNumber decimalNumberWithString:@"100"]] intValue];
    NSDictionary * params = @{@"apiid": @"0084",@"memberid" : userName,@"score":[NSString stringWithFormat:@"%d",scoreNo]};
    NSURLRequest * request = [[AFOSCClient sharedClient] requestWithMethod:@"POST"
                                                                      path:@""
                                                                parameters:params];
    AFHTTPRequestOperation * operation = [[AFOSCClient sharedClient] HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [Waiting dismiss];//隐藏loadin
        NSString *score = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        if(score.length > 0){
            
        }else{
            [self showHint:REQUESTERRORTIP];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [Waiting dismiss];//隐藏loading
        [self showHint:REQUESTERRORTIP];
    }];
    [operation start];
}
//-------
-(void)getPriceDataStr:(NSString *)guid price:(NSString *)price{
    [Waiting show];
    NSDictionary * params = @{@"apiid": @"0134",@"proguid" :guid};
    NSURLRequest * request = [[AFOSCClient sharedClient] requestWithMethod:@"POST"
                                                                      path:@""
                                                                parameters:params];
    AFHTTPRequestOperation * operation = [[AFOSCClient sharedClient] HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [Waiting dismiss];//隐藏loading
        NSString *score = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        if(score.length > 0){
            if (danertuPayPriceData.length==0) {
                danertuPayPriceData = [NSString stringWithFormat:@"%@,%@",score,price];
            }else{
                danertuPayPriceData = [NSString stringWithFormat:@"%@|%@,%@",danertuPayPriceData,score,price];
            }
            
        }else{
            [self showHint:REQUESTERRORTIP];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [Waiting dismiss];//隐藏loading
        [self showHint:REQUESTERRORTIP];
    }];
    [operation start];
}

//检测首特产品购买的合法性
-(void)checkSpecialBuy:(NSString *)proguid price:(NSString *)price{
    [Waiting show];
    //---根据guid,price判断------是首特-----再判断是否购买过------
    NSDictionary * params = @{@"apiid": @"0132",@"proguid" :proguid,@"price":price};
    NSURLRequest * request = [[AFOSCClient sharedClient] requestWithMethod:@"POST"
                                                                      path:@""
                                                                parameters:params];
    AFHTTPRequestOperation * operation = [[AFOSCClient sharedClient] HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [Waiting dismiss];//隐藏loading
        //        NSString *score = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        if([[resultDic objectForKey:@"result"] isEqualToString:@"true"]){
            //-----------
            NSDictionary * params = @{@"apiid": @"0134",@"proguid" :proguid};
            NSURLRequest * request = [[AFOSCClient sharedClient] requestWithMethod:@"POST"
                                                                              path:@""
                                                                        parameters:params];
            AFHTTPRequestOperation * operation = [[AFOSCClient sharedClient] HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
                [Waiting dismiss];//隐藏loading
                NSString *score = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
                
                if(score.length > 0){
                    [Waiting show];
                    NSDictionary * params = @{@"apiid": @"0133",@"proguid" : proguid ,@"memberid":score,@"imei":@"",@"mac":@"",@"deviceid":[Tools getDeviceUUid]};
                    NSURLRequest * request = [[AFOSCClient sharedClient] requestWithMethod:@"POST"
                                                                                      path:@""
                                                                                parameters:params];
                    AFHTTPRequestOperation * operation = [[AFOSCClient sharedClient] HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
                        [Waiting dismiss];//隐藏loadin
                        NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
                        if ([[resultDic objectForKey:@"result"] isEqualToString:@"true"]) {
                            canSpecialBuySubmit = YES;
                        }else{
                            canSpecialBuySubmit = NO;
                            [self.view makeToast:[resultDic objectForKey:@"info"] duration:2.0 position:@"center"];
                        }
                        NSLog(@"jgiojgorHGERGUIREjhohr------%@---%@",resultDic,params);
                    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                        [Waiting dismiss];//隐藏loading
                        NSLog(@"gjorejgioege-----%@",error);
                        [self.view makeToast:@"请检查网络连接是否正常" duration:2.0 position:@"center"];
                    }];
                    [operation start];
                }else{
                    [self.view makeToast:@"系统错误,请稍后重试:0133" duration:2.0 position:@"center"];
                }
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [Waiting dismiss];//隐藏loading
                [self.view makeToast:@"请检查网络连接是否正常" duration:2.0 position:@"center"];
            }];
            [operation start];
            
            //--------
        }
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [Waiting dismiss];//隐藏loading
        NSLog(@"gjorejgioege-----%@",error);
        [self.view makeToast:@"请检查网络连接是否正常" duration:2.0 position:@"center"];
    }];
    [operation start];
}
//----------减去库存
-(void)reduceStore{
    /*
     [Waiting show];
     if(isFromActivity&&![[activityWood objectForKey:@"activityName"] isEqualToString:ACTIVITY_ZEROONE]){
     NSDictionary * params = @{@"apiid": @"0087",@"proguid" : [activityWood objectForKey:@"Guid"] ,@"pcount":@"1"};
     NSURLRequest * request = [[AFOSCClient sharedClient] requestWithMethod:@"POST"
     path:@""
     parameters:params];
     AFHTTPRequestOperation * operation = [[AFOSCClient sharedClient] HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
     [Waiting dismiss];//隐藏loadin
     NSString *score = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
     if(score.length>0){
     NSLog(@"nbiergorejohtorihfjewifjweo---%@--%@",score,params);
     }else{
     [self.view makeToast:@"系统错误,请稍后重试:0087" duration:2.0 position:@"center"];
     }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
     [Waiting dismiss];//隐藏loading
     [self.view makeToast:@"请检查网络连接是否正常" duration:2.0 position:@"center"];
     }];
     [operation start];
     }else{
     for (NSDictionary *wood in productInfo) {
     NSDictionary * params = @{@"apiid": @"0087",@"proguid" : [wood objectForKey:@"productID"] ,@"pcount": [wood objectForKey:@"num"]};
     NSURLRequest * request = [[AFOSCClient sharedClient] requestWithMethod:@"POST"
     path:@""
     parameters:params];
     AFHTTPRequestOperation * operation = [[AFOSCClient sharedClient] HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
     [Waiting dismiss];//隐藏loadin
     NSString *score = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
     if(score.length>0){
     NSLog(@"nbiergorejohtorihjgoirejgioe---%@--%@",score,params);
     }else{
     [self.view makeToast:@"系统错误,请稍后重试:0087" duration:2.0 position:@"center"];
     }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
     [Waiting dismiss];//隐藏loading
     [self.view makeToast:@"请检查网络连接是否正常" duration:2.0 position:@"center"];
     }];
     [operation start];
     }
     }
     */
}
-(void)viewWillAppear:(BOOL)animated{
    canSpecialBuySubmit = YES;
    [[[[UIApplication sharedApplication] keyWindow] viewWithTag:1000] removeFromSuperview];
}

//------支付----
//根据选择的支付方式支付
-(void)onClickPay{
    isFinishPay = 2;
    if (payOffType==DANERTUPAY) {
        DanertupayPostInfo *payObj = [[DanertupayPostInfo alloc] init];
        [payObj doPayByDanertu:orderInfoDic priceData:danertuPayPriceData  parentV:self.view  canclable:YES resultBlock:^(BOOL isFinish){
            if (!isFinish) isFinishPay = 1;
            isShowAlert = YES;
            [self performSelector:@selector(generateOrderClearData) withObject:nil afterDelay:1.5f];
            [Waiting show];
        }];
    }else if (payOffType==ALIPAY) {
        //支付宝支付
        AlipayPostInfo *aliPayObj = [[AlipayPostInfo alloc]init];//初始化
        [aliPayObj doPayByAlipay:orderInfoDic resultBlock:^(BOOL isFinish){
            if (!isFinish) isFinishPay = 1;
            isShowAlert = YES;
            [self generateOrderClearData];
        }];
    }else if (payOffType==CASHPAY) {
        //到付
        isFinishPay = 1;
        isShowAlert = YES;
        [self generateOrderClearData];
    }else if (payOffType==WEBCHATPAY){
        //微信支付
        [self.view makeToast:@"微信支付暂未开通,请使用其他支付方式" duration:1.2 position:@"center"];
        //[self sendPay2];
    }else if (payOffType==UNIONPAY){
        //银联卡支付-------
        NSLog(@"unionPay--------%@",orderInfoDic);
        [Waiting show];
        //NSString *proname =
        NSString *price = [orderInfoDic objectForKey:@"price"];
        price = [NSString stringWithFormat:@"%d",(int)([[orderInfoDic objectForKey:@"price"] doubleValue] *100)];
        //如果是测试支付的话,金额改成1分
        if (isTestPayMoney) {
            price = @"1";
        }
        NSDictionary * params = @{@"apiid": @"0089",@"ordernumber" : [orderInfoDic objectForKey:@"tradeNO"],@"proname":[orderInfoDic objectForKey:@"body"],@"orderAmount":price};
        NSURLRequest * request = [[AFOSCClient sharedClient] requestWithMethod:@"POST"
                                                                          path:@""
                                                                    parameters:params];
        AFHTTPRequestOperation * operation = [[AFOSCClient sharedClient] HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [Waiting dismiss];//隐藏loadin
            NSString *score = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            if(score.length>0){
                [UPPayPlugin startPay:score mode:@"00" viewController:self delegate:self];
            }else{
                [self.view makeToast:@"系统错误,请稍后重试:0089" duration:2.0 position:@"center"];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"jtorijhirojoief---%@--%@",error,params);
            [Waiting dismiss];//隐藏loading
            [self.view makeToast:@"请检查网络连接是否正常" duration:2.0 position:@"center"];
        }];
        [operation start];
    }
}

//返回支付结果,,,,银联支付
- (void)UPPayPluginResult:(NSString *)result
{
    [self generateOrderClearData];//清空购物车数据-----
    NSString *orderNoToPay = [orderInfoDic objectForKey:@"tradeNO"];
    //-----cancel----success
    NSLog(@"biortjhiojiohjytioh----%@--%@",result,orderNoToPay);
    if ([result isEqualToString:@"success"]) {
        int priceScore = 0;
        NSMutableArray *orderWoodsArray = [defaults objectForKey:@"NotPayedOrderWoodsArray"];//未购买商品--------本地存储
        NSMutableArray *orderWoodsArray1  = [[NSMutableArray alloc] init];
        NSMutableArray *_orderWoodsArray = [defaults objectForKey:@"PayedOrderWoodsArray"];//已购买商品--------本地存储
        NSMutableArray *_orderWoodsArray1  = [[NSMutableArray alloc] init];
        if(orderWoodsArray){
            orderWoodsArray1 = [orderWoodsArray mutableCopy];
        }
        if(_orderWoodsArray){
            _orderWoodsArray1 = [_orderWoodsArray mutableCopy];
        }
        NSLog(@"vewovopjgprjegpjregrep--qwe-----%@---%@",orderWoodsArray,_orderWoodsArray);
        for (NSDictionary *itemWood in orderWoodsArray1) {
            if ([[itemWood objectForKey:@"tradeNO"] isEqualToString:orderNoToPay]) {
                [orderWoodsArray1 removeObject:itemWood];//--移除旧的---
                [_orderWoodsArray1 addObject:itemWood];//--添加到已支付
                [defaults setObject:orderWoodsArray1 forKey:@"NotPayedOrderWoodsArray"];//
                [defaults setObject:_orderWoodsArray1 forKey:@"PayedOrderWoodsArray"];//
                break;
            }
        }
        
        NSDictionary * params = @{@"apiid": @"0061",@"score" :[NSString stringWithFormat:@"%d",priceScore],@"mid": memberId};
        NSURLRequest * request = [[AFOSCClient sharedClient] requestWithMethod:@"POST"
                                                                          path:@""
                                                                    parameters:params];
        AFHTTPRequestOperation * operation = [[AFOSCClient sharedClient] HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSString* source = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            if ([source isEqualToString:@"true"]) {
                
            }
        } failure:^(AFHTTPRequestOperation *operation1, NSError *error) {
            NSLog(@"faild , error == %@ ", error);
            //[Waiting dismiss];//----隐藏loading----
        }];
        [operation start];//-----发起请求------
        
        //发送通知,传递参数:订单号
        NSDictionary *userInfoDic = @{@"orderNo":orderNoToPay};
        [[NSNotificationCenter defaultCenter] postNotificationName:@"finishPayment" object:nil userInfo:userInfoDic];//发送通知,重新加载未支付订单
        
    }
}

//生成订单清空数据
- (void) generateOrderClearData{
    [Waiting dismiss];
    if (!isFromActivity&&!isFromDirectlyPay) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"orderSubmitToPay" object:nil];//购物车清空生成订单的商品
        if (isShowAlert) {
            [self showOrderOrBookFinishView];
        }else{
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }else if(isFromActivity){
        [[NSNotificationCenter defaultCenter] postNotificationName:@"showIndexPage" object:nil userInfo:@{@"activityName":[activityWood objectForKey:@"activityName"]}];
        if (isShowAlert) {
            [self showOrderOrBookFinishView];
        }else{
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }else if(isFromDirectlyPay){
        if (isShowAlert) {
            [self showOrderOrBookFinishView];
        }else{
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

-(void)showOrderOrBookFinishView{
    BookFinishController *bookFinish    = [[BookFinishController alloc] init];
    bookFinish.bookOrderInfo            = @{@"bookOrderNo":[orderInfoDic objectForKey:@"tradeNO"],@"bookOrderPrice":[orderInfoDic objectForKey:@"price"],@"isBookOrNot":@0,@"isFinishPay":[NSNumber numberWithInt:isFinishPay],@"payOffType":[NSNumber numberWithInt:payOffType]};
    bookFinish.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:bookFinish animated:YES];
}
@end