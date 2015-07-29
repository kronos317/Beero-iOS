//
//  BERBrandDataModel.m
//  Beero
//
//  Created by Chris Lin on 7/29/15.
//  Copyright (c) 2015 Beero. All rights reserved.
//

#import "BERBrandDataModel.h"
#import "BERGenericFunctionManager.h"

@implementation BERBrandDataModel

- (id) init{
    self = [super init];
    if (self){
        [self initialize];
    }
    return self;
}

- (void) initialize{
    self.m_index = -1;
    self.m_szName = @"";
    self.m_position = -1;
    self.m_isSelected = NO;
}

- (void) setWithDictionary: (NSDictionary *) dict WithId: (int) Id{
    [self initialize];
    @try {
        self.m_index = Id;
        self.m_szName = [BERGenericFunctionManager refineNSString:[dict objectForKey:@"name"]];
        id pos = [dict objectForKey:@"position"];
        if (pos != nil && [pos isKindOfClass:[NSNumber class]] == YES){
            self.m_position = [pos intValue];
        }
    }
    @catch (NSException *exception) {
    }
}

- (BOOL) isFeatured{
    return self.m_position != -1;
}

@end
