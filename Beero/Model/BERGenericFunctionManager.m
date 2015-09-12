//
//  BERGenericFunctionManager.m
//  Beero
//
//  Created by Chris Lin on 7/21/15.
//  Copyright (c) 2015 Beero. All rights reserved.
//

#import "BERGenericFunctionManager.h"
#import <CommonCrypto/CommonDigest.h>
#import <CoreTelephony/CTCallCenter.h>
#import <CoreTelephony/CTCall.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>


@implementation BERGenericFunctionManager

#pragma mark -App

+ (NSString *) getUUID{
    return [[[UIDevice currentDevice] identifierForVendor] UUIDString];
}

+ (NSString *) getOSVersion{
    return [[UIDevice currentDevice] systemVersion];
}

#pragma mark -String Manipulation

+ (NSString *) refineNSString: (NSString *)sz{
    NSString *szResult = @"";
    if ((sz == nil) || ([sz isKindOfClass:[NSNull class]] == YES)) szResult = @"";
    else szResult = [NSString stringWithFormat:@"%@", sz];
    return szResult;
}

+ (BOOL) isValidEmailAddress: (NSString *) candidate {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:candidate];
}

+ (NSString *) stripNonnumericsFromNSString :(NSString *) sz{
    NSString *szResult = sz;
    
    szResult = [[szResult componentsSeparatedByCharactersInSet: [[NSCharacterSet characterSetWithCharactersInString:@"0123456789*●"] invertedSet]] componentsJoinedByString:@""];
    return szResult;
}

+ (NSString *) getLongStringFromDate: (NSDate *) dt{
    if (dt == nil) return @"";
    NSCalendar *cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *dateComps = [cal components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute fromDate:dt];
    return [NSString stringWithFormat:@"%02d-%02d-%04dT%02d:%02d", (int) dateComps.month, (int) dateComps.day, (int) dateComps.year, (int) dateComps.hour,  (int) dateComps.minute];
}

+ (NSString *) generateRandomString :(int) length{
    NSString *szPattern = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    NSMutableString *randomString = [NSMutableString stringWithCapacity: length];
    for (int i = 0; i < length; i++) {
        [randomString appendFormat: @"%C", [szPattern characterAtIndex: arc4random_uniform((int)[szPattern length])]];
    }
    return randomString;
}

+ (NSString *) getBeautifiedDate: (NSDate *) dt{
    if (dt == nil) return @"";
    NSCalendar *cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *compsDt = [cal components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitWeekday fromDate:dt];
    
    NSDateComponents *compsToday = [[NSCalendar currentCalendar] components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:[NSDate date]];
    NSDateComponents *compsTomorrow = [[NSCalendar currentCalendar] components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:[NSDate dateWithTimeIntervalSinceNow:60 * 60 * 24]];
    
    if (compsToday.day == compsDt.day && compsToday.month == compsDt.month && compsToday.year == compsDt.year){
        return @"Today";
    }
    if (compsTomorrow.day == compsDt.day && compsTomorrow.month == compsDt.month && compsTomorrow.year == compsDt.year){
        return @"Tomorrow";
    }
    
    NSArray *arrWeekday = @[@"Sun", @"Mon", @"Tue", @"Wed", @"Thu", @"Fri", @"Sat"];
    NSArray *arrMonth = @[@"Jan", @"Feb", @"Mar", @"Apr", @"May", @"Jun", @"Jul", @"Aug", @"Sep", @"Oct", @"Nov", @"Dec"];
    NSString *szWeekday = [arrWeekday objectAtIndex:compsDt.weekday - 1];
    NSString *szMonth = [arrMonth objectAtIndex:compsDt.month - 1];
    NSString *szDay = [NSString stringWithFormat:@"%d", (int)(compsDt.day)];
    return [NSString stringWithFormat:@"%@, %@ %@", szWeekday, szMonth, szDay];
}

+ (NSString *) getBeautifiedTime: (NSDate *) dt{
    if (dt == nil) return @"";
    NSCalendar *cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *compsDt = [cal components: NSCalendarUnitHour | NSCalendarUnitMinute fromDate:dt];
    
    int nHour = (int) (compsDt.hour);
    int nMinute = (int) (compsDt.minute);
    NSString *szAMPM = @"am";
    
    if (nHour >= 12){
        nHour = nHour - 12;
        szAMPM = @"pm";
    }
    if (nHour == 0) nHour = 12;
    
    return [NSString stringWithFormat:@"%d:%02d %@", nHour, nMinute, szAMPM];
}

+ (NSString *) getBeautifiedRemainingTime: (NSDate *) dt{
    if (dt == nil) return @"";
    NSDate *dtToday = [NSDate date];
    NSDate *dt1, *dt2;
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar rangeOfUnit:NSCalendarUnitDay startDate:&dt1
                 interval:NULL forDate:dtToday];
    [calendar rangeOfUnit:NSCalendarUnitDay startDate:&dt2
                 interval:NULL forDate:dt];
    
    NSDateComponents *difference = [calendar components:NSCalendarUnitDay
                                               fromDate:dt1 toDate:dt2 options:0];
    
    int day = (int) difference.day;
    if (day < 0){
        return @"---";
    }
    else if (day == 0){
        int seconds = [dt timeIntervalSinceDate:dtToday];
        int minutes = seconds / 60;
        int hours = minutes / 60;
        
        if (hours > 0){
            if (minutes > 30) hours++;
            return [NSString stringWithFormat:@"In %d hours", hours];
        }
        
        if (minutes > 45) return @"In 1 hour";
        if (minutes > 30) return @"In 45 mins";
        if (minutes > 20) return @"In 30 mins";
        if (minutes > 15) return @"In 20 mins";
        if (minutes > 10) return @"In 15 mins";
        if (minutes > 5) return @"In 10 mins";
        return [NSString stringWithFormat:@"In %d mins", minutes];
    }
    else if (day == 1){
        return @"Tomorrow";
    }
    else if (day < 30){
        return [NSString stringWithFormat:@"In %d days", day];
    }
    else{
        return @"1 month+";
    }
    return @"";
}

+ (NSString *) getTimestampWithDate: (NSDate *) dt{
    NSCalendar *cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *compsDt = [cal components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond | NSCalendarUnitWeekday fromDate:dt];
    NSString *sz = [NSString stringWithFormat:@"%d-%02d-%02d %02d:%02d:%02d", (int) compsDt.year, (int) compsDt.month, (int) compsDt.day, (int) compsDt.hour, (int) compsDt.minute, (int) compsDt.second];
    return sz;
}

+ (NSString *) getHashFromString: (NSString *) sz{
    NSData *data = [sz dataUsingEncoding:NSUTF8StringEncoding];
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes, (CC_LONG) data.length, digest);
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for (int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
    {
        [output appendFormat:@"%02x", digest[i]];
    }
    
    return output;
}

+ (NSString *) getStringForTimeWithHour: (int) hour AndMinute: (int) minute{
    NSString *ampm = @"am";
    if (hour >= 12) ampm = @"pm";
    if (hour > 12) hour = hour - 12;
    return [NSString stringWithFormat:@"%d:%02d%@", hour, minute, ampm];
}

#pragma mark -UI

+ (void) showAlertWithMessage: (NSString *) szMessage{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:szMessage message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alertView show];
}

+ (void) showPromptViewWithTitle: (NSString *) title CancelButtonTitle: (NSString *) cancelButtonTitle OtherButtonTitle: (NSString *) otherButtonTitle Tag: (int) tag Delegate: (id) delegate{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:nil delegate:delegate cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitle, nil];
    alertView.tag = tag;
    
    [alertView show];
}

#pragma mark -Utils

+ (NSString *) getJSONStringRepresentation: (id) object{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object options:0 error:&error];
    NSString *szResult = @"";
    if (!jsonData){
        NSLog(@"Error while serializing customer details into JSON\r\n%@", error.localizedDescription);
    }
    else{
        szResult = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return szResult;
}

+ (void) drawDropShadowToView: (UIView *) view Size: (float) size{
    UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:view.bounds];
    view.layer.masksToBounds = NO;
    view.layer.shadowColor = [UIColor blackColor].CGColor;
    view.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
    view.layer.shadowRadius = size;
    view.layer.shadowOpacity = 0.5f;
    view.layer.shadowPath = shadowPath.CGPath;
}

+ (UIImage*) scaleImage: (UIImage*) sourceImage scaledToWidth: (float) i_width{
    float oldWidth = sourceImage.size.width;
    float scaleFactor = i_width / oldWidth;
    
    float newHeight = sourceImage.size.height * scaleFactor;
    float newWidth = oldWidth * scaleFactor;
    
    UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight));
    [sourceImage drawInRect:CGRectMake(0, 0, newWidth, newHeight)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

+ (BOOL) canMakePhoneCall{
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tel://"]]){
        CTTelephonyNetworkInfo *netInfo = [[CTTelephonyNetworkInfo alloc] init];
        CTCarrier *carrier = [netInfo subscriberCellularProvider];
        NSString *mnc = [carrier mobileNetworkCode];
        
        if ([mnc length] == 0){
            return NO;
        }
        else{
            return YES;
        }
    }
    return NO;
}

@end
