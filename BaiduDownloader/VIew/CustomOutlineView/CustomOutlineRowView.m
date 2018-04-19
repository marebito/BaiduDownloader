//
//  CustomOutlineRowView.m
//  BaiduDownloader
//
//  Created by Yuri Boyka on 2018/3/29.
//  Copyright © 2018年 Godlike Studio. All rights reserved.
//

#import "CustomOutlineRowView.h"

@implementation CustomOutlineRowView

-(void)didAddSubview:(NSView *)subview
{
    // As noted in the comments, don't forget to call super:
    [super didAddSubview:subview];

    if ([subview isKindOfClass:[NSButton class]]) {
        // This is (presumably) the button holding the
        // outline triangle button.
        // We set our own images here.
        [(NSButton *)subview setImage:[NSImage imageNamed:@"disclosure-closed"]];
        [(NSButton *)subview setAlternateImage:[NSImage imageNamed:@"disclosure-open"]];
    }
}

@end
