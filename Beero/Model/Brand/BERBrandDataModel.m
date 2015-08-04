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
        
        id index = [dict objectForKey:@"id"];
        if (index != nil && [index isKindOfClass:[NSNumber class]] == YES){
            self.m_index = [index intValue];
        }
        
        id pos = [dict objectForKey:@"position"];
        if (pos != nil && [pos isKindOfClass:[NSNumber class]] == YES){
            self.m_position = [pos intValue];
        }
        
        id selected = [dict objectForKey:@"is_selected"];
        if (selected != nil && [selected isKindOfClass:[NSNumber class]] == YES){
            self.m_isSelected = [selected boolValue];
        }
    }
    @catch (NSException *exception) {
    }
}

- (NSDictionary *) serializeToDictionary{
    NSDictionary *dict = @{@"id": [NSNumber numberWithInt:self.m_index],
                           @"name": self.m_szName,
                           @"position": [NSNumber numberWithInt:self.m_position],
                           @"is_selected": [NSNumber numberWithBool:self.m_isSelected],
                           };
    return dict;
}

- (BOOL) isFeatured{
    return self.m_position != -1;
}

@end
