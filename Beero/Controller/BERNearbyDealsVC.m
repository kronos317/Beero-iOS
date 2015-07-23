//
//  BERNearbyDealsVC.m
//  Beero
//
//  Created by Chris Lin on 7/23/15.
//  Copyright (c) 2015 Beero. All rights reserved.
//

#import "BERNearbyDealsVC.h"
#import <GMSCameraPosition.h>
#import <GMSMapView+Animation.h>
#import "BERLocationManager.h"
#import <GMSMarker.h>
#import <GMSCoordinateBounds.h>
#import <GMSCameraUpdate.h>

@interface BERNearbyDealsVC () <GMSMapViewDelegate, UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UIView *m_viewMapView;
@property (strong, nonatomic) GMSMapView *m_mapview;

@end

@implementation BERNearbyDealsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    BERLocationManager *managerLocation = [BERLocationManager sharedInstance];
    self.m_mapview = nil;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:managerLocation.m_location.coordinate.latitude
                                                                longitude:managerLocation.m_location.coordinate.longitude
                                                                     zoom:15];
        
        CGRect rcMapView = self.m_viewMapView.frame;
        self.m_mapview = [GMSMapView mapWithFrame:CGRectMake(0, 0, rcMapView.size.width, rcMapView.size.height) camera:camera];
        self.m_mapview.myLocationEnabled = YES;
        [self.m_viewMapView addSubview:self.m_mapview];
        
        UITapGestureRecognizer * grMapTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onMapTap:)];
        grMapTap.delegate = self;
        [self.m_mapview addGestureRecognizer:grMapTap];
        
        UIPanGestureRecognizer * grMapDrag = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(onMapDrag:)];
        grMapDrag.delegate = self;
        [self.m_mapview addGestureRecognizer:grMapDrag];
        
        UIPinchGestureRecognizer * grMapZoom = [[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(onMapZoom:)];
        grMapZoom.delegate = self;
        [self.m_mapview addGestureRecognizer:grMapZoom];
        
    });
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

#pragma mark - UIGesture Recognizer Event Listener

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}

- (void) onMapTap : (UITapGestureRecognizer *)sender{
    [self.view endEditing:YES];
    if (sender.state == UIGestureRecognizerStateEnded) {
    }
}

- (void) onMapDrag:(UIPanGestureRecognizer *) sender{
    [self.view endEditing:YES];
    if (sender.state == UIGestureRecognizerStateEnded) {
    }
}
- (void) onMapZoom:(UIPinchGestureRecognizer *)sender{
    [self.view endEditing:YES];
    if (sender.state == UIGestureRecognizerStateEnded) {
    }
}

#pragma mark -Button Event Listeners

- (IBAction)onBtnBackClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
