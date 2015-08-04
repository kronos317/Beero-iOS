//
//  BERSearchDealDataModel.m
//  Beero
//
//  Created by Chris Lin on 7/30/15.
//  Copyright (c) 2015 Beero. All rights reserved.
//

#import "BERSearchDealDataModel.h"
#import "BERBrandManager.h"
#import "BERBrandDataModel.h"

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
        self.m_szBrandName = @"";
        self.m_modelWinningDeal = [[BERSearchWinningDealDataModel alloc] init];
        self.m_arrLosingDeal = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void) setWithDictionary: (NSDictionary *) dict WithId:(int)Id{
    self.m_index = Id;
    self.m_modelWinningDeal.m_szName = @"";
    
    NSArray *arrBrand = [BERBrandManager sharedInstance].m_arrBrand;
    for (int i = 0; i < (int) [arrBrand count]; i++){
        BERBrandDataModel *brand = [arrBrand objectAtIndex:i];
        if (brand.m_index == self.m_index){
            self.m_szBrandName = brand.m_szName;
            break;
        }
    }

    if ([dict isKindOfClass:[NSDictionary class]] == NO) return;
    
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

- (BOOL) isDealFound{
    if (self.m_modelWinningDeal.m_szName.length == 0) return NO;
    return YES;
}

@end
