//
//  SubStoreCell.m
//  单耳兔
//
//  Created by yang on 15/9/2.
//  Copyright (c) 2015年 珠海单耳兔电子商务有限公司. All rights reserved.
//

#import "SubStoreCell.h"

@implementation SubStoreCell
@synthesize shopName,wineCount;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.backgroundColor = [UIColor clearColor];
        
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MAINSCREEN_WIDTH, 45)];
        [self addSubview:bgView];
        [bgView setBackgroundColor:[UIColor whiteColor]];
        
        shopName = [[UILabel alloc] initWithFrame:CGRectMake(10, 13, MAINSCREEN_WIDTH-100, 20)];
        [self addSubview:shopName];
        [shopName setFont:[UIFont systemFontOfSize:16]];
        
        UILabel *tip = [[UILabel alloc] initWithFrame:CGRectMake(MAINSCREEN_WIDTH-33, 13, 20, 20)];
        [self addSubview:tip];
        [tip setFont:TEXTFONT];
        tip.text = @"瓶";
        
        wineCount = [[UILabel alloc] initWithFrame:CGRectMake(MAINSCREEN_WIDTH-135, 6, 100, 30)];
        [self addSubview:wineCount];
        [wineCount setFont:[UIFont systemFontOfSize:24]];
        wineCount.textColor = TOPNAVIBGCOLOR;
        wineCount.textAlignment = NSTextAlignmentRight;
    }
    return self;
}
@end
