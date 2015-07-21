//
//  BERBrandSelectVC.m
//  Beero
//
//  Created by Chris Lin on 7/21/15.
//  Copyright (c) 2015 Beero. All rights reserved.
//

#import "BERBrandSelectVC.h"
#import "BERBrandTVC.h"

@interface BERBrandSelectVC () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *m_tableview;

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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void) configureCell:(BERBrandTVC *) cell AtIndex:(int) index{
    cell.m_btnCheck.tag = index;
}

#pragma mark -Tableview Event Listeners

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *szIdentifier = @"TVC_BRAND";
    BERBrandTVC *cell = [tableView dequeueReusableCellWithIdentifier:szIdentifier];
    
    [self configureCell:cell AtIndex:(int) indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (IBAction)onBtnCheckClick:(id)sender {
    
}

#pragma mark -Button Event Listeners

- (IBAction)onBtnDoneClick:(id)sender {
    [self performSegueWithIdentifier:@"SEGUE_FROM_BRAND_TO_SEARCH" sender:nil];
}


@end
