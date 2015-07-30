//
//  BERStoreDetailsVC.m
//  Beero
//
//  Created by Chris Lin on 7/23/15.
//  Copyright (c) 2015 Beero. All rights reserved.
//

#import "BERStoreDetailsVC.h"

@interface BERStoreDetailsVC ()

@property (weak, nonatomic) IBOutlet UILabel *m_lblStoreName;
@property (weak, nonatomic) IBOutlet UILabel *m_lblMemberSince;
@property (weak, nonatomic) IBOutlet UILabel *m_lblPhoneNumber;

@property (weak, nonatomic) IBOutlet UIImageView *m_imgOpen;
@property (weak, nonatomic) IBOutlet UILabel *m_lblOpenTill;
@property (weak, nonatomic) IBOutlet UILabel *m_lblClosesIn;

@property (weak, nonatomic) IBOutlet UIView *m_viewMapView;
@property (weak, nonatomic) IBOutlet UILabel *m_lblAddress;

@property (weak, nonatomic) IBOutlet UIImageView *m_imgStore;
@property (weak, nonatomic) IBOutlet UIView *m_viewManagerWrapper;
@property (weak, nonatomic) IBOutlet UIImageView *m_imgManager;
@property (weak, nonatomic) IBOutlet UILabel *m_lblManagerMessage;

@property (weak, nonatomic) IBOutlet UIImageView *m_imgCatalog;

@property (weak, nonatomic) IBOutlet UILabel *m_lblOpeningHourMonday;
@property (weak, nonatomic) IBOutlet UILabel *m_lblOpeningHourTuesday;
@property (weak, nonatomic) IBOutlet UILabel *m_lblOpeningHourWednesday;
@property (weak, nonatomic) IBOutlet UILabel *m_lblOpeningHourThursday;
@property (weak, nonatomic) IBOutlet UILabel *m_lblOpeningHourFriday;
@property (weak, nonatomic) IBOutlet UILabel *m_lblOpeningHourSaturday;
@property (weak, nonatomic) IBOutlet UILabel *m_lblOpeningHourSunday;

@end

@implementation BERStoreDetailsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark -Button Event Listeners

- (IBAction)onBtnBackClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onBtnViewCatalogClick:(id)sender {
}

@end
