//
//  CustomOutlineView.m
//  BaiduDownloader
//
//  Created by zll on 2018/3/29.
//  Copyright © 2018年 Godlike Studio. All rights reserved.
//

#import "CustomOutlineView.h"

@implementation CustomOutlineView

- (NSView *)makeViewWithIdentifier:(NSUserInterfaceItemIdentifier)identifier owner:(id)owner
{
    NSView *view = [super makeViewWithIdentifier:identifier owner:owner];
    if ([identifier isEqualToString:NSOutlineViewDisclosureButtonKey]) {
        // The normal triangle disclosure button
    }
    if ([identifier isEqualToString:NSOutlineViewShowHideButtonKey])
    {
        // The show/hide button used in"Source Lists"
        
    }
    return view;
}

@end
