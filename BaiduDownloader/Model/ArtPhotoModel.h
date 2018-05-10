//
//  ArtPhotoModel.h
//  BaiduDownloader
//
//  Created by zll on 2018/5/10.
//  Copyright © 2018 Godlike Studio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PhotoSetsModel : NSObject

@property(nonatomic, copy) NSString *setsNo;  // 套图编号

@property(nonatomic, copy) NSString *setsSize;  // 套图尺寸

@property(nonatomic, copy) NSString *setsFileSize;  // 套图大小

@property(nonatomic, copy) NSString *decompressPswd;  // 解压密码

@property(nonatomic, strong) NSArray *previewImages;  // 套图预览

@property(nonatomic, copy) NSString *link;  // 链接

/**
 根据element返回PhotoSetsModel实例

 @param element element
 @return 返回PhotoSetsModel实例
 */
+ (instancetype)modelWithElement:(ONOXMLElement *)element;

@end

@interface ArtPhotoModel : NSObject

@property(nonatomic, copy) NSString *typeName;  // 分类名

@property(nonatomic, copy) NSString *typeURL;  // 分类链接

@property(nonatomic, copy) NSString *title;  // 标题

@property(nonatomic, strong) PhotoSetsModel *photoSets;  // 写真详情

@property(nonatomic, copy) NSString *time;  // 时间

/**
 根据element转ArtPhotoModel实例

 @param element element
 @return 返回ArtPhotoModel实例
 */
+ (instancetype)modelWithElement:(ONOXMLElement *)element;

/**
 获取分类写真

 @param url 分类链接
 @param complete 完成回调
 */
- (void)getPhotosWithURL:(NSString *)url completionHandler:(void (^)(NSArray *artPhotos))complete;

@end
