//
//  FileListVC.m
//  BaiduDownloader
//
//  Created by zll on 27/03/2018.
//  Copyright © 2018 Godlike Studio. All rights reserved.
//

#import "FileListVC.h"
#import "SetDataModel.h"
#import "CustomTableRowView.h"

@interface FileListVC () <NSTableViewDelegate, NSTableViewDataSource>
{
    NSMutableArray<ListModel *> *files;
}
@end

@implementation FileListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mTableView.doubleAction = @selector(doubleClick:);
    [self fakeDat];
}

- (void)fakeDat
{
    files = [[NSMutableArray alloc] init];
    for (int i= 0; i < 10; i++) {
        ListModel *model = [[ListModel alloc] init];
        model.server_filename = @"我的文件";
        model.path = @"http://www.baidu.com";
        model.size = @"15M";
        [files addObject:model];
    }
}

- (void)doubleClick:(NSTableView *)sender
{
    NSLog(@"点击了第%d行", [sender ])
}

- (NSTableRowView *)tableView:(NSTableView *)tableView rowViewForRow:(NSInteger)row
{
    CustomTableRowView *rowView = [[CustomTableRowView alloc] init];
    return rowView;
}

//返回表格的行数
- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView;
{
    if (files)
    {
        return [files count];
    }
    return 0;
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    ListModel *data = [files objectAtIndex:row];
    NSString *identifier = [tableColumn identifier];
    
    if ([identifier isEqualToString:@"server_file_name"]) {
        NSTableCellView *cellView = [tableView makeViewWithIdentifier:@"server_file_name" owner:nil];
        cellView.textField.stringValue = [data server_filename];
        return cellView;
    }
    else if ([identifier isEqualToString:@"file_path"])
    {
        NSTableCellView *cellView = [tableView makeViewWithIdentifier:@"file_path" owner:nil];
        cellView.textField.stringValue = [data path];
        return cellView;
    }
    else if ([identifier isEqualToString:@"file_path"])
    {
        NSTableCellView *cellView = [tableView makeViewWithIdentifier:@"file_path" owner:nil];
        cellView.textField.stringValue = [data path];
        return cellView;
    }
    else if ([identifier isEqualToString:@"file_size"])
    {
        NSTableCellView *cellView = [tableView makeViewWithIdentifier:@"file_size" owner:nil];
        cellView.textField.stringValue = [data size];
        return cellView;
    }
    return nil;
}

- (void)tableView:(NSTableView *)tableView willDisplayCell:(id)cell forTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    
}

@end
