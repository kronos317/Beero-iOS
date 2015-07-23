//
//  BERDataManager.h
//  Beero
//
//  Created by Chris Lin on 7/23/15.
//  Copyright (c) 2015 Beero. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BERDataManager : NSObject

@property (strong, nonatomic) NSMutableArray *m_arrSupportedArea;

+ (instancetype) sharedInstance;
- (void) initializeManager;

@end
