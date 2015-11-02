//
//  NTalkerMainParam.h
//  CustomerServerSDK2
//
//  Created by NTalker on 15/6/6.
//  Copyright (c) 2015年 NTalker. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>



@interface NTalkerMainParam : NSObject

//#define SOUFUNDEBUG
//
////宏输出函数
//#ifdef SOUFUNDEBUG
//#define SFun_Log(fmt, ...) NSLog((@"%s," "[lineNum:%d]" fmt) , __FUNCTION__, __LINE__, ##__VA_ARGS__); //带函数名和行数
//#define SL_Log(fmt, ...) NSLog((@"===[lineNum:%d]" fmt), __LINE__, ##__VA_ARGS__);  //带行数
//#define SC_Log(fmt, ...) NSLog((fmt), ##__VA_ARGS__); //不带函数名和行数
//#else
//#define SFun_Log(fmt, ...);
//#define SL_Log(fmt, ...);
//#define SC_Log(fmt, ...);
//#endif

//#define NTalkDEBUG

#ifdef NTalkDEBUG
#define DLog( s, ... ) NSLog( @"<%p %@:(%d)> %@", self, [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__] )
#else
#define DLog( s, ... )
#endif


#define IOS7 [[UIDevice currentDevice].systemVersion doubleValue] >= 7.0

//设置NavigationBar背景颜色
#define ntalker_navigationBarColor  [UIColor colorWithRed:248/255.0 green:248/255.0 blue:248/255.0 alpha:1.0]

//#define ntalker_navigationBarColor  [UIColor colorWithRed:124.95/255.0 green:186.15/255.0 blue:53.55/255.0 alpha:1.0]

//设置连接提示背景颜色
#define ntalker_BackgroundviewColor [UIColor colorWithRed:251/255.0 green:242/255.0 blue:219/255.0 alpha:1.0]
//设置NavigationBar  Title字体颜色
#define ntalker_navigationBarTitleColor  [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0]

//#define ntalker_navigationBarTitleColor  [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0]
//留言提交按钮
#define leaveMesagerightItemButtonColor             [UIColor colorWithRed:13/255.0 green:94/255.0 blue:250/255.0 alpha:1.0]
//留言界面背景
#define leaveMesageBackGroundColor             [UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1.0]

//inputTextView  picLabel  cameraLabel  usefulLabel  evaluationLabel titleImage
#define ntalker_textColor                [UIColor colorWithRed:34/255.0 green:34/255.0 blue:34/255.0 alpha:1.0]
//recordButton  lineView
#define ntalker_textColor2               [UIColor colorWithRed:136/255.0 green:136/255.0 blue:136/255.0 alpha:1.0]
//lineView1  lineView2   lineView3
#define ntalker_lineColor                [UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1.0]
#define ntalker_viewBackGroundColor      [UIColor whiteColor]
//聊天界面背景色
//#define chatBackgroundColor              [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1.0]
#define chatBackgroundColor              [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0]

#define listCellContentTextSelectedColor [UIColor blueColor]
#define chatItemTimeLine                 [UIColor colorWithRed:225/255.0 green:225/255.0 blue:225/255.0 alpha:1.0]

#define chatFunctionBackgroundColor      [UIColor colorWithRed:250/255.0 green:250/255.0 blue:250/255.0 alpha:1.0]

#define chatCommentTitleColor            [UIColor blackColor]
#define chatCommentCancelBtnColor        [UIColor colorWithRed:21/255.0 green:126/255.0 blue:251/255.0 alpha:1.0]
#define chatCommentOkBtnColor            [UIColor colorWithRed:21/255.0 green:126/255.0 blue:251/255.0 alpha:1.0]
#define chatCommentItemColor             [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0]
#define chatCommentItemSelectedColor     [UIColor colorWithRed:21/255.0 green:126/255.0 blue:251/255.0 alpha:1.0]
#define chatListCellLineViewColor        [UIColor colorWithRed:207/255.0 green:210/255.0 blue:213/255.0 alpha:0.7]

@property (nonatomic,strong)NSString *pcid;

+(NTalkerMainParam *)shareInstance;

+ (NSString *)getDeviceUUID;
@end
