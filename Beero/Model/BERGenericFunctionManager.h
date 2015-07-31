//
//  BERGenericFunctionManager.h
//  Beero
//
//  Created by Chris Lin on 7/21/15.
//  Copyright (c) 2015 Beero. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Global.h"

@interface BERGenericFunctionManager : NSObject

#pragma mark -App

+ (NSString *) getUUID;
+ (NSString *) getOSVersion;

#pragma mark -String Manipulation

+ (NSString *) refineNSString: (NSString *)sz;
+ (BOOL) isValidEmailAddress: (NSString *) candidate;
+ (NSString *) getLongStringFromDate: (NSDate *) dt;
+ (NSString *) stripNonnumericsFromNSString :(NSString *) sz;
+ (NSString *) generateRandomString :(int) length;
+ (NSString *) getBeautifiedDate: (NSDate *) dt;
+ (NSString *) getBeautifiedTime: (NSDate *) dt;
+ (NSString *) getBeautifiedRemainingTime: (NSDate *) dt;
+ (NSString *) getHashFromString: (NSString *) sz;
+ (NSString *) getTimestampWithDate: (NSDate *) dt;
+ (NSString *) getStringForTimeWithHour: (int) hour AndMinute: (int) minute;

#pragma mark -UI

+ (void) showAlertWithMessage: (NSString *) szMessage;
+ (void) showPromptViewWithTitle: (NSString *) title CancelButtonTitle: (NSString *) cancelButtonTitle OtherButtonTitle: (NSString *) otherButtonTitle Tag: (int) tag Delegate: (id) delegate;

#pragma mark -Utils

+ (NSString *) getJSONStringRepresentation: (id) object;

@end
