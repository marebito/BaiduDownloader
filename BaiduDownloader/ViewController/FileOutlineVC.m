//
//  FileOutlineVC.m
//  BaiduDownloader
//
//  Created by zll on 2018/3/29.
//  Copyright © 2018年 Godlike Studio. All rights reserved.
//

#import "FileOutlineVC.h"

@interface FileOutlineVC () <NSOutlineViewDelegate, NSOutlineViewDataSource>

@end

@implementation FileOutlineVC

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)setFileListModel:(FileListModel *)fileListModel
{
    _fileListModel = fileListModel;
    [self.outlineView reloadData];
}

- (void)clickDir:(NSString *)path
{
    if (self.getFileList)
    {
        self.getFileList(path, ^(FileListModel *model){
            NSLog(@"model-->%@",model);
        });
    }
}

#pragma mark - Actions

- (IBAction)doubleClickedItem:(NSOutlineView *)sender
{
    FileListModel *item = [sender itemAtRow:[sender clickedRow]];
    if ([item isKindOfClass:[FileListModel class]])
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

// 返回包含子项目的数量
- (NSInteger)outlineView:(NSOutlineView *)outlineView numberOfChildrenOfItem:(id)item
{
    if ([item isKindOfClass:[ListModel class]])
    {
        if([((ListModel *)item).isdir integerValue] == 1)
        {
            // 请求子目录文件
            [self clickDir:((ListModel *)item).path];
            return 0;
        }
    }
    return 1;
}

// 返回子项目
- (id)outlineView:(NSOutlineView *)outlineView child:(NSInteger)index ofItem:(id)item
{
    FileListModel *listModel = (FileListModel *)item;
    if (listModel)
    {
        return listModel.list[index];
    }
    return self.fileListModel.list[index];
}

- (BOOL)outlineView:(NSOutlineView *)outlineView isItemExpandable:(id)item
{
    if ([item isKindOfClass:[ListModel class]])
    {
        ListModel *listModel = (ListModel *)item;
        return ([listModel.isdir integerValue] == 1);
    }
    return NO;
}

#pragma mark - NSOutlineViewDelegate
- (NSView *)outlineView:(NSOutlineView *)outlineView viewForTableColumn:(NSTableColumn *)tableColumn item:(id)item
{
    NSTableCellView *view;
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
                textField.stringValue = listModel.size;
                [textField sizeToFit];
            }
        }
    }
    return view;
}

- (void)outlineViewSelectionDidChange:(NSNotification *)notification
{
    if (![notification.object isKindOfClass:[NSOutlineView class]]) {
        return;
    }
    NSOutlineView *outlineView = (NSOutlineView *)notification.object;
    NSInteger selectedIndex = outlineView.selectedRow;
    FileListModel *listModel = [outlineView itemAtRow:selectedIndex];
    if (![listModel isKindOfClass:[FileListModel class]]) {
        return;
    }
    if (listModel)
    {
        // 刷新右侧界面
    }
}

#pragma mark - Keyboard Handling

- (void)keyDown:(NSEvent *)event
{
    [self interpretKeyEvents:[NSArray arrayWithObject:event]];
}

@end
