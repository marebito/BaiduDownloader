//
//  AMRoundWindow.m
//  BaiduDownloader
//
//  Created by zll on 2018/4/24.
//  Copyright © 2018年 Godlike Studio. All rights reserved.
//

#import "AMRoundWindow.h"

@implementation AMRoundWindow

- (id)initWithContentRect:(NSRect)contentRect
                styleMask:(NSWindowStyleMask)aStyle
                  backing:(NSBackingStoreType)bufferingType
                    defer:(BOOL)flag
{
    self =
        [super initWithContentRect:contentRect styleMask:NSWindowStyleMaskBorderless backing:bufferingType defer:flag];

    if (self)
    {
        // 设置窗口为无边界
//         NSWindowStyleMaskResizable | NSWindowStyleMaskTitled | NSWindowStyleMaskFullSizeContentView
        [self setStyleMask:NSWindowStyleMaskBorderless];
        // 设置窗口为透明
        [self setOpaque:NO];
        // 设置背景无色
        [self setBackgroundColor:[NSColor clearColor]];
        // 设置为点击背景可以移动窗口
        [self setMovableByWindowBackground:YES];
        // 设置标题半透明
        [self setTitlebarAppearsTransparent:YES];
        // 设置窗口标题是否可见
        [self setTitleVisibility:NSWindowTitleHidden];
        // 设置工具栏是否可见
        [self setShowsToolbarButton:NO];
        // 设置窗口是否有阴影
        [self setHasShadow:YES];
        // 设置窗口隐藏关闭按钮
        [self standardWindowButton:NSWindowCloseButton].hidden = YES;
        // 设置窗口隐藏最小化按钮
        [self standardWindowButton:NSWindowMiniaturizeButton].hidden = YES;
        // 设置窗口隐藏全屏按钮
        [self standardWindowButton:NSWindowZoomButton].hidden = YES;
    }
    return self;
}

- (void)setContentView:(NSView *)aView
{
    aView.wantsLayer = YES;
    aView.layer.frame = aView.frame;

    aView.layer.cornerRadius = 20.0;
    aView.layer.masksToBounds = YES;

    NSShadow *dropShadow = [[NSShadow alloc] init];
    [dropShadow setShadowColor:[NSColor blackColor]];
    [dropShadow setShadowBlurRadius:10.0];
    [aView setShadow:dropShadow];

    [super setContentView:aView];
}

//如果不写此方法，生产的窗口上，添加的一些控件或文本处于editable
//加上此方法是使window变为keywindow
//一般是在无TitleBar时，也就是BorderlessWindow，才覆写此方法
//有TitleBar的Window默认是KeyWindow
- (BOOL)canBecomeKeyWindow { return YES; }
- (BOOL)canBecomeMainWindow { return YES; }
@end
