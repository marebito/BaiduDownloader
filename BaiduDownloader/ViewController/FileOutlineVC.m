//
//  FileOutlineVC.m
//  BaiduDownloader
//
//  Created by zll on 2018/3/29.
//  Copyright © 2018年 Godlike Studio. All rights reserved.
//

#import "FileOutlineVC.h"
#import <SDWebImage/UIImageView+WebCache.h>

#define TREE_ROOT_NODE @"TREE_ROOT_NODE"     // 树根
#define COLUMNID_FILE_NAME @"FileNameColumn" // 文件名列
#define COLUMNID_FILE_SIZE @"FileSizeColumn" // 文件大小列
#define PARENT_KEY @"Parent"                 // 父节点
#define CHILDREN_KEY @"Children"             // 子节点

@interface FileOutlineVC () <NSOutlineViewDelegate, NSOutlineViewDataSource>
{
    NSTreeNode *_rootTreeNode;
}
@property (weak) IBOutlet NSTextField *serverFileName;
@property (weak) IBOutlet NSTextField *fileDir;
@property (weak) IBOutlet NSTextField *fileSize;
@property (weak) IBOutlet NSTextField *fileMD5;
@property (weak) IBOutlet NSComboBox *downloadStyle;
@property (weak) IBOutlet NSImageView *previewImage;
@property (nonatomic, copy) NSString *fileDlinkURL;

- (NSTreeNode *)treeNodeFromListModel:(ListModel *)listModel;
- (IBAction)download:(id)sender;
@end

@implementation FileOutlineVC

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)setFileList:(NSArray *)fileList
{
    _fileList = fileList;
    _rootTreeNode = [NSTreeNode treeNodeWithRepresentedObject:TREE_ROOT_NODE];
    for (ListModel *lm in self.fileList)
    {
        [[_rootTreeNode mutableChildNodes] addObject:[self treeNodeFromListModel:lm]];
    }
}

- (void)setFileListCache:(MutableOrderedDictionary *)fileListCache
{
    _fileListCache = fileListCache;
}

- (void)setFileDlinkCache:(MutableOrderedDictionary *)fileDlinkCache
{
    _fileDlinkCache = fileDlinkCache;
    [self.outlineView reloadData];
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

#pragma mark - Actions

- (IBAction)doubleClickedItem:(NSOutlineView *)sender
{
    id item = [sender itemAtRow:[sender clickedRow]];
    if ([item isKindOfClass:[NSString class]])
    {
        if ([sender isItemExpanded:item])
        {
            [sender collapseItem:item];
        }
        else
        {
            [sender expandItem:item];
        }
    }
}

#pragma mark - NSOutlineViewDataSource
- (NSArray *)childrenForItem:(id)item
{
    if (item ==nil)
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
    ListModel *nodeData = [item representedObject];
    return 1 == [nodeData.isdir integerValue];
}

#pragma mark - NSOutlineViewDelegate
- (id)outlineView:(NSOutlineView *)outlineView objectValueForTableColumn:(NSTableColumn *)tableColumn byItem:(id)item
{
    id objectValue =nil;
    ListModel *nodeData = [item representedObject];
    if ((tableColumn ==nil) || [[tableColumn identifier] isEqualToString:COLUMNID_FILE_NAME])
    {
        objectValue = nodeData.server_filename;
    }
    if ((tableColumn ==nil) || [[tableColumn identifier] isEqualToString:COLUMNID_FILE_SIZE])
    {
        objectValue = nodeData.size;
    }
    return objectValue;
}

- (NSView *)outlineView:(NSOutlineView *)outlineView viewForTableColumn:(NSTableColumn *)tableColumn item:(id)item
{
    NSTableCellView *view;
    ListModel *nodeData = [item representedObject];
    if ([item isKindOfClass:[ListModel class]])
    {
        ListModel *listModel = (ListModel *)item;
        if ([tableColumn.identifier isEqualToString:@"ServerFileNameColumn"])
        {
            if ([listModel.isdir integerValue] != 1)
            {
                view = (NSTableCellView *)[outlineView makeViewWithIdentifier:@"FileItemCell" owner:self];
            }
            else
            {
                view = (NSTableCellView *)[outlineView makeViewWithIdentifier:@"DirItemCell" owner:self];
            }
            NSTextField *textField = view.textField;
            if (textField)
            {
                textField.stringValue = listModel.server_filename;
                [textField sizeToFit];
            }
        }
        if (([listModel.isdir integerValue] != 1) && [tableColumn.identifier isEqualToString:@"FileSizeColumn"])
        {
            view = (NSTableCellView *)[outlineView makeViewWithIdentifier:@"FileSizeCell" owner:self];
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
        if ([tableColumn.identifier isEqualToString:@"ServerFileNameColumn"])
        {
            view = (NSTableCellView *)[outlineView makeViewWithIdentifier:@"DirItemCell" owner:self];
            NSTextField *textField = view.textField;
            if (textField)
            {
                textField.stringValue = item;
                [textField sizeToFit];
            }
        }
        if ([tableColumn.identifier isEqualToString:@"FileSizeColumn"])
        {
            long long allFileSize = [self fileSizeWithDir:item];
            view = (NSTableCellView *)[outlineView makeViewWithIdentifier:@"FileSizeCell" owner:self];
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
    if(((FileListModel *)self.fileListCache[dir]).list.count > 0)
    {
        for (ListModel *listModel in ((FileListModel *)self.fileListCache[dir]).list)
        {
            allFileSize += [listModel.size longLongValue];
        }
    }
    return allFileSize;
}

- (void)updateDescView:(id)object
{
    if (!object) return;
    if ([object isKindOfClass:[ListModel class]])
    {
        self.serverFileName.stringValue = ((ListModel *)object).server_filename;
        self.fileDir.stringValue = ((ListModel *)object).path;
        self.fileSize.stringValue = [StringUtil fileSizeWithBytes:[((ListModel *)object).size longLongValue]];
        self.fileMD5.stringValue = ((ListModel *)object).md5;
        if ([[[self.serverFileName.stringValue pathExtension] lowercaseString] rangeOfString:@"png"].location != NSNotFound || [[[self.serverFileName.stringValue pathExtension] lowercaseString] rangeOfString:@"jpg"].location != NSNotFound || [[[self.serverFileName.stringValue pathExtension] lowercaseString] rangeOfString:@"gif"].location != NSNotFound || [[[self.serverFileName.stringValue pathExtension] lowercaseString] rangeOfString:@"webp"].location != NSNotFound)
        {
            [self.previewImage sd_setImageWithURL:[NSURL URLWithString:self.fileDlinkCache[((ListModel *)object).fs_id]] placeholderImage:nil options:SDWebImageRetryFailed];
        }
        self.fileDlinkURL = self.fileDlinkCache[((ListModel *)object).fs_id];
    }
    else
    {
        self.serverFileName.stringValue = object;
        self.fileDir.stringValue = object;
        self.fileSize.stringValue = [StringUtil fileSizeWithBytes:[self fileSizeWithDir:object]];
        self.fileMD5.stringValue = @"";
        self.previewImage.image = nil;
    }
}

- (void)outlineViewSelectionDidChange:(NSNotification *)notification
{
    if (![notification.object isKindOfClass:[NSOutlineView class]]) {
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

- (void)keyDown:(NSEvent *)event
{
    [self interpretKeyEvents:[NSArray arrayWithObject:event]];
}

- (void)selectFile:(void (^)(NSInteger, NSString *))callback panel:(NSOpenPanel *)panel result:(NSInteger)result {
    NSString *filePath = nil;
    if (result == NSModalResponseOK)
    {
        filePath = [panel.URLs.firstObject path];
    }
    if (callback) callback(result, filePath);
}

- (void)selectFile:(void (^)(NSInteger response, NSString *filePath))callback isPresent:(BOOL)isPresent
{
    NSOpenPanel* panel = [NSOpenPanel openPanel];
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
        [panel beginSheetModalForWindow:self.view.window completionHandler:^(NSInteger result) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf selectFile:callback panel:panel result:result];
        }];
    }
    else
    {
        // 悬浮电脑主屏幕上
        [panel beginWithCompletionHandler:^(NSInteger result) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf selectFile:callback panel:panel result:result];
        }];
    }
}

- (IBAction)download:(id)sender
{
    switch (_downloadStyle.indexOfSelectedItem) {
            case -1:
            case 0:
        {
            NSLog(@"默认");
        }
            break;
            case 1:
        {
            NSLog(@"迅雷");
        }
            break;
            case 2:
        {
            NSLog(@"Folx");
        }
            break;
        default:
            break;
    }
}

@end
