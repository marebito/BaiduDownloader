//
//  Config.h
//  BaiduDownloader
//
//  Created by zll on 2018/4/24.
//  Copyright © 2018年 Godlike Studio. All rights reserved.
//

#ifndef Config_h
#define Config_h

#import "ShellObject.h"

#define logid_js                                                                                                      \
@"\tvar s = "                                                                                                     \
@"\"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/~\uFF01@#\uFFE5%\u2026\u2026&\",\n\t\tu = "   \
@"String.fromCharCode,\n\t\tf = function (n) {\n\t\t\tif (n.length < 2) {\n\t\t\t\tvar e = "                      \
@"n.charCodeAt(0);\n\t\t\t\treturn 128 > e ? n : 2048 > e ? u(192 | e >>> 6) + u(128 | 63 & e) : u(224 | e >>> "  \
@"12 & 15) + u(128 | e >>> 6 & 63) + u(128 | 63 & e)\n\t\t\t}\n\t\t\tvar e = 65536 + 1024 * (n.charCodeAt(0) - "  \
@"55296) + (n.charCodeAt(1) - 56320);\n\t\t\treturn u(240 | e >>> 18 & 7) + u(128 | e >>> 12 & 63) + u(128 | e "  \
@">>> 6 & 63) + u(128 | 63 & e)\n\t\t}, l = /[\\uD800-\\uDBFF][\\uDC00-\\uDFFFF]|[^\\x00-\\x7F]/g,\n\t\td = "     \
@"function (n) {\n\t\t\treturn (n + \"\" + Math.random()).replace(l, f)\n\t\t}, g = function (n) {\n\t\t\tvar e " \
@"= [0, 2, 1][n.length % 3],\n\t\t\t\to = n.charCodeAt(0) << 16 | (n.length > 1 ? n.charCodeAt(1) : 0) << 8 | "   \
@"(n.length > 2 ? n.charCodeAt(2) : 0),\n\t\t\t\tt = [s.charAt(o >>> 18), s.charAt(o >>> 12 & 63), e >= 2 ? "     \
@"\"=\" : s.charAt(o >>> 6 & 63), e >= 1 ? \"=\" : s.charAt(63 & o)];\n\t\t\treturn t.join(\"\")\n\t\t}, m = "    \
@"function (n) {\n\t\t\treturn n.replace(/[\\s\\S]{1,3}/g, g)\n\t\t}, h = function () {\n\t\t\treturn m(d((new "  \
@"Date).getTime()))\n\t\t}, w = function (n, e) {\n\t\t\treturn e ? h(String(n)).replace(/[+\\/]/g, function "    \
@"(n) {\n\t\t\t\treturn \"+\" == n ? \"-\" : \"_\"\n\t\t\t}).replace(/=/g, \"\") : h(String(n))\n\t\t};"

#define cflag_js @"w = function (n) {return String(escape(n));}"

#define BDCLND_MULTIDOWNLOAD_ERROR \
-62  // 获取BDCLND错误（原因是由于多次下载同一个资源造成的，一般三次后需要输入验证码）

#define EXTRACT_PSWD_EMPTY -12  // 未输入提取密码

#define EXTRACT_PSWD_ERROR -9  // 提取密码出错

#define DLINK_PARAM_ERROR 113  // 获取文件失败

#define DLINK_MULTIREQUEST_ERROR -20  // 多次请求导致失败，此时需要输入验证码

#define BAIDU_PAN_HOST @"pan.baidu.com"

#define BAIDU_PCS_HOST @"pcs.baidu.com"

#define BAIDU_ACCEPT_IMAGE @"image/webp,image/apng,image/*,*/*;q=0.8"  // 接收图片

#define BAIDU_ACCEPT_JSON @"application/json, text/javascript, */*; q=0.01"  // 接收JSON

#define BAIDU_ACCEPT_HTML \
@"text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8"  // 接收HTML

#define BAIDU_ACCEPT_ENCODING @"gzip, deflate, br"  // 接收的编码类型

#define BAIDU_CONN_KEEPALIVE @"keep-alive"  // 连接状态

#define WEB_USER_AGENT                                                                                              \
@"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 " \
@"Safari/537.36"  // 浏览器User-Agent

#define BAIDU_ACCEPT_LANGUAGE @"zh-CN,zh;q=0.9,ja;q=0.8,en;q=0.7,zh-TW;q=0.6"  // 接收的语言类型

#define BAIDU_REDIRECT_URL __UDGET__(@"Location")

#define __SHELL_CMD__(cmd, result) [ShellObject executeShell:cmd result:result]

#define PASTE_BOARD_CONTENT @"echo $(pbpaste -prefer text)"

#define CHECK_INSTALLED_CMD(cmd) __SHELL_CMD__(__TOSTR__(@"echo $(command -v %@)", cmd))

#define INSTALL_BREW @"/usr/bin/ruby -e \"$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)\"" // 检测brew

#define CHECK_GMP_INFO @"brew info gmp" // 检测是否安装了gmp

#endif /* Config_h */
