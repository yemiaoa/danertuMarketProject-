//
//  GridViewCell.m
//  AQGridViewDemo
//
//  Created by 夏 华 on 12-6-26.
//  Copyright (c) 2012年 无锡恩梯梯数据有限公司. All rights reserved.
//

#import "CommentViewCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation CommentViewCell
@synthesize imageView, contentLabel,lineLabel,clientLabel,dateLabel;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIView *mainView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MAINSCREEN_WIDTH, 100)];
        [mainView setBackgroundColor:[UIColor clearColor]];
        //用户id
        self.clientLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 100, 20)];
        clientLabel.font = [UIFont systemFontOfSize:16];
        
        [mainView addSubview:clientLabel];//
        //评价星级
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(150, 10, 100, 20)];//商品图片
        [mainView addSubview:imageView];
        //评论内容
        self.contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 30, 280, 50)];
        contentLabel.font = [UIFont systemFontOfSize:14];
        contentLabel.numberOfLines = 3;
        contentLabel.lineBreakMode = NSLineBreakByCharWrapping;
        [mainView addSubview:contentLabel];

        //评论时间
        self.dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 80, 280, 20)];
        dateLabel.font = [UIFont systemFontOfSize:14];
        dateLabel.textColor = [UIColor grayColor];
        [mainView addSubview:dateLabel];
        
        //线条
        lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 99.4, 280, 0.6)];
        lineLabel.backgroundColor = [UIColor grayColor];
        [mainView addSubview:lineLabel];
        [self.contentView addSubview:mainView];
    }
    return self;
}

@end
