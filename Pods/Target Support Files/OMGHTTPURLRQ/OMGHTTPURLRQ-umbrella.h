#ifdef __OBJC__
#import <Cocoa/Cocoa.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "OMGFormURLEncode.h"
#import "OMGHTTPURLRQ.h"
#import "OMGUserAgent.h"

FOUNDATION_EXPORT double OMGHTTPURLRQVersionNumber;
FOUNDATION_EXPORT const unsigned char OMGHTTPURLRQVersionString[];

