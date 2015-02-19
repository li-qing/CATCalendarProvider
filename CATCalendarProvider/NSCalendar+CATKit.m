//
//  NSCalendar+CATKit.m
//  CATKit
//
//  Created by wit on 14-8-6.
//  Copyright (c) 2014年 cat. All rights reserved.
//

#import "NSCalendar+CATKit.h"
#import "NSDate+CATKit.h"

@implementation NSCalendar (CATKit)

#pragma mark compare
- (NSComparisonResult)cat_compareDate:(NSDate *)date1 toDate:(NSDate *)date2 toUnitGranularity:(NSCalendarUnit)unit {
    NSDate *compare1 = [self dateFromComponents:[self components:unit fromDate:date1]];
    NSDate *compare2 = [self dateFromComponents:[self components:unit fromDate:date2]];
    return [compare1 compare:compare2];
}
- (BOOL)cat_isDate:(NSDate *)date1 equalToDate:(NSDate *)date2 toUnitGranularity:(NSCalendarUnit)unit {
    return date1 && date2 && [self cat_compareDate:date1 toDate:date2 toUnitGranularity:unit] == NSOrderedSame;
}

#pragma mark transform
- (NSDate *)cat_startOfDayForDate:(NSDate *)date {
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.era = [self cat_component:NSCalendarUnitEra fromDate:date];
    components.year = [self cat_component:NSCalendarUnitYear fromDate:date];
    components.month = [self cat_component:NSCalendarUnitMonth fromDate:date];
    components.day = [self cat_component:NSCalendarUnitDay fromDate:date];
    return [self dateFromComponents:components];
}

- (NSDate *)cat_startOfWeekForDate:(NSDate *)date {
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.era = [self cat_component:NSCalendarUnitEra fromDate:date];
    components.year = [self cat_component:NSCalendarUnitYear fromDate:date];
    components.month = [self cat_component:NSCalendarUnitMonth fromDate:date];
    components.weekOfMonth = [self cat_component:NSCalendarUnitWeekOfMonth fromDate:date];
    components.weekday = self.firstWeekday;
    return [self dateFromComponents:components];
}

- (NSDate *)cat_startOfMonthForDate:(NSDate *)date {
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.era = [self cat_component:NSCalendarUnitEra fromDate:date];
    components.year = [self cat_component:NSCalendarUnitYear fromDate:date];
    components.month = [self cat_component:NSCalendarUnitMonth fromDate:date];
    return [self dateFromComponents:components];
}

- (NSDate *)cat_startOfYearForDate:(NSDate *)date {
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.era = [self cat_component:NSCalendarUnitEra fromDate:date];
    components.year = [self cat_component:NSCalendarUnitYear fromDate:date];
    return [self dateFromComponents:components];
}

- (NSDate *)cat_dateByAddingUnit:(NSCalendarUnit)unit value:(NSInteger)value toDate:(NSDate *)date options:(NSCalendarOptions)opts {
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components cat_setValue:value forComponent:unit];
    return [self dateByAddingComponents:components toDate:date options:opts];
}

#pragma mark components
- (NSInteger)cat_secondFromDate:(NSDate *)date {
    return [self cat_component:NSCalendarUnitSecond fromDate:date];
}
- (NSInteger)cat_minuteFromDate:(NSDate *)date {
    return [self cat_component:NSCalendarUnitMinute fromDate:date];
}
- (NSInteger)cat_hourFromDate:(NSDate *)date {
    return [self cat_component:NSCalendarUnitHour fromDate:date];
}
- (NSInteger)cat_dayFromDate:(NSDate *)date {
    return [self cat_component:NSCalendarUnitDay fromDate:date];
}
- (CATWeekday)cat_weekdayFromDate:(NSDate *)date {
    return [self cat_component:NSCalendarUnitWeekday fromDate:date];
}
- (NSInteger)cat_monthFromDate:(NSDate *)date {
    return [self cat_component:NSCalendarUnitMonth fromDate:date];
}
- (NSInteger)cat_yearFromDate:(NSDate *)date {
    return [self cat_component:NSCalendarUnitYear fromDate:date];
}
- (NSInteger)cat_component:(NSCalendarUnit)component fromDate:(NSDate *)date {
    return [[self components:component fromDate:date] cat_valueForComponent:component];
}
- (NSInteger)cat_component:(NSCalendarUnit)component fromDate:(NSDate *)date1 toDate:(NSDate *)date2 {
    return [[self components:component fromDate:date1 toDate:date2 options:kNilOptions] cat_valueForComponent:component];
}
@end

#pragma mark -
@implementation NSDateComponents (CATKit)

+ (instancetype)cat_componentsWithValue:(NSInteger)value forComponent:(NSCalendarUnit)unit {
    NSDateComponents *components = [[self alloc] init];
    [components cat_setValue:value forComponent:unit];
    return components;
}

- (void)cat_setValue:(NSInteger)value forComponent:(NSCalendarUnit)unit {
    switch (unit) {
        case NSCalendarUnitEra:
            self.era = value;
            break;
        case NSCalendarUnitYear:
            self.year = value;
            break;
        case NSCalendarUnitQuarter:
            self.quarter = value;
            break;
        case NSCalendarUnitMonth:
            self.month = value;
            break;
            
        case NSCalendarUnitYearForWeekOfYear:
            self.yearForWeekOfYear = value;
            break;
        case NSCalendarUnitWeekOfYear:
            self.weekOfYear = value;
            break;
        case NSCalendarUnitWeekOfMonth:
            self.weekOfMonth = value;
            break;
        case NSCalendarUnitWeekdayOrdinal:
            self.weekdayOrdinal = value;
            break;
        case NSCalendarUnitWeekday:
            self.weekday = value;
            break;
            
        case NSCalendarUnitDay:
            self.day = value;
            break;
        case NSCalendarUnitHour:
            self.hour = value;
            break;
        case NSCalendarUnitMinute:
            self.minute = value;
            break;
        case NSCalendarUnitSecond:
            self.second = value;
            break;
        case NSCalendarUnitNanosecond:
            self.nanosecond = value;
            break;
        default:
            break;
    }
}

- (NSInteger)cat_valueForComponent:(NSCalendarUnit)unit {
    switch (unit) {
        case NSCalendarUnitEra:
            return self.era;
        case NSCalendarUnitYear:
            return self.year;
        case NSCalendarUnitQuarter:
            return self.quarter;
        case NSCalendarUnitMonth:
            return self.month;
            
        case NSCalendarUnitYearForWeekOfYear:
            return self.yearForWeekOfYear;
        case NSCalendarUnitWeekOfYear:
            return self.weekOfYear;
        case NSCalendarUnitWeekOfMonth:
            return self.weekOfMonth;
        case NSCalendarUnitWeekdayOrdinal:
            return self.weekdayOrdinal;
        case NSCalendarUnitWeekday:
            return self.weekday;
            
        case NSCalendarUnitDay:
            return self.day;
        case NSCalendarUnitHour:
            return self.hour;
        case NSCalendarUnitMinute:
            return self.minute;
        case NSCalendarUnitSecond:
            return self.second;
        case NSCalendarUnitNanosecond:
            return self.nanosecond;
        default:
            return 0;
    }
}
@end
