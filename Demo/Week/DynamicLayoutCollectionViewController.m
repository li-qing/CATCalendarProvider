//
//  DynamicLayoutCollectionViewController.m
//  CATCalendarProvider
//
//  Created by wit on 15/2/19.
//  Copyright (c) 2015年 cat. All rights reserved.
//

#import "DynamicLayoutCollectionViewController.h"
#import "CATCollectionViewWeekLayout.h"
#import "CATCalendarProvider.h"
#import "DateCollectionViewCell.h"
#import "TitleCollectionReusableView.h"

@interface DynamicLayoutCollectionViewController ()
@property (strong, nonatomic) IBOutlet UICollectionViewFlowLayout *flowLayout;
@property (strong, nonatomic) IBOutlet CATCollectionViewWeekLayout *weekLayout;
@property (strong, nonatomic) CATCalendarProvider *provider;
@property (strong, nonatomic) NSDateFormatter *sectionFormatter;
@property (strong, nonatomic) NSDateFormatter *titleFormatter;
@property (strong, nonatomic) NSDateFormatter *subtitleFormatter;
@end

@implementation DynamicLayoutCollectionViewController

- (void)awakeFromNib {
    [super awakeFromNib];
    self.provider = [CATCalendarProvider dayByMonthProvider];
    self.sectionFormatter = [[NSDateFormatter alloc] init];
    _sectionFormatter.dateFormat = @"yyyy-MMMM";
    self.titleFormatter = [[NSDateFormatter alloc] init];
    _titleFormatter.dateFormat = @"MMM";
    self.subtitleFormatter = [[NSDateFormatter alloc] init];
    _subtitleFormatter.dateFormat = @"dd";
}

- (void)viewDidLoad {
    [super viewDidLoad];

    _flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    _flowLayout.itemSize = CGSizeMake(CGRectGetWidth(self.view.frame), 50);
    _flowLayout.minimumLineSpacing = 0;
    _flowLayout.minimumInteritemSpacing = 0;
    
    _weekLayout.provider = _provider;
    _weekLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    _weekLayout.sectionInsets = UIEdgeInsetsMake(2.5, 2.5, 2.5, 2.5);
    _weekLayout.itemInsets = UIEdgeInsetsMake(2.5, 2.5, 2.5, 2.5);
    _weekLayout.indicatorHeight = 30;
    _weekLayout.headerHeight = 30;
    _weekLayout.footerHeight = 30;
    _weekLayout.itemSize = CGSizeMake(40, 50);
    
    [self.collectionView registerClass:TitleCollectionReusableView.class
            forSupplementaryViewOfKind:CATCollectionElementKindWeekdayIndicator
                   withReuseIdentifier:CATCollectionElementKindWeekdayIndicator];
    [self.collectionView registerClass:TitleCollectionReusableView.class
            forSupplementaryViewOfKind:CATCollectionElementKindSectionHeader
                   withReuseIdentifier:CATCollectionElementKindSectionHeader];
    [self.collectionView registerClass:TitleCollectionReusableView.class
            forSupplementaryViewOfKind:CATCollectionElementKindSectionFooter
                   withReuseIdentifier:CATCollectionElementKindSectionFooter];
}

- (IBAction)switchLayout {
    if (self.collectionView.collectionViewLayout == _weekLayout) {
        [self.collectionView setCollectionViewLayout:_flowLayout animated:YES];
    } else {
        [self.collectionView setCollectionViewLayout:_weekLayout animated:YES];
    }
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
    TitleCollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                                           withReuseIdentifier:kind
                                                                                  forIndexPath:indexPath];
    
    if ([kind isEqualToString:CATCollectionElementKindSectionHeader] || [kind isEqualToString:CATCollectionElementKindSectionFooter]) {
        view.titleLabel.text = [_sectionFormatter stringFromDate:[_provider dateAtIndexPath:indexPath]];
    }
    else if ([kind isEqualToString:CATCollectionElementKindWeekdayIndicator]) {
        NSInteger weekday = (indexPath.row + _provider.calendar.firstWeekday - 1) % 7;
        view.titleLabel.text = _sectionFormatter.shortWeekdaySymbols[weekday];
    }
    
    return view;
}
@end
