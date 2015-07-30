//
//  BERSearchWinningDealDataModel.h
//  Beero
//
//  Created by Chris Lin on 7/29/15.
//  Copyright (c) 2015 Beero. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Global.h"

@interface BERSearchWinningDealDataModel : NSObject

@property (strong, nonatomic) NSString *m_szName;
@property int m_nQty;
@property BERENUM_SEARCH_CONTAINERTYPE m_enumContainerType;
@property int m_nContainerSize;
@property float m_fPrice;
@property int m_nDrivingDistance;
@property int m_nDrivingTime;
@property BOOL m_isExclusive;

- (id) init;
- (void) setWithDictionary: (NSDictionary *) dict;
- (NSString *) getBeautifiedVolumeSpecification;
- (NSString *) getBeautifiedDriveDistance;

@end
