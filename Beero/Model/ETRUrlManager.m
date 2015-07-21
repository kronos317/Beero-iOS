//
//  ETRUrlManager.m
//  GreenRide
//
//  Created by Chris Lin on 6/21/15.
//  Copyright (c) 2015 Green Ride. All rights reserved.
//

#import "ETRUrlManager.h"

@implementation ETRUrlManager

+ (NSString *) getEndpointForTwilioPhoneNumberVerification{
    return @"https://lookups.twilio.com/v1/PhoneNumbers/";
}

#pragma mark -Endpoint for Location

+ (NSString *) getEndpointForGooglemapsGeocode{
    return @"http://maps.googleapis.com/maps/api/geocode/json";
}

+ (NSString *) getEndpointForGooglemapsPlaceAutoComplete{
    return @"https://maps.googleapis.com/maps/api/place/autocomplete/json";
}

+ (NSString *) getEndpointForGooglemapsPlaceDetails{
    return @"https://maps.googleapis.com/maps/api/place/details/json";
}

+ (NSString *) getEndpointForGooglemapsDirections{
    return @"https://maps.googleapis.com/maps/api/directions/json";
}



@end
