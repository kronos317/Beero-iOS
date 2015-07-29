//
//  BERBrandDataModel.h
//  Beero
//
//  Created by Chris Lin on 7/29/15.
//  Copyright (c) 2015 Beero. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BERBrandDataModel : NSObject

@property int m_index;
@property (strong, nonatomic) NSString *m_szName;
@property int m_position;
@property BOOL m_isSelected;

- (id) init;
- (void) setWithDictionary: (NSDictionary *) dict WithId: (int) Id;
- (BOOL) isFeatured;

@end
