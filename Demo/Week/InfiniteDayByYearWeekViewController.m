//
//  InfiniteDayByYearWeekViewController.m
//  Demo
//
//  Created by wit on 2/17/15.
//  Copyright (c) 2015 cat. All rights reserved.
//

#import "InfiniteDayByYearWeekViewController.h"
#import "CATCollectionViewWeekLayout.h"
#import "CATCalendarProvider.h"
#import "NSCalendar+CATKit.h"
#import "DateCollectionViewCell.h"
#import "TitleCollectionReusableView.h"

@interface InfiniteDayByYearWeekViewController ()
@property (weak, nonatomic) IBOutlet CATCollectionViewWeekLayout *layout;
@property (strong, nonatomic) CATCalendarProvider *provider;
@property (strong, nonatomic) NSDateFormatter *sectionFormatter;
@property (strong, nonatomic) NSDateFormatter *titleFormatter;
@property (strong, nonatomic) NSDateFormatter *subtitleFormatter;
@end

@implementation InfiniteDayByYearWeekViewController

#define kPreload 5

- (void)awakeFromNib {
    [super awakeFromNib];
    self.provider = [CATCalendarProvider dayByYearFillingWeeksProvider];
    self.sectionFormatter = [[NSDateFormatter alloc] init];
    _sectionFormatter.dateFormat = @"yyyy";
    self.titleFormatter = [[NSDateFormatter alloc] init];
    _titleFormatter.dateFormat = @"MMM";
    self.subtitleFormatter = [[NSDateFormatter alloc] init];
    _subtitleFormatter.dateFormat = @"D";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _layout.provider = _provider;
    
    _layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    _layout.sectionInsets = UIEdgeInsetsMake(2.5, 2.5, 2.5, 2.5);
    _layout.itemInsets = UIEdgeInsetsMake(2.5, 2.5, 2.5, 2.5);
    _layout.indicatorHeight = 30;
    _layout.headerHeight = 30;
    _layout.footerHeight = 30;
    _layout.itemSize = CGSizeMake(40, 50);
    
    [self.collectionView registerClass:TitleCollectionReusableView.class
            forSupplementaryViewOfKind:CATCollectionElementKindWeekdayIndicator
                   withReuseIdentifier:CATCollectionElementKindWeekdayIndicator];
    [self.collectionView registerClass:TitleCollectionReusableView.class
            forSupplementaryViewOfKind:CATCollectionElementKindSectionHeader
                   withReuseIdentifier:CATCollectionElementKindSectionHeader];
    [self.collectionView registerClass:TitleCollectionReusableView.class
            forSupplementaryViewOfKind:CATCollectionElementKindSectionFooter
                   withReuseIdentifier:CATCollectionElementKindSectionFooter];
    
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
    cell.titleLabel.text = [_titleFormatter stringFromDate:date];
    cell.subtitleLabel.text = [_subtitleFormatter stringFromDate:date];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath {
    TitleCollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                                           withReuseIdentifier:kind
                                                                                  forIndexPath:indexPath];
    
    if ([kind isEqualToString:CATCollectionElementKindSectionHeader] || [kind isEqualToString:CATCollectionElementKindSectionFooter]) {
        view.titleLabel.text = [_sectionFormatter stringFromDate:[_provider dateOfFirstDayInSection:indexPath.section]];
    }
    else if ([kind isEqualToString:CATCollectionElementKindWeekdayIndicator]) {
        NSInteger weekday = (indexPath.row + _provider.calendar.firstWeekday - 1) % 7;
        view.titleLabel.text = _sectionFormatter.shortWeekdaySymbols[weekday];
    }
    
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
