//
//  CustomTextFieldCell.m
//  BaiduDownloader
//
//  Created by zll on 2018/4/3.
//  Copyright © 2018 Godlike Studio. All rights reserved.
//

#import "CustomTextFieldCell.h"

@implementation CustomTextFieldCell

- (void)drawWithFrame:(NSRect)cellFrame inView:(NSView *)controlView
{
    NSGradient * gradient = [[NSGradient alloc] initWithStartingColor:[NSColor blackColor] endingColor:[NSColor systemBlueColor]];
    [gradient drawInBezierPath:[NSBezierPath bezierPathWithRect:cellFrame] angle:90];
    NSBezierPath * bezierPath = [NSBezierPath bezierPathWithRect:NSInsetRect(cellFrame, 1.5, 1.5)];
    [[NSColor controlColor] setFill];
    [bezierPath fill];
    return [super drawWithFrame:cellFrame inView:controlView];
}

@end
