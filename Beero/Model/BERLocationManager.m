//
//  BERLocationManager.m
//  Beero
//
//  Created by Chris Lin on 7/21/15.
//  Copyright (c) 2015 Beero. All rights reserved.
//

#import "BERLocationManager.h"
#import <UIKit/UIKit.h>
#import "BERGenericFunctionManager.h"
#import "BERUrlManager.h"
#import <AFNetworking.h>
#import "Global.h"
#import "BERGMPlaceAutoCompleteDataModel.h"
#import "BERDataManager.h"

@implementation BERLocationManager

#define LOCATIONMANAGER_DEFAULT_LOCATION_LATITUDE           -33.731628
#define LOCATIONMANAGER_DEFAULT_LOCATION_LONGITUDE          151.216935

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
        // [self initializeManager];
    }
    return self;
}

- (void) dealloc{
    [self.m_locationManager stopUpdatingLocation];
}

- (void) initializeManager{
    if (self.m_locationManager != nil){
        [self.m_locationManager stopUpdatingLocation];
    }
    
    self.m_locationManager = [[CLLocationManager alloc] init];
    self.m_locationManager.delegate = self;
    self.m_locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.m_locationManager.distanceFilter = 5;
    
    self.m_location = [[CLLocation alloc]initWithLatitude:LOCATIONMANAGER_DEFAULT_LOCATION_LATITUDE longitude:LOCATIONMANAGER_DEFAULT_LOCATION_LONGITUDE];
    self.m_szAddress = @"";
    
    [self requestCurrentLocation];
}

- (void) startLocationUpdate{
    NSLog(@"startLocationUpdate called");
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0 &&
        [CLLocationManager authorizationStatus] != kCLAuthorizationStatusAuthorizedWhenInUse
        && [CLLocationManager authorizationStatus] != kCLAuthorizationStatusAuthorizedAlways
        ) {
        [self.m_locationManager requestWhenInUseAuthorization];
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.m_locationManager startUpdatingLocation];
        });
    }
}

- (void) stopLocationUpdate{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.m_locationManager stopUpdatingLocation];
    });
}

- (void) requestCurrentLocation{
    [self stopLocationUpdate];
    [self startLocationUpdate];
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
    switch (status) {
        case kCLAuthorizationStatusDenied:
        {
            NSLog(@"Location service is off.");
            break;
        }
        case kCLAuthorizationStatusNotDetermined:
        case kCLAuthorizationStatusAuthorizedWhenInUse:
        case kCLAuthorizationStatusAuthorizedAlways:
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.m_locationManager startUpdatingLocation];
            });
            break;
        }
        default:
            break;
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    if ([locations count] == 0) return;
    CLLocation *newLocation = [locations lastObject];
    
    self.m_location = newLocation;
    
    // Just for Test
    self.m_location = [[CLLocation alloc] initWithLatitude:LOCATIONMANAGER_DEFAULT_LOCATION_LATITUDE longitude:LOCATIONMANAGER_DEFAULT_LOCATION_LONGITUDE];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:BERLOCALNOTIFICATION_LOCATION_UPDATED object:nil];
    
    [self requestAddressWithLocation:nil callback:nil];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    NSString *sz = @"";
    BOOL shouldRetry = YES;
    switch([error code])
    {
        case kCLErrorNetwork:{ // general, network-related error
            sz = @"Location service failed!\nPlease check your network connection or that you are not in aireplane mode.";
            shouldRetry = YES;
            break;
        }
        case kCLErrorDenied:{
            sz = @"User denied to use location service.";
            shouldRetry = NO;
            break;
        }
        case kCLErrorLocationUnknown:{
            sz = @"Unable to obtain geo-location information right now.";
            shouldRetry = YES;
            break;
        }
        default:{
            sz = [NSString stringWithFormat:@"Location service failed due to unknown error.\n%@", error.description];
            shouldRetry = YES;
            break;
        }
    }
    NSLog(@"locationManager didFailWithError: %@", error.description);
    
    [self.m_locationManager stopUpdatingLocation];
    if (shouldRetry){
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.m_locationManager startUpdatingLocation];
        });
    }
}

- (void) requestAddressWithLocation: (CLLocation *) location callback: (void (^)(NSString *szAddress)) callback{
    NSString *szUrl = [BERUrlManager getEndpointForGooglemapsGeocode];
    CLLocation *loc = location;
    if (loc == nil) {
        loc = self.m_location;
    }
    
    NSString *latlng = [NSString stringWithFormat:@"%f,%f", loc.coordinate.latitude, loc.coordinate.longitude];
    NSDictionary *params = @{@"latlng" : latlng};
    
    AFHTTPRequestOperationManager *requestManager = [AFHTTPRequestOperationManager manager];
    requestManager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    [requestManager GET:szUrl parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        @try {
            NSDictionary *dictResponse = responseObject;
            NSString *status = [BERGenericFunctionManager refineNSString:[dictResponse objectForKey:@"status"]];
            if ([status caseInsensitiveCompare:@"OK"] == NSOrderedSame){
                NSArray *results = [dictResponse objectForKey:@"results"];
                if ([results count] > 0){
                    NSDictionary *dict = [results objectAtIndex:0];
                    NSString *address = [BERGenericFunctionManager refineNSString: [dict objectForKey:@"formatted_address"]];
                    
                    if (location == nil){
                        self.m_szAddress = address;
                    }
                    
                    if (callback){
                        callback(address);
                    }
                    else{
                        // [[NSNotificationCenter defaultCenter] postNotificationName:ETRLOCALNOTIFICATION_LOCATION_ADDRESS_UPDATED object:nil];
                    }
                }
            } else {
                NSLog(@"Got bad status code from google maps geocode: %@", status);
                [self doFallbackGeocode];
            }
        }
        @catch (NSException *exception) {
            NSLog(@"Google maps geocode exception!");
            if (callback){
                callback(@"");
            }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (callback){
            callback(@"");
        }
    }];
}

- (void) requestGoogleMapsApiPlaceAutoCompleteWithInput: (NSString *) input token: (NSString *) token callback: (void (^)(NSString *token, NSArray *results)) callback{
    
    NSString *szUrl = [BERUrlManager getEndpointForGooglemapsPlaceAutoComplete];
    NSDictionary *params = @{@"input" : input,
                             @"sensor": @"true",
                             @"key": GOOGLEMAPS_API_PLACE_KEY,
                             @"components": @"country:au",
                             @"location": @"-33.8150,151.0011",
                             @"radius": @"48782",
                             };
    
    AFHTTPRequestOperationManager *requestManager = [AFHTTPRequestOperationManager manager];
    requestManager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    [requestManager GET:szUrl parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        @try {
            NSDictionary *dictResponse = responseObject;
            NSString *status = [BERGenericFunctionManager refineNSString:[dictResponse objectForKey:@"status"]];
            NSMutableArray *arrResult = [[NSMutableArray alloc] init];
            if ([status caseInsensitiveCompare:@"OK"] == NSOrderedSame){
                NSArray *arr = [dictResponse objectForKey:@"predictions"];
                if ([arr count] > 0){
                    for (int i = 0; i < (int)[arr count]; i++){
                        NSDictionary *dict = [arr objectAtIndex:i];
                        BERGMPlaceAutoCompleteDataModel *place = [[BERGMPlaceAutoCompleteDataModel alloc] init];
                        [place setWithDictionary:dict];
                        [arrResult addObject:place];
                    }
                }
            }
            if (callback){
                callback(token, arrResult);
            }
        }
        @catch (NSException *exception) {
            if (callback){
                callback(token, nil);
            }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (callback){
            callback(token, nil);
        }
    }];
}

- (void) requestGoogleMapsApiPlaceDetailsWithReference: (NSString *) reference callback: (void (^)(CLLocation *location)) callback{
    NSString *szUrl = [BERUrlManager getEndpointForGooglemapsPlaceDetails];
    NSDictionary *params = @{@"reference" : reference,
                             @"sensor": @"true",
                             @"key": GOOGLEMAPS_API_PLACE_KEY
                             };
    
    AFHTTPRequestOperationManager *requestManager = [AFHTTPRequestOperationManager manager];
    requestManager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    [requestManager GET:szUrl parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        @try {
            NSDictionary *dictResponse = responseObject;
            NSString *status = [BERGenericFunctionManager refineNSString:[dictResponse objectForKey:@"status"]];
            if ([status caseInsensitiveCompare:@"OK"] == NSOrderedSame){
                NSDictionary *dictResult = [dictResponse objectForKey:@"result"];
                NSDictionary *dictGeometry = [dictResult objectForKey:@"geometry"];
                NSDictionary *dictLocation = [dictGeometry objectForKey:@"location"];
                float fLat = [((NSNumber *) [dictLocation objectForKey:@"lat"]) floatValue];
                float fLng = [((NSNumber *) [dictLocation objectForKey:@"lng"]) floatValue];
                
                CLLocation *location = [[CLLocation alloc]initWithLatitude: fLat longitude:fLng];
                if (callback){
                    callback(location);
                }
                else{
                    // self.m_location = location;
                    // [[NSNotificationCenter defaultCenter] postNotificationName:ETRLOCALNOTIFICATION_LOCATION_UPDATED object:nil];
                }
            }
        }
        @catch (NSException *exception) {
            if (callback){
                callback([[CLLocation alloc]initWithLatitude: 0 longitude:0]);
            }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (callback){
            callback([[CLLocation alloc]initWithLatitude: 0 longitude:0]);
        }
    }];
}

- (void) doFallbackGeocode{
    NSLog(@"Doing fallback geocoder");
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    
    [geocoder reverseGeocodeLocation:self.m_location completionHandler:^(NSArray *placemarks, NSError *error){
        if (!(error)) {
            CLPlacemark *placemark = [placemarks objectAtIndex:0];
            NSLog(@"Geocoded with CLGeocoder");
            self.m_szAddress = [[placemark.addressDictionary valueForKey:@"FormattedAddressLines"] componentsJoinedByString:@", "];
            // [[NSNotificationCenter defaultCenter] postNotificationName:ETRLOCALNOTIFICATION_LOCATION_ADDRESS_UPDATED object:nil];
        } else {
            NSLog(@"Failover geocode failed with error %@", error);
            NSLog(@"\nCurrent Location Not Detected\n");
        }
    }];
}

- (BOOL) isSupportedArea{
    float lat = self.m_location.coordinate.latitude;
    float lng = self.m_location.coordinate.longitude;
    NSArray *arr = [BERDataManager sharedInstance].m_arrSupportedArea;
    
    for (int i = 0; i < (int) [arr count]; i++){
        NSDictionary *dict = [arr objectAtIndex:i];
        float top_lat = [[dict objectForKey:@"_TOP_LAT"] floatValue];
        float left_lng = [[dict objectForKey:@"_LEFT_LNG"] floatValue];
        float bottom_lat = [[dict objectForKey:@"_BOTTOM_LAT"] floatValue];
        float right_lng = [[dict objectForKey:@"_RIGHT_LNG"] floatValue];
        
        if ((lat <= top_lat) && (lat >= bottom_lat) && (lng >= left_lng) && (lng <= right_lng)) return YES;
    }
    return NO;
}

@end
