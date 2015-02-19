//
//  FiniteYearFlowViewController.m
//  Demo
//
//  Created by wit on 2/16/15.
//  Copyright (c) 2015 cat. All rights reserved.
//

#import "FiniteYearFlowViewController.h"
#import "CATCollectionViewWeekLayout.h"
#import "CATCalendarProvider.h"
#import "DateCollectionViewCell.h"
#import "HeaderCollectionReusableView.h"

@interface FiniteYearFlowViewController ()
@property (strong, nonatomic) CATCalendarProvider *provider;
@property (strong, nonatomic) NSDateFormatter *cellFormatter;
@end

@implementation FiniteYearFlowViewController

- (void)awakeFromNib {
    [super awakeFromNib];
    self.provider = [CATCalendarProvider yearByYearProvider];
    self.cellFormatter = [[NSDateFormatter alloc] init];
    _cellFormatter.dateFormat = @"yyyy";
}

#pragma mark UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 200;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [_provider numberOfItemsInSection:section];
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    DateCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    cell.titleLabel.text = [_cellFormatter stringFromDate:[_provider dateAtIndexPath:indexPath]];
    return cell;
}
@end
