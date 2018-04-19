//
//  NSArray+Unicode.m
//  BaiduDownloader
//
//  Created by Yuri Boyka on 2018/4/3.
//  Copyright © 2018 Godlike Studio. All rights reserved.
//

#import "NSArray+Unicode.h"

@implementation NSArray (Unicode)

-(NSString *)descriptionWithLocale:(id)locale
{
    NSMutableString *string = [NSMutableString string];
    // 开头有个[
    [string appendString:@"[\n"];
    // 遍历所有的元素
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [string appendFormat:@"\t%@,\n", obj];
    }];
    // 结尾有个]
    [string appendString:@"]"];
    // 查找最后一个逗号
    NSRange range = [string rangeOfString:@"," options:NSBackwardsSearch];
    if (range.location != NSNotFound)
        [string deleteCharactersInRange:range];
    return string;
}

@end
