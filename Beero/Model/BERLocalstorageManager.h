//
//  BERLocalstorageManager.h
//  Beero
//
//  Created by Chris Lin on 7/21/15.
//  Copyright (c) 2015 Beero. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BERLocalstorageManager : NSObject

+ (void) saveGlobalObject: (id) obj Key: (NSString *) key;
+ (id) loadGlobalObjectWithKey: (NSString *) key;

@end
