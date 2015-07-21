//
//  BERErrorManager.h
//  Beero
//
//  Created by Chris Lin on 7/21/15.
//  Copyright (c) 2015 Beero. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BERErrorManager : NSObject

@property (strong, nonatomic) NSString *m_szLastServerMessage;

+ (instancetype) sharedInstance;
- (void) initializeManager;

@end
