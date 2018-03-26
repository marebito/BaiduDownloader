//
//  ViewController.m
//  BaiduDownloader
//
//  Created by zll on 2018/3/19.
//  Copyright © 2018年 Godlike Studio. All rights reserved.
//

#import "ViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "YYModel.h"
#import "Ono.h"
#import "HttpUtil.h"
#import "StringUtil.h"
#import "SetDataModel.h"

//https://pan.baidu.com/s/1VSthcUc3fnZGh1mlc43dxg 密码：kcyt

#define WeakObj(o) try{}@finally{} __weak typeof(o) o##Weak = o;
#define StrongObj(o) autoreleasepool{} __strong typeof(o) o = o##Weak;
#define __TOSTR__(FORMAT, ...) [NSString stringWithFormat:FORMAT, ##__VA_ARGS__]
#define __CTS__ [HttpUtil currentTimestamp]
#define __CTSD__(d) [HttpUtil currentTimestampDelay:d]
#define __CMTS__ [HttpUtil currentMilliTimestamp]
#define __CMTSD__(d) [HttpUtil currentMilliTimestampDelay:d]

#define logid_js @"\tvar s = \"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/~\uFF01@#\uFFE5%\u2026\u2026&\",\n\t\tu = String.fromCharCode,\n\t\tf = function (n) {\n\t\t\tif (n.length < 2) {\n\t\t\t\tvar e = n.charCodeAt(0);\n\t\t\t\treturn 128 > e ? n : 2048 > e ? u(192 | e >>> 6) + u(128 | 63 & e) : u(224 | e >>> 12 & 15) + u(128 | e >>> 6 & 63) + u(128 | 63 & e)\n\t\t\t}\n\t\t\tvar e = 65536 + 1024 * (n.charCodeAt(0) - 55296) + (n.charCodeAt(1) - 56320);\n\t\t\treturn u(240 | e >>> 18 & 7) + u(128 | e >>> 12 & 63) + u(128 | e >>> 6 & 63) + u(128 | 63 & e)\n\t\t}, l = /[\\uD800-\\uDBFF][\\uDC00-\\uDFFFF]|[^\\x00-\\x7F]/g,\n\t\td = function (n) {\n\t\t\treturn (n + \"\" + Math.random()).replace(l, f)\n\t\t}, g = function (n) {\n\t\t\tvar e = [0, 2, 1][n.length % 3],\n\t\t\t\to = n.charCodeAt(0) << 16 | (n.length > 1 ? n.charCodeAt(1) : 0) << 8 | (n.length > 2 ? n.charCodeAt(2) : 0),\n\t\t\t\tt = [s.charAt(o >>> 18), s.charAt(o >>> 12 & 63), e >= 2 ? \"=\" : s.charAt(o >>> 6 & 63), e >= 1 ? \"=\" : s.charAt(63 & o)];\n\t\t\treturn t.join(\"\")\n\t\t}, m = function (n) {\n\t\t\treturn n.replace(/[\\s\\S]{1,3}/g, g)\n\t\t}, h = function () {\n\t\t\treturn m(d((new Date).getTime()))\n\t\t}, w = function (n, e) {\n\t\t\treturn e ? h(String(n)).replace(/[+\\/]/g, function (n) {\n\t\t\t\treturn \"+\" == n ? \"-\" : \"_\"\n\t\t\t}).replace(/=/g, \"\") : h(String(n))\n\t\t};"

#define cflag_js @"w = function (n) {return String(escape(n));}"

#define BDCLND_ERROR_1 -62 // 获取BDCLND错误（原因是由于多次下载同一个资源造成的，一般三次后需要输入验证码）

#define BDCLND_ERROR_2 -9 // 获取BDCLND错误（原因是由于多次下载同一个资源造成的，一般三次后需要输入验证码）

#define DLINK_ERROR_1 113  // 获取文件失败

#define DLINK_ERROR_2 -20  // 获取文件失败

#define BAIDU_PAN_HOST @"pan.baidu.com"

#define BAIDU_PCS_HOST @"pcs.baidu.com"

#define BAIDU_ACCEPT_IMAGE @"image/webp,image/apng,image/*,*/*;q=0.8" // 接收图片

#define BAIDU_ACCEPT_JSON @"application/json, text/javascript, */*; q=0.01" // 接收JSON

#define BAIDU_ACCEPT_HTML @"text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8" // 接收HTML

#define BAIDU_ACCEPT_ENCODING @"gzip, deflate, br" // 接收的编码类型

#define BAIDU_CONN_KEEPALIVE @"keep-alive"   // 连接状态

#define WEB_USER_AGENT @"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36" // 浏览器User-Agent

#define BAIDU_ACCEPT_LANGUAGE @"zh-CN,zh;q=0.9,ja;q=0.8,en;q=0.7,zh-TW;q=0.6" // 接收的语言类型

#define BAIDU_REDIRECT_URL __UDGET__(@"Location")

#define TEST_URL @"https://pan.baidu.com/s/1VSthcUc3fnZGh1mlc43dxg" // 测试链接

#define TEST_URL2 @"http://pan.baidu.com/s/1mighQo4" // otwx

@interface ViewController ()

@property (nonatomic, strong) JSContext *context;
@property (weak) IBOutlet NSTextField *downloadURL;
@property (weak) IBOutlet NSTextField *realURL;
@property (weak) IBOutlet NSTextField *fetchPwdTF;
@property (weak) IBOutlet NSImageView *vcodeIV;
@property (weak) IBOutlet NSTextField *vcodeTF;
@property (weak) IBOutlet NSTextField *statusLbl;

@property (nonatomic, copy) NSString *shareURL;    // 分享URL
@property (nonatomic, copy) NSString *redirectURL; // 重定向URL

@property (nonatomic, copy) SetDataModel *sdm;

- (IBAction)fetch:(id)sender;
- (IBAction)fetchVCode:(id)sender;
- (IBAction)copyDirectLink:(id)sender;
- (IBAction)downloadWithFolx:(id)sender;
- (IBAction)downloadWithThunder:(id)sender;
- (IBAction)downloadWithWget:(id)sender;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.vcodeIV.enabled = NO;
    self.vcodeTF.enabled = NO;
}


- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];
}

- (void)setStatus:(NSString *)str isSuccess:(BOOL)isSuccess
{
    _statusLbl.stringValue = str;
    if (!isSuccess)
    {
        _statusLbl.textColor = [NSColor redColor];
    }
    else
    {
        _statusLbl.textColor = [NSColor systemBlueColor];
    }
}

- (void)openURL:(NSString *)url
{
    // 打开URL， 从中获取Cookie
    if ([url hasPrefix:@"http"])
    {
        url = __TOSTR__(@"https:%@",[url substringFromIndex:5]);
    }
    self.shareURL = url;
    self.redirectURL = [NSString stringWithFormat:@"%@?errno=0&errmsg=Auth%%20Login%%20Sucess&&bduss=&ssnerror=0&traceid=", self.shareURL];
    NSDictionary *headers = @{@"Host":BAIDU_PAN_HOST, @"Connection":BAIDU_CONN_KEEPALIVE, @"Upgrade-Insecure-Requests":@"1", @"User-Agent":WEB_USER_AGENT, @"Accept":BAIDU_ACCEPT_HTML, @"Accept-Encoding":BAIDU_ACCEPT_ENCODING, @"Accept-Language":BAIDU_ACCEPT_LANGUAGE};
    @WeakObj(self)
    [HttpUtil request:url method:@"GET" headers:headers params:nil completion:^(NSURLResponse *response, id responseObject, NSError *error) {
        @StrongObj(self)
        [self getPlantCookieEtt];
    }];
}

- (void)getPlantCookieEtt
{
    _statusLbl.stringValue = @"正在获取Ett，请稍后...";
    NSString *url = @"https://pcs.baidu.com/rest/2.0/pcs/file";
    NSString *baiduID = __UDGET__(@"BAIDUID");
    if(!baiduID)
    {
        [self setStatus:@"获取BAIDUID失败" isSuccess:NO];
        return;
    }
    NSDictionary *headers = @{@"Accept":BAIDU_ACCEPT_IMAGE,
                              @"Accept-Encoding":BAIDU_ACCEPT_ENCODING,
                              @"Accept-Language":BAIDU_ACCEPT_LANGUAGE,
                              @"Connection":BAIDU_CONN_KEEPALIVE,
                              @"Cookie":[NSString stringWithFormat:@"BAIDUID=%@", baiduID],
                              @"Host":BAIDU_PCS_HOST,
                              @"Referer":self.redirectURL,
                              @"Upgrade-Insecure-Requests":@"1",
                              @"User-Agent":WEB_USER_AGENT
                              };
    NSDictionary *queryParams = @{@"method":@"plantcookie", @"type":@"ett"};
    @WeakObj(self)
    [HttpUtil request:url method:@"GET" headers:headers params:queryParams completion:^(NSURLResponse *response, id responseObject, NSError *error) {
        @StrongObj(self)
        NSString *pcsetts = __VREGEX__(__SETCOOKIE__(response), @"pcsett=", @";");
        __UDSET__(@"pcsett", pcsetts); __UDSYNC__;
        [self setStatus:__TOSTR__(@"获取ett%@", error?@"失败":@"成功") isSuccess:!error];
        if (error) return;
        [self requestPlantCookieStokenPCS];
    }];
}

- (void)requestPlantCookieStokenPCS
{
    _statusLbl.stringValue = @"正在获取StokenPCS，请稍后...";
    NSString *url = @"https://pcs.baidu.com/rest/2.0/pcs/file";
    NSDictionary *headers = @{@"Accept":BAIDU_ACCEPT_IMAGE,
                              @"Accept-Encoding":BAIDU_ACCEPT_ENCODING,
                              @"Accept-Language":BAIDU_ACCEPT_LANGUAGE,
                              @"Connection":BAIDU_CONN_KEEPALIVE,
                              @"Cookie":[NSString stringWithFormat:@"BAIDUID=%@;pcsett=%@",__UDGET__(@"BAIDUID"), __UDGET__(@"pcsett")],
                              @"Host":BAIDU_PCS_HOST,
                              @"Referer":self.redirectURL,
                              @"User-Agent":WEB_USER_AGENT
                              };
    NSDictionary *queryParams = @{@"method":@"plantcookie", @"type":@"stoken", @"source":@"pcs"};
    [HttpUtil request:url method:@"GET" headers:headers params:queryParams completion:^(NSURLResponse *response, id responseObject, NSError *error) {
        __UDSET__(@"x-bs-client-ip", __HEADV__(response, @"x-bs-client-ip"));
        __UDSET__(@"x-bs-client-ip", __HEADV__(response, @"x-bs-request-id")); __UDSYNC__;
        [self setStatus:__TOSTR__(@"获取StokenPCS%@", error?@"失败":@"成功") isSuccess:!error];
        if (error) return;
        [self requestPlantCookieStokenPCSData];
    }];
}

- (void)requestPlantCookieStokenPCSData
{
    _statusLbl.stringValue = @"正在获取StokenPCSData，请稍后...";
    NSString *url = @"https://pcsdata.baidu.com/rest/2.0/pcs/file";
    NSDictionary *headers = @{@"Accept":BAIDU_ACCEPT_IMAGE,
                              @"Accept-Encoding":BAIDU_ACCEPT_ENCODING,
                              @"Accept-Language":BAIDU_ACCEPT_LANGUAGE,
                              @"Connection":BAIDU_CONN_KEEPALIVE,
                              @"Cookie":[NSString stringWithFormat:@"BAIDUID=%@",__UDGET__(@"BAIDUID")],
                              @"Host":@"pcsdata.baidu.com",
                              @"Referer":BAIDU_REDIRECT_URL,
                              @"User-Agent":WEB_USER_AGENT
                              };
    NSDictionary *queryParams = @{@"method":@"plantcookie", @"type":@"stoken", @"source":@"pcsdata"};
    @WeakObj(self)
    [HttpUtil request:url method:@"GET" headers:headers params:queryParams completion:^(NSURLResponse *response, id responseObject, NSError *error) {
        @StrongObj(self)
        __UDSET__(@"x-bs-request-id", __HEADV__(response, @"x-bs-request-id")); __UDSYNC__;
        [self setStatus:__TOSTR__(@"获取StokenPCSData%@", error?@"失败":@"成功") isSuccess:!error];
        if (error) return;
        [self requestHMValue];
    }];
}

- (void)requestHMValue
{
    _statusLbl.stringValue = @"正在获取HMValue，请稍后...";
    NSString *url = @"https://pan.baidu.com/box-static/disk-share/js/baidu-tongji.js";
    NSDictionary *headers = @{@"Accept":BAIDU_ACCEPT_IMAGE,
                              @"Accept-Encoding":BAIDU_ACCEPT_ENCODING,
                              @"Accept-Language":BAIDU_ACCEPT_LANGUAGE,
                              @"Connection":BAIDU_CONN_KEEPALIVE,
                              @"Cookie":[NSString stringWithFormat:@"PANWED=1;BAIDUID=%@",__UDGET__(@"BAIDUID")],
                              @"Host":BAIDU_PAN_HOST,
                              @"Referer":BAIDU_REDIRECT_URL,
                              @"User-Agent":WEB_USER_AGENT
                              };
    NSDictionary *queryParams = @{@"t":__CMTS__};
    @WeakObj(self)
    [HttpUtil request:url method:@"GET" headers:headers params:queryParams completion:^(NSURLResponse *response, id responseObject, NSError *error) {
        @StrongObj(self)
        NSString *string = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSArray *array = __MREGEX__(string, @"js.*?\"");
        if (array.count > 0) {
            NSString *hm_value = [array[0] substringFromIndex:3];
            hm_value = [hm_value stringByReplacingOccurrencesOfString:@"\"" withString:@""];
            __UDSET__(@"hm_value", hm_value); __UDSYNC__;
        }
        [self setStatus:__TOSTR__(@"获取HMValue%@", error?@"失败":@"成功") isSuccess:!error];
        if (error) return;
        [self requestHMVT];
    }];
}

- (void)requestHMVT
{
    _statusLbl.stringValue = @"正在获取HMVT，请稍后...";
    NSString *url = [NSString stringWithFormat:@"https://hm.baidu.com/h.js?%@", __UDGET__(@"hm_value")];
    NSDictionary *headers = @{@"Accept":@"*/*",
                              @"Accept-Encoding":BAIDU_ACCEPT_ENCODING,
                              @"Accept-Language":BAIDU_ACCEPT_LANGUAGE,
                              @"Connection":BAIDU_CONN_KEEPALIVE,
                              @"Cookie":[NSString stringWithFormat:@"PANWED=1;BAIDUID=%@",__UDGET__(@"BAIDUID")],
                              @"Host":@"hm.baidu.com",
                              @"Referer":BAIDU_REDIRECT_URL,
                              @"User-Agent":WEB_USER_AGENT
                              };
    @WeakObj(self)
    [HttpUtil request:url method:@"GET" headers:headers params:nil completion:^(NSURLResponse *response, id responseObject, NSError *error) {
        @StrongObj(self)
        NSString *set_cookie = __SETCOOKIE__(response);
        NSString *hmvt = __VREGEX__(set_cookie, @"HMVT=", @";");
        NSString *hmaccount = [set_cookie stringByKeyWord:@"HMACCOUNT=" withSuffix:@";"];
        __UDSET__(@"HMVT", [hmvt componentsSeparatedByString:@"|"][1]);
        __UDSET__(@"HMACCOUNT", hmaccount); __UDSYNC__;
        [self setStatus:__TOSTR__(@"获取HMVT%@", error?@"失败":@"成功") isSuccess:!error];
        if (error) return;
        [self requestAppID];
    }];
}

- (void)requestAppID
{
    _statusLbl.stringValue = @"正在获取AppID，请稍后...";
    NSString *url = @"https://pan.baidu.com/box-static/disk-share/js/boot_4faf629.js";
    NSDictionary *headers = @{@"Accept":BAIDU_ACCEPT_IMAGE,
                              @"Accept-Encoding":BAIDU_ACCEPT_ENCODING,
                              @"Accept-Language":BAIDU_ACCEPT_LANGUAGE,
                              @"Connection":BAIDU_CONN_KEEPALIVE,
                              @"Cookie":[NSString stringWithFormat:@"PANWEB=1;BAIDUID=%@",__UDGET__(@"BAIDUID")],
                              @"Host":BAIDU_PAN_HOST,
                              @"Referer":BAIDU_REDIRECT_URL,
                              @"User-Agent":WEB_USER_AGENT
                              };
    @WeakObj(self)
    [HttpUtil request:url method:@"GET" headers:headers params:nil completion:^(NSURLResponse *response, id responseObject, NSError *error) {
        @StrongObj(self)
        NSString *app_id = __VREGEX__(__RD__(responseObject), @"app_id=", @"&");
        NSString *logid = [self executeJS:logid_js params:@[__UDGET__(@"BAIDUID")]];
        __UDSET__(@"app_id", app_id);
        __UDSET__(@"logid", logid); __UDSYNC__;
        [self setStatus:__TOSTR__(@"获取AppID%@", error?@"失败":@"成功") isSuccess:!error];
        if (error) return;
        [self requestHostList];
    }];
}

- (void)requestHostList
{
    _statusLbl.stringValue = @"正在获取服务器列表，请稍后...";
    NSString *url = @"https://d.pcs.baidu.com/rest/2.0/pcs/manage?method=listhost";
    NSDictionary *headers = @{@"Host":@"d.pcs.baidu.com",
                              @"Connection":BAIDU_CONN_KEEPALIVE,
                              @"User-Agent":WEB_USER_AGENT,
                              @"Accept":@"*/*",
                              @"Referer":self.shareURL,
                              @"Accept-Encoding":BAIDU_ACCEPT_ENCODING,
                              @"Accept-Language":BAIDU_ACCEPT_LANGUAGE,
                              @"Cookie":[NSString stringWithFormat:@"BAIDUID=%@;pcsett=%@",__UDGET__(@"BAIDUID"), __UDGET__(@"pcsett")],
                              @"X-Requested-With":@"XMLHttpRequest"
                              };
    @WeakObj(self)
    [HttpUtil request:url method:@"GET" headers:headers params:nil completion:^(NSURLResponse *response, id responseObject, NSError *error) {
        @StrongObj(self)
        [self setStatus:__TOSTR__(@"获取服务器主机列表%@", error?@"失败":@"成功") isSuccess:!error];
        if (error) return;
        // 计算cflag
        NSDictionary *jsonDic = __JSONDIC__(responseObject);
        NSString *hm_lpvt = __VREGEX__(jsonDic[@"path"], @"t=", @"$");
        NSArray *hostList = jsonDic[@"list"];
        NSInteger o = 0;
        NSInteger c = hostList.count - 1;
        for (NSDictionary *dic in hostList)
        {
            o += [dic[@"id"] integerValue];
        }
        NSString *cflag = [NSString stringWithFormat:@"%ld:%ld", (long)o, (long)c];
        cflag = [self executeJS:cflag_js params:@[cflag]];
        __UDSET__(@"hm_lpvt", hm_lpvt);
        __UDSET__(@"cflag", cflag);
        __UDREMOVE__(@"vcode"); __UDSYNC__;
        [self requestBDCLND:_fetchPwdTF.stringValue];
    }];
}

- (void)requestBDCLND:(NSString *)pwd
{
    _statusLbl.stringValue = @"正在获取BDCLND，请稍后...";
    NSString *url = @"https://pan.baidu.com/share/verify";
    NSDictionary *headers = @{
                              @"Host":BAIDU_PAN_HOST,
                              @"Connection":BAIDU_CONN_KEEPALIVE,
                              @"Accept":@"*/*",
                              @"Origin":@"https://pan.baidu.com",
                              @"X-Requested-With":@"XMLHttpRequest",
                              @"User-Agent":WEB_USER_AGENT,
                              @"Content-Type":@"application/x-www-form-urlencoded; charset=UTF-8",
                              @"Accept-Encoding":BAIDU_ACCEPT_ENCODING,
                              @"Accept-Language":BAIDU_ACCEPT_LANGUAGE,
                              @"Content-Length":@"26",
                              @"Referer":BAIDU_REDIRECT_URL,
                              @"Cookie":[NSString stringWithFormat:@"PANWEB=1;BAIDUID=%@;%@;%@",__UDGET__(@"BAIDUID"), __TOSTR__(@"Hm_lvt_%@=%@", __UDGET__(@"hm_value"), __UDGET__(@"HMVT")), __TOSTR__(@"Hm_lpvt_%@=%@", __UDGET__(@"hm_value"), __UDGET__(@"HMVT"))],
                              };
    NSDictionary *queryParams = @{@"surl":__VREGEX__(BAIDU_REDIRECT_URL, @"surl=", @"$"), @"t":__CMTS__, @"bdstoken":@"null", @"channel":@"chunlei", @"clienttype":@"0", @"web":@"1", @"app_id":__UDGET__(@"app_id"), @"logid":__UDGET__(@"logid")};
    url = [NSString stringWithFormat:@"%@?%@",url, [HttpUtil URLParamsString:queryParams]];
    NSString *vcode = [[_vcodeTF.stringValue stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] lowercaseString];
    NSString *vcode_str = __UDGET__(@"vcode");
    NSDictionary *formData = @{@"pwd":pwd, @"vcode":vcode?vcode:@"", @"vcode_str":vcode_str?vcode_str:@""};
    @WeakObj(self)
    [HttpUtil request:url method:@"POST" headers:headers params:formData completion:^(NSURLResponse *response, id responseObject, NSError *error) {
        @StrongObj(self)
        NSString *BDCLND = __VREGEX__(__SETCOOKIE__(response), @"BDCLND=", @";");
        if (BDCLND.length == 0)
        {
            NSDictionary *jsonDic = __JSONDIC__(responseObject);
            if([jsonDic[@"errno"] intValue] == BDCLND_ERROR_1 || [jsonDic[@"errno"] intValue] == BDCLND_ERROR_2)
            {
                [self setStatus:__TOSTR__(@"获取BDCLND%@, 请输入图片中的验证码后，重新获取!", error?@"失败":@"成功") isSuccess:!error];
                self.vcodeIV.enabled = YES;
                [self requestCaptcha];
            }
            return;
        }
        __UDSET__(@"BDCLND", BDCLND); __UDSYNC__;
        [self setStatus:__TOSTR__(@"获取BDCLND%@", error?@"失败":@"成功") isSuccess:!error];
        if (error) return;
        [self getUserBaiduDiskFileList];
    }];
}

- (void)getUserBaiduDiskFileList
{
    _statusLbl.stringValue = @"正在获取文件列表，请稍后...";
    NSDictionary *headers = @{@"Host":BAIDU_PAN_HOST,
                              @"Connection":BAIDU_CONN_KEEPALIVE,
                              @"Upgrade-Insecure-Requests":@"1",
                              @"User-Agent":WEB_USER_AGENT,
                              @"Accept":BAIDU_ACCEPT_HTML,
                              @"Referer":BAIDU_REDIRECT_URL,
                              @"Accept-Encoding":BAIDU_ACCEPT_ENCODING,
                              @"Accept-Language":BAIDU_ACCEPT_LANGUAGE,
                              @"Cookie":[NSString stringWithFormat:@"PANWEB=1;BAIDUID=%@;BDCLND=%@;%@;%@",__UDGET__(@"BAIDUID"), __UDGET__(@"BDCLND"), __TOSTR__(@"Hm_lvt_%@=%@", __UDGET__(@"hm_value"), __CTS__), __TOSTR__(@"Hm_lpvt_%@=%@", __UDGET__(@"hm_value"), __UDGET__(@"HMVT"))],
                              };
    @WeakObj(self)
    [HttpUtil request:self.shareURL method:@"GET" headers:headers params:nil completion:^(NSURLResponse *response, id responseObject, NSError *error) {
        @StrongObj(self)
        NSString *html = __RD__(responseObject);
        NSString *setData = [html matchWithRegex:@"setData.*?;"][0];
        setData = [setData substringWithRange:NSMakeRange(8, setData.length - 10)];
        _sdm = [SetDataModel yy_modelWithJSON:setData];
        if (!_sdm)
        {
            [self setStatus:@"文件列表异常!" isSuccess:NO];
            return;
        }
        NSArray *ukarray = __MREGEX__(html, @"\\?uk=.*?&");
        NSString *uk = [ukarray[0] componentsSeparatedByString:@"="][1];
        uk = [uk substringToIndex:uk.length - 1];
        // 获取share_id, 该值为后续请求参数中的primaryid
        NSArray *shareIdArray = __MREGEX__(html, @"SHARE_ID.*?;");
        NSString *share_id = [[shareIdArray[0] componentsSeparatedByString:@"="][1] stringByReplacingOccurrencesOfString:@"\"" withString:@""];
        share_id = [[share_id stringByReplacingOccurrencesOfString:@";" withString:@""] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        NSArray *signArray = __MREGEX__(html, @"\"sign\".*?,");
        NSString *sign = [[signArray[0] componentsSeparatedByString:@":"][1] stringByReplacingOccurrencesOfString:@"\"" withString:@""];
        sign = [sign substringToIndex:sign.length - 1];
        __UDSET__(@"share_id", share_id);
        __UDSET__(@"sign", sign);
        __UDSET__(@"uk", uk); __UDSYNC__;
        // 计算cflag pcsDownloadUtil.js->initPcsDownloadCdnConnectivity->_getHostList->ajax_callback_success->_startTesting->o=Σhost_id c=host.count-1->escape('o：c')
        // 调用获取host列表接口模拟_getHostList的ajax请求
        [self setStatus:__TOSTR__(@"获取文件列表%@", error?@"失败":@"成功") isSuccess:!error];
        if (error) return;
        [self getFileList:nil];
    }];
}

- (void)getFileList:(NSArray *)dirList
{
    NSString *url = __TOSTR__(@"https://%@/share/list", BAIDU_PAN_HOST);
    NSDictionary *headers = @{@"Host":BAIDU_PAN_HOST,
                              @"Connection":BAIDU_CONN_KEEPALIVE,
                              @"User-Agent":WEB_USER_AGENT,
                              @"Accept":BAIDU_ACCEPT_IMAGE,
                              @"Referer":self.shareURL,
                              @"Accept-Encoding":BAIDU_ACCEPT_ENCODING,
                              @"Accept-Language":BAIDU_ACCEPT_LANGUAGE,
                              @"Cookie":[NSString stringWithFormat:@"PANWEB=1;BAIDUID=%@;%@;BDCLND=%@;%@;cflag=%@",__UDGET__(@"BAIDUID"), __TOSTR__(@"Hm_lvt_%@=%@", __UDGET__(@"hm_value"), __UDGET__(@"HMVT")), __UDGET__ (@"BDCLND"), __TOSTR__(@"Hm_lpvt_%@=%@", __UDGET__(@"hm_value"), __UDGET__(@"hm_lpvt")), __UDGET__(@"cflag")]
                              };
    NSDictionary *queryParams = @{@"uk":__UDGET__(@"uk"), @"shareid":_sdm.shareid, @"order":@"other", @"desc":@"1", @"showempty":@"0", @"web":@"1", @"page":@"1", @"num":@"100", @"dir":self.sdm.file_list.list[0].path, @"t":@"", @"channel":@"chunlei", @"web":@"1", @"app_id":__UDGET__(@"app_id"), @"bdstoken":@"null", @"logid":__UDGET__(@"logid"), @"clienttype":@"0"};
    /*
     {
     errno = 0;
     list =     (
     {
     category = 6;
     "fs_id" = 251947432066287;
     isdir = 1;
     "local_ctime" = 1484072738;
     "local_mtime" = 1484072738;
     path = "/\U9879\U76ee\U5907\U4efd/React.js es6\U5305\U542b\U5b9e\U6218/react native \U5feb\U901f\U5f00\U53d1App \U5b9e\U6218 \U8bfe\U7a0b\U5341\U4e94\Uff088\U670823\U65e5\Uff09";
     "server_ctime" = 1484072738;
     "server_filename" = "react native \U5feb\U901f\U5f00\U53d1App \U5b9e\U6218 \U8bfe\U7a0b\U5341\U4e94\Uff088\U670823\U65e5\Uff09";
     "server_mtime" = 1509458806;
     size = 0;
     },
     {
     category = 6;
     "fs_id" = 1017227447865750;
     isdir = 1;
     "local_ctime" = 1474802565;
     "local_mtime" = 1474802565;
     path = "/\U9879\U76ee\U5907\U4efd/React.js es6\U5305\U542b\U5b9e\U6218/12.\U8d2f\U7a7f\U5168\U6808React Native\U5f00\U53d1App \U5ba0\U7269\U9879\U76ee\U5b9e\U6218";
     "server_ctime" = 1474802565;
     "server_filename" = "12.\U8d2f\U7a7f\U5168\U6808React Native\U5f00\U53d1App \U5ba0\U7269\U9879\U76ee\U5b9e\U6218";
     "server_mtime" = 1509458806;
     size = 0;
     },
     {
     category = 6;
     "fs_id" = 548822466330868;
     isdir = 1;
     "local_ctime" = 1478620743;
     "local_mtime" = 1478620743;
     path = "/\U9879\U76ee\U5907\U4efd/React.js es6\U5305\U542b\U5b9e\U6218/11.React+Redux \Uff08\U8865\U5145\Uff09";
     "server_ctime" = 1478620743;
     "server_filename" = "11.React+Redux \Uff08\U8865\U5145\Uff09";
     "server_mtime" = 1509458806;
     size = 0;
     },
     {
     category = 6;
     "fs_id" = 926164119559310;
     isdir = 1;
     "local_ctime" = 1470059379;
     "local_mtime" = 1470059379;
     path = "/\U9879\U76ee\U5907\U4efd/React.js es6\U5305\U542b\U5b9e\U6218/10.React Native\U89c6\U9891\U6559\U7a0b-\U7535\U5546\U9879\U76ee\U5b9e\U6218";
     "server_ctime" = 1470059379;
     "server_filename" = "10.React Native\U89c6\U9891\U6559\U7a0b-\U7535\U5546\U9879\U76ee\U5b9e\U6218";
     "server_mtime" = 1509458806;
     size = 0;
     },
     {
     category = 6;
     "fs_id" = 150094146437499;
     isdir = 1;
     "local_ctime" = 1471537659;
     "local_mtime" = 1471537659;
     path = "/\U9879\U76ee\U5907\U4efd/React.js es6\U5305\U542b\U5b9e\U6218/09.React Native\U9ad8\U7ea7";
     "server_ctime" = 1471537659;
     "server_filename" = "09.React Native\U9ad8\U7ea7";
     "server_mtime" = 1509458806;
     size = 0;
     },
     {
     category = 6;
     "fs_id" = 1096856158843310;
     isdir = 1;
     "local_ctime" = 1471535065;
     "local_mtime" = 1471535065;
     path = "/\U9879\U76ee\U5907\U4efd/React.js es6\U5305\U542b\U5b9e\U6218/08.React Native\U8fdb\U9636";
     "server_ctime" = 1471535065;
     "server_filename" = "08.React Native\U8fdb\U9636";
     "server_mtime" = 1509458806;
     size = 0;
     },
     {
     category = 6;
     "fs_id" = 788026160045988;
     isdir = 1;
     "local_ctime" = 1471535060;
     "local_mtime" = 1471535060;
     path = "/\U9879\U76ee\U5907\U4efd/React.js es6\U5305\U542b\U5b9e\U6218/07.React Native\U57fa\U7840\U77e5\U8bc6";
     "server_ctime" = 1471535060;
     "server_filename" = "07.React Native\U57fa\U7840\U77e5\U8bc6";
     "server_mtime" = 1509458806;
     size = 0;
     },
     {
     category = 6;
     "fs_id" = 137615177121955;
     isdir = 1;
     "local_ctime" = 1464093743;
     "local_mtime" = 1464093743;
     path = "/\U9879\U76ee\U5907\U4efd/React.js es6\U5305\U542b\U5b9e\U6218/06.ReactJs\U89c6\U9891\U6559\U7a0b";
     "server_ctime" = 1464093743;
     "server_filename" = "06.ReactJs\U89c6\U9891\U6559\U7a0b";
     "server_mtime" = 1509458806;
     size = 0;
     },
     {
     category = 6;
     "fs_id" = 20266363437945;
     isdir = 1;
     "local_ctime" = 1471535056;
     "local_mtime" = 1471535056;
     path = "/\U9879\U76ee\U5907\U4efd/React.js es6\U5305\U542b\U5b9e\U6218/05.React \U8def\U7531";
     "server_ctime" = 1471535056;
     "server_filename" = "05.React \U8def\U7531";
     "server_mtime" = 1509458806;
     size = 0;
     },
     {
     category = 6;
     "fs_id" = 192018523381613;
     isdir = 1;
     "local_ctime" = 1471535051;
     "local_mtime" = 1471535051;
     path = "/\U9879\U76ee\U5907\U4efd/React.js es6\U5305\U542b\U5b9e\U6218/04.React \U57fa\U7840";
     "server_ctime" = 1471535051;
     "server_filename" = "04.React \U57fa\U7840";
     "server_mtime" = 1509458806;
     size = 0;
     },
     {
     category = 6;
     "fs_id" = 168424752130142;
     isdir = 1;
     "local_ctime" = 1471535039;
     "local_mtime" = 1471535039;
     path = "/\U9879\U76ee\U5907\U4efd/React.js es6\U5305\U542b\U5b9e\U6218/03.ECMAScript (es6)\U65b0\U529f\U80fd";
     "server_ctime" = 1471535039;
     "server_filename" = "03.ECMAScript (es6)\U65b0\U529f\U80fd";
     "server_mtime" = 1509458806;
     size = 0;
     },
     {
     category = 6;
     "fs_id" = 165338753862896;
     isdir = 1;
     "local_ctime" = 1434380419;
     "local_mtime" = 1434380419;
     path = "/\U9879\U76ee\U5907\U4efd/React.js es6\U5305\U542b\U5b9e\U6218/02.Javascript\U8fdb\U9636 48\U96c6";
     "server_ctime" = 1434380419;
     "server_filename" = "02.Javascript\U8fdb\U9636 48\U96c6";
     "server_mtime" = 1509458806;
     size = 0;
     },
     {
     category = 6;
     "fs_id" = 527544908695990;
     isdir = 1;
     "local_ctime" = 1471535028;
     "local_mtime" = 1471535028;
     path = "/\U9879\U76ee\U5907\U4efd/React.js es6\U5305\U542b\U5b9e\U6218/01.JavaScript\U57fa\U7840 36\U96c6";
     "server_ctime" = 1471535028;
     "server_filename" = "01.JavaScript\U57fa\U7840 36\U96c6";
     "server_mtime" = 1509458806;
     size = 0;
     }
     );
     "request_id" = 1955971382984942545;
     "server_time" = 1522022561;
     }
     */
    @WeakObj(self)
    [HttpUtil request:url method:@"GET" headers:headers params:queryParams completion:^(NSURLResponse *response, id responseObject, NSError *error) {
        @StrongObj(self)
        NSString *jsonDic = __JSONDIC__(responseObject);
        //        [self downloadFile:@"" vcode_str:@""];
    }];
}

- (void)requestCaptcha
{
    if (!self.vcodeIV.enabled) return;
    self.vcodeIV.enabled = NO;
    NSString *url = @"https://pan.baidu.com/api/getvcode";
    NSDictionary *headers = @{@"Host":BAIDU_PAN_HOST,
                              @"Connection":BAIDU_CONN_KEEPALIVE,
                              @"User-Agent":WEB_USER_AGENT,
                              @"Accept":BAIDU_ACCEPT_JSON,
                              @"Referer":self.shareURL,
                              @"Accept-Encoding":BAIDU_ACCEPT_ENCODING,
                              @"Accept-Language":BAIDU_ACCEPT_LANGUAGE,
                              @"Cookie":[NSString stringWithFormat:@"PANWEB=1;BAIDUID=%@;BDCLND=%@;cflag=%@",__UDGET__(@"BAIDUID"), __UDGET__ (@"BDCLND"),  __UDGET__(@"cflag")],
                              @"X-Requested-With":@"XMLHttpRequest"
                              };
    NSDictionary *queryParams = @{@"prod":@"pan", @"t":__CTS__, @"channel":@"chunlei", @"web":@"1", @"app_id":__UDGET__(@"app_id"), @"bdstoken":@"null", @"logid":__UDGET__(@"logid"), @"clienttype":@"0"};
    url = [NSString stringWithFormat:@"%@?%@",url, [HttpUtil URLParamsString:queryParams]];
    @WeakObj(self)
    [HttpUtil request:url method:@"GET" headers:headers params:nil completion:^(NSURLResponse *response, id responseObject, NSError *error) {
        @StrongObj(self)
        // 获取验证码
        NSDictionary *jsonDic = __JSONDIC__(responseObject);
        __UDSET__(@"vcode", jsonDic[@"vcode"]); __UDSYNC__;
        self.vcodeIV.enabled = YES;
        self.vcodeTF.enabled = YES;
        [self genimage:jsonDic[@"img"]];
    }];
}

- (void)genimage:(NSString *)url
{
    NSDictionary *headers = @{@"Host":BAIDU_PAN_HOST,
                              @"Connection":BAIDU_CONN_KEEPALIVE,
                              @"User-Agent":WEB_USER_AGENT,
                              @"Accept":BAIDU_ACCEPT_IMAGE,
                              @"Referer":self.shareURL,
                              @"Accept-Encoding":BAIDU_ACCEPT_ENCODING,
                              @"Accept-Language":BAIDU_ACCEPT_LANGUAGE,
                              @"Cookie":[NSString stringWithFormat:@"PANWEB=1;BAIDUID=%@;BDCLND=%@;cflag=%@",__UDGET__(@"BAIDUID"), __UDGET__(@"BDCLND"), __UDGET__(@"cflag")],
                              };
    @WeakObj(self)
    [HttpUtil request:url method:@"GET" headers:headers params:nil completion:^(NSURLResponse *response, id responseObject, NSError *error) {
        @StrongObj(self)
        // 此处返回验证码图片, 需要使用OpenCV自动填入验证码
        NSImage *image = [[NSImage alloc] initWithData:responseObject];
        _vcodeIV.image = image;
        [self setStatus:@"请输入验证码!" isSuccess:YES];
    }];
}

// vcode_input用户输入验证码 vcode_str服务器返回验证码
- (void)downloadFile:(NSString *)vcode_input vcode_str:(NSString *)vcode_str
{
    _statusLbl.stringValue = @"正在解析资源真实地址，请稍后...";
    NSString *url = @"https://pan.baidu.com/api/sharedownload";
    NSDictionary *headers = @{@"Host":BAIDU_PAN_HOST,
                              @"Connection":BAIDU_CONN_KEEPALIVE,
                              @"Accept":BAIDU_ACCEPT_JSON,
                              @"Origin":@"https://pan.baidu.com",
                              @"X-Requested-With":@"XMLHttpRequest",
                              @"User-Agent":WEB_USER_AGENT,
                              @"Content-Type":@"application/x-www-form-urlencoded; charset=UTF-8",
                              @"Referer":self.shareURL,
                              @"Accept-Encoding":BAIDU_ACCEPT_ENCODING,
                              @"Accept-Language":BAIDU_ACCEPT_LANGUAGE,
                              @"Cookie":[NSString stringWithFormat:@"PANWEB=1;BAIDUID=%@;BDCLND=%@;cflag=%@;%@;%@",__UDGET__(@"BAIDUID"), __UDGET__(@"BDCLND"), __UDGET__(@"cflag"), __TOSTR__(@"Hm_lvt_%@=%@", __UDGET__(@"hm_value"), __CTS__), __TOSTR__(@"Hm_lpvt_%@=%@", __UDGET__(@"hm_value"), __UDGET__(@"hm_lpvt"))]
                              };
    NSDictionary *queryParams = @{@"sign":__UDGET__(@"sign"), @"timestamp":__CTS__, @"channel":@"chunlei", @"web":@"1", @"app_id":__UDGET__(@"app_id"), @"bdstoken":@"null", @"logid":__UDGET__(@"logid"), @"clienttype":@"0"};
    url = [NSString stringWithFormat:@"%@?%@",url, [HttpUtil URLParamsString:queryParams]];
    //    [[NSUserDefaults standardUserDefaults] objectForKey:@"fid_list"]
    NSString *extra = [NSString stringWithFormat:@"{\"sekey\":\"%@\"}", [HttpUtil URLDecodedString:__UDGET__(@"BDCLND")]];
    NSMutableDictionary *formData = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"0", @"encrypt", extra, @"extra", @"share", @"product", __UDGET__(@"uk"), @"uk", __UDGET__(@"share_id"), @"primaryid", @"[1071271139371590]", @"fid_list", @"", @"path_list", nil];
    if (![_vcodeTF.stringValue isEqualToString:@""])
    {
        [formData setObject:[[_vcodeTF.stringValue stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] lowercaseString] forKey:@"vcode_input"];
        [formData setObject:__UDGET__(@"vcode") forKey:@"vcode_str"];
    }
    @WeakObj(self)
    [HttpUtil request:url method:@"POST" headers:headers params:formData completion:^(NSURLResponse *response, id responseObject, NSError *error) {
        @StrongObj(self)
        NSDictionary *jsonDic = __JSONDIC__(responseObject);
        if ([jsonDic[@"errno"] intValue] == DLINK_ERROR_1 || [jsonDic[@"errno"] intValue] == DLINK_ERROR_2)
        {
            self.vcodeIV.enabled = YES;
            [self requestCaptcha];
            [self setStatus:@"获取数据出错, 稍后请重试!" isSuccess:NO];
            return;
        }
        [self setStatus:__TOSTR__(@"解析资源真实地址%@", error?@"失败":@"成功") isSuccess:!error];
        if (error) return;
        [self parseRealURL:__RD__(responseObject)];
    }];
}

- (void)parseRealURL:(NSString *)jsonStr
{
    NSString *dlink = __VREGEX__(jsonStr, @"\"dlink\":", @",");
    dlink = [dlink substringWithRange:NSMakeRange(1, dlink.length - 2)];
    _realURL.stringValue = [dlink stringByReplacingOccurrencesOfString:@"\\" withString:@""];
}

- (void)getloginPublicKey
{
    // tt是当前毫秒级时间戳
    NSString *url = @"https://passport.baidu.com/v2/getpublickey?token=093101d73c725f675130e7eafcf50abd&tpl=netdisk&subpro=netdisk_web&apiver=v3&tt=1521528854834&gid=591F062-4FFF-4D11-84B4-0701083400A9&loginversion=v4&traceid=&callback=bd__cbs__63ckl";
    NSDictionary *headers = @{@"Accept":@"*/*",
                              @"Accept-Encoding":BAIDU_ACCEPT_ENCODING,
                              @"Accept-Language":BAIDU_ACCEPT_LANGUAGE,
                              @"Connection":BAIDU_CONN_KEEPALIVE,
                              @"Cookie":@"BAIDUID=AF5597ABDE8FCF5EA30C05C8DCECB84E:FG=1; HOSUPPORT=1; FP_UID=c4ce9e32af40e934a17761d81d878872; UBI=fi_PncwhpxZ%7ETaKAY2PlUFKqzhZZC6W2DB%7EXvJf0UB-ynjpoiSPx17DY%7EWrn4FqBnEM66bNJhDPfb6mDR7i",
                              @"Host":@"passport.baidu.com",
                              @"Referer":@"https://pan.baidu.com/s/1eQrwbKY?errno=0&errmsg=Auth%20Login%20Sucess&&bduss=&ssnerror=0&traceid=&",
                              @"User-Agent":WEB_USER_AGENT,
                              };
    [HttpUtil request:url method:@"GET" headers:headers params:nil completion:^(NSURLResponse *response, id responseObject, NSError *error) {
        NSString *string = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"response-->%@", string);
    }];
}

- (IBAction)fetch:(id)sender
{
    _realURL.stringValue = @"";
    if (![_fetchPwdTF.stringValue isEqualToString:@""])
    {
        NSString *url = _downloadURL.stringValue;
        if ([url isEqualToString:@""])
        {
            url = TEST_URL2;
        }
        if (![_vcodeTF.stringValue isEqualToString:@""])
        {
            [self requestBDCLND:_fetchPwdTF.stringValue];
        }
        else
        {
            [self openURL:url];
        }
    }
}

- (IBAction)fetchVCode:(id)sender
{
    [self requestCaptcha];
}

- (IBAction)copyDirectLink:(id)sender
{
    NSPasteboard *paste = [NSPasteboard generalPasteboard];
    [paste clearContents];
    [paste writeObjects:@[_realURL.stringValue]];
}

- (IBAction)downloadWithFolx:(id)sender
{
    if (![[NSWorkspace sharedWorkspace] launchAppWithBundleIdentifier:@"com.eltima.Folx3" options:NSWorkspaceLaunchDefault additionalEventParamDescriptor:NULL launchIdentifier:NULL]) return;
    NSString *command = [NSString stringWithFormat:@"open -a /Applications/Folx.app %@", _realURL.stringValue];
    system([[command stringByReplacingOccurrencesOfString:@"&" withString:@"'&'"] UTF8String]);
}

- (IBAction)downloadWithThunder:(id)sender
{
    if (![[NSWorkspace sharedWorkspace] launchAppWithBundleIdentifier:@"com.xunlei.Thunder" options:NSWorkspaceLaunchDefault additionalEventParamDescriptor:NULL launchIdentifier:NULL]) return;
    NSString *command = [NSString stringWithFormat:@"open -a /Applications/Thunder.app %@", _realURL.stringValue];
    system([[command stringByReplacingOccurrencesOfString:@"&" withString:@"'&'"] UTF8String]);
}

- (IBAction)downloadWithWget:(id)sender
{
    NSPasteboard *paste = [NSPasteboard generalPasteboard];
    [paste clearContents];
    [paste writeObjects:@[[NSString stringWithFormat:@"wget %@", _realURL.stringValue]]];
    system([@"open -a Terminal.app" UTF8String]);
}

- (NSString *)executeJS:(NSString *)js params:(NSArray *)params
{
    self.context = [[JSContext alloc] init];
    [self.context evaluateScript:js];
    JSValue *addJS = self.context[@"w"];
    JSValue *sum = [addJS callWithArguments:params];
    return [sum toString];
}

@end
