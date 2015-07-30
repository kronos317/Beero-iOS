//
//  BERBrandManager.h
//  Beero
//
//  Created by Chris Lin on 7/29/15.
//  Copyright (c) 2015 Beero. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BERBrandManager : NSObject

@property (strong, nonatomic) NSMutableArray *m_arrBrand;

- (id) init;
+ (instancetype) sharedInstance;
- (void) initializeManager;

#pragma mark -Biz Logic

- (void) sortByPosition;
- (NSString *) getSelectedIdsWithPipe;

#pragma mark -Requests

- (void) requestBrands;

@end
