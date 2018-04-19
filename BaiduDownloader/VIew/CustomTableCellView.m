//
//  CustomTableCellView.m
//  BaiduDownloader
//
//  Created by Yuri Boyka on 29/03/2018.
//  Copyright © 2018 Godlike Studio. All rights reserved.
//

#import "CustomTableCellView.h"

@implementation CustomTableCellView

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
}

- (void)setBackgroundStyle:(NSBackgroundStyle)backgroundStyle
{
    [super setBackgroundStyle:backgroundStyle];
    if(backgroundStyle == NSBackgroundStyleDark)
    {
        self.layer.backgroundColor = [NSColor systemGreenColor].CGColor;
    }
    else
    {
        self.layer.backgroundColor = [NSColor colorWithRed:0.97 green:0.93 blue:0.84 alpha:1.00].CGColor;
    }
}

@end
