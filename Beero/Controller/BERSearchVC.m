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

@interface BERSearchVC () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *m_tableview;

@end

@implementation BERSearchVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -Biz Logic

- (void) configureCell: (BERSearchResultBodyTVC *) cell AtIndex: (int) index{
    
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

#pragma mark -Button Event Listeners



@end
