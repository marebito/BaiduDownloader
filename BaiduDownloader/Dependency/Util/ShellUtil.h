//
//  ShellUtil.h
//  BaiduDownloader
//
//  Created by zll on 2018/4/24.
//  Copyright © 2018年 Godlike Studio. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^ShellOutput)(NSString *result);

@interface ShellUtil : NSObject

+ (void)executeShell:(NSString *)cmd args:(NSArray *)args;

@end
