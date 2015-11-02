//
//  MyKeyChainHelper.m
//  KeyChainDemo
//
//  Created by 倪敏杰 on 12-7-8.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MyKeyChainHelper.h"

@implementation MyKeyChainHelper

+ (NSMutableDictionary *)getKeyChainQuery:(NSString *)service {  
    return [NSMutableDictionary dictionaryWithObjectsAndKeys:  
            (__bridge id)kSecClassGenericPassword,(__bridge id)kSecClass,
            service, (__bridge id)kSecAttrService,
            service, (__bridge id)kSecAttrAccount,  
            (id)CFBridgingRelease(kSecAttrAccessibleAfterFirstUnlock),(id)CFBridgingRelease(kSecAttrAccessible),  
            nil];
}  

+ (void) saveUserName:(NSString*)userName 
      userNameService:(NSString*)userNameService 
             psaaword:(NSString*)pwd 
      psaawordService:(NSString*)pwdService
{
    NSMutableDictionary *keychainQuery = [self getKeyChainQuery:userNameService];  
    SecItemDelete((CFDictionaryRef)CFBridgingRetain(keychainQuery));  
    [keychainQuery setObject:[NSKeyedArchiver archivedDataWithRootObject:userName] forKey:(__bridge id)kSecValueData];  
    SecItemAdd((__bridge CFDictionaryRef)keychainQuery, NULL); 
    
    keychainQuery = [self getKeyChainQuery:pwdService];  
    SecItemDelete((__bridge CFDictionaryRef)keychainQuery);  
    [keychainQuery setObject:[NSKeyedArchiver archivedDataWithRootObject:pwd] forKey:(__bridge id)kSecValueData];  
    SecItemAdd((__bridge CFDictionaryRef)keychainQuery, NULL); 
}

+ (void) deleteWithUserNameService:(NSString*)userNameService 
                   psaawordService:(NSString*)pwdService
{
    NSMutableDictionary *keychainQuery = [self getKeyChainQuery:userNameService];  
    SecItemDelete((__bridge CFDictionaryRef)keychainQuery); 
    
    keychainQuery = [self getKeyChainQuery:pwdService];  
    SecItemDelete((__bridge CFDictionaryRef)keychainQuery); 
}

+ (NSString*) getUserNameWithService:(NSString*)userNameService
{
    NSString* ret = nil;  
    NSMutableDictionary *keychainQuery = [self getKeyChainQuery:userNameService];  
    [keychainQuery setObject:(id)kCFBooleanTrue forKey:(__bridge id)kSecReturnData];  
    [keychainQuery setObject:(__bridge id)kSecMatchLimitOne forKey:(__bridge id)kSecMatchLimit];  
    CFDataRef keyData = NULL;  
    if (SecItemCopyMatching((__bridge CFDictionaryRef)keychainQuery, (CFTypeRef *)&keyData) == noErr) 
    {  
        @try 
        {  
            ret = [NSKeyedUnarchiver unarchiveObjectWithData:(__bridge NSData *)keyData];  
        } 
        @catch (NSException *e) 
        {  
            NSLog(@"Unarchive of %@ failed: %@", userNameService, e);  
        }
        @finally 
        {  
        }  
    }  
    if (keyData)   
        CFRelease(keyData);  
    return ret; 
}

+ (NSString*) getPasswordWithService:(NSString*)pwdService
{
    NSString* ret = nil;  
    NSMutableDictionary *keychainQuery = [self getKeyChainQuery:pwdService];  
    [keychainQuery setObject:(id)kCFBooleanTrue forKey:(__bridge id)kSecReturnData];  
    [keychainQuery setObject:(__bridge id)kSecMatchLimitOne forKey:(__bridge id)kSecMatchLimit];  
    CFDataRef keyData = NULL;  
    if (SecItemCopyMatching((__bridge CFDictionaryRef)keychainQuery, (CFTypeRef *)&keyData) == noErr) 
    {
        @try 
        {  
            ret = [NSKeyedUnarchiver unarchiveObjectWithData:(__bridge NSData *)keyData];  
        } 
        @catch (NSException *e) 
        {  
            NSLog(@"Unarchive of %@ failed: %@", pwdService, e);  
        }
        @finally 
        {  
        }  
    }  
    if (keyData)   
        CFRelease(keyData);  
    return ret;
}
@end
