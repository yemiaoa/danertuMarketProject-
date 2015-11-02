//
//  NoItemView.m
//  单耳兔
//
//  Created by yang on 15/8/27.
//  Copyright (c) 2015年 珠海单耳兔电子商务有限公司. All rights reserved.
//
//tableview 没有数据时,出现的提示界面
#import "NoItemView.h"

@implementation NoItemView//
- (id)initWithY:(float)y Image:(UIImage *)tipImage mes:(NSString *)message{
    self = [super initWithFrame:CGRectMake(0, y, MAINSCREEN_WIDTH, 150)];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        UIImageView *noItemImage = [[UIImageView alloc] initWithFrame:CGRectMake((MAINSCREEN_WIDTH-100)/2, 0, 100, 100)];
        [self addSubview:noItemImage];
        noItemImage.backgroundColor = [UIColor clearColor];
        [noItemImage setImage:tipImage];
        //文字
        UILabel *noItemLabel = [[UILabel alloc] initWithFrame:CGRectMake((MAINSCREEN_WIDTH-200)/2, 110, 200, 20)];
        [self addSubview:noItemLabel];
        [noItemLabel setBackgroundColor:[UIColor clearColor]];
        [noItemLabel setTextAlignment:NSTextAlignmentCenter];
        [noItemLabel setTextColor:[UIColor grayColor]];
        [noItemLabel setText:message];
    }
    return self;
}
@end
