//
//  BERUrlManager.h
//  Beero
//
//  Created by Chris Lin on 7/21/15.
//  Copyright (c) 2015 Beero. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BERUrlManager : NSObject

#pragma mark -Endpoint for Location

+ (NSString *) getEndpointForGooglemapsGeocode;
+ (NSString *) getEndpointForGooglemapsPlaceAutoComplete;
+ (NSString *) getEndpointForGooglemapsPlaceDetails;

#pragma mark -Endpoint for Brand

+ (NSString *) getAllBrands;

@end
