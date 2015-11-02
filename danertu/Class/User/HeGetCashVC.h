//
//  HeGetCashVC.h
//  单耳兔
//
//  Created by Tony on 15/8/18.
//  Copyright (c) 2015年 珠海单耳兔电子商务有限公司. All rights reserved.
//

#import "TopNaviViewController.h"


@protocol getCashProtol <NSObject>

- (void)getCashSucceed;

@end

@interface HeGetCashVC : TopNaviViewController<UITextFieldDelegate>

@property(assign,nonatomic)id<getCashProtol>getCashDelegate;

@end
