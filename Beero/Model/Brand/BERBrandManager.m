//
//  BERBrandManager.m
//  Beero
//
//  Created by Chris Lin on 7/29/15.
//  Copyright (c) 2015 Beero. All rights reserved.
//

#import "BERBrandManager.h"
#import "Global.h"
#import "BERBrandDataModel.h"
#import "BERGenericFunctionManager.h"
#import "BERUrlManager.h"
#import <AFNetworking.h>

@implementation BERBrandManager

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
        [self initializeManager];
    }
    return self;
}

- (void) initializeManager{
    self.m_arrBrand = [[NSMutableArray alloc] init];
}

#pragma mark -Biz Logic

- (void) sortByPosition{
    // Featured first, ordered by position
    [self.m_arrBrand sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        BERBrandDataModel *brand1 = obj1;
        BERBrandDataModel *brand2 = obj2;
        
        if ([brand1 isFeatured] == NO) return NSOrderedDescending;
        if ([brand2 isFeatured] == NO) return NSOrderedAscending;
        if (brand1.m_position < brand2.m_position) return NSOrderedAscending;
        else if (brand1.m_position > brand2.m_position) return NSOrderedDescending;
        return NSOrderedSame;
    }];
}

- (NSString *) getSelectedIdsWithPipe{
    // 1|2|4
    
    NSString *sz = @"";
    for (int i = 0; i < (int) [self.m_arrBrand count]; i++){
        BERBrandDataModel *brand = [self.m_arrBrand objectAtIndex:i];
        if (brand.m_isSelected == YES){
            sz = [NSString stringWithFormat:@"%@|%d", sz, brand.m_index];
        }
    }
    if (sz.length > 1){
        sz = [sz substringFromIndex:1];
    }
    return sz;
}

#pragma mark -AFNetworking

- (void) requestBrands{
    NSString *szUrl = [BERUrlManager getEndpointForAllBrands];
    AFHTTPRequestOperationManager *requestManager = [AFHTTPRequestOperationManager manager];
//    requestManager.requestSerializer = [AFJSONRequestSerializer serializer];
    requestManager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [requestManager GET:szUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        @try {
            NSDictionary *dict = responseObject;
            NSString *szStatus = [BERGenericFunctionManager refineNSString:[dict objectForKey:@"status"]];
            if ([szStatus caseInsensitiveCompare:@"ok"] == NSOrderedSame){
                [self.m_arrBrand removeAllObjects];
                NSDictionary *results = [dict objectForKey:@"results"];
                
                for (NSString *key in [results allKeys]){
                    NSDictionary *d = [results objectForKey:key];
                    BERBrandDataModel *brand = [[BERBrandDataModel alloc] init];
                    [brand setWithDictionary:d WithId:[key intValue]];
                    [self.m_arrBrand addObject:brand];
                }
                
                [self sortByPosition];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:BERLOCALNOTIFICATION_BRAND_GETALL_COMPLETED object:nil];
            }
            else{
                NSLog(@"Failed to load brands from server!");
                [[NSNotificationCenter defaultCenter] postNotificationName:BERLOCALNOTIFICATION_BRAND_GETALL_FAILED object:nil];
            }
        }
        @catch (NSException *exception) {
            NSLog(@"Failed to load brands from server! %@", exception);
            [[NSNotificationCenter defaultCenter] postNotificationName:BERLOCALNOTIFICATION_BRAND_GETALL_FAILED object:nil];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Failed to load products from server due to network connection!");
        [[NSNotificationCenter defaultCenter] postNotificationName:BERLOCALNOTIFICATION_BRAND_GETALL_FAILED object:nil];
    }];
}


@end
