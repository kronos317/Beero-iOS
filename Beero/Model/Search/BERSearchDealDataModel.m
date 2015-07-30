//
//  BERSearchDealDataModel.m
//  Beero
//
//  Created by Chris Lin on 7/30/15.
//  Copyright (c) 2015 Beero. All rights reserved.
//

#import "BERSearchDealDataModel.h"

@implementation BERSearchDealDataModel

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
        self.m_index = 0;
        self.m_modelWinningDeal = [[BERSearchWinningDealDataModel alloc] init];
        self.m_arrLosingDeal = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void) setWithDictionary: (NSDictionary *) dict WithId:(int)Id{
    self.m_index = Id;
    
    NSDictionary *dictWinning = [dict objectForKey:@"winning_deal"];
    NSArray *arrLosing = [dict objectForKey:@"losing_deals"];
    
    [self.m_modelWinningDeal setWithDictionary:dictWinning];
    [self.m_arrLosingDeal removeAllObjects];
    
    for (int i = 0; i < (int) [arrLosing count]; i++){
        BERSearchLosingDealDataModel *losing = [[BERSearchLosingDealDataModel alloc] init];
        [losing setWithDictionary:[arrLosing objectAtIndex:i]];
        [self.m_arrLosingDeal addObject:losing];
    }
}


@end
