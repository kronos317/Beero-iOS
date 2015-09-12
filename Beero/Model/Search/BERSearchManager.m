//
//  BERSearchManager.m
//  Beero
//
//  Created by Chris Lin on 7/29/15.
//  Copyright (c) 2015 Beero. All rights reserved.
//

#import "BERSearchManager.h"
#import "BERGenericFunctionManager.h"
#import "BERLocationManager.h"
#import <AFNetworking.h>
#import "BERUrlManager.h"
#import "BERBrandManager.h"

#define BEERO_SECRET_KEY                @"21cda18e56dae228eb5b367f5a44a8c3e702cb36bf999879d8e7c3dbf1dafc06ef3f8c4641a9dd53db5a59197de69ff50a936b5b250bf5ded9499b07569240e2"

@implementation BERSearchManager

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
    self.m_arrResult = [[NSMutableArray alloc] init];
    self.m_enumContainerType = BERENUM_SEARCH_CONTAINERTYPE_ANY;
    self.m_enumPackageSize = BERENUM_SEARCH_PACKAGESIZE_CASES;
    
    self.m_indexSelectedToViewDetails = 0;
    self.m_isAllBeers = NO;
}

#pragma mark -Biz Logic

- (void) requestSearchDealWithCallback: (void (^)(int status)) callback{
    NSString *szOS = @"ios";
    NSString *szOSVersion = [BERGenericFunctionManager getOSVersion];
    NSString *szAppId = [BERGenericFunctionManager getUUID];
    float fLat = [BERLocationManager sharedInstance].m_location.coordinate.latitude;
    float fLng = [BERLocationManager sharedInstance].m_location.coordinate.longitude;
    NSString *szBrands = [[BERBrandManager sharedInstance] getSelectedIdsWithPipe];
    NSString *szPackage = @"case";
    NSString *szContainer = @"any";
    NSString *szNow = [BERGenericFunctionManager getTimestampWithDate:[NSDate date]];
    NSString *szSignature = [NSString stringWithFormat:@"%@_%.6f_%.6f_%@", szAppId, fLat, fLng, BEERO_SECRET_KEY];
    
    if (self.m_enumPackageSize == BERENUM_SEARCH_PACKAGESIZE_CASES){
        szPackage = @"case";
    }
    else if (self.m_enumPackageSize == BERENUM_SEARCH_PACKAGESIZE_SIXPACK){
        szPackage = @"six";
    }
    
    if (self.m_enumContainerType == BERENUM_SEARCH_CONTAINERTYPE_ANY){
        szContainer = @"any";
    }
    else if (self.m_enumContainerType == BERENUM_SEARCH_CONTAINERTYPE_BOTTLE){
        szContainer = @"bottles";
    }
    else if (self.m_enumContainerType == BERENUM_SEARCH_CONTAINERTYPE_CAN){
        szContainer = @"cans";
    }
    
    if (self.m_isAllBeers == YES){
        szBrands = [[BERBrandManager sharedInstance] getAllIdsWithPipe];
    }
    
    szSignature = [BERGenericFunctionManager getHashFromString:szSignature];
    
    NSDictionary *params = @{@"os": szOS,
                             @"os_version": szOSVersion,
                             @"app_id": szAppId,
                             @"lat": [NSString stringWithFormat:@"%.6f", fLat],
                             @"lng": [NSString stringWithFormat:@"%.6f", fLng],
                             @"brands": szBrands,
                             @"package": szPackage,
                             @"container": szContainer,
                             @"user_time": szNow,
                             @"signature": szSignature,
                             };
    
    self.m_szRequestToken = [BERGenericFunctionManager generateRandomString:16];
    NSString *szToken = self.m_szRequestToken;
    
    NSString *szUrl = [BERUrlManager getEndpointForSearchDeal];
    AFHTTPRequestOperationManager *requestManager = [AFHTTPRequestOperationManager manager];
    requestManager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    NSLog(@"%@", [BERGenericFunctionManager getJSONStringRepresentation:params]);
    
    [requestManager GET:szUrl parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dict = responseObject;
        NSString *szStatus = [BERGenericFunctionManager refineNSString:[dict objectForKey:@"status"]];
        int status = ERROR_NONE;

//        NSLog(@"%@", dict);
        if ([szToken caseInsensitiveCompare:self.m_szRequestToken] != NSOrderedSame){
            // New request has sent, ignore current request
            status = ERROR_SEARCH_DEAL_CANCELLED;
        }
        else if ([szStatus caseInsensitiveCompare:@"ok"] == NSOrderedSame){
            NSDictionary *dictResults = [dict objectForKey:@"results"];
            [self.m_arrResult removeAllObjects];
            
            for (NSString *key in [dictResults allKeys]){
                BERSearchDealDataModel *deal = [[BERSearchDealDataModel alloc] init];
                id item = [dictResults objectForKey:key];
                
                [deal setWithDictionary:item WithId:[key intValue]];
                [self.m_arrResult addObject:deal];
                /*
                if ([item isKindOfClass:[NSDictionary class]] == YES){
                    [deal setWithDictionary:[dictResults objectForKey:key] WithId:[key intValue]];
                    [self.m_arrResult addObject:deal];
                }
                 */
            }
            
            if ([self.m_arrResult count] == 0){
                status = ERROR_SEARCH_DEAL_NOTFOUND;
            }
        }
        else {
            status = ERROR_SEARCH_DEAL_FAILED;
        }
        if (callback) callback(status);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (callback) callback(ERROR_SEARCH_DEAL_FAILED);
    }];
}

@end
