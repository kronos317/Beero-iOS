//
//  ETRUrlManager.h
//  GreenRide
//
//  Created by Chris Lin on 6/21/15.
//  Copyright (c) 2015 Green Ride. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ETRUrlManager : NSObject

#pragma mark -Endpoint for Order

+ (NSString *) getEndpointForTwilioPhoneNumberVerification;

#pragma mark -Endpoint for Location

+ (NSString *) getEndpointForGooglemapsGeocode;
+ (NSString *) getEndpointForGooglemapsPlaceAutoComplete;
+ (NSString *) getEndpointForGooglemapsPlaceDetails;
+ (NSString *) getEndpointForGooglemapsDirections;

@end
