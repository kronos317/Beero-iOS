//
//  BERDealDetailsVC.m
//  Beero
//
//  Created by Chris Lin on 7/22/15.
//  Copyright (c) 2015 Beero. All rights reserved.
//

#import "BERDealDetailsVC.h"
#import "BERSearchManager.h"
#import "BERSearchDealDataModel.h"

@interface BERDealDetailsVC ()

@property (weak, nonatomic) IBOutlet UILabel *m_lblBrandName;

@property (weak, nonatomic) IBOutlet UILabel *m_lblStoreName;
@property (weak, nonatomic) IBOutlet UILabel *m_lblStoreAddress;
@property (weak, nonatomic) IBOutlet UILabel *m_lblStoreSpec;

@property (weak, nonatomic) IBOutlet UIImageView *m_imgBrand;
@property (weak, nonatomic) IBOutlet UILabel *m_lblDealSizeSpec;
@property (weak, nonatomic) IBOutlet UILabel *m_lblPriceBig;
@property (weak, nonatomic) IBOutlet UILabel *m_lblPriceSmall;

@property (weak, nonatomic) IBOutlet UIView *m_viewBadgeExclusive;
@property (weak, nonatomic) IBOutlet UIView *m_viewBadgeExclusiveDesc;

@property (weak, nonatomic) IBOutlet UILabel *m_lblNearby;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *m_constraintViewVerifiedStockHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *m_constraintViewStoreDetailsBottomSpace;

@end

@implementation BERDealDetailsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self refreshFields];
}

#pragma mark -Biz Logic

- (void) refreshFields{
    BERSearchDealDataModel *deal = [[BERSearchManager sharedInstance].m_arrResult objectAtIndex:[BERSearchManager sharedInstance].m_indexSelectedToViewDetails];
    BERSTRUCT_STORE_OPENHOURS openHour = [deal.m_modelWinningDeal.m_modelStore getOpenHourToday];
    
    self.m_lblBrandName.text = deal.m_modelWinningDeal.m_szName;    
    self.m_lblStoreName.text = deal.m_modelWinningDeal.m_modelStore.m_szName;
    self.m_lblStoreAddress.text = deal.m_modelWinningDeal.m_modelStore.m_szAddress;
    self.m_lblStoreSpec.text = [NSString stringWithFormat:@"%@ mins drive, open till %dpm", [deal.m_modelWinningDeal getBeautifiedDriveDistance], (openHour.m_nCloseHour <= 12) ? openHour.m_nCloseHour : (openHour.m_nCloseHour - 12)];
    
    self.m_lblDealSizeSpec.text = [deal.m_modelWinningDeal getBeautifiedVolumeSpecification];
    self.m_lblPriceBig.text = [NSString stringWithFormat:@"%d", (int) (deal.m_modelWinningDeal.m_fPrice)];
    self.m_lblPriceSmall.text = [NSString stringWithFormat:@"%d", (int) ((deal.m_modelWinningDeal.m_fPrice - (int)(deal.m_modelWinningDeal.m_fPrice)) * 100)];
    
    self.m_viewBadgeExclusiveDesc.layer.cornerRadius = 3;
    self.m_viewBadgeExclusiveDesc.clipsToBounds = YES;
    
    deal.m_modelWinningDeal.m_isExclusive = YES;
    if (deal.m_modelWinningDeal.m_isExclusive == YES){
        self.m_viewBadgeExclusive.hidden = NO;
        self.m_constraintViewStoreDetailsBottomSpace.constant = 60;
        [self.m_viewBadgeExclusive layoutIfNeeded];
    }
    else {
        self.m_viewBadgeExclusive.hidden = YES;
        self.m_constraintViewStoreDetailsBottomSpace.constant = 0;
        [self.m_viewBadgeExclusive layoutIfNeeded];
    }
    
    self.m_lblNearby.text = [NSString stringWithFormat:@"Best of %d nearby deals", (int) [deal.m_arrLosingDeal count]];
}

#pragma mark -Button Event Listeners

- (IBAction)onBtnBackClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onBtnStoreDetailsClick:(id)sender {
     [self performSegueWithIdentifier:@"SEGUE_FROM_DEAL_DETAILS_TO_STORE_DETAILS" sender:nil];
}

- (IBAction)onBtnNearbyDealsClick:(id)sender {
     [self performSegueWithIdentifier:@"SEGUE_FROM_DEAL_DETAILS_TO_NEARBY" sender:nil];
}

- (IBAction)onBtnCallStoreClick:(id)sender {
}

- (IBAction)onBtnViewCatalogClick:(id)sender {
}

@end
