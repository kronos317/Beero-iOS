//
//  BERGMPlaceAutoCompleteDataModel.m
//  Beero
//
//  Created by Chris Lin on 7/21/15.
//  Copyright (c) 2015 Beero. All rights reserved.
//

#import "BERGMPlaceAutoCompleteDataModel.h"
#import "BERGenericFunctionManager.h"

@implementation BERGMPlaceAutoCompleteDataModel

- (id) init{
    self = [super init];
    if (self){
        [self initialize];
    }
    return self;
}

- (void) initialize{
    self.m_szId = @"";
    self.m_szDescription = @"";
    self.m_szPlaceId = @"";
    self.m_szReference = @"";
}

- (void) setWithDictionary: (NSDictionary *) dict{
    [self initialize];
    
    @try {
        NSString *szId = [BERGenericFunctionManager refineNSString:[dict objectForKey:@"id"]];
        NSString *szDescription = [BERGenericFunctionManager refineNSString:[dict objectForKey:@"description"]];
        NSString *szPlaceId = [BERGenericFunctionManager refineNSString:[dict objectForKey:@"place_id"]];
        NSString *szReference = [BERGenericFunctionManager refineNSString:[dict objectForKey:@"reference"]];
        
        self.m_szId = szId;
        self.m_szDescription = szDescription;
        self.m_szPlaceId = szPlaceId;
        self.m_szReference = szReference;
    }
    @catch (NSException *exception) {
        [self initialize];
        @throw exception;
    }
}

@end
