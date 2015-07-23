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

@interface BERSplashLoadingVC ()

@end

@implementation BERSplashLoadingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onLocalNotificationReceived:)
                                                 name:nil
                                               object:nil];
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

- (void) gotoNotSupported{
    [self performSegueWithIdentifier:@"SEGUE_FROM_SPLASHLOADING_TO_NOTSUPPORTED" sender:nil];
}

- (void) gotoBrands{
    [self performSegueWithIdentifier:@"SEGUE_FROM_SPLASHLOADING_TO_SELECTBRAND" sender:nil];
}

#pragma mark -Notification Observer

- (void) onLocalNotificationReceived:(NSNotification *) notification
{
    if ([[notification name] isEqualToString:BERLOCALNOTIFICATION_LOCATION_UPDATED]){
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        
        if ([[BERLocationManager sharedInstance] isSupportedArea] == YES){
            [self gotoBrands];
        }
        else {
            [self gotoNotSupported];
        }        
    }
}

@end
