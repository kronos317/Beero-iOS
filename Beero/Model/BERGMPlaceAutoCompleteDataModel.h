//
//  BERGMPlaceAutoCompleteDataModel.h
//  Beero
//
//  Created by Chris Lin on 7/21/15.
//  Copyright (c) 2015 Beero. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BERGMPlaceAutoCompleteDataModel : NSObject

@property (strong, nonatomic) NSString *m_szId;
@property (strong, nonatomic) NSString *m_szPlaceId;
@property (strong, nonatomic) NSString *m_szReference;
@property (strong, nonatomic) NSString *m_szDescription;

- (id) init;
- (void) setWithDictionary: (NSDictionary *) dict;

@end
