//
//  BERSearchManager.h
//  Beero
//
//  Created by Chris Lin on 7/29/15.
//  Copyright (c) 2015 Beero. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum _ENUM_SEARCH_PACKAGESIZE{
    BERENUM_SEARCH_PACKAGESIZE_CASES = 0,
    BERENUM_SEARCH_PACKAGESIZE_SIXPACK = 1,
}BERENUM_SEARCH_PACKAGESIZE;

typedef enum _ENUM_SEARCH_CONTAINERTYPE{
    BERENUM_SEARCH_CONTAINERTYPE_BOTTLE = 0,
    BERENUM_SEARCH_CONTAINERTYPE_CAN = 1,
    BERENUM_SEARCH_CONTAINERTYPE_ANY = 2,
}BERENUM_SEARCH_CONTAINERTYPE;


@interface BERSearchManager : NSObject

@property (strong, nonatomic) NSMutableArray *m_arrResult;
@property BERENUM_SEARCH_PACKAGESIZE m_enumPackageSize;
@property BERENUM_SEARCH_CONTAINERTYPE m_enumContainerType;

- (id) init;
+ (instancetype) sharedInstance;
- (void) initializeManager;

- (void) requestSearchDealWithCallback: (void (^)(int status)) callback;

@end
