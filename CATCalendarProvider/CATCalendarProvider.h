//
//  CATCalendarProvider.h
//  CATCalendarProvider
//
//  Created by wit on 2/15/15.
//  Copyright (c) 2015 cat.erp. All rights reserved.
//

#import <UIKit/UIKit.h>

/** calendar table/collection view data provider */
@interface CATCalendarProvider : NSObject

#pragma mark factory
/** create a provider instance uses day component as both section & item */
+ (instancetype)dayByDayProvider;
/** create a provider instance uses day component as item and month component as section */
+ (instancetype)dayByMonthProvider;
/** create a provider instance uses day component as item and year component as section */
+ (instancetype)dayByYearProvider;
/** create a provider instance uses month component as both section & item */
+ (instancetype)monthByMonthProvider;
/** create a provider instance uses month component as item and year component as section */
+ (instancetype)monthByYearProvider;
/** create a provider instance uses year component as both section & item */
+ (instancetype)yearByYearProvider;
/** 
 create a provider instance uses day component as item and month component as section; 
 it adds days at the begining from that week's first weekday to the first day;
 and adds days at the end from the last day to that week's last weekday.
 
 for example:
 
 in Gregorian Calendar, using Sunday as first week day, for the section Apr 2015,
 
 Sun    Mon     Tue     Wed     Thu     Fri     Sat
 
 3-29'  3-30'   3-31'   4-1     4-2     4-3     4-4
 
 ...
 
 4-26   4-27    4-28    4-29    4-30    5-1'    5-2'
 
 MM-dd' would not be included in if you use -dayByMonthProvider.
 
 @sa -dayByMonthProvider
 */
+ (instancetype)dayByMonthFillingWeeksProvider;
/**
 create a provider instance uses day component as item and year component as section;
 it adds days at the begining from that week's first weekday to the first day;
 and adds days at the end from the last day to that week's last weekday.
 
 for example:
 
 in Gregorian Calendar, using Sunday as first week day, for the section year 2015,
 
 Sun    Mon     Tue     Wed     Thu     Fri     Sat
 
 362'   363'    364'    365'    1       2       3
 
 ...
 
 361    362     363     364     365     1'      2'
 
 n' would not be included in if you use -dayByYearProvider.
 
 @sa -dayByYearProvider
 */
+ (instancetype)dayByYearFillingWeeksProvider;

#pragma mark property
/** calendar */
@property (copy, nonatomic) NSCalendar *calendar;
/** baseline date for indexPath {0, 0} */
@property (strong, nonatomic) NSDate *baseline;
/** 
 adds days at the begining and the end to complete weeks or not
 @sa -dayByMonthFillingWeeksProvider, -dayByYearFillingWeeksProvider
 */
@property (assign, nonatomic, readonly) BOOL fillingWeeks;

#pragma mark data source
/** 
 number of sections; reserved; always returns NSUIntegerMax now.
 */
- (NSUInteger)numberOfSections;
/**
 number of items in the given section
 */
- (NSUInteger)numberOfItemsInSection:(NSUInteger)section;

#pragma mark date to index path
/**
 query section for the given date; may return negative section if the given date is earlier than baseline date.
 */
- (NSInteger)sectionForDate:(NSDate *)date;
/**
 query indexPath for the given date; may return nil if the given date is earlier than baseline date.
 */
- (NSIndexPath *)indexPathForDate:(NSDate *)date;

#pragma mark index path to date
/**
 query the first date in the given section
 */
- (NSDate *)dateOfFirstDayInSection:(NSUInteger)section;
/**
 query the last date in the given section
 */
- (NSDate *)dateOfLastDayInSection:(NSUInteger)section;
/**
 query the date in the given indexPath
 */
- (NSDate *)dateAtIndexPath:(NSIndexPath *)indexPath;
/**
 query the first date including filling days in the given section
 */
- (NSDate *)dateOfFirstFillingDayInSection:(NSUInteger)section;
/**
 query the last date including filling days in the given section
 */
- (NSDate *)dateOfLastFillingDayInSection:(NSUInteger)section;
@end
