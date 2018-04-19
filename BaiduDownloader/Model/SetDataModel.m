//
//  SetDataModel.m
//  BaiduDownloader
//
//  Created by Yuri Boyka on 26/03/2018.
//  Copyright © 2018 Godlike Studio. All rights reserved.
//

#import "SetDataModel.h"

@implementation Thumb

@end

@implementation FileModel

@end

@implementation ListModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"thumbs" : [Thumb class]};
}
@end

@implementation FileListModel
+ (NSArray *)modelPropertyBlacklist {
    return @[@"request_id", @"server_time"];
}

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
