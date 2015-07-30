//
//  BERSearchDealDataModel.h
//  Beero
//
//  Created by Chris Lin on 7/30/15.
//  Copyright (c) 2015 Beero. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BERSearchWinningDealDataModel.h"
#import "BERSearchLosingDealDataModel.h"

@interface BERSearchDealDataModel : NSObject

@property int m_index;
@property (strong, nonatomic) BERSearchWinningDealDataModel *m_modelWinningDeal;
@property (strong, nonatomic) NSMutableArray *m_arrLosingDeal;

- (id) init;
- (void) setWithDictionary: (NSDictionary *) dict WithId: (int) Id;

@end
