//
//  BERSearchResultBodyTVC.h
//  Beero
//
//  Created by Chris Lin on 7/21/15.
//  Copyright (c) 2015 Beero. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BERSearchResultBodyTVC : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *m_imgBrand;
@property (weak, nonatomic) IBOutlet UIImageView *m_imgBadgeExclusive;
@property (weak, nonatomic) IBOutlet UILabel *m_lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *m_lblSpec;
@property (weak, nonatomic) IBOutlet UILabel *m_lblPrice;
@property (weak, nonatomic) IBOutlet UILabel *m_lblDistance;

@end
