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
#import "BERGenericFunctionManager.h"

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

@property (weak, nonatomic) IBOutlet UIView *m_viewActionPanel;
@property (weak, nonatomic) IBOutlet UIView *m_viewPhotoPanel;

@property (weak, nonatomic) IBOutlet UIButton *m_btnNearby;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *m_constraintViewVerifiedStockHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *m_constraintViewStoreDetailsBottomSpace;

@property (weak, nonatomic) IBOutlet UILabel *m_lblActionBottomSeparator;
@property (weak, nonatomic) IBOutlet UILabel *m_lblPhotoBottomSeparator;

@property (weak, nonatomic) IBOutlet UIView *m_viewStoreDetailsPanel;
@property (weak, nonatomic) IBOutlet UIView *m_viewNearbyPanel;

@end

@implementation BERDealDetailsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    self.view.backgroundColor = BERUICOLOR_THEMECOLOR_MAIN;
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
    
    self.m_viewStoreDetailsPanel.backgroundColor = [UIColor clearColor];
    self.m_viewNearbyPanel.backgroundColor = [UIColor clearColor];
    
    [BERGenericFunctionManager drawDropShadowToView:self.m_lblActionBottomSeparator Size:2];
    [BERGenericFunctionManager drawDropShadowToView:self.m_lblPhotoBottomSeparator Size:2];
}

#pragma mark -Biz Logic

- (void) refreshFields{
    BERSearchDealDataModel *deal = [[BERSearchManager sharedInstance].m_arrResult objectAtIndex:[BERSearchManager sharedInstance].m_indexSelectedToViewDetails];
    
    self.m_lblBrandName.text = deal.m_modelWinningDeal.m_szName;    
    self.m_lblStoreName.text = deal.m_modelWinningDeal.m_modelStore.m_szName;
    self.m_lblStoreAddress.text = deal.m_modelWinningDeal.m_modelStore.m_szAddress;
    
    self.m_lblDealSizeSpec.text = [deal.m_modelWinningDeal getBeautifiedVolumeSpecification];
    self.m_lblPriceBig.text = [NSString stringWithFormat:@"%d", (int) (deal.m_modelWinningDeal.m_fPrice)];
    self.m_lblPriceSmall.text = [NSString stringWithFormat:@"%02d", (int) ((deal.m_modelWinningDeal.m_fPrice - (int)(deal.m_modelWinningDeal.m_fPrice)) * 100)];
    
    self.m_viewBadgeExclusiveDesc.layer.cornerRadius = 3;
    self.m_viewBadgeExclusiveDesc.clipsToBounds = YES;
    
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
    
    [self.m_btnNearby setTitle:[NSString stringWithFormat:@"Best of %d nearby deals", (int) [deal.m_arrLosingDeal count]] forState:UIControlStateNormal] ;
    
    int nRemainingMinute = [deal.m_modelWinningDeal.m_modelStore getRemainingMinutesTillClose];
    if (nRemainingMinute == STORE_OPENHOUR_CLOSED){
        // Closed
        self.m_lblStoreSpec.text = [NSString stringWithFormat:@"%@ mins drive, closed", [deal.m_modelWinningDeal getBeautifiedDriveDistance]];
    }
    else if (nRemainingMinute == STORE_OPENHOUR_NOTOPEN){
        // NOT OPEN YET
        self.m_lblStoreSpec.text = [NSString stringWithFormat:@"%@ mins drive, %@", [deal.m_modelWinningDeal getBeautifiedDriveDistance], [[deal.m_modelWinningDeal.m_modelStore getBeautifiedLabelForOpenTimeToday] lowercaseString]];
    }
    else {
        self.m_lblStoreSpec.text = [NSString stringWithFormat:@"%@ mins drive, open %@", [deal.m_modelWinningDeal getBeautifiedDriveDistance], [[deal.m_modelWinningDeal.m_modelStore getBeautifiedLabelForOpenTimeToday] lowercaseString]];
    }
}

#pragma mark -Button Event Listeners

- (IBAction)onBtnBackClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onBtnStoreDetailsClick:(id)sender {
     [self performSegueWithIdentifier:@"SEGUE_FROM_DEAL_DETAILS_TO_STORE_DETAILS" sender:nil];
}

- (IBAction)onBtnStoreDetailsTouchDown:(id)sender {
    self.m_viewStoreDetailsPanel.backgroundColor = BERUICOLOR_BACKGROUND_SELECTED;
}

- (IBAction)onBtnStoreDetailsDragExit:(id)sender {
    self.m_viewStoreDetailsPanel.backgroundColor = [UIColor clearColor];
}

- (IBAction)onBtnNearbyDealsClick:(id)sender {
     [self performSegueWithIdentifier:@"SEGUE_FROM_DEAL_DETAILS_TO_NEARBY" sender:nil];
}

- (IBAction)onBtnNearbyTouchDown:(id)sender {
    self.m_viewNearbyPanel.backgroundColor = BERUICOLOR_BACKGROUND_SELECTED;
}

- (IBAction)onBtnNearbyDragExit:(id)sender {
    self.m_viewNearbyPanel.backgroundColor = [UIColor clearColor];
}

- (IBAction)onBtnCallStoreClick:(id)sender {
}

- (IBAction)onBtnViewCatalogClick:(id)sender {
}

@end
