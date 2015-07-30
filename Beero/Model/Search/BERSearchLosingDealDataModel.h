//
//  BERSearchLosingDealDataModel.h
//  Beero
//
//  Created by Chris Lin on 7/29/15.
//  Copyright (c) 2015 Beero. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Global.h"

@interface BERSearchLosingDealDataModel : NSObject

@property float m_fLatitude;
@property float m_fLongitude;
@property (strong, nonatomic) NSString *m_szPricePerLitre;
@property (strong, nonatomic) NSString *m_szStoreName;

- (id) init;
- (void) setWithDictionary: (NSDictionary *) dict;

@end
