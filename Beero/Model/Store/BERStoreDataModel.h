//
//  BERStoreDataModel.h
//  Beero
//
//  Created by Chris Lin on 7/30/15.
//  Copyright (c) 2015 Beero. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Global.h"

@interface BERStoreDataModel : NSObject

@property int m_index;
@property float m_fLatitude;
@property float m_fLongitude;
@property (strong, nonatomic) NSString *m_szName;
@property BOOL m_isBeeroMember;
@property (strong, nonatomic) NSString *m_szAddress;
@property (strong, nonatomic) NSMutableDictionary *m_dictOpenHours;

- (id) init;
- (void) setWithDictionary: (NSDictionary *) dict;
- (BERSTRUCT_STORE_OPENHOURS) getOpenHourWithWeekday: (BERENUM_WEEKDAY) weekday;
- (BERSTRUCT_STORE_OPENHOURS) getOpenHourToday;
- (int) getRemainingMinutesTillClose;
- (NSString *) getBeautifiedLabelForOpenTimeToday;
- (NSString *) getBeautifiedLabelForRemainingTimeToday;

@end
