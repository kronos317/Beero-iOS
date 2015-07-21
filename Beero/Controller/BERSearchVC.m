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

typedef enum _ENUM_BEER_SIZE{
    BERENUM_BEER_SIZE_CASES = 0,
    BERENUM_BEER_SIZE_SIXPACK = 1,
}BERENUM_BEER_SIZE;

typedef enum _ENUM_BEER_TYPE{
    BERENUM_BEER_TYPE_BOTTLE = 0,
    BERENUM_BEER_TYPE_CAN = 1,
    BERENUM_BEER_TYPE_CANBOTTLE = 2,
}BERENUM_BEER_TYPE;

typedef enum _ENUM_SEARCHOPTION_SHOW{
    BERENUM_SEARCHOPTION_SHOW_NONE,
    BERENUM_SEARCHOPTION_SHOW_SIZE,
    BERENUM_SEARCHOPTION_SHOW_TYPE,
}BERENUM_SEARCHOPTION_SHOW;

@interface BERSearchVC () <UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate>

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

@property BERENUM_SEARCHOPTION_SHOW m_enumSearchOptionShow;
@property BERENUM_BEER_SIZE m_enumBeerSize;
@property BERENUM_BEER_TYPE m_enumBeerType;

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
    self.m_enumBeerSize = BERENUM_BEER_SIZE_CASES;
    self.m_enumBeerType = BERENUM_BEER_TYPE_CANBOTTLE;
    
    self.m_arrSearchOptionSize = @[@{@"_TITLE": @"CASES"},
                                   @{@"_TITLE": @"SIX PACKS"},
                                   ];
    self.m_arrSearchOptionType = @[@{@"_TITLE": @"BOTTLES"},
                                   @{@"_TITLE": @"CANS"},
                                   @{@"_TITLE": @"BOTTLES/CANS"},
                                   ];
    
    self.m_isSearchCompleted = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    self.m_viewSearchOptionSizeContainer.hidden = YES;
    self.m_viewSearchOptionTypeContainer.hidden = YES;
    
    self.m_imgBottomSizeArrow.alpha = 1;
    self.m_imgBottomTypeArrow.alpha = 1;
    self.m_viewSearchOptionWrapper.alpha = 1;
    
    if (self.m_enumSearchOptionShow == BERENUM_SEARCHOPTION_SHOW_NONE){
    }
    else if (self.m_enumSearchOptionShow == BERENUM_SEARCHOPTION_SHOW_SIZE){
        self.m_viewSearchOptionWrapper.hidden = NO;
        self.m_viewSearchOptionSizeContainer.hidden = NO;
        self.m_imgBottomSizeArrow.hidden = NO;
    }
    else if (self.m_enumSearchOptionShow == BERENUM_SEARCHOPTION_SHOW_TYPE){
        self.m_viewSearchOptionWrapper.hidden = NO;
        self.m_viewSearchOptionTypeContainer.hidden = NO;
        self.m_imgBottomTypeArrow.hidden = NO;
    }
}

- (void) configureCell: (BERSearchResultBodyTVC *) cell AtIndex: (int) index{
    
}

- (void) animateSearchOptionToShow: (BERENUM_SEARCHOPTION_SHOW) enumOption{
    if (self.m_enumSearchOptionShow == enumOption) return;
    
    float fFrom = 0, fTo = 1;
    UIImageView *img = self.m_imgBottomSizeArrow;
    
    if (enumOption == BERENUM_SEARCHOPTION_SHOW_NONE){
        fFrom = 1;
        fTo = 0;
        if (self.m_enumSearchOptionShow == BERENUM_SEARCHOPTION_SHOW_TYPE){
            img = self.m_imgBottomTypeArrow;
        }
    }
    else if (enumOption == BERENUM_SEARCHOPTION_SHOW_SIZE){
        self.m_viewSearchOptionSizeContainer.hidden = NO;
        self.m_viewSearchOptionTypeContainer.hidden = YES;
    }
    else if (enumOption == BERENUM_SEARCHOPTION_SHOW_TYPE){
        self.m_viewSearchOptionSizeContainer.hidden = YES;
        self.m_viewSearchOptionTypeContainer.hidden = NO;
        img = self.m_imgBottomTypeArrow;
    }
    
    [self.m_viewSearchOptionWrapper.layer removeAllAnimations];
    
    self.m_viewSearchOptionWrapper.hidden = NO;
    img.hidden = NO;
    self.m_viewSearchOptionWrapper.alpha = fFrom;
    img.alpha = fFrom;
    
    self.m_enumSearchOptionShow = enumOption;
    
    [UIView animateWithDuration:0.5f animations:^{
        self.m_viewSearchOptionWrapper.alpha = fTo;
        img.alpha = fTo;
    } completion:^(BOOL finished) {
        [self refreshFields];
    }];
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
    self.m_viewMainSearchResult.hidden = YES;
    self.m_viewMainSearch.hidden = NO;
    self.m_isSearchCompleted = NO;
    
    [self startSpin];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.m_isSearchCompleted = YES;
        [self.m_imgSearchBeer.layer removeAllAnimations];
        self.m_viewMainSearchResult.hidden = NO;
        self.m_viewMainSearch.hidden = YES;
        
        self.m_viewMainSearchResult.alpha = 0;
        [UIView animateWithDuration:1.0f animations:^{
            self.m_viewMainSearchResult.alpha = 1;
        }];
    });
}

- (void) gotoDealDetailsAtIndex: (int) index{
    [self performSegueWithIdentifier:@"SEGUE_FROM_SEARCH_TO_DEAL_DETAILS" sender:nil];
}

#pragma mark -UITableView Event Listeners

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *szCellIdentifier = @"TVC_SEARCH_RESULT_BODY";
    BERSearchResultBodyTVC *cell = [tableView dequeueReusableCellWithIdentifier:szCellIdentifier];
    [self configureCell:cell AtIndex:(int) indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    static NSString *szCellIdentifier = @"TVC_SEARCH_RESULT_FOOTER";
    BERSearchResultFooterTVC *cell = [tableView dequeueReusableCellWithIdentifier:szCellIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell.contentView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 60.0f;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete){
        NSLog(@"Remove");
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self gotoDealDetailsAtIndex:(int) indexPath.row];
}

#pragma mark -Button Event Listeners

- (IBAction)onBtnHeaderMyBeersClick:(id)sender {
}

- (IBAction)onBtnHeaderAllBeersClick:(id)sender {
}

- (IBAction)onBtnBottomSizeClick:(id)sender {
    [self animateSearchOptionToShow:BERENUM_SEARCHOPTION_SHOW_SIZE];
}

- (IBAction)onBtnBottomTypeClick:(id)sender {
    [self animateSearchOptionToShow:BERENUM_SEARCHOPTION_SHOW_TYPE];
}

- (IBAction)onBtnOptionSizeClick:(id)sender {
    UIButton *button = sender;
    int size = (int) button.tag;
    
    if (self.m_enumBeerSize != size){
        [self doSearch];
    }

    self.m_enumBeerSize = size;
    [self animateSearchOptionToShow:BERENUM_SEARCHOPTION_SHOW_NONE];
}

- (IBAction)onBtnOptionTypeClick:(id)sender {
    UIButton *button = sender;
    int type = (int) button.tag;
    
    if (self.m_enumBeerType != type){
        [self doSearch];
    }

    self.m_enumBeerType = type;
    [self animateSearchOptionToShow:BERENUM_SEARCHOPTION_SHOW_NONE];
}

#pragma mark -Gesture Recognizer

- (void) onSearchOptionWrapperTap : (UITapGestureRecognizer *)sender{
    [self animateSearchOptionToShow:BERENUM_SEARCHOPTION_SHOW_NONE];
    if (sender.state == UIGestureRecognizerStateEnded) {
    }
}

@end
