//
//  SetDataModel.h
//  BaiduDownloader
//
//  Created by zll on 26/03/2018.
//  Copyright © 2018 Godlike Studio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Thumb : NSObject
@property (nonatomic, copy) NSString *icon;
@property (nonatomic, copy) NSString *url1;
@property (nonatomic, copy) NSString *url2;
@property (nonatomic, copy) NSString *url3;
@end

@interface FileModel : NSObject
@property (nonatomic, copy) NSString *category;
@property (nonatomic, copy) NSString *fs_id;
@property (nonatomic, copy) NSString *isdir;
@property (nonatomic, copy) NSString *local_ctime;
@property (nonatomic, copy) NSString *local_mtime;
@property (nonatomic, copy) NSString *path;
@property (nonatomic, copy) NSString *server_ctime;
@property (nonatomic, copy) NSString *server_filename;
@property (nonatomic, copy) NSString *server_mtime;
@property (nonatomic, copy) NSString *size;
@property (nonatomic, strong) Thumb *thumbs;
@end

@interface ListModel : FileModel
@property (nonatomic, copy) NSString *app_id;
@property (nonatomic, copy) NSString *delete_fs_id;
@property (nonatomic, copy) NSString *extent_int3;
@property (nonatomic, copy) NSString *extent_tinyint1;
@property (nonatomic, copy) NSString *extent_tinyint2;
@property (nonatomic, copy) NSString *extent_tinyint3;
@property (nonatomic, copy) NSString *extent_tinyint4;
@property (nonatomic, copy) NSString *file_key;
@property (nonatomic, copy) NSString *isdelete;
@property (nonatomic, copy) NSString *md5;
@property (nonatomic, copy) NSString *oper_id;
@property (nonatomic, copy) NSString *parent_path;
@property (nonatomic, copy) NSString *path_md5;
@property (nonatomic, copy) NSString *root_ns;
@property (nonatomic, copy) NSString *share;
@property (nonatomic, copy) NSString *status;
@end

@interface FileListModel : NSObject
@property (nonatomic, copy) NSString *err;
@property (nonatomic, strong) NSArray<ListModel *> *list;
@property (nonatomic, copy) NSString *request_id;
@property (nonatomic, copy) NSString *server_time;
@end

@interface SamplingModel : NSObject
@property (nonatomic, strong) NSArray<NSString *> *expvar;
@end

@interface SetDataModel : NSObject
@property (nonatomic, copy) NSString *XDUSS;
@property (nonatomic, copy) NSString *activity_end_time;
@property (nonatomic, copy) NSString *applystatus;
@property (nonatomic, copy) NSString *bdstoken;
@property (nonatomic, copy) NSString *bt_paths;
@property (nonatomic, copy) NSString *ctime;
@property (nonatomic, copy) NSString *curr_activity_code;
@property (nonatomic, copy) NSString *desc;
@property (nonatomic, copy) NSString *errortype;
@property (nonatomic, copy) NSString *expiredType;
@property (nonatomic, copy) NSString *face_status;
@property (nonatomic, strong) FileListModel *file_list;
@property (nonatomic, copy) NSString *flag;
@property (nonatomic, copy) NSString *is_auto_svip;
@property (nonatomic, copy) NSString *is_evip;
@property (nonatomic, copy) NSString *is_master_svip;
@property (nonatomic, copy) NSString *is_master_vip;
@property (nonatomic, copy) NSString *is_svip;
@property (nonatomic, copy) NSString *is_vip;
@property (nonatomic, copy) NSString *is_year_vip;
@property (nonatomic, copy) NSString *linkusername;
@property (nonatomic, copy) NSString *loginstate;
@property (nonatomic, copy) NSString *need_tips;
@property (nonatomic, copy) NSString *novelid;
@property (nonatomic, copy) NSString *pansuk;
@property (nonatomic, copy) NSString *photo;
@property (nonatomic, copy) NSString *publik;
@property (nonatomic, strong) SamplingModel *sampling;
@property (nonatomic, copy) NSString *celf;
@property (nonatomic, copy) NSString *share_page_type;
@property (nonatomic, copy) NSString *shareid;
@property (nonatomic, copy) NSString *sharesuk;
@property (nonatomic, copy) NSString *show_vip_ad;
@property (nonatomic, copy) NSString *sign;
@property (nonatomic, copy) NSString *sign1;
@property (nonatomic, copy) NSString *sign2;
@property (nonatomic, copy) NSString *sign3;
@property (nonatomic, copy) NSString *srv_ts;
@property (nonatomic, copy) NSString *task_key;
@property (nonatomic, copy) NSString *task_time;
@property (nonatomic, copy) NSString *third;
@property (nonatomic, copy) NSString *timeline_status;
@property (nonatomic, copy) NSString *timestamp;
@property (nonatomic, copy) NSString *uk;
@property (nonatomic, copy) NSString *urlparam;
@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *vip_end_time;
@property (nonatomic, copy) NSString *visitor_avatar;
@property (nonatomic, copy) NSString *visitor_uk;
@end


