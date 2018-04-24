//
//  RegisterWindowController.m
//  BaiduDownloader
//
//  Created by zll on 2018/4/23.
//  Copyright © 2018年 Godlike Studio. All rights reserved.
//

#import "RegisterWindowController.h"

@interface RegisterWindowController ()
@property(weak) IBOutlet NSTextField *macUUID;
@property(weak) IBOutlet NSTextField *serialNumber;
@property(weak) IBOutlet NSTextField *unameTF;
@property(weak) IBOutlet NSTextField *registerCodeTF;
- (IBAction)registerAction:(id)sender;
@end

@implementation RegisterWindowController

#pragma mark - Class Methods

+ (NSString *)nibName { return @"RegisterWindowController"; }
#pragma mark - Overrides

- (id)init { return [super initWithWindowNibName:[[self class] nibName]]; }
- (void)windowDidLoad
{
    [super windowDidLoad];
    NSString *hardwareInfo = [self getHardwareInfo];
    NSString *uuid = [self getInfoWithKey:@"IOPlatformUUID" hardwareInfo:hardwareInfo];
    NSString *sn = [self getInfoWithKey:@"IOPlatformSerialNumber" hardwareInfo:hardwareInfo];
    _macUUID.stringValue = uuid;
    _serialNumber.stringValue = sn;
}

- (NSString *)getInfoWithKey:(NSString *)key hardwareInfo:(NSString *)hardwareInfo
{
    NSString *value = __VREGEX__(hardwareInfo, key, @"\n");
    return [value substringWithRange:NSMakeRange(5, value.length - 6)];
}

- (NSString *)getHardwareInfo
{
    NSTask *task;
    task = [[NSTask alloc] init];
    [task setLaunchPath:@"/usr/sbin/ioreg"];
    NSArray *arguments;
    arguments = [NSArray arrayWithObjects:@"-rd1", @"-c", @"IOPlatformExpertDevice", nil];
    [task setArguments:arguments];

    NSPipe *pipe;
    pipe = [NSPipe pipe];
    [task setStandardOutput:pipe];

    NSFileHandle *file;
    file = [pipe fileHandleForReading];

    [task launch];

    NSData *data;
    data = [file readDataToEndOfFile];

    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

- (void)showWindow:(id)sender
{
    [NSApp activateIgnoringOtherApps:YES];
    [self.window center];
    //    [self showCopyright:sender];
    [super showWindow:sender];
}

- (IBAction)registerAction:(id)sender
{
    [Alert alertWithStyle:kAlertStyleSheet titles:nil message:@"提示" informative:@"注册成功!" clickBlock:nil];
}

@end
