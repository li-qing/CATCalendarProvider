//
//  NSCalendar+CATKit.h
//  CATKit
//
//  Created by wit on 14-8-6.
//  Copyright (c) 2014年 cat. All rights reserved.
//

#import <Foundation/Foundation.h>

/** weekday */
typedef NS_ENUM(NSInteger, CATWeekday) {
    /** Sunday */
    CATWeekdaySunday = 1,
    /** Monday */
    CATWeekdayMonday,
    /** Tuesday */
    CATWeekdayTuesday,
    /** Wednesday */
    CATWeekdayWednesday,
    /** Thurday */
    CATWeekdayThurday,
    /** Friday */
    CATWeekdayFriday,
    /** Saturday */
    CATWeekdaySaturday
};

#pragma mark -
@interface NSCalendar (CATKit)

#pragma mark compare
/**
 compares the given dates down to the given unit, reporting them equal if they are the same in the given unit and all larger units, 
 otherwise either less than or greater than.
 @param date1   given date
 @param date2   given date
 @param unit    given unit
 @return comparison result
 */
- (NSComparisonResult)cat_compareDate:(NSDate *)date1 toDate:(NSDate *)date2 toUnitGranularity:(NSCalendarUnit)unit;
/**
 compares the given dates down to the given unit, reporting them equal if they are the same in the given unit and all larger units.
 @param date1   given date
 @param date2   given date
 @param unit    given unit
 @return comparison result
 */
- (BOOL)cat_isDate:(NSDate *)date1 equalToDate:(NSDate *)date2 toUnitGranularity:(NSCalendarUnit)unit;

#pragma mark transform
/**
 get day's begining of a given date.
 @param date    given date
 @return day's begining
 */
- (NSDate *)cat_startOfDayForDate:(NSDate *)date;
/**
 get week's begining of a given date.
 @param date    given date
 @return week's begining
 */
- (NSDate *)cat_startOfWeekForDate:(NSDate *)date;
/**
 get month's begining of a given date.
 @param date    given date
 @return month's begining
 */
- (NSDate *)cat_startOfMonthForDate:(NSDate *)date;
/**
 get year's begining of a given date.
 @param date    given date
 @return year's begining
 */
- (NSDate *)cat_startOfYearForDate:(NSDate *)date;
/**
 offset a specific component of NSDate
 @param unit    specific component
 @param value   value of the specific component
 @param date    date
 @param opts    options for adding
 @return offset date
 */
- (NSDate *)cat_dateByAddingUnit:(NSCalendarUnit)unit value:(NSInteger)value toDate:(NSDate *)date options:(NSCalendarOptions)opts;

#pragma mark components
/**
 get second component of the given date
 @param date    the given date
 @return second component
 */
- (NSInteger)cat_secondFromDate:(NSDate *)date;
/**
 get minute component of the given date
 @param date    the given date
 @return minute component
 */
- (NSInteger)cat_minuteFromDate:(NSDate *)date;
/**
 get hour component of the given date
 @param date    the given date
 @return hour component
 */
- (NSInteger)cat_hourFromDate:(NSDate *)date;
/**
 get day component of the given date
 @param date    the given date
 @return day component
 */
- (NSInteger)cat_dayFromDate:(NSDate *)date;
/**
 get weekday component of the given date
 @param date    the given date
 @return weekday component
 */
- (CATWeekday)cat_weekdayFromDate:(NSDate *)date;
/**
 get month component of the given date
 @param date    the given date
 @return month component
 */
- (NSInteger)cat_monthFromDate:(NSDate *)date;
/**
 get year component of the given date
 @param date    the given date
 @return year component
 */
- (NSInteger)cat_yearFromDate:(NSDate *)date;

/**
 get a specific component of the given date
 @param component   specific component
 @param date        the given date
 @return value of the specific component
 */
- (NSInteger)cat_component:(NSCalendarUnit)component fromDate:(NSDate *)date;
/**
 returns the difference between two supplied dates using specified component.
 @param component   specific component
 @param date1       from date
 @param date2       to date
 @return value of the specific component
 */
- (NSInteger)cat_component:(NSCalendarUnit)component fromDate:(NSDate *)date1 toDate:(NSDate *)date2;
@end

#pragma mark -
@interface NSDateComponents (CATKit)
/**
 create a date components with specific component
 @param value   value of the specific component
 @param unit    specific component
 @return date components
 */
+ (instancetype)cat_componentsWithValue:(NSInteger)value forComponent:(NSCalendarUnit)unit;
/**
 set a specific component of NSDateComponents
 @param value   value of the specific component
 @param unit    specific component
 */
- (void)cat_setValue:(NSInteger)value forComponent:(NSCalendarUnit)unit;
/**
 get a specific component of NSDateComponents
 @param unit    specific component
 @return value of the specific component
 */
- (NSInteger)cat_valueForComponent:(NSCalendarUnit)unit;
@end
