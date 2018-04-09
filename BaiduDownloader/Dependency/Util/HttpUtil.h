//
//  HttpUtil.h
//  BaiduDownloader
//
//  Created by zll on 2018/3/19.
//  Copyright © 2018年 Godlike Studio. All rights reserved.
//

#import <Foundation/Foundation.h>

#define __UD__ [NSUserDefaults standardUserDefaults]
#define __UDGET__(o) [__UD__ objectForKey:o]
#define __UDSET__(k,v) [__UD__ setObject:v forKey:k]
#define __UDSYNC__ [__UD__ synchronize]
#define __UDREMOVE__(k) [[NSUserDefaults standardUserDefaults] removeObjectForKey:k]


#define __HEADV__(o,k) ((NSHTTPURLResponse *)o).allHeaderFields[k]
#define __SETCOOKIE__(o) ((NSHTTPURLResponse *)o).allHeaderFields[@"Set-Cookie"]

#define __MREGEX__(string, regex) [string matchWithRegex:regex];
#define __VREGEX__(string, keyword, suffix) [string stringByKeyWord:keyword withSuffix:suffix]

#define __RD__(o) [[NSString alloc] initWithData:o encoding:NSUTF8StringEncoding]
#define __JSONDIC__(o) [NSJSONSerialization JSONObjectWithData:o options:NSJSONReadingMutableContainers error:nil];

@interface HttpUtil : NSObject

+ (NSString *)currentTimestamp;

+ (NSString *)currentMilliTimestamp;

+ (NSString *)currentTimestampDelay:(long long)delay;

+ (NSString *)currentMilliTimestampDelay:(long long)delay;

+ (NSString *)URLParamsString:(NSDictionary *)dic;

+ (NSString *)URLEncodedString:(NSString *)str;

+ (NSString *)URLDecodedString:(NSString *)str;

+ (void)request:(NSString *)url
         method:(NSString *)mothod
        headers:(NSDictionary *)headers
         params:(NSDictionary *)params
     completion:(void (^)(NSURLResponse *response, id responseObject,  NSError * error))completion;

@end
