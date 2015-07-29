//
//  BERUrlManager.m
//  Beero
//
//  Created by Chris Lin on 7/21/15.
//  Copyright (c) 2015 Beero. All rights reserved.
//

#import "BERUrlManager.h"
#import "Global.h"

@implementation BERUrlManager

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

#pragma mark -Endpoint for Brand

+ (NSString *) getAllBrands{
    return [NSString stringWithFormat:@"%@/brands", BER_BASEURL];
}

@end
