//
//  FavoriteGoodsCell.m
//  单耳兔
//
//  Created by yang on 15/8/27.
//  Copyright (c) 2015年 珠海单耳兔电子商务有限公司. All rights reserved.
//

#import "FavoriteGoodsCell.h"

@implementation FavoriteGoodsCell
@synthesize goodsImage,goodsLabel,priceLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {

        goodsImage = [[AsynImageView alloc] initWithFrame:CGRectMake(5, 5, 80, 80)];//商品图片
        [goodsImage setPlaceholderImage:[UIImage imageNamed:@"noData1"]];
        goodsImage.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:goodsImage];
        
        goodsLabel               = [[UILabel alloc] initWithFrame:CGRectMake(100, 0, 180, 45)];
        goodsLabel.font          = [UIFont systemFontOfSize:16];
        goodsLabel.numberOfLines = 0;
        [self addSubview:goodsLabel];
        
        priceLabel           = [[UILabel alloc] initWithFrame:CGRectMake(100, 45, 180, 20)];
        priceLabel.font      = [UIFont systemFontOfSize:16];
        priceLabel.textColor = TOPNAVIBGCOLOR;
        [self addSubview:priceLabel];
    }
    return self;
}
@end
