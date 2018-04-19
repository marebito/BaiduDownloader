//
//  CustomTableRowView.m
//  BaiduDownloader
//
//  Created by Yuri Boyka on 29/03/2018.
//  Copyright © 2018 Godlike Studio. All rights reserved.
//

#import "CustomTableRowView.h"

@implementation CustomTableRowView

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    if (self.selectionHighlightStyle != NSTableViewSelectionHighlightStyleNone) {
        NSRect selectionRect = NSInsetRect(self.bounds, 0, 0);
        [[NSColor colorWithRed:0.97 green:0.93 blue:0.84 alpha:1.00] setFill];
        NSBezierPath *selectionPath = [NSBezierPath bezierPathWithRoundedRect:selectionRect xRadius:0 yRadius:0];
        [selectionPath fill];
    }
}

@end
