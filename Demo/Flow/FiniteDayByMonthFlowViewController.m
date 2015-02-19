//
//  FiniteDayByMonthFlowViewController.m
//  Demo
//
//  Created by wit on 2/16/15.
//  Copyright (c) 2015 cat. All rights reserved.
//

#import "FiniteDayByMonthFlowViewController.h"
#import "CATCollectionViewWeekLayout.h"
#import "CATCalendarProvider.h"
#import "DateCollectionViewCell.h"
#import "HeaderCollectionReusableView.h"

@interface FiniteDayByMonthFlowViewController ()
@property (strong, nonatomic) CATCalendarProvider *provider;
@property (strong, nonatomic) NSDateFormatter *sectionFormatter;
@property (strong, nonatomic) NSDateFormatter *titleFormatter;
@property (strong, nonatomic) NSDateFormatter *subtitleFormatter;
@end

@implementation FiniteDayByMonthFlowViewController

- (void)awakeFromNib {
    [super awakeFromNib];
    self.provider = [CATCalendarProvider dayByMonthFillingWeeksProvider];
    self.sectionFormatter = [[NSDateFormatter alloc] init];
    _sectionFormatter.dateFormat = @"yyyy-MMMM";
    self.titleFormatter = [[NSDateFormatter alloc] init];
    _titleFormatter.dateFormat = @"MMM";
    self.subtitleFormatter = [[NSDateFormatter alloc] init];
    _subtitleFormatter.dateFormat = @"dd";
}

#pragma mark UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 20;
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
    if (![kind isEqualToString:UICollectionElementKindSectionHeader]) return nil;
        
    HeaderCollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                                            withReuseIdentifier:@"Header"
                                                                                   forIndexPath:indexPath];
    view.titleLabel.text = [_sectionFormatter stringFromDate:[_provider dateAtIndexPath:indexPath]];
    return view;
}

@end
