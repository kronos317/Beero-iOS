//
//  BERSearchLosingDealDataModel.m
//  Beero
//
//  Created by Chris Lin on 7/29/15.
//  Copyright (c) 2015 Beero. All rights reserved.
//

#import "BERSearchLosingDealDataModel.h"
#import "BERGenericFunctionManager.h"

@implementation BERSearchLosingDealDataModel

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
        self.m_fLatitude = 0;
        self.m_fLongitude = 0;
        self.m_szPricePerLitre = @"";
        self.m_szStoreName = @"";
    }
    return self;
}

- (void) setWithDictionary: (NSDictionary *) dict{
    self.m_szStoreName = [BERGenericFunctionManager refineNSString:[dict objectForKey: @"store_name"]];
    self.m_szPricePerLitre = [BERGenericFunctionManager refineNSString:[dict objectForKey: @"price_per_litre"]];
    self.m_fLatitude = [[dict objectForKey:@"lat"] floatValue];
    self.m_fLongitude = [[dict objectForKey:@"lng"] floatValue];
}

@end
