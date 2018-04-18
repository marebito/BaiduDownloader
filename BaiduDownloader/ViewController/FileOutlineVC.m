//
//  FileOutlineVC.m
//  BaiduDownloader
//
//  Created by zll on 2018/3/29.
//  Copyright © 2018年 Godlike Studio. All rights reserved.
//

#import "FileOutlineVC.h"
#import <SDWebImage/UIImageView+WebCache.h>

#define TREE_ROOT_NODE @"TREE_ROOT_NODE"      // 树根
#define COLUMNID_FILE_NAME @"FileNameColumn"  // 文件名列
#define COLUMNID_FILE_SIZE @"FileSizeColumn"  // 文件大小列
#define FILE_ITEM_CELL @"FileItemCell"        // 文件Cell
#define FILE_DIR_CELL @"DirItemCell"          // 文件夹Cell
#define FILE_SIZE_CELL @"FileSizeCell"        // 文件大小Cell
#define PARENT_KEY @"Parent"                  // 父节点
#define CHILDREN_KEY @"Children"              // 子节点

@interface FileOutlineVC ()<NSOutlineViewDelegate, NSOutlineViewDataSource>
{
    NSTreeNode *_rootTreeNode;
}
@property(weak) IBOutlet NSTextField *serverFileName;
@property(weak) IBOutlet NSTextField *fileDir;
@property(weak) IBOutlet NSTextField *fileSize;
@property(weak) IBOutlet NSTextField *fileMD5;
@property(weak) IBOutlet NSComboBox *downloadStyle;
@property(weak) IBOutlet NSImageView *previewImage;
@property(weak) IBOutlet NSButton *cpLinkBtn;
@property(nonatomic, copy) NSString *fileDlinkURL;

- (NSTreeNode *)treeNodeFromListModel:(ListModel *)listModel;
- (IBAction)copyURL:(id)sender;
- (IBAction)download:(id)sender;
- (IBAction)close:(id)sender;

@end

@implementation FileOutlineVC

- (void)viewDidLoad { [super viewDidLoad]; }
- (void)setFileList:(NSArray *)fileList { _fileList = fileList; }
- (void)setFileListCache:(MutableOrderedDictionary *)fileListCache
{
    _fileListCache = fileListCache;
    _rootTreeNode = [NSTreeNode treeNodeWithRepresentedObject:TREE_ROOT_NODE];
    for (ListModel *lm in self.fileList)
    {
        [[_rootTreeNode mutableChildNodes] addObject:[self treeNodeFromListModel:lm]];
    }
}

- (void)setFileDlinkCache:(MutableOrderedDictionary *)fileDlinkCache
{
    _fileDlinkCache = fileDlinkCache;
    [self.outlineView reloadData];
    [self.outlineView selectRowIndexes:[NSIndexSet indexSetWithIndex:0] byExtendingSelection:YES];
    [self.outlineView expandItem:[self.outlineView itemAtRow:0] expandChildren:YES];
    [self updateDescView:[self.outlineView itemAtRow:0]];
}

- (NSTreeNode *)treeNodeFromListModel:(ListModel *)listModel
{
    FileListModel *model = self.fileListCache[listModel.path];
    NSTreeNode *result = [NSTreeNode treeNodeWithRepresentedObject:listModel.path];
    if (model)
    {
        for (ListModel *lm in model.list)
        {
            NSTreeNode *childTreeNode;
            if ([lm.isdir integerValue] == 1)
            {
                childTreeNode = [self treeNodeFromListModel:lm];
            }
            else
            {
                childTreeNode = [NSTreeNode treeNodeWithRepresentedObject:lm];
            }
            [[result mutableChildNodes] addObject:childTreeNode];
        }
    }
    return result;
}

- (IBAction)copyURL:(id)sender
{
    NSPasteboard *paste = [NSPasteboard generalPasteboard];
    [paste clearContents];
    [paste writeObjects:@[ self.fileDlinkURL ]];
}

#pragma mark - Actions
- (IBAction)clickedItem:(NSOutlineView *)sender
{
    if ([self.outlineView clickedRow] == -1) {
        [self.outlineView deselectAll:nil];
    }
}

- (IBAction)doubleClickedItem:(NSOutlineView *)sender
{
    id item = [sender itemAtRow:[sender clickedRow]];
    if ([sender isItemExpanded:item])
    {
        [sender collapseItem:item];
    }
    else
    {
        [sender expandItem:item];
    }
}

#pragma mark - NSOutlineViewDataSource
- (NSArray *)childrenForItem:(id)item
{
    if (item == nil)
    {
        return [_rootTreeNode childNodes];
    }
    else
    {
        return [item childNodes];
    }
}

// 返回包含子项目的数量
- (NSInteger)outlineView:(NSOutlineView *)outlineView numberOfChildrenOfItem:(id)item
{
    NSArray *children = [self childrenForItem:item];
    return [children count];
}

- (id)outlineView:(NSOutlineView *)outlineView child:(NSInteger)index ofItem:(id)item
{
    NSArray *children = [self childrenForItem:item];
    return [children objectAtIndex:index];
}

- (BOOL)outlineView:(NSOutlineView *)outlineView isItemExpandable:(id)item
{
    id nodeData = [item representedObject];
    if ([nodeData isKindOfClass:[ListModel class]])
    {
        return 1 == [((ListModel *)nodeData).isdir integerValue];
    }
    FileListModel *flm = self.fileListCache[nodeData];
    if (flm)
    {
        return flm.list.count > 0;
    }
    return NO;
}

#pragma mark - NSOutlineViewDelegate
- (NSView *)outlineView:(NSOutlineView *)outlineView viewForTableColumn:(NSTableColumn *)tableColumn item:(id)item
{
    NSTableCellView *view;
    id nodeData = [item representedObject];
    if ([nodeData isKindOfClass:[ListModel class]])
    {
        ListModel *listModel = (ListModel *)nodeData;
        if ([tableColumn.identifier isEqualToString:COLUMNID_FILE_NAME])
        {
            if ([listModel.isdir integerValue] != 1)
            {
                view = (NSTableCellView *)[outlineView makeViewWithIdentifier:FILE_ITEM_CELL owner:self];
            }
            else
            {
                view = (NSTableCellView *)[outlineView makeViewWithIdentifier:FILE_DIR_CELL owner:self];
            }
            NSTextField *textField = view.textField;
            if (textField)
            {
                textField.stringValue = listModel.server_filename;
                [textField sizeToFit];
            }
        }
        if (([listModel.isdir integerValue] != 1) && [tableColumn.identifier isEqualToString:COLUMNID_FILE_SIZE])
        {
            view = (NSTableCellView *)[outlineView makeViewWithIdentifier:FILE_SIZE_CELL owner:self];
            NSTextField *textField = view.textField;
            if (textField)
            {
                textField.stringValue = [StringUtil fileSizeWithBytes:[listModel.size longLongValue]];
                [textField sizeToFit];
            }
        }
    }
    else
    {
        if ([tableColumn.identifier isEqualToString:COLUMNID_FILE_NAME])
        {
            view = (NSTableCellView *)[outlineView makeViewWithIdentifier:FILE_DIR_CELL owner:self];
            NSTextField *textField = view.textField;
            if (textField)
            {
                textField.stringValue = [nodeData lastPathComponent];
                [textField sizeToFit];
            }
        }
        if ([tableColumn.identifier isEqualToString:COLUMNID_FILE_SIZE])
        {
            long long allFileSize = [self fileSizeWithDir:nodeData];
            view = (NSTableCellView *)[outlineView makeViewWithIdentifier:FILE_SIZE_CELL owner:self];
            NSTextField *textField = view.textField;
            if (textField)
            {
                textField.stringValue = [StringUtil fileSizeWithBytes:allFileSize];
                [textField sizeToFit];
            }
        }
    }
    return view;
}

- (long long)fileSizeWithDir:(NSString *)dir
{
    long long allFileSize = 0;
    if (((FileListModel *)self.fileListCache[dir]).list.count > 0)
    {
        for (ListModel *listModel in ((FileListModel *)self.fileListCache[dir]).list)
        {
            if ([listModel.isdir integerValue] == 1)
            {
                allFileSize += [self fileSizeWithDir:listModel.path];
            }
            else
            {
                allFileSize += [listModel.size longLongValue];
            }
        }
    }
    return allFileSize;
}

- (void)updateDescView:(id)object
{
    if (!object) return;
    id model = [object representedObject];
    if ([model isKindOfClass:[ListModel class]])
    {
        self.serverFileName.stringValue = ((ListModel *)model).server_filename;
        self.fileDir.stringValue = ((ListModel *)model).path;
        self.fileSize.stringValue = [StringUtil fileSizeWithBytes:[((ListModel *)model).size longLongValue]];
        self.fileMD5.stringValue = ((ListModel *)model).md5;
        if ([[[self.serverFileName.stringValue pathExtension] lowercaseString] rangeOfString:@"png"].location !=
                NSNotFound ||
            [[[self.serverFileName.stringValue pathExtension] lowercaseString] rangeOfString:@"jpg"].location !=
                NSNotFound ||
            [[[self.serverFileName.stringValue pathExtension] lowercaseString] rangeOfString:@"gif"].location !=
                NSNotFound ||
            [[[self.serverFileName.stringValue pathExtension] lowercaseString] rangeOfString:@"webp"].location !=
                NSNotFound)
        {
            //            [self.previewImage sd_setImageWithURL:[NSURL URLWithString:self.fileDlinkCache[((ListModel
            //            *)model).fs_id]] placeholderImage:nil options:SDWebImageRetryFailed completed:^(NSImage *
            //            _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable
            //            imageURL) {}];
        }
        self.fileDlinkURL = self.fileDlinkCache[((ListModel *)model).fs_id];
    }
    else
    {
        self.serverFileName.stringValue = model;
        self.fileDir.stringValue = model;
        self.fileSize.stringValue = [StringUtil fileSizeWithBytes:[self fileSizeWithDir:model]];
        self.fileMD5.stringValue = @"";
        self.previewImage.image = nil;
    }
}

- (void)outlineViewSelectionDidChange:(NSNotification *)notification
{
    if (![notification.object isKindOfClass:[NSOutlineView class]])
    {
        return;
    }
    NSOutlineView *outlineView = (NSOutlineView *)notification.object;
    id item = [outlineView itemAtRow:outlineView.selectedRow];
    if (item)
    {
        [self updateDescView:item];
    }
}

#pragma mark - Keyboard Handling

- (void)keyDown:(NSEvent *)event { [self interpretKeyEvents:[NSArray arrayWithObject:event]]; }
- (void)selectFile:(void (^)(NSInteger, NSString *))callback panel:(NSOpenPanel *)panel result:(NSInteger)result
{
    NSString *filePath = nil;
    if (result == NSModalResponseOK)
    {
        filePath = [panel.URLs.firstObject path];
    }
    if (callback) callback(result, filePath);
}

- (void)selectDownloadPath:(void (^)(NSInteger response, NSString *filePath))callback isPresent:(BOOL)isPresent
{
    NSOpenPanel *panel = [NSOpenPanel openPanel];
    //是否可以创建文件夹
    panel.canCreateDirectories = YES;
    //是否可以选择文件夹
    panel.canChooseDirectories = YES;
    //是否可以选择文件
    panel.canChooseFiles = YES;

    //是否可以多选
    [panel setAllowsMultipleSelection:NO];

    __weak typeof(self) weakSelf = self;
    if (!isPresent)
    {
        //显示
        [panel beginSheetModalForWindow:self.view.window
                      completionHandler:^(NSModalResponse result) {
                          __strong typeof(weakSelf) strongSelf = weakSelf;
                          [strongSelf selectFile:callback panel:panel result:result];
                      }];
    }
    else
    {
        // 悬浮电脑主屏幕上
        [panel beginWithCompletionHandler:^(NSModalResponse result) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf selectFile:callback panel:panel result:result];
        }];
    }
}

- (NSMutableArray *)filesInDir:(NSString *)dir
{
    NSMutableArray *files = [[NSMutableArray alloc] init];
    FileListModel *flm = self.fileListCache[dir];
    for (ListModel *lm in flm.list)
    {
        if ([lm.isdir integerValue] == 1)
        {
            [files addObjectsFromArray:[self filesInDir:lm.path]];
        }
        else
        {
            [files addObject:@{ @"name" : lm.server_filename, @"link" : self.fileDlinkCache[lm.fs_id] }];
        }
    }
    return files;
}

- (IBAction)download:(id)sender
{
    @WeakObj(self)[self selectDownloadPath:^(NSModalResponse response, NSString *filePath) {
        @StrongObj(self) if (response == 0) return;
        NSString *downloadDir = filePath;
        id nodeData = [[self.outlineView itemAtRow:self.outlineView.selectedRow] representedObject];
        NSMutableArray *files;
        if ([nodeData isKindOfClass:[FileModel class]])
        {
            [files addObject:self.fileDlinkCache[((FileModel *)nodeData).fs_id]];
        }
        else
        {
            files = [self filesInDir:nodeData];
        }
        NSMutableArray *links = [[NSMutableArray alloc] init];
        for (NSDictionary *dic in files)
        {
            [links addObject:dic[@"link"]];
        }
        switch (self.downloadStyle.indexOfSelectedItem)
        {
            case -1:
            case 0:
            {
                NSLog(@"默认");
            }
            break;
            case 1:
            {
                NSLog(@"迅雷");
                if (![[NSWorkspace sharedWorkspace] launchAppWithBundleIdentifier:@"com.xunlei.Thunder"
                                                                          options:NSWorkspaceLaunchDefault
                                                   additionalEventParamDescriptor:NULL
                                                                 launchIdentifier:NULL])
                {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
                    NSRunAlertPanel(@"无法下载", @"未安装迅雷， 请安装最新版本迅雷进行下载", @"OK", nil, nil);
#pragma clang diagnostic pop
                    return;
                }
                NSString *command = [NSString
                    stringWithFormat:@"open -a /Applications/Thunder.app %@", [links componentsJoinedByString:@" "]];
                system([[command stringByReplacingOccurrencesOfString:@"&" withString:@"'&'"] UTF8String]);
            }
            break;
            case 2:
            {
                NSLog(@"Folx");
                if (![[NSWorkspace sharedWorkspace] launchAppWithBundleIdentifier:@"com.eltima.Folx3"
                                                                          options:NSWorkspaceLaunchDefault
                                                   additionalEventParamDescriptor:NULL
                                                                 launchIdentifier:NULL])
                {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
                    NSRunAlertPanel(@"无法下载", @"未安装Folx， 请安装最新版本Folx进行下载", @"OK", nil, nil);
#pragma clang diagnostic pop
                    return;
                }
                NSString *command = [NSString
                    stringWithFormat:@"open -a /Applications/Folx.app %@", [links componentsJoinedByString:@" "]];
                system([[command stringByReplacingOccurrencesOfString:@"&" withString:@"'&'"] UTF8String]);
            }
            break;
            case 3:
            {
                // wget
                NSAppleEventDescriptor *eventDescriptor = nil;
                NSAppleScript *script = nil;
                NSMutableArray *cmds = [[NSMutableArray alloc] init];
                for (int i = 0; i < files.count; i++)
                {
                    NSString *wgetCmd = [NSString stringWithFormat:@"wget -P %@ -O %@/%@ %@", downloadDir, downloadDir,
                                                                   files[i][@"name"], files[i][@"link"]];
                    [cmds addObject:wgetCmd];
                }
                NSString *cmdArray = [NSString stringWithFormat:@"\"%@\"", [cmds componentsJoinedByString:@"\",\""]];

                NSString *scriptSource =
                    [NSString stringWithFormat:@"set downloads to {%@}\n tell application \"Terminal\"\n    activate\n "
                                               @"repeat with download in downloads\n do script download in tab 1 of "
                                               @"window 1\n end repeat\nend tell",
                                               cmdArray];
                if (scriptSource)
                {
                    script = [[NSAppleScript alloc] initWithSource:scriptSource];
                    if (script)
                    {
                        eventDescriptor = [script executeAndReturnError:nil];
                        if (eventDescriptor)
                        {
                            NSLog(@"%@", [eventDescriptor stringValue]);
                        }
                    }
                }
            }
            break;
            default:
                break;
        }
    }
                                 isPresent:NO];
}

- (IBAction)close:(id)sender { [self.view.window close]; }
@end
