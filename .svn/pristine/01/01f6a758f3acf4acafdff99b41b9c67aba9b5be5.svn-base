//
//  GridViewCell.m
//  AQGridViewDemo
//
//  Created by 夏 华 on 12-6-26.
//  Copyright (c) 2012年 无锡恩梯梯数据有限公司. All rights reserved.
//

#import "CatListViewCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation CatListViewCell

@synthesize imageView,catView, unitPrice,lineLabel,totalPrice,woodsLabel,countLabel,shopName,stepper,timeView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIView *mainView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MAINSCREEN_WIDTH, 100)];
        [mainView setBackgroundColor:[UIColor whiteColor]];

        //商品图片
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(3, 8, 80, 84)];//商品图片
        [mainView addSubview:imageView];
        //商品名称
        self.woodsLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, 0, 200, 38)];
        woodsLabel.font = TEXTFONT;
        woodsLabel.numberOfLines = 2;
        [mainView addSubview:woodsLabel];//
        
        //删除按钮呢
        catView = [[UIView alloc] initWithFrame:CGRectMake(270, 0, 40, 45)];
        [mainView addSubview:catView];
        catView.userInteractionEnabled = YES;
        
        UIImageView *deleteImg = [[UIImageView alloc] initWithFrame:CGRectMake(20, 5, 16, 16)];
        [catView addSubview:deleteImg];
        deleteImg.image = [UIImage imageNamed:@"delete"];

        //单价
        UILabel *unitPriceText = [[UILabel alloc] initWithFrame:CGRectMake(90, 39, 40, 12)];
        unitPriceText.font = TEXTFONTSMALL;
        unitPriceText.text = @"单价:   ";
        unitPriceText.textColor = [UIColor grayColor];
        [mainView addSubview:unitPriceText];
        //单价符号
        UILabel *unitPriceSign = [[UILabel alloc] initWithFrame:CGRectMake(130, 39, 7, 12)];
        unitPriceSign.font = TEXTFONTSMALL;
        unitPriceSign.text = @"¥";
        [mainView addSubview:unitPriceSign];
        //单价数字
        self.unitPrice = [[UILabel alloc] initWithFrame:CGRectMake(140, 39, 70, 12)];
        unitPrice.font = TEXTFONTSMALL;
        [mainView addSubview:unitPrice];
        
        //数量
        UILabel *countTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, 54, 40, 12)];
        countTextLabel.font = TEXTFONTSMALL;
        countTextLabel.text = @"数量:";//这不用空格,宽度40控制
        countTextLabel.textColor = [UIColor grayColor];
        [mainView addSubview:countTextLabel];
        //数量数字
        self.countLabel = [[UILabel alloc] initWithFrame:CGRectMake(130, 54, 80, 12)];
        countLabel.font = TEXTFONTSMALL;
        countLabel.textColor = [UIColor redColor];
        [mainView addSubview:countLabel];
        
        //总价
        UILabel *totalPriceText = [[UILabel alloc] initWithFrame:CGRectMake(90, 69, 40, 15)];
        totalPriceText.font = [UIFont systemFontOfSize:13];
        totalPriceText.text = @"总价:  ";
        totalPriceText.textColor = [UIColor grayColor];
        [mainView addSubview:totalPriceText];
        //总价数字
        self.totalPrice = [[UILabel alloc] initWithFrame:CGRectMake(130, 69, 80, 15)];
        totalPrice.font = [UIFont systemFontOfSize:13];
        totalPrice.textColor = [UIColor redColor];
        [mainView addSubview:totalPrice];
        
        //店铺
        UILabel *shopText = [[UILabel alloc] initWithFrame:CGRectMake(90, 86, 40, 12)];
        shopText.font = [UIFont systemFontOfSize:13];
        shopText.text = @"店铺:  ";
        shopText.textColor = [UIColor grayColor];
        [mainView addSubview:shopText];
        //店铺名称
        self.shopName = [[UILabel alloc] initWithFrame:CGRectMake(130, 86, 80, 12)];
        shopName.font = [UIFont systemFontOfSize:13];
        [mainView addSubview:shopName];
        
        //说明,
        /*----在调用页面修改----
        stepper显示时woodsLabel高度38,2行,timeLb隐藏,selectDateBtn隐藏,
        stepper隐藏时woodsLabel高度25,1行,timeLb显示,selectDateBtn显示,
         */
        
        // + - 按钮
        stepper = [[UIStepper alloc]initWithFrame:CGRectMake(220, 50, 50, 30)];
        [stepper sizeToFit];
        [mainView addSubview:stepper];
        [stepper addTarget:self action:@selector(stepperAction:) forControlEvents:UIControlEventValueChanged];

        timeView = [[UIView alloc] initWithFrame:CGRectMake(210, 39, 100, 60)];
        [mainView addSubview:timeView];
        //timeLb.userInteractionEnabled = YES;
        
        
        UILabel *arriveTimeValueLb = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 105, 25)];
        [timeView addSubview:arriveTimeValueLb];
        arriveTimeValueLb.userInteractionEnabled = YES;
        arriveTimeValueLb.font = TEXTFONTSMALL;
        arriveTimeValueLb.textAlignment = NSTextAlignmentCenter;
        arriveTimeValueLb.layer.borderWidth = 0.6;
        arriveTimeValueLb.text = @"点击选择抵达时间";
        
        UILabel *leaveTimeValueLb = [[UILabel alloc] initWithFrame:CGRectMake(0, 35, 105, 25)];
        [timeView addSubview:leaveTimeValueLb];
        leaveTimeValueLb.userInteractionEnabled = YES;
        leaveTimeValueLb.font = TEXTFONTSMALL;
        leaveTimeValueLb.textAlignment = NSTextAlignmentCenter;
        leaveTimeValueLb.layer.borderWidth = 0.6;
        leaveTimeValueLb.text = @"点击选择离开时间";
        
        
        //底边线
        UILabel *bottom = [[UILabel alloc] initWithFrame:CGRectMake(0, 99, MAINSCREEN_WIDTH, 1)];
        bottom.backgroundColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:0.8];
        [mainView addSubview:bottom];
        [self.contentView addSubview:mainView];
        
    }
    return self;
}

- (void)stepperAction:(id)sender {
    UIStepper *st = (UIStepper *)sender;
    int selfCount = [[NSString stringWithFormat:@"%0.0f",st.value] intValue];
    countLabel.text = [NSString stringWithFormat:@"%d",selfCount];
    //自己总价
    totalPrice.text = [NSString stringWithFormat:@"¥ %0.2f",selfCount*[unitPrice.text floatValue]];
    //object 和 userInfo都可以传值,把当前的  cell传过去,当前cell  商品不是自营店商品,计算总价
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reCalculateTotal" object:self];
}
@end
