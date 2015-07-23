//
//  Global.h
//  GreenRide
//
//  Created by Chris Lin on 6/18/15.
//  Copyright (c) 2015 Green Ride. All rights reserved.
//

#ifndef GreenRide_Global_h
#define GreenRide_Global_h

// Provider

#define GOOGLEMAPS_API_PLACE_KEY                                @"AIzaSyAvrIo6cGEl-wLfr4d75HMdij5VjikgnxA"
#define GOOGLEMAPS_API_KEY                                      @"AIzaSyAvrIo6cGEl-wLfr4d75HMdij5VjikgnxA"
#define GOOGLEMAPS_API_DIRECTION_KEY                            @"AIzaSyCigSA-o0Tf3JLljjDLIJScUZ1Y0akFCTc"

// Constants

#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_RETINA ([[UIScreen mainScreen] scale] >= 2.0)

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))

#define IS_IPHONE_4_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
#define IS_IPHONE_5 (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
#define IS_IPHONE_6 (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6P (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)

#define CONSTANT_BUTTON_CORNERRADIUS                            3
#define CONSTANT_USER_PHONENUMBER_COUNTRYCODE_DEFAULTVALUE      @"+61"

// UICOLOR

// 03446d
#define BERUICOLOR_THEMECOLOR_MAIN                              [UIColor colorWithRed:(3 / 255.0) green:(68 / 255.0) blue:(109 / 255.0) alpha:1]
#define BERUICOLOR_THEMECOLOR_INVALID                           [UIColor colorWithRed:(195 / 255.0) green:(40 / 255.0) blue:(0 / 255.0) alpha:1]
#define BERUICOLOR_TEXTFIELD_BORDER                             [UIColor colorWithRed:(217 / 255.0) green:(223 / 255.0) blue:(223 / 255.0) alpha:1]
#define BERUICOLOR_TEXTFIELD_BORDER_INVALID                     [UIColor colorWithRed:(195 / 255.0) green:(40 / 255.0) blue:(0 / 255.0) alpha:1]

// Error Code

#define ERROR_NONE                                              1000

// Local Notification

#define BERLOCALNOTIFICATION_LOCATION_UPDATED                   @"BERLOCALNOTIFICATION_LOCATION_UPDATED"

// Localstorage Key

#define LOCALSTORAGE_PREFIX                 @"BER_LOCALSTORAGE_"
#define LOCALSTORAGE_USERLOOKUP             @"USERLOOKUP"
#define LOCALSTORAGE_USERLASTLOGIN          @"USERLASTLOGIN"
#define LOCALSTORAGE_USERINFO               @"USERINFO"


#endif
