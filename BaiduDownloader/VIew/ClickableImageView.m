//
//  ClickableImageView.m
//  BaiduDownloader
//
//  Created by Yuri Boyka on 2018/3/23.
//  Copyright © 2018年 Godlike Studio. All rights reserved.
//

#import "ClickableImageView.h"

@implementation ClickableImageView

- (void)mouseDown:(NSEvent *)theEvent
{
    [NSApp sendAction:[self action] to:[self target] from:self];
}

@end
