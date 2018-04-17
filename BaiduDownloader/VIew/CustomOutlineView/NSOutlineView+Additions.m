//
//  NSOutlineView+Additions.m
//  BaiduDownloader
//
//  Created by zll on 2018/4/17.
//  Copyright © 2018年 Godlike Studio. All rights reserved.
//

#import "NSOutlineView+Additions.h"

@implementation NSOutlineView (Additions)

- (void)expandParentsOfItem:(id)item
{
    while (item != nil)
    {
        id parent = [self parentForItem:item];
        if (![self isExpandable:parent]) break;
        if (![self isItemExpanded:parent]) [self expandItem:parent];
        item = parent;
    }
}

- (void)selectItem:(id)item
{
    NSInteger itemIndex = [self rowForItem:item];
    if (itemIndex < 0)
    {
        [self expandParentsOfItem:item];
        itemIndex = [self rowForItem:item];
        if (itemIndex < 0) return;
    }

    [self selectRowIndexes:[NSIndexSet indexSetWithIndex:itemIndex] byExtendingSelection:NO];
}

@end
