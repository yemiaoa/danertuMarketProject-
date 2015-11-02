//
//  ViewController.m
//  orderProduce
//
//  Created by imac on 14/12/22.
//  Copyright (c) 2014年 ___FULLUSERNAME___. All rights reserved.
//
#define LINESPACE 20

#import "BookFinishController.h"


@interface BookFinishController (){
    bool isBook;
}

@end

@implementation BookFinishController
@synthesize bookOrderInfo;

- (void)viewDidLoad
{
    //预订:为yes
    isBook = [bookOrderInfo objectForKey:@"isBookOrNot"] ? NO :YES;
    
    [super viewDidLoad];
    
    addStatusBarHeight = [TopNaviViewController getStatusBarHeight];
	UIView *view1 = [[UIView alloc]initWithFrame:CGRectMake(0, addStatusBarHeight+TOPNAVIHEIGHT, MAINSCREEN_WIDTH, 300)];
    self.view.backgroundColor = [UIColor whiteColor];
    UIImageView *image1 = [[UIImageView alloc]init];
    image1.frame = CGRectMake(80, 31, 24, 20);
    image1.image = [UIImage imageNamed:@"yes.png"];
    if (!isBook) {
        image1.image = [UIImage imageNamed:@"yes_r.jpg"];
    }
    [view1 addSubview:image1];
    UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(110, 26, 150, 30)];
    if (isBook) {
        label1.text =@"已预订成功";
    }else{
        label1.text =@"订单提交成功!";
    }
    [view1 addSubview:label1];
    UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(30, 56, 260, 20)];
    label2.font = TEXTFONT;
    label2.text = @"请及时到本店消费，如有疑问请咨询商家";
    [view1 addSubview:label2];
    if (!isBook) {
        [label2 setHidden:YES];
        [image1 setFrame:CGRectMake(80, 55, 24, 20)];
        [label1 setFrame:CGRectMake(110, 50, 150, 30)];
    }
    
    UILabel *label3 = [[UILabel alloc]initWithFrame:CGRectMake(20, 86, 280, 70+35)];
    if (isBook) {
        [label3 setFrame:CGRectMake(20, 86, 280, 70)];
    }
    label3.layer.cornerRadius = 6;
    label3.layer.borderColor = BORDERCOLOR.CGColor;
    label3.layer.borderWidth = 1;
    [view1 addSubview:label3];
    
    UILabel *orderLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, 86 +7, 200, 35)];
    orderLabel.font = [UIFont systemFontOfSize:14];
    orderLabel.text = [NSString stringWithFormat:@"  订单号：%@",[bookOrderInfo objectForKey:@"bookOrderNo"]];
    [view1 addSubview:orderLabel];
    
    UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, 86 + 42, 200, 35)];
    priceLabel.font = [UIFont systemFontOfSize:14];
    priceLabel.textColor = !isBook ? TOPNAVIBGCOLOR : TOPNAVIBGCOLOR_G;
    priceLabel.text = [NSString stringWithFormat:@"  订单金额：￥%@",[bookOrderInfo objectForKey:@"bookOrderPrice"]];
    [view1 addSubview:priceLabel];
    priceLabel.backgroundColor = [UIColor clearColor];
    
    if (!isBook) {
        //分割线
        UILabel *l1 = [[UILabel alloc]initWithFrame:CGRectMake(30, 119 +35, 260, 1)];
        l1.backgroundColor = BORDERCOLOR;
        [view1 addSubview:l1];
        
        UILabel *payLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, 86 + 77, 200, 35)];
        payLabel.backgroundColor = [UIColor clearColor];
        payLabel.font = [UIFont systemFontOfSize:14];
        payLabel.text = [NSString stringWithFormat:@"  支付方式: %@",[self getPayWay]];
        [view1 addSubview:payLabel];
    }
   
    //分割线
    UILabel *l = [[UILabel alloc]initWithFrame:CGRectMake(30, 120, 260, 1)];
    l.backgroundColor = BORDERCOLOR;
    [view1 addSubview:l];
    
    UIButton *myOrder = [[UIButton alloc]initWithFrame:CGRectMake(20, 210, 280, 30)];
    myOrder.titleLabel.textColor = [UIColor whiteColor];
    myOrder.titleLabel.font = [UIFont systemFontOfSize:14];
    [myOrder setTitle:@"查看我的订单" forState:UIControlStateNormal];
    myOrder.backgroundColor = TOPNAVIBGCOLOR;
    if (isBook) {
        [myOrder setFrame:CGRectMake(20, 210 - 35, 280, 30)];
        myOrder.backgroundColor = TOPNAVIBGCOLOR_G;
        [myOrder setTitle:@"查看我的预订" forState:UIControlStateNormal];
    }
    myOrder.layer.cornerRadius = 5.0;
    [myOrder addTarget:self action:@selector(goView) forControlEvents:UIControlEventTouchUpInside];
    [view1 addSubview:myOrder];
    [self.view addSubview:view1];
}

-(NSString *)getPayWay{
    int payType = [[bookOrderInfo objectForKey:@"payOffType"] intValue];
    NSString *payWayStr = @"";
    switch (payType) {
        case 0:
            payWayStr = @"单耳兔账户支付";
            break;
        case 1:
            payWayStr = @"支付宝支付";
            break;
        case 2:
            payWayStr = @"到付";
            break;
        case 3:
            payWayStr = @"微信支付";
            break;
        case 4:
            payWayStr = @"银联支付";
            break;
        case 5:
            payWayStr = @"货到付款";
            break;
        default:
            break;
    }
    return payWayStr;
}
- (BOOL)prefersStatusBarHidden
{
    return YES;
}

//-----修改标题
-(NSString*)getTitle{
    return @"提交成功";
}
//-----修改标题栏背景颜色
-(UIColor *)getTopNaviColor{
    if (isBook) {
        return TOPNAVIBGCOLOR_G;
    }
    return TOPNAVIBGCOLOR;
}

//返回
-(void)onClickBack{
    NSLog(@"%@",self.navigationController);
    [self.navigationController popToViewController:[[self.navigationController viewControllers] objectAtIndex:[[self.navigationController viewControllers] count] -3] animated:YES];
}
//----跳转-----
-(void)goView{
    
    if (isBook) {
        BookOrderController *orderController = [[BookOrderController alloc] init];
        orderController.currentItemTag =  1;
        orderController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:orderController animated:YES];
    }else{
        OrderListController *orderlistVC = [[OrderListController alloc] init];
        orderlistVC.hidesBottomBarWhenPushed = YES;
        orderlistVC.currentItemTag = [[bookOrderInfo valueForKey:@"isFinishPay"] intValue];
        [self.navigationController pushViewController:orderlistVC animated:YES];
    }
}



@end
