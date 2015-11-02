//
//  Tools.m
//  danertu
//
//  Created by 何栋明 on 15/5/25.
//  Copyright (c) 2015年 danertu. All rights reserved.
//  工具类，实现一些协助类的方法

#import "Tools.h"
#import "MyKeyChainHelper.h"
#import "KKAppDelegate.h"
#include <sys/xattr.h>

@implementation Tools

//判断当前用户是否已经登录
+ (BOOL)isUserHaveLogin
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *userInfo = [defaults objectForKey:@"userLoginInfo"];
    if (userInfo) {
        //如果有个人信息，代表已经登录
        return YES;
    }
    return NO;
}

//判断用户是否切换账号
+ (BOOL)isUserAccountChanged{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *currentAccount = [[defaults valueForKey:@"userLoginInfo"] valueForKey:@"MemLoginID"];
    NSString *oldAccount     = [defaults valueForKey:@"OldUserAccountKey"];
    if ([currentAccount isEqualToString:oldAccount]) {
        return NO;
    }
    return YES;
}
//初始化推送服务
+ (void)initPush
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *account = [[defaults objectForKey:@"userLoginInfo"] objectForKey:@"MemLoginID"];//本地存储;
    if (account == nil) {
        account = DEFAULTPUSHTAG;
    }
    NSArray *objectarray = [NSArray arrayWithObject:account];
    KKAppDelegate *appdelegate = (KKAppDelegate *)[[UIApplication sharedApplication] delegate];
    [APService setTags:[[NSSet alloc] initWithArray:objectarray] alias:account callbackSelector:@selector(tagsAliasCallback:tags:alias:) object:appdelegate];
    
}

//判断是否泉眼的商品
+ (BOOL)isSpringGoodsWithDic:(NSDictionary *)woodDic
{
    BOOL isAllSpringGoods = YES;
    NSString *path=[[NSBundle mainBundle] pathForResource:@"springHotelGuid" ofType:@"plist"];
    //取得sortednames.plist绝对路径
    //sortednames.plist本身是一个NSDictionary,以键-值的形式存储字符串数组
    
    NSDictionary *guidDic=[[NSDictionary alloc] initWithContentsOfFile:path];
    //温泉,客房的guid写到这里--------
    NSArray *hotelGuidArr = [guidDic objectForKey:@"hotelGuidArr"];
    //温泉客房商品
    if([[woodDic objectForKey:@"SupplierLoginID"] isEqualToString:SPRINGSUPPLIERID]){
        //生成商品本身的------guid
        NSString *guidTmp = [[woodDic objectForKey:@"Guid"] substringToIndex:36];
        if ([hotelGuidArr indexOfObject:guidTmp]!= NSNotFound) {
            isAllSpringGoods = YES;
        }
    }else{
        isAllSpringGoods = NO;//不全都是温泉客房的产品----有其他产品---不能使用  到付
    }
    return isAllSpringGoods;
}

+ (NSString *)getDeviceUUid
{
    NSString *libraryfolderPath = [NSHomeDirectory() stringByAppendingString:@"/Library"];
    NSString *myPath = [libraryfolderPath stringByAppendingPathComponent:@"DanertuDocument"];
    NSFileManager *fm = [NSFileManager defaultManager];
    if (![fm fileExistsAtPath:myPath]) {
        [fm createDirectoryAtPath:myPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSString *documentString = [myPath stringByAppendingPathComponent:@"UserData"];
    if(![fm fileExistsAtPath:documentString])
    {
        [fm createDirectoryAtPath:documentString withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSString *uuidPath = [documentString stringByAppendingPathComponent:@"uuid.plist"];
    NSDictionary *uuidDic = [[NSDictionary alloc] initWithContentsOfFile:uuidPath];
    NSString *uuid = [uuidDic objectForKey:@"uuid"];
    if (uuidDic && uuid) {
        
        return uuid;
    }
    Class cls = NSClassFromString(@"UMANUtil");
    SEL deviceIDSelector = @selector(openUDIDString);
    NSString *deviceID = nil;
    if(cls && [cls respondsToSelector:deviceIDSelector]){
        deviceID = [cls performSelector:deviceIDSelector];
    }
    uuidDic = [[NSDictionary alloc] initWithObjectsAndKeys:deviceID,@"uuid", nil];
    [uuidDic writeToFile:uuidPath atomically:YES];
    return deviceID;
}

+ (NSString *)getPlatformInfo
{
    return @"ios";
}

+ (NSString *)getCurrentTime
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateTime = [formatter stringFromDate:[NSDate date]];
    return dateTime;
}

+ (int)addFileSkipBackupAttribute: (NSString*) filePath
{
    NSURL* url = [NSURL fileURLWithPath:filePath];
    const char* fileSysPath = [[url path] fileSystemRepresentation];
    const char* attrName = "com.apple.MobileBackup";
    u_int8_t attrValue = 1;
    return setxattr(fileSysPath, attrName, &attrValue, sizeof(attrValue), 0, 0);
}

+ (void)canceliClouldBackup
{
    NSFileManager *manager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *plistPath1 = [paths objectAtIndex:0];
    NSFileManager *fm = [NSFileManager defaultManager];
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:plistPath1] objectEnumerator];
    NSString* fileName;
    while ((fileName = [childFilesEnumerator nextObject]) != nil){
        NSString* fileAbsolutePath = [plistPath1 stringByAppendingPathComponent:fileName];
        if ([fm fileExistsAtPath:fileAbsolutePath])
        {
            NSURL *myurl = [NSURL fileURLWithPath:fileAbsolutePath];
            [self addSkipBackupAttributeToItemAtURL:myurl];
        }
        NSURL *myurl = [NSURL fileURLWithPath:fileAbsolutePath];
        [self addSkipBackupAttributeToItemAtURL:myurl];
        
    }
    
    NSString *libraryfolderPath = [NSHomeDirectory() stringByAppendingString:@"/Library"];
    childFilesEnumerator = [[manager subpathsAtPath:libraryfolderPath] objectEnumerator];
    while ((fileName = [childFilesEnumerator nextObject]) != nil){
        NSString* fileAbsolutePath = [libraryfolderPath stringByAppendingPathComponent:fileName];
        if ([fm fileExistsAtPath:fileAbsolutePath])
        {
            NSURL *myurl = [NSURL fileURLWithPath:fileAbsolutePath];
            [self addSkipBackupAttributeToItemAtURL:myurl];
        }
    }
}

//IOS5或者以上的版本处理不备份都iCloud的方法
+ (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL
{
    assert([[NSFileManager defaultManager] fileExistsAtPath: [URL path]]);
    NSError *error = nil;
    BOOL success = [URL setResourceValue: [NSNumber numberWithBool: YES]
                                  forKey: NSURLIsExcludedFromBackupKey error: &error];
    if(!success){
        NSLog(@"Error excluding %@ from backup %@", [URL lastPathComponent], error);
    }
    return success;
}

+ (void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}

+ (NSString *)deleteErrorStringInString:(NSString *)inputString
{
    NSMutableString *mutablestring = [[NSMutableString alloc] initWithString:inputString];
    BOOL haveError = YES;
    //先记录mutablestring的长度，如果每次调用[mutablestring length]，会加长搜索时间
    NSUInteger length = [mutablestring length] - 1;
    NSRange searchRange = NSMakeRange(0, length);
    
    while (haveError && searchRange.length > 0 && searchRange.length + searchRange.location <= [mutablestring length]) {
        NSRange range = [mutablestring rangeOfString:@"\n" options:NSCaseInsensitiveSearch range:searchRange]; //去除特殊字符
        if (range.length != 0) {
            range.location = range.location - 1;
            range.length = 2;
            length = length - range.length;
            [mutablestring replaceCharactersInRange:range withString:@""];
            searchRange.location = range.location;
            searchRange.length = length - searchRange.location;
        }
        else{
            haveError = NO;
        }
    }
    NSString *outPutString = [[NSString alloc] initWithFormat:@"%@",mutablestring];
    return outPutString;
}

+ (NSString *)deleteErrorStringInData:(NSData *)inputData
{
    NSString *temp = [[NSString alloc] initWithData:inputData encoding:NSUTF8StringEncoding];
    temp = [temp stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    temp = [temp stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    //留意20150918曾经删除
//    temp = [temp stringByReplacingOccurrencesOfString:@"\\" withString:@"\\\\"];
    temp = [temp stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    temp = [temp stringByReplacingOccurrencesOfString:@"&" withString:@""];
    temp = [temp stringByReplacingOccurrencesOfString:@"•	" withString:@""];
    
    return temp;
}

+ (NSString *)replaceUnicode:(NSString *)unicodeStr{
    NSString *tempStr1 = [unicodeStr stringByReplacingOccurrencesOfString:@"\\u" withString:@"\\U"];
    NSString *tempStr2 = [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3 = [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString* returnStr = [NSPropertyListSerialization propertyListFromData:tempData
                                                           mutabilityOption:NSPropertyListImmutable
                                                                     format:NULL
                                                           errorDescription:NULL];
    
    return [returnStr stringByReplacingOccurrencesOfString:@"\\r\\n"withString:@"\n"];

}

+ (UIImage *)thumbnailWithImage:(UIImage *)image size:(CGSize)asize
{
    UIImage *newimage;
    if (nil == image) {
        newimage = nil;
    }
    else{
        CGSize oldsize = image.size;
        CGRect rect;
        if (asize.width/asize.height > oldsize.width/oldsize.height) {
            rect.size.width = asize.height*oldsize.width/oldsize.height;
            rect.size.height = asize.height;
            rect.origin.x = (asize.width - rect.size.width)/2;
            rect.origin.y = 0;
        }
        else{
            rect.size.width = asize.width;
            rect.size.height = asize.width*oldsize.height/oldsize.width;
            rect.origin.x = 0;
            rect.origin.y = (asize.height - rect.size.height)/2;
        }
        UIGraphicsBeginImageContext(asize);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(context, [[UIColor clearColor] CGColor]);
        UIRectFill(CGRectMake(0, 0, asize.width, asize.height));//clear background
        newimage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    return newimage;
}

+ (NSString *)deleStringWithGuid:(NSString *)guid
{
    NSString *tempGuid;
    NSRange range = [guid rangeOfString:@"_*_"];
    if (range.length != 0) {
        tempGuid = [guid substringToIndex:range.location];
    }
    else{
        tempGuid = guid;
    }
    return tempGuid;
}
//判断温泉客房
+ (BOOL)isSpringHotelTicketWithInfo:(NSDictionary *)goodInfo{
    NSString *path=[[NSBundle mainBundle] pathForResource:@"springHotelGuid" ofType:@"plist"];
    //取得sortednames.plist绝对路径
    //sortednames.plist本身是一个NSDictionary,以键-值的形式存储字符串数组
    
    NSDictionary *guidDic=[[NSDictionary alloc] initWithContentsOfFile:path];
    //温泉,客房的guid写到这里--------
    NSArray *hotelGuidArr = [guidDic objectForKey:@"hotelGuidArr"];
    
    NSString *guidTmp = [[goodInfo objectForKey:@"Guid"] substringToIndex:36];
    
    //温泉客房商品
    if([[goodInfo objectForKey:@"SupplierLoginID"] isEqualToString:SPRINGSUPPLIERID]){
        for (NSString *guidString in hotelGuidArr) {
            if ([guidTmp compare:guidString options:NSCaseInsensitiveSearch] == NSOrderedSame) {
                return YES;
            }
        }
        return NO;
    }else{
        return NO;
    }
}

//判断温泉门票
+ (BOOL)isSpringTicketWithGuid:(NSString *)guid{
    NSRange range = [guid rangeOfString:@"_*_"];
    if (range.length != 0) {
        guid = [guid substringToIndex:range.location];
    }
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"SpringTicket" ofType:@"plist"];
    NSArray *array = [[NSArray alloc] initWithContentsOfFile:filePath];
    for (NSString *guidString in array) {
        if ([guid compare:guidString options:NSCaseInsensitiveSearch] == NSOrderedSame) {
            return YES;
        }
    }
    return NO;
}

+ (BOOL)isSpringHotelWithGuid:(NSString *)guid
{
    NSRange range = [guid rangeOfString:@"_*_"];
    if (range.length != 0) {
        guid = [guid substringToIndex:range.location];
    }
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"SpringTicket" ofType:@"plist"];
    NSArray *array = [[NSArray alloc] initWithContentsOfFile:filePath];
    for (NSString *guidString in array) {
        if ([guid compare:guidString options:NSCaseInsensitiveSearch] == NSOrderedSame) {
            return NO;
        }
    }
    return YES;
}

+ (BOOL)recordBindShopWithShareNumber:(NSString *)sharenumber shopid:(NSString *)shopid
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString * userName = [[defaults objectForKey:@"userLoginInfo"] objectForKey:@"MemLoginID"];//本地存储
    if (userName == nil || [userName isEqualToString:@""]) {
        userName = @"";
    }
    NSString *key = @"specialUserKey";
    NSString *deviceID = [Tools getDeviceUUid];
    NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:userName,@"userName",shopid,@"shopid",sharenumber,@"sharenumber",deviceID,@"deviceID", nil];
    [defaults setObject:dict forKey:key];
    return YES;
}

+ (NSString *)getUserLoginNumber
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString * userName = [[userDefault objectForKey:@"userLoginInfo"] objectForKey:@"MemLoginID"];//本地存储
    return userName;
}

+ (NSString *)getGoodsImageUrlWithData:(NSDictionary *)tempDic{
    
    NSString *imageUrl = @"";
    NSString *url = [tempDic valueForKey:@"SmallImage"];
    if (![[tempDic valueForKey:@"SupplierLoginID"] isEqualToString:@""]) {
        //供应商
        imageUrl = [NSString stringWithFormat:@"%@%@/%@" ,SUPPLIERPRODUCT,[tempDic valueForKey:@"SupplierLoginID"],url];
    }else if (![[tempDic valueForKey:@"AgentID"] isEqualToString:@""]){
        //代理商
        imageUrl = [NSString stringWithFormat:@"%@%@/%@" ,MEMBERPRODUCT,[tempDic valueForKey:@"AgentID"],url];
    }else{
        //平台
        imageUrl = [NSString stringWithFormat:@"%@%@" ,DANERTUPRODUCT,url];
        if ([url hasPrefix:@"/ImgUpload/"]) {
            url = [url stringByReplacingOccurrencesOfString:@"/ImgUpload/" withString:@""];
            imageUrl = [NSString stringWithFormat:@"%@%@" ,DANERTUPRODUCT,url];
        }
    }
    return imageUrl;
}

//获取app的版本号
+ (NSString *)getAppVersion
{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
}

@end
