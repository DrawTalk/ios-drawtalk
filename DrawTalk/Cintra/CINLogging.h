//
//  CINLogging.h
//  Cintra
//
//  Created by Jacek Suliga on 11/7/14.
//  Copyright (c) 2014 LinkedIn. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!
 Wrapper class for logging to enable access from both Obj-C and swift.
 */
@interface CINLogging : NSObject

+ (void) logError:(NSString *)message;
+ (void) logWarn:(NSString *)message;
+ (void) logInfo:(NSString *)message;
+ (void) logDebug:(NSString *)message;
+ (void) logVerbose:(NSString *)message;

@end
