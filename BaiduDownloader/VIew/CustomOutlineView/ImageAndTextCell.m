//
//  ImageAndTextCell.m
//  BaiduDownloader
//
//  Created by zll on 2018/4/5.
//  Copyright © 2018 Godlike Studio. All rights reserved.
//

#import "ImageAndTextCell.h"

@implementation ImageAndTextCell

- (instancetype)init
{
    if (nil != (self = [super init]))
    {
        self.iconSize = NSMakeSize(16, 16);
        self.offset = 3.0;
        [self setLineBreakMode:NSLineBreakByTruncatingTail];
        [self setSelectable:YES];
    }
    return self;
}

- (NSSize)cellSize
{
    NSSize cellSize = [super cellSize];
    if (self.icon != nil)
    {
        cellSize.width += self.iconSize.width;
    }
    cellSize.width += 3;
    return cellSize;
}

- (NSRect)titleRectForBounds:(NSRect)rect
{
    NSRect result;
    if (nil != self.icon)
    {
        CGFloat imageWidth = self.iconSize.width;
        result = rect;
        result.origin.x += (self.offset + imageWidth);
        result.size.width -= (self.offset + imageWidth);
    }
    else
    {
        result = [super titleRectForBounds:rect];
    }
    return result;
}

- (NSRect)imageRectForBounds:(NSRect)rect
{
    NSRect result;
    if (nil != self.icon)
    {
        result.size = self.iconSize;
        result.origin = rect.origin;
        result.origin.x += self.offset;
        result.origin.y += ceil((rect.size.height - rect.size.height) / 2.0);
    }
    else
    {
        result = NSZeroRect;
    }
    return result;
}

- (void)drawWithFrame:(NSRect)cellFrame inView:(NSView *)controlView
{
    // 如果对象图片不为空，就计算位置并绘制图
    if (nil != self.icon)
    {
        NSRect imageFrame = [self imageRectForBounds:cellFrame];
        [self.icon drawInRect:imageFrame fromRect:NSZeroRect operation:NSCompositingOperationSourceOver fraction:1.0 respectFlipped:YES hints:nil];
        NSInteger newX = NSMaxX(cellFrame) + self.offset;
        cellFrame.size.width = NSMaxX(cellFrame) - newX;
        cellFrame.origin.x = newX;
    }
    [super drawWithFrame:cellFrame inView:controlView];
}

@end
