//
//  FileListVC.h
//  BaiduDownloader
//
//  Created by Yuri Boyka on 27/03/2018.
//  Copyright © 2018 Godlike Studio. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface FileListVC : NSViewController
@property (weak) IBOutlet NSTableView *mTableView;
@property (nonatomic, copy) void (^closeAction)(void);
@end
