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

@end
