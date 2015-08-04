//
//  BERStoreDetailsVC.m
//  Beero
//
//  Created by Chris Lin on 7/23/15.
//  Copyright (c) 2015 Beero. All rights reserved.
//

#import "BERStoreDetailsVC.h"
#import <GMSCameraPosition.h>
#import <GMSMapView+Animation.h>
#import "BERLocationManager.h"
#import <GMSMarker.h>
#import <GMSCoordinateBounds.h>
#import <GMSCameraUpdate.h>
#import "BERSearchManager.h"
#import "BERSearchDealDataModel.h"
#import "BERGenericFunctionManager.h"
#import <MapKit/MapKit.h>

@interface BERStoreDetailsVC () <GMSMapViewDelegate, UIGestureRecognizerDelegate, UIActionSheetDelegate>

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

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *m_constraintOpenMarkWidth;

@property (strong, nonatomic) GMSMapView *m_mapview;
@property (strong, nonatomic) BERStoreDataModel *m_store;

@end

@implementation BERStoreDetailsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.m_mapview = nil;
    
    BERSearchManager *managerSearch = [BERSearchManager sharedInstance];
    BERSearchDealDataModel *deal = [managerSearch.m_arrResult objectAtIndex:managerSearch.m_indexSelectedToViewDetails];
    self.m_store = deal.m_modelWinningDeal.m_modelStore;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

        GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:self.m_store.m_fLatitude
                                                                longitude:self.m_store.m_fLongitude
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
        
        [self addMarker];
    });
    self.view.backgroundColor = BERUICOLOR_THEMECOLOR_MAIN;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self refreshFields];
}

- (void) refreshFields{
    self.m_lblStoreName.text = self.m_store.m_szName;
    if (self.m_store.m_isBeeroMember == YES){
        self.m_lblMemberSince.text = @"Beero Member";
    }
    else {
        self.m_lblMemberSince.text = @"";
    }
    self.m_lblAddress.text = self.m_store.m_szAddress;
    
    NSArray *arrLabelWeekday = @[self.m_lblOpeningHourSunday, self.m_lblOpeningHourMonday, self.m_lblOpeningHourTuesday, self.m_lblOpeningHourWednesday, self.m_lblOpeningHourThursday, self.m_lblOpeningHourFriday, self.m_lblOpeningHourSaturday];
    
    for (int i = 0; i < 7; i++){
        BERSTRUCT_STORE_OPENHOURS openHour = [self.m_store getOpenHourWithWeekday:i];
        NSString *szOpen = [BERGenericFunctionManager getStringForTimeWithHour:openHour.m_nOpenHour AndMinute:openHour.m_nOpenMinute];
        NSString *szClose = [BERGenericFunctionManager getStringForTimeWithHour:openHour.m_nCloseHour AndMinute:openHour.m_nCloseMinute];
        UILabel *lbl = [arrLabelWeekday objectAtIndex:i];
        lbl.text = [NSString stringWithFormat:@"%@ to %@", szOpen, szClose];
    }
    
    self.m_lblClosesIn.text = [self.m_store getBeautifiedLabelForRemainingTimeToday];
    self.m_lblOpenTill.text = [self.m_store getBeautifiedLabelForOpenTimeToday];
    int nRemainingMinute = [self.m_store getRemainingMinutesTillClose];
    if (nRemainingMinute == STORE_OPENHOUR_CLOSED || nRemainingMinute == STORE_OPENHOUR_NOTOPEN){
        // Closed or Not Open Yet
        self.m_lblClosesIn.text = @"";
        self.m_constraintOpenMarkWidth.constant = 0;
        self.m_lblOpenTill.textColor = BERUICOLOR_GREY;
    }
    else {
        self.m_constraintOpenMarkWidth.constant = 47;
        self.m_lblOpenTill.textColor = BERUICOLOR_GREEN;
    }
    
    self.m_viewManagerWrapper.layer.cornerRadius = 55;
    self.m_viewManagerWrapper.clipsToBounds = YES;
    self.m_viewManagerWrapper.layer.masksToBounds = YES;
    
    self.m_imgManager.layer.cornerRadius = 50;
    self.m_imgManager.clipsToBounds = YES;
    self.m_imgManager.layer.masksToBounds = YES;
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
    
    UIImage *imgPin = [UIImage imageNamed:@"map-pin-large"];
    
    CLLocationCoordinate2D position = CLLocationCoordinate2DMake(self.m_store.m_fLatitude, self.m_store.m_fLongitude);
    GMSMarker *marker = [GMSMarker markerWithPosition:position];
    marker.map = self.m_mapview;
    marker.appearAnimation = kGMSMarkerAnimationPop;
    marker.icon = imgPin;
    marker.groundAnchor = CGPointMake(0.5, 1);
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

- (IBAction)onBtnViewCatalogClick:(id)sender {
}

- (IBAction)onBtnViewMapClick:(id)sender {
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"Open in Maps" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"Apple Maps",@"Google Maps", nil];
    [sheet showInView:self.view];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    //coordinates for the place we want to display
    CLLocationCoordinate2D position = CLLocationCoordinate2DMake(self.m_store.m_fLatitude, self.m_store.m_fLongitude);

    if (buttonIndex==0) {
        //Apple Maps, using the MKMapItem class
        MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:position addressDictionary:nil];
        MKMapItem *item = [[MKMapItem alloc] initWithPlacemark:placemark];
        item.name = self.m_store.m_szAddress;
        [item openInMapsWithLaunchOptions:nil];
    } else if (buttonIndex==1) {
        //Google Maps
        //construct a URL using the comgooglemaps schema
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"comgooglemaps://?center=%f,%f",position.latitude,position.longitude]];
        if (![[UIApplication sharedApplication] canOpenURL:url]) {
            NSLog(@"Google Maps app is not installed");
            //left as an exercise for the reader: open the Google Maps mobile website instead!
            
            [BERGenericFunctionManager showAlertWithMessage:@"Google Maps app is not installed."];
        } else {
            [[UIApplication sharedApplication] openURL:url];
        }
    }
}

@end
