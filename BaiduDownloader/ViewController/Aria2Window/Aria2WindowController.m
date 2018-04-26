//
//  Aria2WindowController.m
//  BaiduDownloader
//
//  Created by zll on 2018/4/26.
//  Copyright © 2018年 Godlike Studio. All rights reserved.
//

#import "Aria2WindowController.h"
#import <WebKit/WebKit.h>
#import "WebViewJavascriptBridge.h"

@interface Aria2WindowController ()<WKUIDelegate, WKNavigationDelegate>
@property(weak) IBOutlet WKWebView *aria2WebView;
@property(nonatomic, strong) WebViewJavascriptBridge *bridge;
@end

@implementation Aria2WindowController

#pragma mark - Class Methods

+ (NSString *)nibName { return @"Aria2Window"; }
#pragma mark - Overrides

- (id)init { return [super initWithWindowNibName:[[self class] nibName]]; }
- (void)windowDidLoad
{
    [super windowDidLoad];
    //    _aria2WebView.UIDelegate = self;
    //    _aria2WebView.navigationDelegate = self;
    [_aria2WebView.configuration.preferences setValue:@YES forKey:@"allowFileAccessFromFileURLs"];
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"index" withExtension:@"html" subdirectory:@"yaaw"];
    [_aria2WebView loadFileURL:url allowingReadAccessToURL:[url URLByDeletingLastPathComponent]];
    [_aria2WebView addObserver:self
                    forKeyPath:NSStringFromSelector(@selector(estimatedProgress))
                       options:0
                       context:nil];
    self.bridge = [WebViewJavascriptBridge bridgeForWebView:_aria2WebView];
    [WebViewJavascriptBridge enableLogging];
}

//开始加载
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation
{
    //开始加载的时候，让进度条显示
}

// kvo 监听进度
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSKeyValueChangeKey, id> *)change
                       context:(void *)context
{
    if ([keyPath isEqualToString:NSStringFromSelector(@selector(estimatedProgress))] && object == self.aria2WebView)
    {
        //        [self.progressView setAlpha:1.0f];
        //        BOOL animated = self.aria2WebView.estimatedProgress > self.progressView.progress;
        //        [self.progressView setProgress:self.aria2WebView.estimatedProgress
        //                              animated:animated];

        if (self.aria2WebView.estimatedProgress >= 1.0f)
        {
            //            [NSView animateWithDuration:0.3f
            //                                  delay:0.3f
            //                                options:UIViewAnimationOptionCurveEaseOut
            //                             animations:^{
            //                                 [self.progressView setAlpha:0.0f];
            //                             }
            //                             completion:^(BOOL finished) {
            //                                 [self.progressView setProgress:0.0f animated:NO];
            //                             }];
        }
    }
    else
    {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)showWindow:(id)sender
{
    [NSApp activateIgnoringOtherApps:YES];
    [self.window center];
    [super showWindow:sender];
}

-(void)downloadFiles:(NSArray *)urls
{
    [self.bridge callHandler:@"Aria2 Download"
                        data:@{@"path":@"", @"files":urls}
            responseCallback:^(id responseData) {
                NSLog(@"ObjC received response: %@", responseData);
            }];
}

- (void)dealloc
{
    [self.aria2WebView removeObserver:self forKeyPath:NSStringFromSelector(@selector(estimatedProgress))];
}

@end
