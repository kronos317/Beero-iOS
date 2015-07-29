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

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *m_constraintSizeContainerBottomSpace;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *m_constraintTypeContainerBottomSpace;


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
//    self.m_viewSearchOptionSizeContainer.hidden = YES;
//    self.m_viewSearchOptionTypeContainer.hidden = YES;
    
    self.m_imgBottomSizeArrow.alpha = 1;
    self.m_imgBottomTypeArrow.alpha = 1;
    self.m_viewSearchOptionWrapper.alpha = 1;
    
    if (self.m_enumSearchOptionShow == BERENUM_SEARCHOPTION_SHOW_NONE){
    }
    else if (self.m_enumSearchOptionShow == BERENUM_SEARCHOPTION_SHOW_SIZE){
        self.m_viewSearchOptionWrapper.hidden = NO;
//        self.m_viewSearchOptionSizeContainer.hidden = NO;
        self.m_imgBottomSizeArrow.hidden = NO;
    }
    else if (self.m_enumSearchOptionShow == BERENUM_SEARCHOPTION_SHOW_TYPE){
        self.m_viewSearchOptionWrapper.hidden = NO;
//        self.m_viewSearchOptionTypeContainer.hidden = NO;
        self.m_imgBottomTypeArrow.hidden = NO;
    }
}

- (void) configureCell: (BERSearchResultBodyTVC *) cell AtIndex: (int) index{
    
}

- (void) animateSearchOptionToShow: (BERENUM_SEARCHOPTION_SHOW) enumOption{
    if (self.m_enumSearchOptionShow == enumOption) return;
    
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
            self.m_constraintSizeContainerBottomSpace.constant = 0;
            [self.m_viewSearchOptionWrapper layoutIfNeeded];
        }
        else if (enumOption == BERENUM_SEARCHOPTION_SHOW_TYPE){
            // [Size] to [Type]
            self.m_imgBottomSizeArrow.hidden = YES;
            self.m_imgBottomTypeArrow.hidden = NO;
            self.m_constraintTypeContainerBottomSpace.constant = 0;
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
            self.m_constraintSizeContainerBottomSpace.constant = 0;
            [self.m_viewSearchOptionWrapper layoutIfNeeded];
            
            self.m_constraintSizeContainerBottomSpace.constant = -fSizeContainerHeight;
            [UIView animateWithDuration:0.25f animations:^{
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
            self.m_constraintTypeContainerBottomSpace.constant = 0;
            [self.m_viewSearchOptionWrapper layoutIfNeeded];
            
            self.m_constraintTypeContainerBottomSpace.constant = -fTypeContainerHeight;
            [UIView animateWithDuration:0.25f animations:^{
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
        
        self.m_constraintSizeContainerBottomSpace.constant = 0;
        [UIView animateWithDuration:0.25f animations:^{
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
        
        self.m_constraintTypeContainerBottomSpace.constant = 0;
        [UIView animateWithDuration:0.25f animations:^{
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
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
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
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
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

    NSString *szSize = [[self.m_arrSearchOptionSize objectAtIndex:self.m_enumBeerSize] objectForKey:@"_TITLE"];
    self.m_lblBottomSize.text = szSize;
    
    [self animateSearchOptionToShow:BERENUM_SEARCHOPTION_SHOW_NONE];
}

- (IBAction)onBtnOptionTypeClick:(id)sender {
    UIButton *button = sender;
    int type = (int) button.tag;
    
    if (self.m_enumBeerType != type){
        [self doSearch];
    }

    self.m_enumBeerType = type;
    
    NSString *szType = [[self.m_arrSearchOptionType objectAtIndex:self.m_enumBeerType] objectForKey:@"_TITLE"];
    self.m_lblBottomType.text = szType;

    [self animateSearchOptionToShow:BERENUM_SEARCHOPTION_SHOW_NONE];
}

#pragma mark -Gesture Recognizer

- (void) onSearchOptionWrapperTap : (UITapGestureRecognizer *)sender{
    [self animateSearchOptionToShow:BERENUM_SEARCHOPTION_SHOW_NONE];
    if (sender.state == UIGestureRecognizerStateEnded) {
    }
}

@end
