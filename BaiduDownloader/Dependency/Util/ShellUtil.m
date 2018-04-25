//
//  ShellObject.m
//  BaiduDownloader
//
//  Created by zll on 2018/4/24.
//  Copyright © 2018年 Godlike Studio. All rights reserved.
//

#import "ShellObject.h"

@interface ShellObject ()

@property (nonatomic, copy) ShellOutput output;

@end

@implementation ShellObject

- (BOOL)runProcessAsAdministrator:(NSString *)scriptPath
                    withArguments:(NSArray *)arguments
                           output:(NSString **)output
                 errorDescription:(NSString **)errorDescription
{
    NSString *allArgs = [arguments componentsJoinedByString:@" "];
    NSString *fullScript = [NSString stringWithFormat:@"%@ %@", scriptPath, allArgs];

    NSDictionary *errorInfo = [NSDictionary new];
    NSString *script = [NSString stringWithFormat:@"do shell script \"%@\" with administrator privileges", fullScript];

    NSAppleScript *appleScript = [[NSAppleScript new] initWithSource:script];
    NSAppleEventDescriptor *eventResult = [appleScript executeAndReturnError:&errorInfo];

    // Check errorInfo
    if (!eventResult)
    {
        // Describe common errors
        *errorDescription = nil;
        if ([errorInfo valueForKey:NSAppleScriptErrorNumber])
        {
            NSNumber *errorNumber = (NSNumber *)[errorInfo valueForKey:NSAppleScriptErrorNumber];
            if ([errorNumber intValue] == -128)
                *errorDescription = @"The administrator password is required to do this.";
        }
        // Set error message from provided message
        if (*errorDescription == nil)
        {
            if ([errorInfo valueForKey:NSAppleScriptErrorMessage])
                *errorDescription = (NSString *)[errorInfo valueForKey:NSAppleScriptErrorMessage];
        }
        return NO;
    }
    else
    {
        // Set output to the AppleScript's output
        *output = [eventResult stringValue];
        return YES;
    }
}

+ (void)executeShell:(NSString *)shellCmd
{
    NSArray *cmds = [shellCmd componentsSeparatedByString:@"|"];

}

+ (void)executeShell:(NSString *)cmd args:(NSArray *)args
{
    // Commands are read from standard input:
    NSFileHandle *input = [NSFileHandle fileHandleWithStandardInput];

    NSPipe *inPipe = [NSPipe new]; // pipe for shell input
    NSPipe *outPipe = [NSPipe new]; // pipe for shell output

    NSTask *task = [NSTask new];
    [task setLaunchPath:cmd];
    [task setArguments:args];
    [task setStandardInput:inPipe];
    [task setStandardOutput:outPipe];
    [task launch];

    // Wait for standard input ...
    [input waitForDataInBackgroundAndNotify];
    // ... and wait for shell output.
    [[outPipe fileHandleForReading] waitForDataInBackgroundAndNotify];

    // Wait asynchronously for standard input.
    // The block is executed as soon as some data is available on standard input.
    [[NSNotificationCenter defaultCenter] addObserverForName:NSFileHandleDataAvailableNotification
                                                      object:input queue:nil
                                                  usingBlock:^(NSNotification *notif)
     {
         NSData *inData = [input availableData];
         if ([inData length] == 0) {
             // EOF on standard input.
             [[inPipe fileHandleForWriting] closeFile];
         } else {
             // Read from standard input and write to shell input pipe.
             [[inPipe fileHandleForWriting] writeData:inData];

             // Continue waiting for standard input.
             [input waitForDataInBackgroundAndNotify];
         }
     }];

    // Wait asynchronously for shell output.
    // The block is executed as soon as some data is available on the shell output pipe.
    [[NSNotificationCenter defaultCenter] addObserverForName:NSFileHandleDataAvailableNotification
                                                      object:[outPipe fileHandleForReading] queue:nil
                                                  usingBlock:^(NSNotification *notif)
     {
         // Read from shell output
         NSData *outData = [[outPipe fileHandleForReading] availableData];
         NSString *outStr = [[NSString alloc] initWithData:outData encoding:NSUTF8StringEncoding];
         NSLog(@"output: %@", outStr);

         // Continue waiting for shell output.
         [[outPipe fileHandleForReading] waitForDataInBackgroundAndNotify];
     }];

    [task waitUntilExit];
}

@end
