//
//  FileOutlineDataSource.m
//  BaiduDownloader
//
//  Created by zll on 2018/4/5.
//  Copyright © 2018 Godlike Studio. All rights reserved.
//

#import "FileOutlineDataSource.h"
#import "SetDataModel.h"

#define COLUMNID_FILE_NAME @"FileNameColumn" // 文件名列
#define COLUMNID_FILE_SIZE @"FileSizeColumn" // 文件大小列
#define PARENT_KEY @"Parent"                 // 父节点
#define CHILDREN_KEY @"Children"             // 子节点

@interface FileOutlineDataSource ()
{
     NSTreeNode *_rootTreeNode;
}

- (NSTreeNode *)treeNodeFromPath:(NSString *)path;

@end

@implementation FileOutlineDataSource

- (id)init
{
    if (nil != (self = [super init]))
    {
        _rootTreeNode = [self treeNodeFromPath:nil];
    }
    return self;
}

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

- (NSInteger)outlineView:(NSOutlineView *)outlineView numberOfChildrenOfItem:(id)item
{
    NSArray *children = [self childrenForItem:item];
    return [children count];
}

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

- (NSTreeNode *)treeNodeFromPath:(NSString *)path
{
    FileListModel *model = self.cacheFileList[path];
    NSTreeNode *result = [NSTreeNode treeNodeWithRepresentedObject:model.list[0]];
    if (model)
    {
        for (ListModel *lm in model.list)
        {
            NSTreeNode *childTreeNode;
            if ([lm.isdir integerValue] == 1)
            {
                childTreeNode = [self treeNodeFromPath:lm.path];
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

@end
