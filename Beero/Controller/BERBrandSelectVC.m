//
//  BERBrandSelectVC.m
//  Beero
//
//  Created by Chris Lin on 7/21/15.
//  Copyright (c) 2015 Beero. All rights reserved.
//

#import "BERBrandSelectVC.h"
#import "BERBrandTVC.h"
#import "BERBrandManager.h"
#import "BERBrandDataModel.h"
#import "BERGenericFunctionManager.h"

@interface BERBrandSelectVC () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *m_tableview;
@property (strong, nonatomic) NSMutableArray *m_arrSelected;

@end

@implementation BERBrandSelectVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.m_tableview.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self refreshFields];
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

- (void) refreshFields{
    self.m_arrSelected = [[NSMutableArray alloc] init];
    BERBrandManager *managerBrand = [BERBrandManager sharedInstance];
    for (int i = 0; i < (int) [managerBrand.m_arrBrand count]; i++) {
        BERBrandDataModel *brand = [managerBrand.m_arrBrand objectAtIndex:i];
        [self.m_arrSelected addObject:[NSNumber numberWithBool:brand.m_isSelected]];
    }
}

- (void) configureCell:(BERBrandTVC *) cell AtIndex:(int) index{
    BERBrandManager *managerBrand = [BERBrandManager sharedInstance];
    BERBrandDataModel *brand = [managerBrand.m_arrBrand objectAtIndex:index];
    
    if ([[self.m_arrSelected objectAtIndex:index] boolValue] == YES){
        [cell.m_imgCheck setImage:[UIImage imageNamed:@"checkbox-selected"]];
    }
    else {
        [cell.m_imgCheck setImage:[UIImage imageNamed:@"checkbox-unselected"]];
    }
    cell.m_lblTitle.text = brand.m_szName;
    cell.m_btnWrapper.tag = index;
}

- (void) gotoSearch{
    int count = 0;
    for (int i = 0; i < (int) [self.m_arrSelected count]; i++){
        if ([[self.m_arrSelected objectAtIndex:i] boolValue] == YES) count++;
    }
    
    if (count < 1){
        [BERGenericFunctionManager showAlertWithMessage:@"Please select at least one brand!"];
        return;
    }
    
    for (int i = 0; i < (int) [self.m_arrSelected count]; i++){
        BERBrandDataModel *brand = [[BERBrandManager sharedInstance].m_arrBrand objectAtIndex:i];
        brand.m_isSelected = [[self.m_arrSelected objectAtIndex:i] boolValue];
    }
    
    [self performSegueWithIdentifier:@"SEGUE_FROM_BRAND_TO_SEARCH" sender:nil];
}

#pragma mark -Tableview Event Listeners

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[BERBrandManager sharedInstance].m_arrBrand count];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *szIdentifier = @"TVC_BRAND";
    BERBrandTVC *cell = [tableView dequeueReusableCellWithIdentifier:szIdentifier];
    
    [self configureCell:cell AtIndex:(int) indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (IBAction)onBtnWrapperClick:(id)sender {
    UIButton *button = sender;
    int index = (int) button.tag;
    BOOL isSelected = [[self.m_arrSelected objectAtIndex:index] boolValue];
    isSelected = !isSelected;
    [self.m_arrSelected replaceObjectAtIndex:index withObject:[NSNumber numberWithBool:isSelected]];
    
    [self.m_tableview reloadData];
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

- (IBAction)onBtnDoneClick:(id)sender {
    [self gotoSearch];
}


@end
