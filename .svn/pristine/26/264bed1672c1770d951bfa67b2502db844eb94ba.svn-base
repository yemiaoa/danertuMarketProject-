//
//  GridViewCell.m
//  AQGridViewDemo
//
//  Created by 夏 华 on 12-6-26.
//  Copyright (c) 2012年 无锡恩梯梯数据有限公司. All rights reserved.
//

#import "DanertuWoodsViewCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation DanertuWoodsViewCell

@synthesize imageView;
@synthesize marketPriceLabel;
@synthesize lineLabel;
@synthesize priceLabel;
@synthesize woodsLabel;
@synthesize mainView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withCellSize:(CGSize)cellsize
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        CGFloat cellH = cellsize.height;
        CGFloat cellW = cellsize.width;
        
        mainView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, cellW, cellH)];
        [mainView setBackgroundColor:[UIColor clearColor]];
        
        CGFloat imageX = 13;
        CGFloat imageY = 8;
        CGFloat imageW = 80;
        CGFloat imageH = 84;
        
        //商品图片
        imageView = [[AsynImageView alloc] initWithFrame:CGRectMake(imageX, imageY, imageW, imageH)];//商品图片
        imageView.placeholderImage = [UIImage imageNamed:@"noData1"];
        imageView.imageURL = nil;
        [mainView addSubview:imageView];
        
        CGFloat labelX = 100;
        CGFloat labelY = 10;
        CGFloat labelW = 202;
        CGFloat labelH = 40;
    
        //商品名称
        self.woodsLabel = [[UILabel alloc] initWithFrame:CGRectMake(labelX, labelY, labelW, labelH)];
        woodsLabel.font = [UIFont fontWithName:@"Helvetica" size:16.0];
        woodsLabel.numberOfLines = 2;
        [mainView addSubview:woodsLabel];
        
        //市场价格
        labelY = labelY + labelH +  5;
        self.marketPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(labelX, labelY, 136, 12)];
        marketPriceLabel.font = [UIFont fontWithName:@"Helvetica" size:14.0];
        marketPriceLabel.textColor = [UIColor grayColor];
        marketPriceLabel.numberOfLines = 1;
        [mainView addSubview:marketPriceLabel];
        
        self.lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 6, 136, 1)];
        lineLabel.backgroundColor = [UIColor redColor];
        [marketPriceLabel addSubview:lineLabel];//画条线
        
        labelY = marketPriceLabel.frame.origin.y + marketPriceLabel.frame.size.height + 5;
        //价格
        self.priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(labelX, labelY, 136, 16)];
        priceLabel.font = [UIFont fontWithName:@"Helvetica" size:15.0];
        priceLabel.numberOfLines = 1;
        priceLabel.textColor = [UIColor redColor];
        [mainView addSubview:priceLabel];
        
        [self addSubview:mainView];
    }
    return self;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        mainView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MAINSCREEN_WIDTH, 100)];
        [mainView setBackgroundColor:[UIColor clearColor]];
        
        UIImageView *frameImageView = [[UIImageView alloc] initWithFrame:CGRectMake(9, 4, 302, 92)];
        //[frameImageView setImage:[UIImage imageNamed:@"tab-mask.png"]];
        [frameImageView setBackgroundColor:[UIColor whiteColor]];
        frameImageView.layer.masksToBounds = YES;
        frameImageView.layer.cornerRadius = 4;
        [mainView addSubview:frameImageView];
        //商品图片
        self.imageView = [[AsynImageView alloc] initWithFrame:CGRectMake(13, 8, 80, 84)];//商品图片
        self.imageView.placeholderImage = [UIImage imageNamed:@"noData1"];
        //添加边框
        /*
         CALayer *layer = [imageView layer];
         layer.borderColor = [[UIColor grayColor] CGColor];
         layer.borderWidth = 2.0f;
         */
        [mainView addSubview:imageView];
        //商品名称
        self.woodsLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 10, 202, 25)];
        woodsLabel.font = [UIFont systemFontOfSize:18];
        woodsLabel.numberOfLines = 1;
        [mainView addSubview:woodsLabel];//
        //市场价格
        self.marketPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 40, 136, 12)];
        marketPriceLabel.font = [UIFont systemFontOfSize:14];
        marketPriceLabel.textColor = [UIColor grayColor];
        marketPriceLabel.numberOfLines = 2;
        [mainView addSubview:marketPriceLabel];
        
        self.lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 45, 136, 1)];
        lineLabel.backgroundColor = [UIColor redColor];
        [mainView addSubview:lineLabel];//画条线
        
        //价格
        self.priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 55, 136, 16)];
        priceLabel.font = [UIFont systemFontOfSize:16];
        priceLabel.numberOfLines = 2;
        priceLabel.textColor = [UIColor redColor];
        [mainView addSubview:priceLabel];

        [self.contentView addSubview:mainView];
    }
    return self;
}

@end
