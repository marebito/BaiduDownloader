//
//  FileOutlineVC.h
//  BaiduDownloader
//
//  Created by Yuri Boyka on 2018/3/29.
//  Copyright © 2018年 Godlike Studio. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SetDataModel.h"

typedef void (^GetFileListBlock)(FileListModel *model);

@interface FileOutlineVC : NSViewController
@property (weak) IBOutlet NSOutlineView *outlineView;
@property (nonatomic, strong) NSArray *fileList;
@property (nonatomic, strong) MutableOrderedDictionary *fileListCache;
@property (nonatomic, strong) MutableOrderedDictionary *fileDlinkCache;
@property (nonatomic, copy) void (^getFileList) (NSString *path, GetFileListBlock block);
@end
