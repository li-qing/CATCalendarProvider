//
//  FiniteYearTableViewController.m
//  Demo
//
//  Created by wit on 2/16/15.
//  Copyright (c) 2015 cat. All rights reserved.
//

#import "FiniteYearTableViewController.h"
#import "CATCalendarProvider.h"

@interface FiniteYearTableViewController ()
@property (strong, nonatomic) CATCalendarProvider *provider;
@property (strong, nonatomic) NSDateFormatter *cellFormatter;
@end

@implementation FiniteYearTableViewController

- (void)awakeFromNib {
    [super awakeFromNib];
    self.provider = [CATCalendarProvider yearByYearProvider];
    self.cellFormatter = [[NSDateFormatter alloc] init];
    _cellFormatter.dateFormat = @"yyyy";
}

#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 200;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_provider numberOfItemsInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.textLabel.text = [_cellFormatter stringFromDate:[_provider dateAtIndexPath:indexPath]];
    return cell;
}

@end
