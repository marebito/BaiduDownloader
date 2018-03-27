//
//  FileListVC.m
//  BaiduDownloader
//
//  Created by zll on 27/03/2018.
//  Copyright © 2018 Godlike Studio. All rights reserved.
//

#import "FileListVC.h"

@interface FileListVC () <NSTableViewDelegate, NSTableViewDataSource>

@end

@implementation FileListVC

- (void)viewDidLoad {
    [super viewDidLoad];
}

//返回表格的行数
//- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView;
//{
//    return [array count];
//}
//
////用了下面那个函数来显示数据就用不上这个，但是协议必须要实现，所以这里返回nil
//- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
//{
//    return nil;
//}
//
////
//- (void)tableView:(NSTableView *)tableView willDisplayCell:(id)cell forTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
//{
//    SimpleData *data = [array objectAtIndex:row];
//    NSString *identifier = [tableColumn identifier];
//    
//    if ([identifier isEqualToString:@"name"]) {
//        NSTextFieldCell *textCell = cell;
//        [textCell setTitle:[data name]];
//    }
//    else if ([identifier isEqualToString:@"id"])
//    {
//        NSTextFieldCell *textCell = cell;
//        [textCell setTitle:[data iD]];
//    }
//}

@end
