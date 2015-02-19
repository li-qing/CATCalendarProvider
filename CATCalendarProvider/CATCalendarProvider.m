//
//  CATCalendarProvider.m
//  CATCalendarProvider
//
//  Created by wit on 2/15/15.
//  Copyright (c) 2015 cat.erp. All rights reserved.
//

#import "CATCalendarProvider.h"
#import "NSCalendar+CATKit.h"
#import "NSDate+CATKit.h"

@interface CATCalendarProvider ()
@property (assign, nonatomic) NSCalendarUnit sectionUnit;
@property (assign, nonatomic) NSCalendarUnit itemUnit;
@property (assign, nonatomic) BOOL fillingWeeks;
@end

@implementation CATCalendarProvider

#pragma mark life cycle
- (instancetype)init {
    self = [super init];
    if (self) {
        self.calendar = [NSCalendar currentCalendar];
        self.baseline = [NSDate date];
    }
    return self;
}

+ (instancetype)dayByDayProvider {
    CATCalendarProvider *provider = [[self alloc] init];
    provider.sectionUnit = NSCalendarUnitDay;
    provider.itemUnit = NSCalendarUnitDay;
    return provider;
}
+ (instancetype)dayByMonthProvider {
    CATCalendarProvider *provider = [[self alloc] init];
    provider.sectionUnit = NSCalendarUnitMonth;
    provider.itemUnit = NSCalendarUnitDay;
    return provider;
}
+ (instancetype)dayByYearProvider {
    CATCalendarProvider *provider = [[self alloc] init];
    provider.sectionUnit = NSCalendarUnitYear;
    provider.itemUnit = NSCalendarUnitDay;
    return provider;
}
+ (instancetype)monthByMonthProvider {
    CATCalendarProvider *provider = [[self alloc] init];
    provider.sectionUnit = NSCalendarUnitMonth;
    provider.itemUnit = NSCalendarUnitMonth;
    return provider;
}
+ (instancetype)monthByYearProvider {
    CATCalendarProvider *provider = [[self alloc] init];
    provider.sectionUnit = NSCalendarUnitYear;
    provider.itemUnit = NSCalendarUnitMonth;
    return provider;
}
+ (instancetype)yearByYearProvider {
    CATCalendarProvider *provider = [[self alloc] init];
    provider.sectionUnit = NSCalendarUnitYear;
    provider.itemUnit = NSCalendarUnitYear;
    return provider;
}
+ (instancetype)dayByMonthFillingWeeksProvider {
    CATCalendarProvider *provider = [[self alloc] init];
    provider.sectionUnit = NSCalendarUnitMonth;
    provider.itemUnit = NSCalendarUnitDay;
    provider.fillingWeeks = YES;
    return provider;
}
+ (instancetype)dayByYearFillingWeeksProvider {
    CATCalendarProvider *provider = [[self alloc] init];
    provider.sectionUnit = NSCalendarUnitYear;
    provider.itemUnit = NSCalendarUnitDay;
    provider.fillingWeeks = YES;
    return provider;
}

#pragma mark query
- (NSDate *)cat_startOfUnit:(NSCalendarUnit)unit forDate:(NSDate *)date {
    if (unit == NSCalendarUnitYear) {
        return [_calendar cat_startOfYearForDate:date];
    } else if (unit == NSCalendarUnitMonth) {
        return [_calendar cat_startOfMonthForDate:date];
    } else {
        return [_calendar cat_startOfDayForDate:date];
    }
}

#pragma mark data source
- (NSUInteger)numberOfSections {
    return NSUIntegerMax;
}
- (NSUInteger)numberOfItemsInSection:(NSUInteger)section {
    NSDate *start = [self dateOfFirstFillingDayInSection:section];
    NSDate *end = [self dateOfLastFillingDayInSection:section];
    return [_calendar cat_component:_itemUnit fromDate:start toDate:end] + 1;
}

#pragma mark index path to date
- (NSDate *)dateOfFirstDayInSection:(NSUInteger)section {
    NSDate *shift = [_calendar cat_dateByAddingUnit:_sectionUnit value:section toDate:_baseline options:kNilOptions];
    return [self cat_startOfUnit:_sectionUnit forDate:shift];
}
- (NSDate *)dateOfLastDayInSection:(NSUInteger)section {
    NSDate *shift = [_calendar cat_dateByAddingUnit:_sectionUnit value:section + 1 toDate:_baseline options:kNilOptions];
    return [[self cat_startOfUnit:_sectionUnit forDate:shift] cat_dateByAddingDays:-1];
}
- (NSDate *)dateAtIndexPath:(NSIndexPath *)indexPath {
    NSDate *shift = [self dateOfFirstFillingDayInSection:indexPath.section];
    return [_calendar cat_dateByAddingUnit:_itemUnit value:indexPath.row toDate:shift options:kNilOptions];
}
- (NSDate *)dateOfFirstFillingDayInSection:(NSUInteger)section {
    if (!_fillingWeeks) return [self dateOfFirstDayInSection:section];
    return [self.calendar cat_startOfWeekForDate:[self dateOfFirstDayInSection:section]];
}
- (NSDate *)dateOfLastFillingDayInSection:(NSUInteger)section {
    if (!_fillingWeeks) return [self dateOfLastDayInSection:section];
    return [[self.calendar cat_startOfWeekForDate:[self dateOfLastDayInSection:section]] cat_dateByAddingDays:CATDaysPerWeek - 1];
}

#pragma mark date to index path
- (NSInteger)sectionForDate:(NSDate *)date {
    NSDate *start = [self cat_startOfUnit:_sectionUnit forDate:_baseline];
    NSDate *end = [self cat_startOfUnit:_sectionUnit forDate:date];
    return [_calendar cat_component:_sectionUnit fromDate:start toDate:end];
}
- (NSIndexPath *)indexPathForDate:(NSDate *)date {
    NSInteger section = [self sectionForDate:date];
    if (section < 0) return nil;
    
    NSDate *start = [self dateOfFirstFillingDayInSection:section];
    NSInteger row = [_calendar cat_component:_itemUnit fromDate:start toDate:date];;
    return [NSIndexPath indexPathForRow:row inSection:section];
}
@end
