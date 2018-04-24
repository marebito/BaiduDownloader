//
//  AMRoundView.m
//  BaiduDownloader
//
//  Created by zll on 2018/4/24.
//  Copyright © 2018年 Godlike Studio. All rights reserved.
//

#import "AMRoundView.h"

@implementation AMRoundView

- (id)initWithFrame:(NSRect)frameRect
{
    self = [super initWithFrame:frameRect];
    if (self != nil)
    {
    }

    return self;
}

// Shared objects.
static NSShadow *borderShadow = nil;

- (void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];

    // Drawing code here.
    [[NSColor colorWithDeviceCyan:0.23 magenta:0.17 yellow:0.17 black:0 alpha:1] set];
    NSRectFill(dirtyRect);

    [NSGraphicsContext saveGraphicsState];

    // Initialize shared objects.
    if (borderShadow == nil)
    {
        borderShadow = [[NSShadow alloc] init];
        borderShadow.shadowColor = [NSColor colorWithDeviceWhite:0 alpha:0.5];
        borderShadow.shadowOffset = NSMakeSize(1, -1);
        borderShadow.shadowBlurRadius = 5.0;
    }

    // Outer bounds with shadow.
    NSRect bounds = [self bounds];
    bounds.size.width -= 20;
    bounds.size.height -= 20;
    bounds.origin.x += 10;
    bounds.origin.y += 10;

    NSBezierPath *borderPath = [NSBezierPath bezierPathWithRoundedRect:bounds xRadius:5 yRadius:5];
    [borderShadow set];
    [[NSColor whiteColor] set];
    [borderPath fill];

    [NSGraphicsContext restoreGraphicsState];

    [[self window] invalidateShadow];
}

@end
