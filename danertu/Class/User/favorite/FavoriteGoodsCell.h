//
//  FavoriteGoodsCell.h
//  单耳兔
//
//  Created by yang on 15/8/27.
//  Copyright (c) 2015年 珠海单耳兔电子商务有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsynImageView.h"
@interface FavoriteGoodsCell : UITableViewCell
@property (nonatomic,strong) AsynImageView *goodsImage;
@property (nonatomic,strong) UILabel *goodsLabel;
@property (nonatomic,strong) UILabel *priceLabel;
@end
