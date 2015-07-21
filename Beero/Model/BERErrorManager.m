//
//  BERErrorManager.m
//  Beero
//
//  Created by Chris Lin on 7/21/15.
//  Copyright (c) 2015 Beero. All rights reserved.
//

#import "BERErrorManager.h"

@implementation BERErrorManager

+ (instancetype) sharedInstance{
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (id) init{
    if (self = [super init]){
        [self initialize];
    }
    return self;
}

- (void) initialize{
    self.m_szLastServerMessage = @"";
}

- (void) initializeManager{
    [self initialize];
}

@end
