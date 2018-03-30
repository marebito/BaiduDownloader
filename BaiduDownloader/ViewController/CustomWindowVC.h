//
//  CustomWindowVC.h
//  BaiduDownloader
//
//  Created by zll on 2018/3/29.
//  Copyright © 2018年 Godlike Studio. All rights reserved.
//

#import <Cocoa/Cocoa.h>

/**
 显示窗口风格

 - ShowWindowStyleDefault: 默认方式显示窗口（非模态）
 - ShowWindowStyleModal: 模态方式显示窗口（模态)
 - ShowWindowStyleSheet: Sheet方式显示窗口(卷帘)
 */
typedef NS_ENUM(NSUInteger, ShowWindowStyle) {
    ShowWindowStyleDefault,
    ShowWindowStyleModal,
    ShowWindowStyleSheet
};

@interface CustomWindowVC : NSWindowController

@property (nonatomic, assign) ShowWindowStyle style;

- (void)show;

- (void)showWithStyle:(ShowWindowStyle)style;

- (void)close;

- (void)closeWithComplete:(void (^)(void))closeComplete;

@end
