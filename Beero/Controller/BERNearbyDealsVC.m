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
#import "BERGMSMarkerStoreInfoView.h"

@interface BERNearbyDealsVC () <GMSMapViewDelegate, UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UIView *m_viewMapView;
@property (strong, nonatomic) GMSMapView *m_mapview;
@property (strong, nonatomic) NSMutableArray *m_arrMarkers;

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
        
        self.m_mapview.delegate = self;
        
        [self addMarker];
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

- (void) addMarker{
    BERSearchManager *managerSearch = [BERSearchManager sharedInstance];
    BERSearchDealDataModel *deal = [managerSearch.m_arrResult objectAtIndex:managerSearch.m_indexSelectedToViewDetails];
    
    self.m_arrMarkers = [[NSMutableArray alloc] init];
    
    UIImage *imgPin = [UIImage imageNamed:@"map-pin-small"];
    UIImage *imgPinMine = [UIImage imageNamed:@"map-pin-small-orange"];
    
    GMSMarker *markerMine = [GMSMarker markerWithPosition:[BERLocationManager sharedInstance].m_location.coordinate];
    markerMine.map = self.m_mapview;
    markerMine.appearAnimation = kGMSMarkerAnimationPop;
    markerMine.icon = imgPinMine;
    markerMine.groundAnchor = CGPointMake(0.5, 1);
    
    [self.m_arrMarkers addObject:markerMine];
    
    for (int i = 0; i < (int) [deal.m_arrLosingDeal count]; i++){
        BERSearchLosingDealDataModel *losing = [deal.m_arrLosingDeal objectAtIndex:i];
        
        CLLocationCoordinate2D position = CLLocationCoordinate2DMake(losing.m_fLatitude, losing.m_fLongitude);
        GMSMarker *marker = [GMSMarker markerWithPosition:position];
//        marker.title = losing.m_szStoreName;
        marker.infoWindowAnchor = CGPointMake(0.5, 0);
        marker.map = self.m_mapview;
        marker.appearAnimation = kGMSMarkerAnimationPop;
        marker.icon = imgPin;
        marker.groundAnchor = CGPointMake(0.5, 1);
//        [self.m_mapview setSelectedMarker:marker];
        [self.m_arrMarkers addObject:marker];
    }
    
    CLLocationCoordinate2D firstLocation = ((GMSMarker *)[self.m_arrMarkers firstObject]).position;
    GMSCoordinateBounds *bounds = [[GMSCoordinateBounds alloc] initWithCoordinate:firstLocation coordinate:firstLocation];
    
    for (GMSMarker *marker in self.m_arrMarkers) {
        bounds = [bounds includingCoordinate:marker.position];
    }
    
    [self.m_mapview moveCamera:[GMSCameraUpdate fitBounds:bounds withEdgeInsets:UIEdgeInsetsMake(50.0f, 50.0f, 50.0f, 50.0f)]];

    /*
    // Show all markers in one screen with Orange marker at center point
    
    CLLocationCoordinate2D posCenter = [BERLocationManager sharedInstance].m_location.coordinate;
    float fZoom = self.m_mapview.camera.zoom;
    float fZoomOutStep = 0.1f;
    int countLoop = 0;

    [self.m_mapview moveCamera:[GMSCameraUpdate setTarget:posCenter]];
    while (true) {
        GMSVisibleRegion region = [self.m_mapview.projection visibleRegion];
        GMSCoordinateBounds *boundScreen = [[GMSCoordinateBounds alloc] initWithRegion:region];
        BOOL bAllMarkersVisible = YES;
        
        for (int i = 0; i < (int) [self.m_arrMarkers count]; i++){
            GMSMarker *marker = [self.m_arrMarkers objectAtIndex:i];
            if ([boundScreen containsCoordinate:marker.position] == NO){
                bAllMarkersVisible = NO;
                break;
            }
        }
        
        if (bAllMarkersVisible == YES) break;
        
        // Zoom map to show all markers in screen
        fZoom = fZoom - fZoomOutStep;
        [self.m_mapview moveCamera:[GMSCameraUpdate setTarget:posCenter zoom:fZoom]];
        
        countLoop++;
        if (countLoop > 200) break;
    }
     */
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

#pragma mark -GMSMapView Delegate

- (UIView *)mapView:(GMSMapView *)mapView markerInfoWindow:(GMSMarker *)marker{
    BERGMSMarkerStoreInfoView *view =  [[[NSBundle mainBundle] loadNibNamed:@"MarkerInfoView" owner:self options:nil] objectAtIndex:0];
    view.m_viewMainContainer.backgroundColor = BERUICOLOR_THEMECOLOR_MAIN;
    BERSearchDealDataModel *deal = [[BERSearchManager sharedInstance].m_arrResult objectAtIndex:[BERSearchManager sharedInstance].m_indexSelectedToViewDetails];
    
    for (int i = 0; i < (int) [self.m_arrMarkers count]; i++){
        GMSMarker *m = [self.m_arrMarkers objectAtIndex:i];
        if (m == marker){
            if (i == 0){
                // Orange icon... no info window needed
                return nil;
            }
            
            BERSearchLosingDealDataModel *losing = [deal.m_arrLosingDeal objectAtIndex:(i - 1)];
            view.m_lblName.text = losing.m_szStoreName;
            view.m_lblPrice.text = [NSString stringWithFormat:@"$%@ per litre", losing.m_szPricePerLitre];
            break;
        }
    }
    
    return view.m_viewStoreInfoContainer;
}

#pragma mark -Button Event Listeners

- (IBAction)onBtnBackClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
