//
//  BERSplashLoadingVC.m
//  Beero
//
//  Created by Chris Lin on 7/21/15.
//  Copyright (c) 2015 Beero. All rights reserved.
//

#import "BERSplashLoadingVC.h"
#import "Global.h"
#import "BERLocationManager.h"
#import "BERBrandManager.h"

@interface BERSplashLoadingVC ()

@property BOOL m_isLocationConfirmed;
@property BOOL m_isBrandLoaded;

@end

@implementation BERSplashLoadingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onLocalNotificationReceived:)
                                                 name:nil
                                               object:nil];
    
    self.m_isLocationConfirmed = NO;
    self.m_isBrandLoaded = NO;
    
    [self doRequestBrand];
    
    self.view.backgroundColor = BERUICOLOR_THEMECOLOR_MAIN;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) dealloc{
    NSLog(@"<<<<<< BERSplashLoadingVC Dealloc >>>>>>>>");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark -Biz Logic

- (void) doRequestBrand{
    [[BERBrandManager sharedInstance] requestBrands];
}

- (void) gotoNotSupported{
    [self performSegueWithIdentifier:@"SEGUE_FROM_SPLASHLOADING_TO_NOTSUPPORTED" sender:nil];
}

- (void) gotoBrands{
    [self performSegueWithIdentifier:@"SEGUE_FROM_SPLASHLOADING_TO_SELECTBRAND" sender:nil];
}

- (void) gotoSearch{
    [self performSegueWithIdentifier:@"SEGUE_FROM_SPLASHLOADING_TO_SEARCH" sender:nil];
}

- (void) checkMandatoryRequests{
    if (self.m_isBrandLoaded == YES && self.m_isLocationConfirmed == YES){
        [[NSNotificationCenter defaultCenter] removeObserver:self];

        // Check if "selected" brands were saved in localstorage...
        [[BERBrandManager sharedInstance] loadFromLocalstorageWithCompareForSelection];
        NSString *szSelected = [[BERBrandManager sharedInstance] getSelectedIdsWithPipe];
        if (szSelected.length == 0){
            [self gotoBrands];
        }
        else {
            [self gotoSearch];
        }
    }
}

#pragma mark -Notification Observer

- (void) onLocalNotificationReceived:(NSNotification *) notification
{
    if ([[notification name] isEqualToString:BERLOCALNOTIFICATION_LOCATION_UPDATED] && self.m_isLocationConfirmed == NO){
//        [[NSNotificationCenter defaultCenter] removeObserver:self];
        self.m_isLocationConfirmed = YES;
        if ([[BERLocationManager sharedInstance] isSupportedArea] == YES){
            [self checkMandatoryRequests];
        }
        else {
            [[NSNotificationCenter defaultCenter] removeObserver:self];
            [self gotoNotSupported];
        }
    }
    else if ([[notification name] isEqualToString:BERLOCALNOTIFICATION_BRAND_GETALL_COMPLETED] && self.m_isBrandLoaded == NO){
        self.m_isBrandLoaded = YES;
        [self checkMandatoryRequests];
    }
    else if ([[notification name] isEqualToString:BERLOCALNOTIFICATION_BRAND_GETALL_FAILED] && self.m_isBrandLoaded == NO){
        self.m_isBrandLoaded = YES;
        [self checkMandatoryRequests];
    }
}

@end
