//
//  ImageAndTextCell.h
//  BaiduDownloader
//
//  Created by zll on 2018/4/5.
//  Copyright © 2018 Godlike Studio. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ImageAndTextCell : NSTextFieldCell

@property (nonatomic, strong) NSImage *icon;

@property (nonatomic, assign) NSSize iconSize;

@property (nonatomic, assign) CGFloat offset;

@end
