//
//  NSObject+DebugDescription.m
//  BaiduDownloader
//
//  Created by zll on 2018/4/4.
//  Copyright © 2018 Godlike Studio. All rights reserved.
//

#import "NSObject+DebugDescription.h"
#import <objc/runtime.h>

@implementation NSObject (DebugDescription)

//- (NSString *)debugDescription
//{
//    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
//    uint count;
//    objc_property_t *properties = class_copyPropertyList([self class], &count);
//    for (int i = 0; i < count; i++) {
//        objc_property_t property = properties[i];
//        NSString *name = @(property_getName(property));
//        id value = [self valueForKey:name]?:@"nil";
//        [dic setObject:value forKey:name];
//    }
//    free(properties);
//    return [NSString stringWithFormat:@"%@ : %p\n> -- %@",[self class],self, dic];
//}

@end
