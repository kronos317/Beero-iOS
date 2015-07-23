//
//  BERDataManager.m
//  Beero
//
//  Created by Chris Lin on 7/23/15.
//  Copyright (c) 2015 Beero. All rights reserved.
//

#import "BERDataManager.h"

@implementation BERDataManager

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
    }
    return self;
}

- (void) initializeManager{
    [self loadSupportedAreaCode];
}

#pragma mark -Load Data from Property-List files

- (void) loadSupportedAreaCode{
    NSString *path = [[NSBundle mainBundle] pathForResource: @"SupportedArea" ofType:@"plist"];
    NSArray *arr = [[NSMutableArray alloc] initWithContentsOfFile:path];
    
    self.m_arrSupportedArea = [[NSMutableArray alloc] init];
    [self.m_arrSupportedArea addObjectsFromArray:arr];
}


@end
