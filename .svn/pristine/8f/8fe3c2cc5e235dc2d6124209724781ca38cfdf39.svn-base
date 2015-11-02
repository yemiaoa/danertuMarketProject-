//
//  SellGoodCell.h
//  单耳兔
//
//  Created by yang on 15/7/3.
//  Copyright (c) 2015年 珠海单耳兔电子商务有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UnderLineLabel.h"
#import "AsynImageView.h"

@interface SellGoodCell : UITableViewCell{
    CGRect _editeRect;
    CGRect _onOrOffRect;
    CGRect _deleteRect;

}
@property (nonatomic,strong) AsynImageView *goodImage;
@property (nonatomic,strong) UILabel *goodNameLabel;
@property (nonatomic,strong) UnderLineLabel *oldPriceLabel;
@property (nonatomic,strong) UILabel *currentPriceLabel;
@property (nonatomic,strong) UILabel *totalCountLabel;
@property (nonatomic,strong) UILabel *leftCountLabel;
@property (nonatomic,strong) UIImageView *editImageView;
@property (nonatomic,strong) UILabel *editLabel;
@property (nonatomic,strong) UIImageView *onLineImageView;
@property (nonatomic,strong) UILabel *onLineLabel;
@property (nonatomic,strong) UIImageView *deleteImageView;
@property (nonatomic,strong) UILabel *deleteLabel;
@property (nonatomic,strong) void(^goodEditBlock)();
@property (nonatomic,strong) void(^onOrOffLineBlock)();
@property (nonatomic,strong) void(^deleteBlock)();
@end
