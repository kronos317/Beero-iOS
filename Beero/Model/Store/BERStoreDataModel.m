//
//  BERStoreDataModel.m
//  Beero
//
//  Created by Chris Lin on 7/30/15.
//  Copyright (c) 2015 Beero. All rights reserved.
//

#import "BERStoreDataModel.h"
#import "BERGenericFunctionManager.h"

@implementation BERStoreDataModel

+ (instancetype) sharedInstance{
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (id) init{
    if (self = [super init]){
        self.m_index = -1;
        self.m_isBeeroMember = NO;
        self.m_fLatitude = 0;
        self.m_fLongitude = 0;
        self.m_szAddress = @"";
        self.m_szName = @"";
        self.m_dictOpenHours = nil;
        
        self.m_hasCatalog = NO;
        self.m_hasCoverImage = NO;
        self.m_hasManagerImage = NO;
        self.m_szPhoneNumber = @"";
    }
    return self;
}

- (void) setWithDictionary: (NSDictionary *) dict{
    self.m_index = [[dict objectForKey:@"id"] intValue];
    self.m_fLatitude = [[dict objectForKey:@"lat"] floatValue];
    self.m_fLongitude = [[dict objectForKey:@"lng"] floatValue];
    self.m_szName = [BERGenericFunctionManager refineNSString:[dict objectForKey:@"name"]];
    self.m_isBeeroMember = [[dict objectForKey:@"is_member"] boolValue];
    self.m_szAddress = [BERGenericFunctionManager refineNSString:[dict objectForKey:@"address"]];
    self.m_dictOpenHours = [[NSMutableDictionary alloc] initWithDictionary:[dict objectForKey:@"open_hours"] copyItems:YES];
    self.m_hasCatalog = [[dict objectForKey:@"has_catalog"] boolValue];
    self.m_hasCoverImage = [[dict objectForKey:@"has_cover_image"] boolValue];
    self.m_hasManagerImage = [[dict objectForKey:@"has_manager_image"] boolValue];
    self.m_szPhoneNumber = [BERGenericFunctionManager refineNSString:[dict objectForKey:@"phone"]];
    
#warning Just for Test
    self.m_index = 1;
    self.m_hasCatalog = YES;
    self.m_hasCoverImage = YES;
    self.m_hasManagerImage = YES;
}

- (BERSTRUCT_STORE_OPENHOURS) getOpenHourWithWeekday: (BERENUM_WEEKDAY) weekday{
    NSArray *arrWeekday = @[@"sun", @"mon", @"tue", @"wed", @"thu", @"fri", @"sat", @"sun"];
    NSDictionary *dict = [self.m_dictOpenHours objectForKey:[arrWeekday objectAtIndex:weekday]];
    int nOpen = [[dict objectForKey:@"open"] intValue];
    int nClose = [[dict objectForKey:@"close"] intValue];
    
    BERSTRUCT_STORE_OPENHOURS openHours;
    openHours.m_nOpenHour = nOpen / 100;
    openHours.m_nOpenMinute = nOpen % 100;
    openHours.m_nCloseHour = nClose / 100;
    openHours.m_nCloseMinute = nClose % 100;
    
    return openHours;
}

- (BERSTRUCT_STORE_OPENHOURS) getOpenHourToday{
    NSCalendar * gregorian = [[NSCalendar alloc]
                              initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents * componentsDate = [gregorian components: (NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit | NSCalendarUnitWeekday) fromDate:[NSDate date]];
    
    return [self getOpenHourWithWeekday: (BERENUM_WEEKDAY) (componentsDate.weekday - 1)];
}

- (int) getRemainingMinutesTillClose{
    NSDate *dtNow = [NSDate date];
    NSDate *dtClose, *dtOpen;
    BERSTRUCT_STORE_OPENHOURS openHour = [self getOpenHourToday];
    NSCalendar * gregorian = [[NSCalendar alloc]
                              initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents * componentsDate = [gregorian components: (NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit | NSCalendarUnitWeekday) fromDate:dtNow];

    componentsDate.hour = openHour.m_nOpenHour;
    componentsDate.minute = openHour.m_nOpenMinute;
    componentsDate.second = 0;
    dtOpen = [gregorian dateFromComponents:componentsDate];
    
    componentsDate.hour = openHour.m_nCloseHour;
    componentsDate.minute = openHour.m_nCloseMinute;
    dtClose = [gregorian dateFromComponents:componentsDate];
    
    int secondsToClose = [dtClose timeIntervalSinceDate:dtNow];
    int secondsToOpen = [dtOpen timeIntervalSinceDate:dtNow];
    
    if (secondsToOpen > 0) return STORE_OPENHOUR_NOTOPEN;
    if (secondsToClose < 0) return STORE_OPENHOUR_CLOSED;
    
    int minutesToClose = secondsToClose / 60;
    return minutesToClose;
}

- (NSString *) getBeautifiedLabelForOpenTimeToday{
    int nRemaining = [self getRemainingMinutesTillClose];
    BERSTRUCT_STORE_OPENHOURS openHour = [self getOpenHourToday];
    NSString *szOpen = [NSString stringWithFormat:@"Open at %@", [self getShortStringForTimeWithHour:openHour.m_nOpenHour AndMinute:openHour.m_nOpenMinute]];
    NSString *szClose = [NSString stringWithFormat:@"Till %@", [self getShortStringForTimeWithHour:openHour.m_nCloseHour AndMinute:openHour.m_nCloseMinute]];
    
    if (nRemaining == STORE_OPENHOUR_NOTOPEN){
        return szOpen;
    }
    if (nRemaining == STORE_OPENHOUR_CLOSED) return @"Closed";
    return szClose;
}

- (NSString *) getBeautifiedLabelForRemainingTimeToday{
    int nRemaining = [self getRemainingMinutesTillClose];
    if (nRemaining == STORE_OPENHOUR_NOTOPEN || nRemaining == STORE_OPENHOUR_NOTOPEN){
        return @"";
    }
    if (nRemaining >= 60) return @"";
    return [NSString stringWithFormat:@"Closes in %d minutes!", nRemaining];
}

- (NSString *) getShortStringForTimeWithHour: (int) hour AndMinute: (int) minute{
    NSString *ampm = @"am";
    if (hour >= 12) ampm = @"pm";
    if (hour > 12) hour = hour - 12;
    if (minute == 0){
        return [NSString stringWithFormat:@"%d%@", hour, ampm];
    }
    return [NSString stringWithFormat:@"%d:%02d%@", hour, minute, ampm];
}

- (NSString *) getCatalogPdfPath{
    if (self.m_hasCatalog == NO) return @"";
    return [NSString stringWithFormat:@"http://beero.com.au/stores/%d/files/catalog.pdf", self.m_index];
}

- (NSString *) getCatalogCoverImagePath{
    if (self.m_hasCatalog == NO) return @"";
    return [NSString stringWithFormat:@"http://beero.com.au/stores/%d/files/catalog.png", self.m_index];
}

- (NSString *) getStoreCoverImagePath{
    if (self.m_hasCoverImage == NO) return @"";
    return [NSString stringWithFormat:@"http://beero.com.au/stores/%d/files/cover.jpg", self.m_index];
}

- (NSString *) getManagerImagePath{
    if (self.m_hasManagerImage == NO) return @"";
    return [NSString stringWithFormat:@"http://beero.com.au/stores/%d/files/manager.jpg", self.m_index];
}

@end
