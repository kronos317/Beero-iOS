//
//  BERLocalstorageManager.m
//  Beero
//
//  Created by Chris Lin on 7/21/15.
//  Copyright (c) 2015 Beero. All rights reserved.
//

#import "BERLocalstorageManager.h"
#import "Global.h"

@implementation BERLocalstorageManager

+ (void) saveGlobalObject: (id) obj Key: (NSString *) key{
    NSString *szKey = [NSString stringWithFormat:@"%@%@", LOCALSTORAGE_PREFIX, key];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:obj forKey:szKey];
    [userDefaults synchronize];
}

+ (id) loadGlobalObjectWithKey: (NSString *) key{
    NSString *szKey = [NSString stringWithFormat:@"%@%@", LOCALSTORAGE_PREFIX, key];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults objectForKey:szKey];
}


@end
