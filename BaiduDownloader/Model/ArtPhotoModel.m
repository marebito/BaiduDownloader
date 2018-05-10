//
//  ArtPhotoModel.m
//  BaiduDownloader
//
//  Created by zll on 2018/5/10.
//  Copyright © 2018 Godlike Studio. All rights reserved.
//

#import "ArtPhotoModel.h"

@implementation PhotoSetsModel

+ (instancetype)modelWithElement:(ONOXMLElement *)element
{
    PhotoSetsModel *model = [PhotoSetsModel new];
    model.setsNo = __VREGEX__([[element firstChildWithXPath:@"font[1]/text()[1]"] stringValue],
                              @"\\[\u5957\u56fe\u7f16\u53f7] :", @"$");
    model.setsSize = __VREGEX__([[element firstChildWithXPath:@"font[1]/text()[2]"] stringValue],
                                @"\\[\u5957\u56fe\u5c3a\u5bf8] :", @"$");
    model.setsFileSize = __VREGEX__([[element firstChildWithXPath:@"font[1]/text()[3]"] stringValue],
                                    @"\\[\u5957\u56fe\u5927\u5c0f] :", @"$");
    model.decompressPswd = [[element firstChildWithXPath:@"font[1]/span"] stringValue];
    NSMutableArray *imagePaths = [[NSMutableArray alloc] init];
    for (int i = 1; i < INT_MAX; i++)
    {
        NSString *imagePath =
            [[element firstChildWithXPath:__TOSTR__(@"span[%d]/span/img", i)] valueForAttribute:@"src"];
        if (!imagePath)
        {
            break;
        }
        [imagePaths addObject:imagePath];
    }
    model.previewImages = [NSArray arrayWithArray:imagePaths];
    model.link = __TOSTR__(@"链接: %@ 密码: %@", [[element firstChildWithXPath:@"a[2]"] valueForAttribute:@"href"],
                           __VREGEX__([element stringValue], @"\u5bc6\u7801: ", @"$"));
    return model;
}

- (NSString *)description
{
    return __TOSTR__(@"[套图编号]:%@\n[套图尺寸]:%@\n[套图大小]:%@\n[解压密码]:%@\n[预览图片]:%@\n[链接地址]:%@",
                     self.setsNo, self.setsSize, self.setsFileSize, self.decompressPswd, self.previewImages, self.link);
}

@end

@implementation ArtPhotoModel

+ (instancetype)modelWithElement:(ONOXMLElement *)element
{
    __block ArtPhotoModel *model = [ArtPhotoModel new];
    ONOXMLElement *typeElement = [element firstChildWithXPath:@"a[1]"];
    model.typeName = typeElement.stringValue;
    model.typeURL = [typeElement valueForAttribute:@"href"];
    ONOXMLElement *titleElement = [element firstChildWithXPath:@"a[2]"];
    model.title = [titleElement stringValue];
    NSString *url = [titleElement valueForAttribute:@"href"];
    if (url)
    {
        [HttpUtil htmlForURL:__TOSTR__(@"%@%@", BAIDU_SEARCH_BASE_URL, url)
                        xPath:@"/html/body/div/div[2]/div[1]/div"
            completionHandler:^(ONOXMLElement *elem, NSUInteger idx, BOOL *_Nonnull stop) {
                PhotoSetsModel *photoSetsModel = [PhotoSetsModel modelWithElement:elem];
                model.photoSets = photoSetsModel;
                NSLog(@"model-->%@", model);
            }];
    }
    ONOXMLElement *timeElement = [element.parent firstChildWithXPath:@"li[2]"];
    model.time = timeElement.stringValue;
    return model;
}

- (void)getPhotosWithURL:(NSString *)url completionHandler:(void (^)(NSArray *artPhotos))complete
{
    if (!url)
    {
        NSLog(@"url不能为空!");
        return;
    }
    __block NSMutableArray *artPhotos = [[NSMutableArray alloc] init];
    [HttpUtil htmlForURL:__TOSTR__(@"%@%@", BAIDU_SEARCH_BASE_URL, url)
                    xPath:@"/html/body/div/div[1]/div/ul"
        completionHandler:^(ONOXMLElement *elem, NSUInteger idx, BOOL *_Nonnull stop) {
            ArtPhotoModel *artPhotoModel = [ArtPhotoModel modelWithElement:elem];
            if (artPhotoModel)
            {
                [artPhotos addObject:artPhotoModel];
            }
            if (idx == elem.parent.children.count - 1)
            {
                if (complete)
                {
                    complete(artPhotos);
                }
            }
        }];
}

- (NSString *)description
{
    return __TOSTR__(@"[%@]\t%@\t%@\n%@", self.typeName, self.title, self.time, [self.photoSets description]);
}

@end
