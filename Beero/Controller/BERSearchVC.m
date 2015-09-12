//
//  BERSearchVC.m
//  Beero
//
//  Created by Chris Lin on 7/21/15.
//  Copyright (c) 2015 Beero. All rights reserved.
//

#import "BERSearchVC.h"
#import "BERSearchResultBodyTVC.h"
#import "BERSearchResultFooterTVC.h"
#import "Global.h"
#import "BERSearchManager.h"
#import "BERBrandManager.h"
#import "BERBrandDataModel.h"
#import "BERBrandSelectVC.h"
#import "BERGenericFunctionManager.h"

typedef enum _ENUM_SEARCHOPTION_SHOW{
    BERENUM_SEARCHOPTION_SHOW_NONE,
    BERENUM_SEARCHOPTION_SHOW_SIZE,
    BERENUM_SEARCHOPTION_SHOW_TYPE,
}BERENUM_SEARCHOPTION_SHOW;

@interface BERSearchVC () <UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UIView *m_viewHeader;
@property (weak, nonatomic) IBOutlet UIView *m_viewMainSearch;
@property (weak, nonatomic) IBOutlet UIView *m_viewMainSearchResult;
@property (weak, nonatomic) IBOutlet UIView *m_viewSearchOptionWrapper;
@property (weak, nonatomic) IBOutlet UIView *m_viewSearchOptionSizeContainer;
@property (weak, nonatomic) IBOutlet UIView *m_viewSearchOptionTypeContainer;
@property (weak, nonatomic) IBOutlet UITableView *m_tableview;

@property (weak, nonatomic) IBOutlet UIButton *m_btnHeaderMyBeers;
@property (weak, nonatomic) IBOutlet UIButton *m_btnHeaderAllBeers;

@property (weak, nonatomic) IBOutlet UILabel *m_lblBottomSize;
@property (weak, nonatomic) IBOutlet UILabel *m_lblBottomType;
@property (weak, nonatomic) IBOutlet UIImageView *m_imgBottomSizeArrow;
@property (weak, nonatomic) IBOutlet UIImageView *m_imgBottomTypeArrow;

@property (weak, nonatomic) IBOutlet UIImageView *m_imgSearchBeer;
@property (weak, nonatomic) IBOutlet UILabel *m_lblSearchStatus;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *m_constraintSizeContainerBottomSpace;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *m_constraintTypeContainerBottomSpace;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *m_constraintSearchResultViewTopSpace;

@property BERENUM_SEARCHOPTION_SHOW m_enumSearchOptionShow;
@property BERENUM_SEARCH_PACKAGESIZE m_enumBeerSize;
@property BERENUM_SEARCH_CONTAINERTYPE m_enumBeerType;

@property (strong, nonatomic) NSArray *m_arrSearchOptionSize;
@property (strong, nonatomic) NSArray *m_arrSearchOptionType;

@property BOOL m_isSearchCompleted;

@end

@implementation BERSearchVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.m_tableview.allowsMultipleSelectionDuringEditing = NO;
    
    UITapGestureRecognizer * grSearchOptionWrapperTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onSearchOptionWrapperTap:)];
    grSearchOptionWrapperTap.delegate = self;
    [self.m_viewSearchOptionWrapper addGestureRecognizer:grSearchOptionWrapperTap];
    
    self.m_enumSearchOptionShow = BERENUM_SEARCHOPTION_SHOW_NONE;
    self.m_enumBeerSize = BERENUM_SEARCH_PACKAGESIZE_CASES;
    self.m_enumBeerType = BERENUM_SEARCH_CONTAINERTYPE_ANY;
    
    self.m_arrSearchOptionSize = @[@{@"_TITLE": @"CASES"},
                                   @{@"_TITLE": @"SIX PACKS"},
                                   ];
    self.m_arrSearchOptionType = @[@{@"_TITLE": @"BOTTLES"},
                                   @{@"_TITLE": @"CANS"},
                                   @{@"_TITLE": @"BOTTLES/CANS"},
                                   ];
   
    self.m_isSearchCompleted = YES;
    [BERSearchManager sharedInstance].m_isAllBeers = NO;
    [self doSearch];
    
    self.view.backgroundColor = BERUICOLOR_THEMECOLOR_MAIN;
    self.m_viewHeader.backgroundColor = BERUICOLOR_THEMECOLOR_MAIN;
    
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.m_viewSearchOptionSizeContainer.backgroundColor = BERUICOLOR_ORANGE;
    self.m_viewSearchOptionTypeContainer.backgroundColor = BERUICOLOR_ORANGE;
}

#pragma mark -Biz Logic

- (void) refreshFields{
    NSString *szSize = [[self.m_arrSearchOptionSize objectAtIndex:self.m_enumBeerSize] objectForKey:@"_TITLE"];
    NSString *szType = [[self.m_arrSearchOptionType objectAtIndex:self.m_enumBeerType] objectForKey:@"_TITLE"];
    
    self.m_lblBottomSize.text = szSize;
    self.m_lblBottomType.text = szType;

    self.m_imgBottomSizeArrow.hidden = YES;
    self.m_imgBottomTypeArrow.hidden = YES;
    self.m_viewSearchOptionWrapper.hidden = YES;
    
    self.m_imgBottomSizeArrow.alpha = 1;
    self.m_imgBottomTypeArrow.alpha = 1;
    self.m_viewSearchOptionWrapper.alpha = 1;
    
    if (self.m_enumSearchOptionShow == BERENUM_SEARCHOPTION_SHOW_NONE){
    }
    else if (self.m_enumSearchOptionShow == BERENUM_SEARCHOPTION_SHOW_SIZE){
        self.m_viewSearchOptionWrapper.hidden = NO;
        self.m_imgBottomSizeArrow.hidden = NO;
    }
    else if (self.m_enumSearchOptionShow == BERENUM_SEARCHOPTION_SHOW_TYPE){
        self.m_viewSearchOptionWrapper.hidden = NO;
        self.m_imgBottomTypeArrow.hidden = NO;
    }
}

- (void) configureCell: (BERSearchResultBodyTVC *) cell AtIndex: (int) index{
    BERSearchDealDataModel *deal = [[BERSearchManager sharedInstance].m_arrResult objectAtIndex:index];
    cell.m_lblTitle.text = deal.m_szBrandName;
    if ([deal isDealFound] == YES){
        cell.m_lblPrice.text = [NSString stringWithFormat:@"$%.2f", deal.m_modelWinningDeal.m_fPrice];
        cell.m_lblSpec.text = [deal.m_modelWinningDeal getBeautifiedVolumeSpecification];
        cell.m_lblStore.text = deal.m_modelWinningDeal.m_modelStore.m_szName;
        cell.m_lblDistance.text = [NSString stringWithFormat:@"%@ mins away", [deal.m_modelWinningDeal getBeautifiedDriveDistance]];
        if (deal.m_modelWinningDeal.m_isExclusive == YES){
            cell.m_constraintBadgeWidth.constant = 33;
            cell.m_imgBadgeExclusive.hidden = NO;
        }
        else {
            cell.m_constraintBadgeWidth.constant = 0;
            cell.m_imgBadgeExclusive.hidden = YES;
        }
        [cell.m_imgBrand setImage:[UIImage imageNamed:[NSString stringWithFormat:@"brand-small-%d", deal.m_modelWinningDeal.m_indexImage]]];
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    }
    else {
        cell.m_lblPrice.text = @"";
        cell.m_lblSpec.text = @"No Deals Found";
        cell.m_lblStore.text = @"";
        cell.m_lblDistance.text = @"";
        cell.m_constraintBadgeWidth.constant = 0;
        if (self.m_enumBeerType == BERENUM_SEARCH_CONTAINERTYPE_CAN){
            [cell.m_imgBrand setImage:[UIImage imageNamed:@"brand-can-notfound"]];
        }
        else if (self.m_enumBeerType == BERENUM_SEARCH_CONTAINERTYPE_BOTTLE){
            [cell.m_imgBrand setImage:[UIImage imageNamed:@"brand-bottle-notfound"]];
        }
        else if (self.m_enumBeerType == BERENUM_SEARCH_CONTAINERTYPE_ANY){
            [cell.m_imgBrand setImage:[UIImage imageNamed:@"brand-bottlecan-notfound"]];
        }
        
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
}

- (void) animateSearchOptionToShow: (BERENUM_SEARCHOPTION_SHOW) enumOption{
    if (self.m_enumSearchOptionShow == enumOption) return;
    
    // Check if the layer is in animation...
    
    NSArray *arrAnimKeysSize = [self.m_viewSearchOptionSizeContainer.layer animationKeys];
    NSArray *arrAnimKeysType = [self.m_viewSearchOptionTypeContainer.layer animationKeys];
    
    if ([arrAnimKeysType isKindOfClass:[NSArray class]] == YES || [arrAnimKeysSize isKindOfClass:[NSArray class]] == YES){
        if ([arrAnimKeysSize count] > 0 || [arrAnimKeysType count] > 0) {
            return;
        }        
    }
    
    float fSizeContainerHeight = self.m_viewSearchOptionSizeContainer.frame.size.height;
    float fTypeContainerHeight = self.m_viewSearchOptionTypeContainer.frame.size.height;
    
    self.m_viewSearchOptionWrapper.hidden = NO;
    
    self.m_constraintSizeContainerBottomSpace.constant = -fSizeContainerHeight;
    self.m_constraintTypeContainerBottomSpace.constant = -fTypeContainerHeight;
    [self.m_viewSearchOptionWrapper layoutIfNeeded];
    
    if (self.m_enumSearchOptionShow != BERENUM_SEARCHOPTION_SHOW_NONE && enumOption != BERENUM_SEARCHOPTION_SHOW_NONE){
        // Change from [Size] to [Type] or vise versa without close the wrapper and no animation
        if (enumOption == BERENUM_SEARCHOPTION_SHOW_SIZE){
            // [Type] to [Size]
            self.m_imgBottomSizeArrow.hidden = NO;
            self.m_imgBottomTypeArrow.hidden = YES;
            self.m_constraintSizeContainerBottomSpace.constant = -50;
            [self.m_viewSearchOptionWrapper layoutIfNeeded];
        }
        else if (enumOption == BERENUM_SEARCHOPTION_SHOW_TYPE){
            // [Size] to [Type]
            self.m_imgBottomSizeArrow.hidden = YES;
            self.m_imgBottomTypeArrow.hidden = NO;
            self.m_constraintTypeContainerBottomSpace.constant = -50;
            [self.m_viewSearchOptionWrapper layoutIfNeeded];
        }
        self.m_enumSearchOptionShow = enumOption;
        return;
    }
    
    // Animation starts... Arrow to fade in/out, Panel to Slide up
    
    if (enumOption == BERENUM_SEARCHOPTION_SHOW_NONE){
        // Hide
        
        if (self.m_enumSearchOptionShow == BERENUM_SEARCHOPTION_SHOW_SIZE){
            // [Size] to Hide
            self.m_imgBottomSizeArrow.hidden = NO;
            self.m_imgBottomSizeArrow.alpha = 1;
            self.m_constraintSizeContainerBottomSpace.constant = -50;
            [self.m_viewSearchOptionWrapper layoutIfNeeded];
            
            self.m_constraintSizeContainerBottomSpace.constant = -fSizeContainerHeight - 50;
            
            [UIView animateWithDuration:0.5
                                  delay:0
                 usingSpringWithDamping:0.6
                  initialSpringVelocity:0.6
                                options:0
                             animations:^{
                                 self.m_imgBottomSizeArrow.alpha = 0;
                                 [self.m_viewSearchOptionWrapper layoutIfNeeded];
                             } completion:^(BOOL finished) {
                                 self.m_enumSearchOptionShow = enumOption;
                                 [self refreshFields];
                             }];
        }

        if (self.m_enumSearchOptionShow == BERENUM_SEARCHOPTION_SHOW_TYPE){
            // [Type] to Hide
            self.m_imgBottomTypeArrow.hidden = NO;
            self.m_imgBottomTypeArrow.alpha = 1;
            self.m_constraintTypeContainerBottomSpace.constant = -50;
            [self.m_viewSearchOptionWrapper layoutIfNeeded];
            
            self.m_constraintTypeContainerBottomSpace.constant = -fTypeContainerHeight - 50;

            [UIView animateWithDuration:0.5
                                  delay:0
                 usingSpringWithDamping:0.6
                  initialSpringVelocity:0.6
                                options:0
                             animations:^{
                                 self.m_imgBottomTypeArrow.alpha = 0;
                                 [self.m_viewSearchOptionWrapper layoutIfNeeded];
                             } completion:^(BOOL finished) {
                                 self.m_enumSearchOptionShow = enumOption;
                                 [self refreshFields];
                             }];
        }
    }
    else if (enumOption == BERENUM_SEARCHOPTION_SHOW_SIZE){
        // [Size] to show

        self.m_imgBottomSizeArrow.hidden = NO;
        self.m_imgBottomSizeArrow.alpha = 0;
        self.m_constraintSizeContainerBottomSpace.constant = -fSizeContainerHeight;
        [self.m_viewSearchOptionWrapper layoutIfNeeded];
        
        self.m_constraintSizeContainerBottomSpace.constant = -50;
        
        [UIView animateWithDuration:0.5
                              delay:0
             usingSpringWithDamping:0.6
              initialSpringVelocity:0.6
                            options:0
                         animations:^{
                             self.m_imgBottomSizeArrow.alpha = 1;
                             [self.m_viewSearchOptionWrapper layoutIfNeeded];
                         } completion:^(BOOL finished) {
                             self.m_enumSearchOptionShow = enumOption;
                             [self refreshFields];
                         }];
    }
    else if (enumOption == BERENUM_SEARCHOPTION_SHOW_TYPE){
        // [Type] to show
        
        self.m_imgBottomTypeArrow.hidden = NO;
        self.m_imgBottomTypeArrow.alpha = 0;
        self.m_constraintTypeContainerBottomSpace.constant = -fTypeContainerHeight;
        [self.m_viewSearchOptionWrapper layoutIfNeeded];
        
        self.m_constraintTypeContainerBottomSpace.constant = -50;
        
        [UIView animateWithDuration:0.5
                              delay:0
             usingSpringWithDamping:0.6
              initialSpringVelocity:0.6
                            options:0
                         animations:^{
                             self.m_imgBottomTypeArrow.alpha = 1;
                             [self.m_viewSearchOptionWrapper layoutIfNeeded];
                         } completion:^(BOOL finished) {
                             self.m_enumSearchOptionShow = enumOption;
                             [self refreshFields];
                         }];
    }
}

- (void) spinBeerWithOptions: (UIViewAnimationOptions) options {
    // this spin completes 360 degrees every 1 seconds
    
    [UIView animateWithDuration: 0.5f
                          delay: 0.0f
                        options: options
                     animations: ^{
                         self.m_imgSearchBeer.transform = CGAffineTransformRotate(self.m_imgSearchBeer.transform, M_PI / 2);
//                         [self.m_imgSearchBeer layoutIfNeeded];
                     }
                     completion: ^(BOOL finished) {
                         if (!self.m_isSearchCompleted) {
                             // if flag still set, keep spinning with constant speed
                             [self spinBeerWithOptions: UIViewAnimationOptionCurveLinear];
                         }
                     }];
}

- (void) startSpin {
    [self.m_imgSearchBeer.layer removeAllAnimations];
    self.m_imgSearchBeer.transform = CGAffineTransformMakeRotation(0);
    [self spinBeerWithOptions: UIViewAnimationOptionCurveEaseIn];
}

- (void) doSearch{
    self.m_lblSearchStatus.text = @"Finding Beer...";
    self.m_viewMainSearch.hidden = NO;
    self.m_viewMainSearchResult.hidden = YES;
    
    if (self.m_isSearchCompleted == YES){
        [self startSpin];
    }
    if (self.m_viewMainSearchResult.hidden == NO){
        [self animateSearchResultViewToHide];
    }

    self.m_isSearchCompleted = NO;
    
    BERSearchManager *managerSearch = [BERSearchManager sharedInstance];
    managerSearch.m_enumContainerType = self.m_enumBeerType;
    managerSearch.m_enumPackageSize = self.m_enumBeerSize;
    
    NSDate *dtStart = [NSDate date];
    [managerSearch requestSearchDealWithCallback:^(int status) {
        // Should wait at least 2 second...
        
        NSString *szToken = managerSearch.m_szRequestToken;
        NSDate *dtEnd = [NSDate date];
        NSTimeInterval elapsed = [dtEnd timeIntervalSinceDate:dtStart];
        NSTimeInterval waiting = (elapsed > 2) ? 0 : (2 - elapsed);
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(waiting * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if ([szToken isEqualToString:managerSearch.m_szRequestToken] == NO){
                // If another search request has made before 2 second waiting is finished...
                return;
            }
            
            if (status == ERROR_SEARCH_DEAL_CANCELLED) return;
            if (status == ERROR_NONE){
                self.m_isSearchCompleted = YES;
                [self.m_imgSearchBeer.layer removeAllAnimations];
                self.m_imgSearchBeer.transform = CGAffineTransformMakeRotation(0);
                self.m_lblSearchStatus.text = @"";
                [self.m_tableview reloadData];
                
                [self animateSearchResultViewToShow];
            }
            else if (status == ERROR_SEARCH_DEAL_FAILED || status == ERROR_SEARCH_DEAL_NOTFOUND){
                self.m_isSearchCompleted = YES;
                [self.m_imgSearchBeer.layer removeAllAnimations];
                self.m_imgSearchBeer.transform = CGAffineTransformMakeRotation(0);
                self.m_lblSearchStatus.text = @"No deal found!";
            }
        });
    }];
}

- (void) animateSearchResultViewToShow{
    self.m_viewMainSearchResult.hidden = NO;
    [self.m_viewMainSearchResult.layer removeAllAnimations];
    
    float height = self.m_viewMainSearchResult.frame.size.height;
    self.m_constraintSearchResultViewTopSpace.constant = -height;
    [self.m_viewMainSearchResult layoutIfNeeded];
    self.m_constraintSearchResultViewTopSpace.constant = 0;
    
    [UIView animateWithDuration:0.8
                          delay:0
         usingSpringWithDamping:0.6
          initialSpringVelocity:0.6
                        options:0
                     animations:^{
                         [self.m_viewMainSearchResult layoutIfNeeded];
                     } completion:^(BOOL finished) {
                         
                     }];
}

- (void) animateSearchResultViewToHide{
    self.m_viewMainSearchResult.hidden = NO;
    [self.m_viewMainSearchResult.layer removeAllAnimations];
    
    float height = self.m_viewMainSearchResult.frame.size.height;
    self.m_constraintSearchResultViewTopSpace.constant = 0;
    [self.m_viewMainSearchResult layoutIfNeeded];
    self.m_constraintSearchResultViewTopSpace.constant = -height;
    
    [UIView animateWithDuration:0.8
                          delay:0
         usingSpringWithDamping:0.6
          initialSpringVelocity:0.6
                        options:0
                     animations:^{
                         [self.m_viewMainSearchResult layoutIfNeeded];
                     } completion:^(BOOL finished) {
                         self.m_viewMainSearchResult.hidden = YES;
                     }];
}

- (void) gotoDealDetailsAtIndex: (int) index{
    [BERSearchManager sharedInstance].m_indexSelectedToViewDetails = index;
    [self performSegueWithIdentifier:@"SEGUE_FROM_SEARCH_TO_DEAL_DETAILS" sender:nil];
}

- (void) removeBrandAtIndex: (int) index{
    BERSearchDealDataModel *deal = [[BERSearchManager sharedInstance].m_arrResult objectAtIndex:index];
    BERBrandManager *managerBrand = [BERBrandManager sharedInstance];
    
    for (int i = 0; i < (int) [managerBrand.m_arrBrand count]; i++){
        BERBrandDataModel *brand = [managerBrand.m_arrBrand objectAtIndex:i];
        if (brand.m_index == deal.m_index){
            brand.m_isSelected = NO;
            break;
        }
    }
    
    [self doSearch];
}

- (void) gotoBrandSelect{
    NSMutableArray *arrVCs = [[NSMutableArray alloc] initWithArray: self.navigationController.viewControllers];
    for (int i = 0; i < (int) [arrVCs count]; i++){
        UIViewController *vc = [arrVCs objectAtIndex:i];
        if ([vc isKindOfClass:[BERBrandSelectVC class]] == YES){
            [self.navigationController popViewControllerAnimated:YES];
            return;
        }
    }
    
    // No "BrandSelect VC" is detected in navigation stack. This is the case when we come to this search screen directly from Loading splash screen.
    UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"STORYBOARD_BRANDS"];
    [arrVCs insertObject:vc atIndex:[arrVCs count] - 1];
    self.navigationController.viewControllers = arrVCs;
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -UITableView Event Listeners

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[BERSearchManager sharedInstance].m_arrResult count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *szCellIdentifier = @"TVC_SEARCH_RESULT_BODY";
    BERSearchResultBodyTVC *cell = [tableView dequeueReusableCellWithIdentifier:szCellIdentifier];
    [self configureCell:cell AtIndex:(int) indexPath.row];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    static NSString *szCellIdentifier = @"TVC_SEARCH_RESULT_FOOTER";
    BERSearchResultFooterTVC *cell = [tableView dequeueReusableCellWithIdentifier:szCellIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.contentView.backgroundColor = BERUICOLOR_THEMECOLOR_MAIN;
    
    [BERGenericFunctionManager drawDropShadowToView:cell.m_viewContentView Size:5];
    return cell.contentView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 65.0f;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return ![BERSearchManager sharedInstance].m_isAllBeers;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete){
        [self removeBrandAtIndex:(int) indexPath.row];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    BERSearchDealDataModel *deal = [[BERSearchManager sharedInstance].m_arrResult objectAtIndex:indexPath.row];
    if ([deal isDealFound] == YES){
        [self gotoDealDetailsAtIndex:(int) indexPath.row];
        [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];        
    }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Remove seperator inset
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    // Prevent the cell from inheriting the Table View's margin settings
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    
    // Explictly set your cell's layout margins
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

#pragma mark -Button Event Listeners

- (IBAction)onBtnHeaderMyBeersClick:(id)sender {
    [BERSearchManager sharedInstance].m_isAllBeers = NO;
    [self doSearch];
    
    [self.m_btnHeaderMyBeers setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.m_btnHeaderAllBeers setTitleColor:BERUICOLOR_SEARCHBUTTON_NOTSELECTED forState:UIControlStateNormal];
}

- (IBAction)onBtnHeaderAllBeersClick:(id)sender {
    [BERSearchManager sharedInstance].m_isAllBeers = YES;
    [self doSearch];

    [self.m_btnHeaderAllBeers setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.m_btnHeaderMyBeers setTitleColor:BERUICOLOR_SEARCHBUTTON_NOTSELECTED forState:UIControlStateNormal];
}

- (IBAction)onBtnBottomSizeClick:(id)sender {
    if (self.m_viewSearchOptionWrapper.hidden == YES || self.m_enumSearchOptionShow != BERENUM_SEARCHOPTION_SHOW_SIZE){
        [self animateSearchOptionToShow:BERENUM_SEARCHOPTION_SHOW_SIZE];
    }
    else {
        [self animateSearchOptionToShow:BERENUM_SEARCHOPTION_SHOW_NONE];
    }
}

- (IBAction)onBtnBottomTypeClick:(id)sender {
    if (self.m_viewSearchOptionWrapper.hidden == YES || self.m_enumSearchOptionShow != BERENUM_SEARCHOPTION_SHOW_TYPE){
        [self animateSearchOptionToShow:BERENUM_SEARCHOPTION_SHOW_TYPE];
    }
    else {
        [self animateSearchOptionToShow:BERENUM_SEARCHOPTION_SHOW_NONE];
    }
}

- (IBAction)onBtnOptionSizeClick:(id)sender {
    UIButton *button = sender;
    int size = (int) button.tag;
//    BERENUM_SEARCH_PACKAGESIZE oldSize = self.m_enumBeerSize;
    self.m_enumBeerSize = size;
    
//    if (oldSize != size){
    // Do search again even if we select the previously selected option
        [self doSearch];
//    }

    NSString *szSize = [[self.m_arrSearchOptionSize objectAtIndex:self.m_enumBeerSize] objectForKey:@"_TITLE"];
    self.m_lblBottomSize.text = szSize;
    
    [self animateSearchOptionToShow:BERENUM_SEARCHOPTION_SHOW_NONE];
}

- (IBAction)onBtnOptionTypeClick:(id)sender {
    UIButton *button = sender;
    int type = (int) button.tag;
//    BERENUM_SEARCH_CONTAINERTYPE oldType = self.m_enumBeerType;
    self.m_enumBeerType = type;
    
//    if (oldType != type){
        [self doSearch];
//    }    
    
    NSString *szType = [[self.m_arrSearchOptionType objectAtIndex:self.m_enumBeerType] objectForKey:@"_TITLE"];
    self.m_lblBottomType.text = szType;

    [self animateSearchOptionToShow:BERENUM_SEARCHOPTION_SHOW_NONE];
}

- (IBAction)onBtnRefreshClick:(id)sender {
    [self doSearch];
}

- (IBAction)onBtnAddBeerClick:(id)sender {
    [self gotoBrandSelect];
}

#pragma mark -Gesture Recognizer

- (void) onSearchOptionWrapperTap : (UITapGestureRecognizer *)sender{
    [self animateSearchOptionToShow:BERENUM_SEARCHOPTION_SHOW_NONE];
    if (sender.state == UIGestureRecognizerStateEnded) {
    }
}

@end
