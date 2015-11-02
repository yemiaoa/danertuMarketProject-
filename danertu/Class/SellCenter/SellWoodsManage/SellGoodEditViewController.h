//
//  SellGoodEditViewController.h
//  单耳兔
//
//  Created by yang on 15/7/6.
//  Copyright (c) 2015年 珠海单耳兔电子商务有限公司. All rights reserved.
//

#import "TopNaviViewController.h"
#import "DelMenuItem.h"

typedef enum {
    SellGood_Edity,
    SellGood_Add,
} SellGoodEditStytle;
@interface SellGoodEditViewController : TopNaviViewController<UINavigationControllerDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UITextFieldDelegate,UITextViewDelegate,MenuItemDelegate>
@property (nonatomic,assign) SellGoodEditStytle currentStyle;
@property (nonatomic,strong) NSDictionary *editGoodsDic;

- (void) enableEditingMode;
@end
