//
//  WebViewController.h
//  Tuan
//
//  Created by 夏 华 on 12-7-6.
//  Copyright (c) 2012年 无锡恩梯梯数据有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderFormController.h"
#import "TopNaviViewController.h"
#import "AFJSONRequestOperation.h"

#import "LoginViewController.h"
@interface ShopCatController : TopNaviViewController<UICollectionViewDelegate,UICollectionViewDataSource>
{
    NSString *lastSelectDataString;
}
@property (nonatomic) NSUserDefaults *defaults;//本地存储


@property (nonatomic) int addStatusBarHeight;
@property (nonatomic, strong)UIView *noOrderView;//没有数据显示view
@property (nonatomic, strong)UIView *haveOrderView;//有数据显示的view
/*-------woodsArrByShop----变量说明:
按照商店对商品分类,多个dictionary(商店)组成的数组,购物车展示的商品顺序依次变量为准
dictionary字段:shopId,shopName,
 shopPay(所有商品价钱总和),woodsArr(商店商品的数组),woodsTotalCount(商店所有商品的总数量)
 */
@property (nonatomic, strong)NSMutableArray *woodsArrByShop;
@property (nonatomic) BOOL isFirstToLoad;
@property (nonatomic, strong)UILabel *totalPayLb;
@property (nonatomic, strong)UIImageView *bottomSelectAll;
@property (nonatomic, strong)NSMutableDictionary *subViewDict; //存放与价格有关的视图，可以方便寻址修改价格

@end
