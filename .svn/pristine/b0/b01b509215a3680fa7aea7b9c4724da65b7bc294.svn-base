//
//  FavoriteShopCell.m
//  单耳兔
//
//  Created by yang on 15/8/27.
//  Copyright (c) 2015年 珠海单耳兔电子商务有限公司. All rights reserved.
//

#import "FavoriteShopCell.h"

@implementation FavoriteShopCell
@synthesize shopImage,shopName,woodsLabel,addLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        shopImage = [[AsynImageView alloc] initWithFrame:CGRectMake(5, 5, 80, 80)];//135
        [shopImage setPlaceholderImage:[UIImage imageNamed:@"noData1"]];
        shopImage.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:shopImage];
        
        shopName = [[UILabel alloc] initWithFrame:CGRectMake(100, 10, 150, 18)];
        shopName.font = [UIFont fontWithName:@"Helvetica-Bold" size:17];
        shopName.backgroundColor = [UIColor clearColor];
        [self addSubview:shopName];
        
        woodsLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 30, 190, 20)];
        woodsLabel.backgroundColor = [UIColor clearColor];
        woodsLabel.font = [UIFont systemFontOfSize:15];
        woodsLabel.numberOfLines = 2;
        [self addSubview:woodsLabel];
        
        addLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 50, 190, 40)];
        addLabel.font = TEXTFONT;
        addLabel.backgroundColor = [UIColor clearColor];
        addLabel.textColor = [UIColor grayColor];
        addLabel.numberOfLines = 2;
        [self addSubview:addLabel];
        
    }
    return self;
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
