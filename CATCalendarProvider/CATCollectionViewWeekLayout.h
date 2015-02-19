//
//  CATCalendarCollectionViewLayout.h
//  CATCalendarProvider
//
//  Created by wit on 2/16/15.
//  Copyright (c) 2015 cat.erp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CATCalendarProvider.h"

/** collection view weekday indicator decoration kind */
extern NSString * const CATCollectionElementKindWeekdayIndicator;
/** collection view section header decoration kind */
extern NSString * const CATCollectionElementKindSectionHeader;
/** collection view section footer decoration kind */
extern NSString * const CATCollectionElementKindSectionFooter;

/** collection view week layout */
@interface CATCollectionViewWeekLayout : UICollectionViewLayout
/** calendar provider */
@property (weak, nonatomic) CATCalendarProvider *provider;
/** scroll direction */
@property (assign, nonatomic) UICollectionViewScrollDirection scrollDirection;
/** weekday indicator height, defaults 0 */
@property (assign, nonatomic) CGFloat indicatorHeight;
/** section header height, defaults 0 */
@property (assign, nonatomic) CGFloat headerHeight;
/** section footer height, defaults 0 */
@property (assign, nonatomic) CGFloat footerHeight;
/** section insets, defaults UIEdgeInsetsZero */
@property (assign, nonatomic) UIEdgeInsets sectionInsets;
/** item insets, defaults UIEdgeInsetsZero */
@property (assign, nonatomic) UIEdgeInsets itemInsets;
/** item size, defaults {40, 40} */
@property (assign, nonatomic) CGSize itemSize;
@end
