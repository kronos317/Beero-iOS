//
//  BERDealDetailsVC.m
//  Beero
//
//  Created by Chris Lin on 7/22/15.
//  Copyright (c) 2015 Beero. All rights reserved.
//

#import "BERDealDetailsVC.h"

@interface BERDealDetailsVC ()

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

@end
