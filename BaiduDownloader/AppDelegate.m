//
//  AppDelegate.m
//  BaiduDownloader
//
//  Created by Yuri Boyka on 2018/3/19.
//  Copyright © 2018年 Godlike Studio. All rights reserved.
//

#import "AppDelegate.h"
#import "RegisterWindowController.h"

@interface AppDelegate ()
@property(nonatomic, strong) RegisterWindowController *registerWindowController;
- (IBAction)clickRegister:(id)sender;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    _registerWindowController = [[RegisterWindowController alloc] init];
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender
{
    return YES;
}

- (void)applicationWillTerminate:(NSNotification *)aNotification
{
    // Insert code here to tear down your application
}

- (IBAction)clickRegister:(id)sender { [_registerWindowController showWindow:nil]; }
@end
