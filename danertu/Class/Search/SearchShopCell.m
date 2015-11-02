//
//  SearchShopCell.m
//  单耳兔
//
//  Created by yang on 15/8/10.
//  Copyright (c) 2015年 珠海单耳兔电子商务有限公司. All rights reserved.
//

#import "SearchShopCell.h"

@implementation SearchShopCell
@synthesize shopImage,shopNameL,shopProductL,shopAddressL,shopTelL;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MAINSCREEN_WIDTH, 92)];
        [self addSubview:bgView];
        bgView.backgroundColor = [UIColor whiteColor];
        
        shopImage = [[AsynImageView alloc] initWithFrame:CGRectMake(4, 4, 84, 84)];
        shopImage.placeholderImage = [UIImage imageNamed:@"noData1"];
        shopImage.layer.masksToBounds = YES;
        shopImage.layer.borderWidth = 0;
        shopImage.layer.borderColor = [UIColor clearColor].CGColor;
        shopImage.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:shopImage];
        
        shopNameL = [[UILabel alloc] initWithFrame:CGRectMake(100, 4, 190, 18)];
        shopNameL.font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
        [self addSubview:shopNameL];
        
        shopProductL = [[UILabel alloc] initWithFrame:CGRectMake(100, 29, 190, 18)];
        shopProductL.font = [UIFont fontWithName:@"Helvetica-Bold" size:12];
        [self addSubview:shopProductL];
        
        shopTelL = [[UILabel alloc] initWithFrame:CGRectMake(100, 47, 190, 18)];
        shopTelL.font = [UIFont fontWithName:@"Helvetica-Bold" size:12];
        [self addSubview:shopTelL];
        
        shopAddressL = [[UILabel alloc] initWithFrame:CGRectMake(100, 65, 190, 18)];
        shopAddressL.font = [UIFont fontWithName:@"Helvetica-Bold" size:12];
        [self addSubview:shopAddressL];
    
    }
    return self;
}

@end
