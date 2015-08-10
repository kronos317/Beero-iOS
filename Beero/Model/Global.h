//
//  Global.h
//  GreenRide
//
//  Created by Chris Lin on 6/18/15.
//  Copyright (c) 2015 Green Ride. All rights reserved.
//

#ifndef GreenRide_Global_h
#define GreenRide_Global_h

#define BER_BASEURL                                             @"http://beero.com.au/api/v1"

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
#define BERUICOLOR_ORANGE                                       [UIColor colorWithRed:(247 / 255.0) green:(146 / 255.0) blue:(30 / 255.0) alpha:1]
#define BERUICOLOR_GREEN                                        [UIColor colorWithRed:(64 / 255.0) green:(180 / 255.0) blue:(79 / 255.0) alpha:1]
#define BERUICOLOR_GREY                                         [UIColor colorWithRed:(104 / 255.0) green:(104 / 255.0) blue:(104 / 255.0) alpha:1]
#define BERUICOLOR_BACKGROUND_SELECTED                          [UIColor colorWithRed:(225 / 255.0) green:(225 / 255.0) blue:(225 / 255.0) alpha:1]

// Error Code

#define ERROR_NONE                                              0
#define ERROR_SEARCH_DEAL_FAILED                                1000
#define ERROR_SEARCH_DEAL_CANCELLED                             1001
#define ERROR_SEARCH_DEAL_NOTFOUND                              1002

// Local Notification

#define BERLOCALNOTIFICATION_LOCATION_UPDATED                   @"BERLOCALNOTIFICATION_LOCATION_UPDATED"
#define BERLOCALNOTIFICATION_BRAND_GETALL_COMPLETED             @"BERLOCALNOTIFICATION_BRAND_GETALL_COMPLETED"
#define BERLOCALNOTIFICATION_BRAND_GETALL_FAILED                @"BERLOCALNOTIFICATION_BRAND_GETALL_FAILED"

// Localstorage Key

#define LOCALSTORAGE_PREFIX                 @"BER_LOCALSTORAGE_"
#define LOCALSTORAGE_BRAND                  @"BRAND"

// ENUMs

typedef enum _ENUM_SEARCH_PACKAGESIZE{
    BERENUM_SEARCH_PACKAGESIZE_CASES = 0,
    BERENUM_SEARCH_PACKAGESIZE_SIXPACK = 1,
}BERENUM_SEARCH_PACKAGESIZE;

typedef enum _ENUM_SEARCH_CONTAINERTYPE{
    BERENUM_SEARCH_CONTAINERTYPE_BOTTLE = 0,
    BERENUM_SEARCH_CONTAINERTYPE_CAN = 1,
    BERENUM_SEARCH_CONTAINERTYPE_ANY = 2,
}BERENUM_SEARCH_CONTAINERTYPE;

typedef enum _ENUM_WEEKDAY{
    BERENUM_WEEKDAY_SUNDAY,
    BERENUM_WEEKDAY_MONDAY,
    BERENUM_WEEKDAY_TUESDAY,
    BERENUM_WEEKDAY_WEDNESDAY,
    BERENUM_WEEKDAY_THURSDAY,
    BERENUM_WEEKDAY_FRIDAY,
    BERENUM_WEEKDAY_SATURDAY,
}BERENUM_WEEKDAY;

typedef struct _STRUCT_STORE_OPENHOURS{
    int m_nOpenHour;
    int m_nOpenMinute;
    int m_nCloseHour;
    int m_nCloseMinute;
}BERSTRUCT_STORE_OPENHOURS;

#define STORE_OPENHOUR_NOTOPEN                  99999
#define STORE_OPENHOUR_CLOSED                   -1

#endif
