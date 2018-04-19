//
//  CustomWindowVC.m
//  BaiduDownloader
//
//  Created by Yuri Boyka on 2018/3/29.
//  Copyright © 2018年 Godlike Studio. All rights reserved.
//

#import "CustomWindowVC.h"

@interface CustomWindowVC ()
{
    NSTimer *_timer;
}
@end

@implementation CustomWindowVC

- (void)windowDidLoad {
    [super windowDidLoad];
}

- (void)show
{
    [self showWithStyle:ShowWindowStyleDefault];
}

- (void)showWithStyle:(ShowWindowStyle)style
{
    [self loadWindow];
    _style = style;
    switch (style) {
        case ShowWindowStyleDefault:
            [[self window] makeKeyAndOrderFront:nil];
            [self startTimer];
            break;
        case ShowWindowStyleModal:
            [NSApp runModalForWindow:[self window]];
            break;
        case ShowWindowStyleSheet:
        {
            [[[NSApplication sharedApplication] mainWindow] beginSheet:[self window] completionHandler:^(NSModalResponse returnCode) {
                [NSApp runModalForWindow:[self window]];
            }];
        }
            break;
        default:
            break;
    }
}

- (void)close
{
    [self closeWithComplete:nil];
}

- (void)closeWithComplete:(void (^)(void))closeComplete
{
    [NSApp stopModal];
    [NSApp endSheet:[self window]];
    [[self window] orderOut:nil];
    if (closeComplete) closeComplete();
}

- (BOOL)windowShouldClose:(id)sender {
    [NSApp stopModalWithCode:1];
    return YES;
}

- (void)dealloc
{
    if (_style)
    {
        [self stopTimer];
    }
}

- (void)startTimer
{
    [self stopTimer];
    _timer = [NSTimer scheduledTimerWithTimeInterval:1/60
                                              target:self
                                            selector:@selector(checkVisible:)
                                            userInfo:nil
                                             repeats:YES];
}

- (void)stopTimer
{
    [_timer invalidate];
    _timer = nil;
}

- (void)checkVisible:(NSTimer *)timer
{
    if (![[self window] isVisible])
    {
        [[self window] orderOut:self];
        [self stopTimer];
    }
    else
    {
        [[NSApp mainWindow] makeKeyAndOrderFront:self];
    }
}

@end
