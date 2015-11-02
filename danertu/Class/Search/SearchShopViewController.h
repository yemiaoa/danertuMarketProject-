//
//  SearchShopViewController.h
//  单耳兔
//
//  Created by yang on 15/8/10.
//  Copyright (c) 2015年 珠海单耳兔电子商务有限公司. All rights reserved.
//

#import "TopNaviViewController.h"

@interface SearchShopViewController : TopNaviViewController<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) NSString *keyWord;//搜索关键字
@end
