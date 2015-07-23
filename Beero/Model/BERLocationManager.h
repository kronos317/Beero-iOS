//
//  BERLocationManager.h
//  Beero
//
//  Created by Chris Lin on 7/21/15.
//  Copyright (c) 2015 Beero. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <GMSMutablePath.h>

@interface BERLocationManager : NSObject <CLLocationManagerDelegate>

@property (strong, nonatomic) CLLocationManager *m_locationManager;
@property (strong, nonatomic) CLLocation *m_location;               // LOCATION
@property (strong, nonatomic) NSString *m_szAddress;

+ (instancetype) sharedInstance;
- (void) initializeManager;

- (void) startLocationUpdate;
- (void) stopLocationUpdate;
- (void) requestCurrentLocation;

- (void) requestAddressWithLocation: (CLLocation *) location callback: (void (^)(NSString *szAddress)) callback;
- (void) requestGoogleMapsApiPlaceAutoCompleteWithInput: (NSString *) input token: (NSString *) token callback: (void (^)(NSString *token, NSArray *results)) callback;
- (void) requestGoogleMapsApiPlaceDetailsWithReference: (NSString *) reference callback: (void (^)(CLLocation *location)) callback;

- (BOOL) isSupportedArea;

@end
