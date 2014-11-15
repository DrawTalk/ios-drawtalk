//
//  CINLogging.m
//  Cintra
//
//  Created by Jacek Suliga on 11/7/14.
//  Copyright (c) 2014 LinkedIn. All rights reserved.
//

#import "CINLogging.h"

#ifndef CIN_ENABLE_LOGGING
#ifdef DEBUG
#define CIN_ENABLE_LOGGING 1
#else
#define CIN_ENABLE_LOGGING 0
#endif
#endif

#ifdef CIN_ENABLE_LOGGING

// Check if we can use Cocoalumberjack for logging
#ifdef LOG_VERBOSE
#define CINLogInfo(...) DDLogInfo(__VA_ARGS__)
#define CINLogError(...) DDLogError(__VA_ARGS__)
#define CINLogWarn(...) DDLogWarn(__VA_ARGS__)
#define CINLogDebug(...) DDLogDebug(__VA_ARGS__)
#define CINLogVerbose(...) DDLogVerbose(__VA_ARGS__)
#else
// If not, just go with NSLog
#define CINLogWrapper(...) NSLog(@"%s(%p) %@", __PRETTY_FUNCTION__, self, [NSString stringWithFormat:__VA_ARGS__])
#define CINLogInfo(...) CINLogWrapper(__VA_ARGS__)
#define CINLogError(...) CINLogWrapper(__VA_ARGS__)
#define CINLogWarn(...) CINLogWrapper(__VA_ARGS__)
#define CINLogDebug(...) CINLogWrapper(__VA_ARGS__)
#define CINLogVerbose(...) CINLogWrapper(__VA_ARGS__)
#endif

#else

// Logging disabled
#define CINLogInfo(...) ((void)0)
#define CINLogError(...) ((void)0)
#define CINLogWarn(...) ((void)0)
#define CINLogDebug(...) ((void)0)
#define CINLogVerbose(...) ((void)0)

#endif

@implementation CINLogging

+ (void) logError:(NSString *)message {
  CINLogError(@"%@", message);
}

+ (void) logWarn:(NSString *)message {
  CINLogWarn(@"%@", message);
}

+ (void) logInfo:(NSString *)message {
  CINLogInfo(@"%@", message);
}

+ (void) logDebug:(NSString *)message {
  CINLogDebug(@"%@", message);
}

+ (void) logVerbose:(NSString *)message {
  CINLogInfo(@"%@", message);
}

@end
