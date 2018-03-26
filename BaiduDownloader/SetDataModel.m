//
//  SetDataModel.m
//  BaiduDownloader
//
//  Created by zll on 26/03/2018.
//  Copyright © 2018 Godlike Studio. All rights reserved.
//

#import "SetDataModel.h"

@implementation ListModel

@end

@implementation FileListModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"list" : [ListModel class]};
}

//返回一个 Dict，将 Model 属性名对映射到 JSON 的 Key。
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"err" : @"errno"};
}
@end

@implementation SetDataModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"desc" : @"description", @"celf":@"self", @"publik":@"public"};
}
@end
