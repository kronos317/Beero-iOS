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
#import "BERSearchManager.h"
#import "BERSearchDealDataModel.h"

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
        
        [self addPresetMarker];
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

#pragma mark -Biz Logic

- (void) addPresetMarker{
    BERSearchManager *managerSearch = [BERSearchManager sharedInstance];
    BERSearchDealDataModel *deal = [managerSearch.m_arrResult objectAtIndex:managerSearch.m_indexSelectedToViewDetails];
    
    NSMutableArray *arrMarkers = [[NSMutableArray alloc] init];
    
    UIImage *imgPin = [UIImage imageNamed:@"map-pin-small"];
    UIImage *imgPinMine = [UIImage imageNamed:@"map-pin-small-orange"];
    
    GMSMarker *markerMine = [GMSMarker markerWithPosition:[BERLocationManager sharedInstance].m_location.coordinate];
    markerMine.map = self.m_mapview;
    markerMine.appearAnimation = kGMSMarkerAnimationPop;
    markerMine.icon = imgPinMine;
    markerMine.groundAnchor = CGPointMake(0.5, 1);
    
    [arrMarkers addObject:markerMine];
    
    for (int i = 0; i < (int) [deal.m_arrLosingDeal count]; i++){
        BERSearchLosingDealDataModel *losing = [deal.m_arrLosingDeal objectAtIndex:i];
        
        CLLocationCoordinate2D position = CLLocationCoordinate2DMake(losing.m_fLatitude, losing.m_fLongitude);
        GMSMarker *marker = [GMSMarker markerWithPosition:position];
        marker.title = losing.m_szStoreName;
        marker.map = self.m_mapview;
        marker.appearAnimation = kGMSMarkerAnimationPop;
        marker.icon = imgPin;
        marker.groundAnchor = CGPointMake(0.5, 1);
        
//        [self.m_mapview setSelectedMarker:marker];
        [arrMarkers addObject:marker];
    }
    
    CLLocationCoordinate2D firstLocation = ((GMSMarker *)[arrMarkers firstObject]).position;
    GMSCoordinateBounds *bounds = [[GMSCoordinateBounds alloc] initWithCoordinate:firstLocation coordinate:firstLocation];
    
    for (GMSMarker *marker in arrMarkers) {
        bounds = [bounds includingCoordinate:marker.position];
    }
    
    [self.m_mapview animateWithCameraUpdate:[GMSCameraUpdate fitBounds:bounds withEdgeInsets:UIEdgeInsetsMake(50.0f, 50.0f, 50.0f, 50.0f)]];
    
//#warning Check this article to show all markers with mine at center, --- once fit bounds, move camera to my position, check if all are in screen, if not zoom-out until it fits...
//    http://stackoverflow.com/questions/30065098/google-maps-for-ios-how-can-you-tell-if-a-marker-is-within-the-bounds-of-the-s
}

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
