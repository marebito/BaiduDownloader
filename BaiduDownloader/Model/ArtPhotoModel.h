//
//  ArtPhotoModel.h
//  BaiduDownloader
//
//  Created by zll on 2018/5/10.
//  Copyright © 2018 Godlike Studio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PhotoSetsModel : NSObject

@property (nonatomic, copy) NSString *setsNo;           // 套图编号

@property (nonatomic, copy) NSString *setsSize;         // 套图尺寸

@property (nonatomic, copy) NSString *setsFileSize;     // 套图大小

@property (nonatomic, copy) NSString *decompressPswd;   // 解压密码

@property (nonatomic, strong) NSArray *previewImages;   // 套图预览

@property (nonatomic, copy) NSString *link;             // 链接

+ (instancetype)modelWithElement:(ONOXMLElement *)element;

@end

@interface ArtPhotoModel : NSObject

@property(nonatomic, copy) NSString *typeName;

@property(nonatomic, copy) NSString *typeURL;

@property(nonatomic, copy) NSString *title;

@property(nonatomic, strong) PhotoSetsModel *photoSets;

@property(nonatomic, copy) NSString *time;

+ (instancetype)modelWithElement:(ONOXMLElement *)element;

@end
