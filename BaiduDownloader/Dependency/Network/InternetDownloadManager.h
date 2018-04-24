//
//  DownLoadManager.h
//  BaiduDownloader
//
//  Created by Yuri Boyka on 2018/3/19.
//  Copyright © 2018年 Godlike Studio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileSegment : NSObject

/**
 分片索引
 */
@property(nonatomic, assign) NSUInteger segIdx;

/**
 分片已下载大小
 */
@property(nonatomic, assign) double segDownloadedSize;

/**
 分片临时文件
 */
@property(nonatomic, assign) NSString *segTmpFile;

/**
 分片开始
 */
@property(nonatomic, assign) double start;
/*
 分片结束
 */
@property(nonatomic, assign) double end;

@end

@interface FileInformation : NSObject

/**
 文件下载URL
 */
@property(nonatomic, copy) NSString *url;

/**
 文件下载路径
 */
@property(nonatomic, copy) NSString *path;

/**
 文件大小
 */
@property(nonatomic, assign) double fileSize;

/**
 文件分片信息
 */
@property(nonatomic, strong) NSMutableArray<FileSegment *> *fileSegs;

@end

typedef void (^ProgressBlock)(double progress);

typedef void (^SuccessBlock)(NSString *fileStorePath);

typedef void (^FailureBlock)(NSError *error);

@interface InternetDownloadCore : NSObject<NSURLSessionDataDelegate>
{
    BOOL _downloading;
}
/**
 * 所需要下载文件的远程URL(连接服务器的路径)
 */
@property(nonatomic, copy) NSString *url;
/**
 * 文件的存储路径(文件下载到什么地方)
 */
@property(nonatomic, copy) NSString *destPath;

/**
 * 是否正在下载(有没有在下载, 只有下载器内部才知道)
 */
@property(nonatomic, readonly, getter=isDownloading) BOOL downloading;

@property(nonatomic, copy) ProgressBlock progressBlock;

@property(nonatomic, copy) SuccessBlock successBlock;

@property(nonatomic, copy) FailureBlock failureBlock;

/**
 *  开始的位置
 */
@property(nonatomic, assign) long long begin;

/**
 *  结束的位置
 */
@property(nonatomic, assign) long long end;

/**
 * 开始(恢复)下载
 */
- (void)start;

/**
 * 暂停下载
 */
- (void)pause;

- (void)downLoadWithURL:(NSString *)URL
               progress:(ProgressBlock)progressBlock
                success:(SuccessBlock)successBlock
                  faile:(FailureBlock)faileBlock;

+ (instancetype)sharedInstance;

- (void)stopTask;

@end

/*
 FileInfoCache
 */
@interface InternetDownloadManager : NSObject

/**
 分段下载数
 */
@property(nonatomic, assign) NSUInteger segmentCount;

/**
 文件信息
 */
@property(nonatomic, strong) FileInformation *fileInfo;

+ (instancetype)sharedInstance;

- (void)downloadFileWithURL:(NSString *)url;

@end
