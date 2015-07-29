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
}

#pragma mark -Biz Logic

- (void) requestSearchDealWithCallback: (void (^)(int status)) callback{
    NSString *szOS = @"ios";
    NSString *szOSVersion = @"8.1";
    NSString *szAppId = [BERGenericFunctionManager getUUID];
    float fLat = [BERLocationManager sharedInstance].m_location.coordinate.latitude;
    float fLng = [BERLocationManager sharedInstance].m_location.coordinate.longitude;
    NSString *szBrands = @"1|2|4";
    NSString *szPackage = @"case";
    NSString *szContainer = @"any";
    NSString *szNow = @"2015-07-29 13:07:22";
    NSString *szSignature = [NSString stringWithFormat:@"%@_%.6f_%.6f_%@", szAppId, fLat, fLng, BEERO_SECRET_KEY];
    
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
    
    NSString *szUrl = [BERUrlManager getEndpointForSearchDeal];
    AFHTTPRequestOperationManager *requestManager = [AFHTTPRequestOperationManager manager];
    requestManager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [requestManager GET:szUrl parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (callback) callback(ERROR_NONE);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (callback) callback(ERROR_SEARCH_DEAL_FAILED);
    }];
}


@end
