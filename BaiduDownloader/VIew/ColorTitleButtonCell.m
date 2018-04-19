//
//  ColorTitleButtonCell.m
//  BaiduDownloader
//
//  Created by Yuri Boyka on 27/03/2018.
//  Copyright © 2018 Godlike Studio. All rights reserved.
//

#import "ColorTitleButtonCell.h"

@implementation ColorTitleButtonCell

- (NSRect)drawTitle:(NSAttributedString *)title withFrame:(NSRect)frame inView:(NSView *)controlView
{
    
    NSSize titleSize =  [title size];
    
    //居中显示
    CGFloat titleY = frame.origin.y + (frame.size.height - titleSize.height)/2;
    NSRect rectTitle = frame;
    
    rectTitle.origin.y = titleY;
    
    NSMutableAttributedString *titleStr =[[NSMutableAttributedString alloc]
                                          initWithAttributedString:title];
    [titleStr addAttribute:NSForegroundColorAttributeName value:[NSColor colorWithRed:0.97 green:0.93 blue:0.84 alpha:1.00]
                     range:NSMakeRange(0, titleStr.length)];
    [titleStr drawInRect:rectTitle];
    
    return frame;
}

@end
