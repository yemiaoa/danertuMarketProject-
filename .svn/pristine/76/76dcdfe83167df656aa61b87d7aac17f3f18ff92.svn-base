//
//  KKFirstViewController.m
//  Tuan
//
//  Created by 夏 华 on 12-7-3.
//  Copyright (c) 2012年 无锡恩梯梯数据有限公司. All rights reserved.
//
//订餐+送餐
#import "ShopDataController.h"

#import <QuartzCore/QuartzCore.h>
#import "GridViewCell.h"
#import "DetailViewController.h"
#import "UIImageView+WebCache.h"
#import "Waiting.h"

@implementation NSString(mamu)

-(void)method
{

}

@end

@implementation ShopDataController{
    UILabel *topNaviClassifyText ;
    NSDictionary *selectTypeDic;
    UIView *classifyView;
    UIImageView *adsImgV;
    NSArray *classifyDataArr;
    NSArray *adsImgArr;
    NSString *dateStr_imgSuffix;
    UIWebView *webView;
    int currentClassifyIndex;
}

@synthesize city;
@synthesize coordinate;
@synthesize preCoordinate;
@synthesize keyWord;
@synthesize distanceParameter;
@synthesize classifyType;
@synthesize addStatusBarHeight;
@synthesize modleFromFavoarite;
@synthesize province;
@synthesize arrays;
@synthesize titleLb;
@synthesize refreshLb;
@synthesize scrollView;
@synthesize imageCache;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initialization];   //初始化
}

//初始化方法
- (void)initialization
{
    imageCache = [[NSCache alloc] init];
    arrays = [[NSMutableArray alloc] init];//初始化
    addStatusBarHeight = STATUSBAR_HEIGHT;
    
    [super viewDidLoad];
    NSDateFormatter *f = [[NSDateFormatter alloc] init];
    [f setDateFormat:@"yyyy-MM-dd"];
    dateStr_imgSuffix = [f stringFromDate:[NSDate date]];
    
    //返回
    UIButton *goBack = [[UIButton alloc] initWithFrame:CGRectMake(10, 2+addStatusBarHeight, 53.5, 40)];
    [self.view addSubview:goBack];
    [goBack setBackgroundImage:[UIImage imageNamed:@"gobackBtn"] forState:UIControlStateNormal];
    [goBack addTarget:self action:@selector(onClickBack) forControlEvents:UIControlEventTouchUpInside];
    
    //刷新按钮,temp扩大热区
    titleLb = [[UILabel alloc]initWithFrame:CGRectMake(60, 0+addStatusBarHeight, 200, 44)];
    titleLb.textAlignment = NSTextAlignmentCenter;
    titleLb.textColor = [UIColor whiteColor];
    titleLb.backgroundColor = [UIColor clearColor];
    [self.view addSubview:titleLb];
    
    self.p = @"1";//当前页
    self.isHaveMore = YES;
    self.isNetWorkRight = YES;
    classifyDataArr = @[@{@"Name":@"订餐",@"Id":@"0"},@{@"Name":@"送餐",@"Id":@"1"}];
    self.view.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];
    
    //dateStr_imgSuffix
    adsImgArr = @[[NSString stringWithFormat:@"https://dn-danertu.qbox.me/dingcan.jpg?%@",dateStr_imgSuffix],[NSString stringWithFormat:@"https://dn-danertu.qbox.me/songcan.jpg?%@",dateStr_imgSuffix]];   //第一个是订餐,第二个是送餐
    
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, TOPNAVIHEIGHT+addStatusBarHeight, MAINSCREEN_WIDTH, self.view.frame.size.height-(TOPNAVIHEIGHT+addStatusBarHeight))];
    scrollView.contentSize = CGSizeMake(MAINSCREEN_WIDTH, self.view.frame.size.height-(TOPNAVIHEIGHT+addStatusBarHeight)+84);
    scrollView.delegate = self;
    [self.view addSubview:scrollView];
    
    //分类,可以点击
    UIView *classifyBlock = [[UIView alloc] initWithFrame:CGRectMake(70, 0+addStatusBarHeight, 60, TOPNAVIHEIGHT)];
    [self.view addSubview:classifyBlock];
    UITapGestureRecognizer *singleTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showClassify)];
    [classifyBlock addGestureRecognizer:singleTap];//添加大图片点击事件
    //文字
    topNaviClassifyText = [[UILabel alloc] initWithFrame:CGRectMake(0, 12, 50, 25)];
    [classifyBlock addSubview:topNaviClassifyText];
    topNaviClassifyText.backgroundColor = [UIColor clearColor];
    
    if ([classifyType isEqualToString:@"0"]) {
        topNaviClassifyText.text = @"订餐";
        currentClassifyIndex = 0;
    }else if ([classifyType isEqualToString:@"1"]) {
        topNaviClassifyText.text = @"送餐";
        currentClassifyIndex = 1;
    }
    topNaviClassifyText.font = [UIFont systemFontOfSize:18];
    topNaviClassifyText.textColor = [UIColor whiteColor];
    topNaviClassifyText.userInteractionEnabled = YES;//这样才可以点击
    [topNaviClassifyText setNumberOfLines:1];
    [topNaviClassifyText sizeToFit];//自适应
    
    CGRect frame = topNaviClassifyText.frame;
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(frame.size.width, 20, 10, 10)];
    [classifyBlock addSubview:imgView];
    imgView.image = [UIImage imageNamed:@"classifyTopImg"];
    
    //定送餐
    webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, addStatusBarHeight+TOPNAVIHEIGHT, self.view.frame.size.width, CONTENTHEIGHT+49)];//上半部分
    [self.view addSubview:webView];
    webView.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];
    webView.delegate = self;
    NSString *webURL = [NSString stringWithFormat:@"%@/bookFood_Shop.html",PAGEURLADDRESS];
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:webURL]]];
    
    [self getShopDataByCity];
    
    //分类下拉---------------------------------
    int itemH = 40;
    int itemW = 100;
    int count = (int)classifyDataArr.count;
    //---------头部第一分类,下拉选择项-------
    classifyView = [[UIView alloc] initWithFrame:CGRectMake(70, TOPNAVIHEIGHT+addStatusBarHeight, itemW, itemH*count)];
    [self.view addSubview:classifyView];
    classifyView.hidden = YES;
    classifyView.userInteractionEnabled = YES;//这样才可以点击
    classifyView.backgroundColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0.8];
    for (int i=0;i<count;i++) {
        //顺便初始化,@""代替占位符
        UIView *item = [[UIView alloc] initWithFrame:CGRectMake(0, itemH*i, itemW, itemH)];
        [classifyView addSubview:item];
        item.tag = 100+i;
        UITapGestureRecognizer *singleTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectClassify:)];
        [item addGestureRecognizer:singleTap];//---添加大图片点击事件
        
        UILabel *itemText = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, itemW, itemH)];
        [item addSubview:itemText];
        itemText.text = [classifyDataArr[i] objectForKey:@"Name"];
        itemText.backgroundColor = [UIColor clearColor];
        itemText.textColor = [UIColor whiteColor];
        itemText.textAlignment = NSTextAlignmentCenter;
        if (i<count-1) {
            UILabel *border = [[UILabel alloc] initWithFrame:CGRectMake(0,itemH-1, itemW, 1)];
            [item addSubview:border];
            border.backgroundColor = BORDERCOLOR;
        }
    }
}

-(void)onClickBack{
    [self.navigationController popViewControllerAnimated:YES];
}

//-----展示分类
-(void)showClassify{
    NSLog(@"jbrjokfopjojgri");
    classifyView.hidden = !classifyView.hidden;
}
//-----选择其他分类
-(void)selectClassify:(id)sender{
    int tag = (int)[[sender view] tag]-100;
    classifyView.hidden = YES;
    if (tag!=currentClassifyIndex) {
        currentClassifyIndex = tag;
        topNaviClassifyText.text = [classifyDataArr[tag] objectForKey:@"Name"];
        //----调整文字,小标大小------
        [topNaviClassifyText sizeToFit];
        CGRect frame = topNaviClassifyText.frame;
        //父view
        UIView *parentV = [topNaviClassifyText superview];
        UIImageView *imgView = [[parentV subviews] objectAtIndex:1];
        imgView.frame = CGRectMake(frame.size.width, 20, 10, 10);
        
        parentV.frame = CGRectMake(70, 0, frame.size.width+10, TOPNAVIHEIGHT);
        //选择分类,之后重新加载数据,,,,,,,住玩购,定送餐多要根据id刷新数据
        classifyType = [classifyDataArr[tag] objectForKey:@"Id"];
        [self refreshHttp];//刷新重新加载
        if (tag<adsImgArr.count) {
            [adsImgV sd_setImageWithURL:[NSURL URLWithString:adsImgArr[tag]] placeholderImage:[UIImage imageNamed:@"noData1"]];
        }else{
            [self.view makeToast:@"数据错误:数组" duration:1.2 position:@"center"];
        }
    }
}

//重新加载数据
-(void)refreshHttp{
    [self initHttpParameters];//----清除之前的数据----
    [self getShopDataByCity];//-----
}
/*恢复初始化状态
 *数据页数  置1
 *是否更多数据,是否有数据,是否网络正常,都  置 YES
 *arrays  清空,这样会把页面数据消掉------
 */
-(void)initHttpParameters{
    self.p = @"1";//如果更换了城市就把page页数变成1
    self.isHaveMore = YES;//是否有更多数据可以加载
    self.isNetWorkRight = YES;//网络状态是否正常
    [arrays removeAllObjects];//移除所有元素
}

//-----同意方法调用-------
-(void)parameter_iosFunc:(NSArray *) inputArray{
    NSInteger parameterCount = inputArray.count;
    if (parameterCount>0) {
        NSString *funcFlag = [inputArray firstObject];
        SEL func = NSSelectorFromString(funcFlag);
        if (parameterCount>1) {
            //---------带参数的方法-----
            func = NSSelectorFromString([NSString stringWithFormat:@"%@:",funcFlag]);
        }
        if ( [self respondsToSelector:func]){
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [self performSelector:func withObject:inputArray];
#pragma clang diagnostic pop
        }
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 404) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)mywebView
{
}

- (void)webViewDidStartLoad:(UIWebView *)mywebView
{
}

- (BOOL)webView:(UIWebView *)webViewTmp shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    static BOOL isRequestWeb = YES;
    
    if (isRequestWeb) {
        NSHTTPURLResponse *response = nil;
        
        NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
        if (response.statusCode == 404 || response.statusCode == 403) {
            // code for 404 or 403
            UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"noData"]];
            imageView.frame = CGRectMake((MAINSCREEN_WIDTH - 100)/2.0, 200, 100, 100);
            imageView.center = self.view.center;
            [self.view addSubview:imageView];
            
            [webView stopLoading];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"亲，目前页面有点问题，请稍后再试" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
            alert.tag = 404;
            [alert show];
            return NO;
        }
        
        [webView loadData:data MIMEType:@"text/html" textEncodingName:nil baseURL:[request URL]];
        
        isRequestWeb = NO;
        return NO;
    }
    
    NSLog(@"fjeoijwoifjejfoepierbhiohgoireghre----%@---%@",request,request.URL.scheme);
    //window.location.href="ios:normalPage/"+page+"/"+name+"/"+id+"/"+tagFlag;
    // 说明协议头是ios
    // 说明协议头是ios
    if ([@"ios" isEqualToString:request.URL.scheme]) {
        NSString *url = request.URL.absoluteString;
        NSRange range = [url rangeOfString:@":"];
        NSString *method = [request.URL.absoluteString substringFromIndex:range.location + 1];
        method = [method
                  stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSLog(@"jfoepierbhiohgoireghre----%@",method);
        //--------不带参数的直接方法名------
        if ([method hasPrefix:@"parameter_"]){
            NSInteger location = [method rangeOfString:@"/"].location;
            NSString *funcName = [method substringToIndex:location];
            SEL func = NSSelectorFromString([NSString stringWithFormat:@"%@:",funcName]);
            NSArray *parameterArr = [[method substringFromIndex:location+1] componentsSeparatedByString:@"/"];
            NSLog(@"jfioewjigoreg------%@--%@",funcName,parameterArr);
            if ( [self respondsToSelector:func]){
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                [self performSelector:func withObject:parameterArr];
#pragma clang diagnostic pop
            }
        }
        NSLog(@"jgioregoregiorje-------no");
        return NO;
    }
    NSLog(@"jgioregoregiorje-------yes");
    return YES;
}
-(void)goShopDetail:(NSArray *)inputArray{
    if (inputArray.count>1) {
        NSString *shopId = inputArray[1];
        DetailViewController *detailV = [[DetailViewController alloc] init];
        for (DataModle *modle in arrays) {
            if ([modle.id isEqualToString:shopId]) {
                detailV.modle = modle;
                break;
            }
        }
        //-----跳转----
        detailV.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:detailV animated:YES];
    }
}
//获取店铺列表,分为----分类和关键字两种-------
-(void)getShopDataByCity{
    if (self.isHaveMore) {
       
        if (arrays.count < ([self.p integerValue]* 20 - 20)) {
            //无下一页
            return;
        }
        // 数据加载进度状态
        [Waiting show];
        NSString *resultDataKeyPrefix = @"shoplist";
        NSString *resultDataKeyPrefix1 = @"shopbean";
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"0037",@"apiid",
                                                                                        keyWord, @"kword" ,
                                                                                     coordinate,@"gps",
                                                                                       @"80000",@"less",
                                                                   [city objectForKey:@"cName"],@"areaCode",
                                                                                          @"20",@"pageSize",
                                                                                         self.p,@"pageIndex",nil];
        if ([classifyType isEqualToString:@"0"]) {
            [params setValue:@"1" forKey:@"isCanOrder"];
        }else if ([classifyType isEqualToString:@"1"]) {
            [params setValue:@"1" forKey:@"isCanSell"];
        }
        
        NSURLRequest * request = [[AFOSCClient sharedClient] requestWithMethod:@"POST"
                                                                          path:@""
                                                                    parameters:params];
        AFHTTPRequestOperation * operation = [[AFOSCClient sharedClient] HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [Waiting dismiss];//隐藏loading
            if(self.isNetWorkRight==NO){
                [arrays removeObjectAtIndex:0];//前一状态  网络异常时array有一个无效的cell,删除
            }
            self.isNetWorkRight = YES;
        
            NSString* jsonDataStr  = [Tools deleteErrorStringInData:responseObject];
            NSData *jsonDataTmp    = [jsonDataStr dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:jsonDataTmp options:NSJSONReadingMutableLeaves error:nil];//json解析
            
            DataModle *model       = [[DataModle alloc] init];//对象数据模型
            NSMutableArray *temp   = [[jsonData objectForKey:resultDataKeyPrefix] objectForKey:resultDataKeyPrefix1];
            //多个item数组
            if(temp.count > 0){
                for(int i=0;i<temp.count;i++){
                    //[model setM:[[temp objectAtIndex:i] objectForKey:@"m"]];
                    model = [[DataModle alloc] initWithDataDic:[temp objectAtIndex:i]];//对象属性的拷贝
                    
                    [arrays addObject:model];//追加到数组
                }
                self.p = [NSString stringWithFormat:@"%d",[self.p intValue]+1];
            }else{
                self.isHaveMore = NO;//没有更多数据
            }
            //-----定送餐加载页面数据--------
            NSString *dingSongCanFlag = classifyType;
            if ([dingSongCanFlag isEqualToString:@"0"]) {
                dingSongCanFlag = @"1";
            }else{
                dingSongCanFlag = @"0";
            }
            NSString *jsFuncName = [NSString stringWithFormat:@"javaLoadData('%@','%@')",dingSongCanFlag,jsonDataStr];
            [webView stringByEvaluatingJavaScriptFromString:jsFuncName];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [Waiting dismiss];//隐藏loading
            //前一状态的 isNetWorkRight=YES,否则不再执行
            if(self.isNetWorkRight){
                self.isNetWorkRight = NO;
                [self showHint:REQUESTERRORTIP];
//                [self performSelector:@selector(onClickBack) withObject:nil afterDelay:1.5];
            }
        }];
        [operation start];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

-(float)getDistanceOfPoints:(float)x1 y1:(float)y1 x2:(float)x2 y2:(float)y2{
    float distance = 1.0;
    float wuce = 1000000;
    float poA = fabs(x2*wuce  - x1 );
    float poB = fabs(y2*wuce  - y1 );
    float wwc = 0.9296;//换算百度精准倍率
    //return parseInt(Math.sqrt((poA * poA) + (poB * poB))/10/ wwc);
    distance = sqrt((poA * poA) + (poB * poB))/10/ wwc;
    NSLog(@"jgieowjovijewoifjieowf------%f---%f--%f---%f",x1,y1,x2,y2);
    return distance;
}

//-----------内存不足报警------
-(void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    NSLog(@"memory warning,kkappdelegate---");
}
@end
