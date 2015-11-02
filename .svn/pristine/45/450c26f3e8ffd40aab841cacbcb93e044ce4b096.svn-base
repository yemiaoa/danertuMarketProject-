//
//  GoodsShopListCell.m
//  单耳兔
//
//  Created by yang on 15/8/11.
//  Copyright (c) 2015年 珠海单耳兔电子商务有限公司. All rights reserved.
//

#import "GoodsShopListCell.h"

@implementation GoodsShopListCell
@synthesize imageView,nameL,shopProductL,distanceL,saleGoodL,goodPriceL;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MAINSCREEN_WIDTH, 92)];
        [self addSubview:bgView];
        bgView.backgroundColor = [UIColor whiteColor];
        
        imageView = [[AsynImageView alloc] initWithFrame:CGRectMake(4, 4, 84, 84)];
        imageView.placeholderImage = [UIImage imageNamed:@"noData1"];
        imageView.layer.masksToBounds = YES;
        imageView.layer.borderWidth = 0;
        imageView.layer.borderColor = [UIColor clearColor].CGColor;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:imageView];
        
        nameL = [[UILabel alloc] initWithFrame:CGRectMake(102, 4, MAINSCREEN_WIDTH-170, 20)];
        nameL.font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
        [self addSubview:nameL];
        
        //距离
        distanceL = [[UILabel alloc] initWithFrame:CGRectMake(MAINSCREEN_WIDTH-70, 8, 60, 12)];
        distanceL.font = [UIFont fontWithName:@"Helvetica" size:12];
        distanceL.textAlignment = NSTextAlignmentRight;
        distanceL.textColor = [UIColor grayColor];
        [self addSubview:distanceL];
        
        //主营
        shopProductL = [[UILabel alloc] initWithFrame:CGRectMake(102, 30, MAINSCREEN_WIDTH-110, 14)];
        shopProductL.font = [UIFont fontWithName:@"Helvetica" size:14];
        [self addSubview:shopProductL];
        
        //特价商品
        saleGoodL = [[UILabel alloc] initWithFrame:CGRectMake(102, 50, MAINSCREEN_WIDTH-180, 40)];
        saleGoodL.font = [UIFont fontWithName:@"Helvetica" size:16];
        saleGoodL.numberOfLines = 2;
        saleGoodL.textColor = [UIColor grayColor];
        [self addSubview:saleGoodL];
        
        //特价价格
        goodPriceL = [[UILabel alloc] initWithFrame:CGRectMake(MAINSCREEN_WIDTH-80, 60, 70, 20)];
        goodPriceL.textColor = [UIColor redColor];
        goodPriceL.font = [UIFont fontWithName:@"Helvetica" size:14];
        goodPriceL.textAlignment = NSTextAlignmentRight;
        [self addSubview:goodPriceL];
        
        UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 91, MAINSCREEN_WIDTH, 0.4)];
        [self addSubview:line];
        [line setBackgroundColor:[UIColor grayColor]];
    }
    return self;
}
@end
