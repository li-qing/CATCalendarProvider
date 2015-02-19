//
//  FiniteDayInMonthTableViewController.m
//  Demo
//
//  Created by wit on 2/16/15.
//  Copyright (c) 2015 cat. All rights reserved.
//

#import "FiniteDayByMonthTableViewController.h"
#import "CATCalendarProvider.h"
#import "NSCalendar+CATKit.h"

@interface FiniteDayByMonthTableViewController ()
@property (strong, nonatomic) CATCalendarProvider *provider;
@property (strong, nonatomic) NSDateFormatter *sectionFormatter;
@property (strong, nonatomic) NSDateFormatter *cellFormatter;
@end

@implementation FiniteDayByMonthTableViewController

- (void)awakeFromNib {
    [super awakeFromNib];
    self.provider = [CATCalendarProvider dayByMonthProvider];
    self.sectionFormatter = [[NSDateFormatter alloc] init];
    _sectionFormatter.dateFormat = @"yyyy-MMMM";
    self.cellFormatter = [[NSDateFormatter alloc] init];
    _cellFormatter.dateFormat = @"yyyy-MM-dd";
}

#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 20;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_provider numberOfItemsInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.textLabel.text = [_cellFormatter stringFromDate:[_provider dateAtIndexPath:indexPath]];
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [_sectionFormatter stringFromDate:[_provider dateOfFirstDayInSection:section]];
}
@end
