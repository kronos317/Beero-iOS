//
//  BERSearchWinningDealDataModel.m
//  Beero
//
//  Created by Chris Lin on 7/29/15.
//  Copyright (c) 2015 Beero. All rights reserved.
//

#import "BERSearchWinningDealDataModel.h"
#import "BERGenericFunctionManager.h"

@implementation BERSearchWinningDealDataModel

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
        self.m_szName = @"";
        self.m_nQty = 0;
        self.m_indexImage = 1;
        self.m_enumContainerType = BERENUM_SEARCH_CONTAINERTYPE_ANY;
        self.m_nContainerSize = 0;
        self.m_fPrice = 0;
        self.m_nDrivingDistance = 0;
        self.m_nDrivingTime = 0;
        self.m_isExclusive = NO;
        self.m_modelStore = [[BERStoreDataModel alloc] init];
    }
    return self;
}

- (void) setWithDictionary: (NSDictionary *) dict{
    self.m_szName = [BERGenericFunctionManager refineNSString:[dict objectForKey: @"brand_name"]];
    self.m_nQty = [[dict objectForKey:@"qty"] intValue];
    self.m_indexImage = [[dict objectForKey:@"image_id"] intValue];
    self.m_nContainerSize = [[dict objectForKey:@"container_size"] intValue];
    self.m_fPrice = [[dict objectForKey:@"price"] floatValue];
    self.m_nDrivingDistance = [[dict objectForKey:@"driving_distance"] intValue];
    self.m_nDrivingTime = [[dict objectForKey:@"driving_time"] intValue];
    
    id exclusive = [dict objectForKey:@"is_exclusive"];
    self.m_isExclusive = NO;
    if ([exclusive isKindOfClass:[NSNumber class]] == YES){
        self.m_isExclusive = [exclusive boolValue];
    }
    
    NSString *szContainerType = [BERGenericFunctionManager refineNSString:[dict objectForKey:@"container_type"]];
    if ([szContainerType caseInsensitiveCompare:@"cans"] == NSOrderedSame){
        self.m_enumContainerType = BERENUM_SEARCH_CONTAINERTYPE_CAN;
    }
    else if ([szContainerType caseInsensitiveCompare:@"bottles"] == NSOrderedSame){
        self.m_enumContainerType = BERENUM_SEARCH_CONTAINERTYPE_BOTTLE;
    }
    else {
        self.m_enumContainerType = BERENUM_SEARCH_CONTAINERTYPE_ANY;
    }
    
    [self.m_modelStore setWithDictionary:[dict objectForKey:@"store_details"]];
}

- (NSString *) getBeautifiedVolumeSpecification{
    NSString *szContainerType = @"Any";
    if (self.m_enumContainerType == BERENUM_SEARCH_CONTAINERTYPE_CAN){
        szContainerType = @"Cans";
    }
    else if (self.m_enumContainerType == BERENUM_SEARCH_CONTAINERTYPE_BOTTLE){
        szContainerType = @"Bottles";
    }
    
    NSString *sz = [NSString stringWithFormat:@"%d x %dml %@", self.m_nQty, self.m_nContainerSize, szContainerType];
    return sz;
}

- (NSString *) getBeautifiedDriveDistance{
    int nMinute = self.m_nDrivingTime / 60;
    int nSecond = self.m_nDrivingTime % 60;
    if (nSecond > 0) nMinute++;
    return [NSString stringWithFormat:@"%d", nMinute];
}

@end
