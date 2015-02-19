//
//  InfiniteMonthByYearFlowViewController.m
//  Demo
//
//  Created by wit on 2/16/15.
//  Copyright (c) 2015 cat. All rights reserved.
//

#import "InfiniteMonthByYearFlowViewController.h"
#import "CATCalendarProvider.h"
#import "NSCalendar+CATKit.h"
#import "DateCollectionViewCell.h"
#import "HeaderCollectionReusableView.h"

@interface InfiniteMonthByYearFlowViewController ()
@property (strong, nonatomic) CATCalendarProvider *provider;
@property (strong, nonatomic) NSDateFormatter *sectionFormatter;
@property (strong, nonatomic) NSDateFormatter *cellFormatter;
@end

@implementation InfiniteMonthByYearFlowViewController

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
    [self.collectionView layoutIfNeeded];
    
    NSIndexPath *indexPath = [[self.collectionView indexPathsForVisibleItems] firstObject];
    const CGPoint origin = [self.collectionView layoutAttributesForItemAtIndexPath:indexPath].frame.origin;
    const CGPoint delta = CGPointMake(origin.x - self.collectionView.contentOffset.x, origin.y - self.collectionView.contentOffset.y);
    
    NSDate *date = [_provider dateAtIndexPath:indexPath];
    _provider.baseline = [_provider.calendar cat_dateByAddingUnit:NSCalendarUnitYear value:-kPreload toDate:date options:kNilOptions];
    [self.collectionView reloadData];
    
    NSIndexPath *newIndexPath = [_provider indexPathForDate:date];
    const CGPoint newOrigin = [self.collectionView layoutAttributesForItemAtIndexPath:newIndexPath].frame.origin;
    self.collectionView.contentOffset = CGPointMake(newOrigin.x - delta.x, newOrigin.y - delta.y);
}

#pragma mark UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return kPreload * 2 + 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [_provider numberOfItemsInSection:section];
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    DateCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    NSDate *date = [_provider dateAtIndexPath:indexPath];
    cell.titleLabel.text = [_cellFormatter stringFromDate:date];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath {
    if (![kind isEqualToString:UICollectionElementKindSectionHeader]) return nil;
    
    HeaderCollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                                            withReuseIdentifier:@"Header"
                                                                                   forIndexPath:indexPath];
    view.titleLabel.text = [_sectionFormatter stringFromDate:[_provider dateAtIndexPath:indexPath]];
    return view;
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
