//
//  BERGMSMarkerStoreInfoView.h
//  Beero
//
//  Created by Chris Lin on 7/31/15.
//  Copyright (c) 2015 Beero. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BERGMSMarkerStoreInfoView : UIView

@property (weak, nonatomic) IBOutlet UIView *m_viewStoreInfoContainer;
@property (weak, nonatomic) IBOutlet UIView *m_viewMainContainer;
@property (weak, nonatomic) IBOutlet UILabel *m_lblName;
@property (weak, nonatomic) IBOutlet UILabel *m_lblPrice;

@end
