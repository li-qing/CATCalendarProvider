//
//  InfiniteMonthbyYearTableViewController.m
//  Demo
//
//  Created by wit on 2/16/15.
//  Copyright (c) 2015 cat. All rights reserved.
//

#import "InfiniteMonthByYearTableViewController.h"
#import "CATCalendarProvider.h"
#import "NSCalendar+CATKit.h"

@interface InfiniteMonthByYearTableViewController ()
@property (strong, nonatomic) CATCalendarProvider *provider;
@property (strong, nonatomic) NSDateFormatter *sectionFormatter;
@property (strong, nonatomic) NSDateFormatter *cellFormatter;
@end

@implementation InfiniteMonthByYearTableViewController

#define kPreload 50

- (void)awakeFromNib {
    [super awakeFromNib];
    self.provider = [CATCalendarProvider monthByYearProvider];
    self.sectionFormatter = [[NSDateFormatter alloc] init];
    _sectionFormatter.dateFormat = @"G-yyyy";
    self.cellFormatter = [[NSDateFormatter alloc] init];
    _cellFormatter.dateFormat = @"yyyy-MM";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self rebase];
}

#pragma mark modify
- (void)rebase {
    [self.tableView layoutIfNeeded];
    
    NSIndexPath *indexPath = [[self.tableView indexPathsForVisibleRows] firstObject];
    const CGPoint origin = [self.tableView rectForSection:indexPath.section].origin;
    const CGPoint delta = CGPointMake(origin.x - self.tableView.contentOffset.x, origin.y - self.tableView.contentOffset.y);
    
    NSDate *date = [_provider dateAtIndexPath:indexPath];
    _provider.baseline = [_provider.calendar cat_dateByAddingUnit:NSCalendarUnitYear value:-kPreload toDate:date options:kNilOptions];
    [self.tableView reloadData];
    
    NSIndexPath *newIndexPath = [_provider indexPathForDate:date];
    const CGPoint newOrigin = [self.tableView rectForSection:newIndexPath.section].origin;
    self.tableView.contentOffset = CGPointMake(newOrigin.x - delta.x, newOrigin.y - delta.y);
}

#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return kPreload * 2 + 1;
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

#pragma mark UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self rebase];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) [self rebase];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    [self rebase];
}

- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView {
    [self rebase];
}

@end
