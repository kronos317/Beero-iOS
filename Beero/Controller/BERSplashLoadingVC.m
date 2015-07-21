//
//  BERSplashLoadingVC.m
//  Beero
//
//  Created by Chris Lin on 7/21/15.
//  Copyright (c) 2015 Beero. All rights reserved.
//

#import "BERSplashLoadingVC.h"

@interface BERSplashLoadingVC ()

@end

@implementation BERSplashLoadingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self performSelector:@selector(gotoBrands) withObject:nil afterDelay:3.0f];
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

#pragma mark -Biz Logic

- (void) gotoNotSupported{
    [self performSegueWithIdentifier:@"SEGUE_FROM_SPLASHLOADING_TO_NOTSUPPORTED" sender:nil];
}

- (void) gotoBrands{
    [self performSegueWithIdentifier:@"SEGUE_FROM_SPLASHLOADING_TO_SELECTBRAND" sender:nil];
}

@end
