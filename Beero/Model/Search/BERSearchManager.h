//
//  BERSearchManager.h
//  Beero
//
//  Created by Chris Lin on 7/29/15.
//  Copyright (c) 2015 Beero. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Global.h"
#import "BERSearchDealDataModel.h"

@interface BERSearchManager : NSObject

@property int m_indexSelectedToViewDetails;

@property (strong, nonatomic) NSMutableArray *m_arrResult;
@property BERENUM_SEARCH_PACKAGESIZE m_enumPackageSize;
@property BERENUM_SEARCH_CONTAINERTYPE m_enumContainerType;

@property (strong, nonatomic) NSString *m_szRequestToken;
@property BOOL m_isAllBeers;

- (id) init;
+ (instancetype) sharedInstance;
- (void) initializeManager;

- (void) requestSearchDealWithCallback: (void (^)(int status)) callback;

@end
