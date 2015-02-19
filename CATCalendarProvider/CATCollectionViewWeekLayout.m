//
//  CATCalendarCollectionViewLayout.m
//  CATCalendarProvider
//
//  Created by wit on 2/16/15.
//  Copyright (c) 2015 cat.erp. All rights reserved.
//

#import "CATCollectionViewWeekLayout.h"
#import "NSCalendar+CATKit.h"

NSString * const CATCollectionElementKindWeekdayIndicator   = @"CATCollectionElementKindWeekdayIndicator";
NSString * const CATCollectionElementKindSectionHeader      = @"CATCollectionElementKindSectionHeader";
NSString * const CATCollectionElementKindSectionFooter      = @"CATCollectionElementKindSectionFooter";

@interface CATCollectionViewWeekLayout ()
@property (copy, nonatomic) NSDictionary *indicatorAttributes;
@property (copy, nonatomic) NSDictionary *headerAttributes;
@property (copy, nonatomic) NSDictionary *itemAttributes;
@property (copy, nonatomic) NSDictionary *footerAttributes;
@property (assign, nonatomic) CGSize contentSize;
@end

@implementation CATCollectionViewWeekLayout

#define kDaysPerWeek 7

#pragma mark life cycle
- (id)init {
    self = [super init];
    if (self) {
        [self cat_initialize];
        [self cat_registerKVO];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self cat_initialize];
        [self cat_decodeWithCoder:aDecoder];
        [self cat_registerKVO];
    }
    return self;
}

- (void)cat_initialize {
    _itemSize = CGSizeMake(40, 40);
}

- (void)dealloc {
    [self cat_unregisterKVO];
}

#pragma mark NSCoding
- (void)cat_decodeWithCoder:(NSCoder *)aDecoder {
    if ([aDecoder containsValueForKey:NSStringFromSelector(@selector(scrollDirection))]) {
        self.scrollDirection = [aDecoder decodeIntegerForKey:NSStringFromSelector(@selector(scrollDirection))];
    }
    if ([aDecoder containsValueForKey:NSStringFromSelector(@selector(indicatorHeight))]) {
        self.indicatorHeight = [aDecoder decodeFloatForKey:NSStringFromSelector(@selector(indicatorHeight))];
    }
    if ([aDecoder containsValueForKey:NSStringFromSelector(@selector(headerHeight))]) {
        self.headerHeight = [aDecoder decodeFloatForKey:NSStringFromSelector(@selector(headerHeight))];
    }
    if ([aDecoder containsValueForKey:NSStringFromSelector(@selector(footerHeight))]) {
        self.footerHeight = [aDecoder decodeFloatForKey:NSStringFromSelector(@selector(footerHeight))];
    }
    if ([aDecoder containsValueForKey:NSStringFromSelector(@selector(sectionInsets))]) {
        self.sectionInsets = [aDecoder decodeUIEdgeInsetsForKey:NSStringFromSelector(@selector(sectionInsets))];
    }
    if ([aDecoder containsValueForKey:NSStringFromSelector(@selector(itemInsets))]) {
        self.itemInsets = [aDecoder decodeUIEdgeInsetsForKey:NSStringFromSelector(@selector(itemInsets))];
    }
    if ([aDecoder containsValueForKey:NSStringFromSelector(@selector(itemSize))]) {
        self.itemSize = [aDecoder decodeCGSizeForKey:NSStringFromSelector(@selector(itemSize))];
    }
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [super encodeWithCoder:aCoder];
    
    [aCoder encodeInteger:_scrollDirection forKey:NSStringFromSelector(@selector(scrollDirection))];
    [aCoder encodeFloat:_indicatorHeight forKey:NSStringFromSelector(@selector(indicatorHeight))];
    [aCoder encodeFloat:_headerHeight forKey:NSStringFromSelector(@selector(headerHeight))];
    [aCoder encodeFloat:_footerHeight forKey:NSStringFromSelector(@selector(footerHeight))];
    [aCoder encodeUIEdgeInsets:_sectionInsets forKey:NSStringFromSelector(@selector(sectionInsets))];
    [aCoder encodeUIEdgeInsets:_itemInsets forKey:NSStringFromSelector(@selector(itemInsets))];
    [aCoder encodeCGSize:_itemSize forKey:NSStringFromSelector(@selector(itemSize))];
}

#pragma mark kvo
- (void)cat_registerKVO {
    [self addObserver:self forKeyPath:NSStringFromSelector(@selector(scrollDirection)) options:0 context:NULL];
    [self addObserver:self forKeyPath:NSStringFromSelector(@selector(indicatorHeight)) options:0 context:NULL];
    [self addObserver:self forKeyPath:NSStringFromSelector(@selector(headerHeight)) options:0 context:NULL];
    [self addObserver:self forKeyPath:NSStringFromSelector(@selector(footerHeight)) options:0 context:NULL];
    [self addObserver:self forKeyPath:NSStringFromSelector(@selector(sectionInsets)) options:0 context:NULL];
    [self addObserver:self forKeyPath:NSStringFromSelector(@selector(itemInsets)) options:0 context:NULL];
    [self addObserver:self forKeyPath:NSStringFromSelector(@selector(itemSize)) options:0 context:NULL];
}

- (void)cat_unregisterKVO {
    [self removeObserver:self forKeyPath:NSStringFromSelector(@selector(scrollDirection))];
    [self removeObserver:self forKeyPath:NSStringFromSelector(@selector(indicatorHeight))];
    [self removeObserver:self forKeyPath:NSStringFromSelector(@selector(headerHeight))];
    [self removeObserver:self forKeyPath:NSStringFromSelector(@selector(footerHeight))];
    [self removeObserver:self forKeyPath:NSStringFromSelector(@selector(sectionInsets))];
    [self removeObserver:self forKeyPath:NSStringFromSelector(@selector(itemInsets))];
    [self removeObserver:self forKeyPath:NSStringFromSelector(@selector(itemSize))];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    [self invalidateLayout];
}

#pragma mark layout attributes
- (CGSize)collectionViewContentSize {
    return _contentSize;
}

- (void)prepareLayout {
    [super prepareLayout];
    if (_scrollDirection == UICollectionViewScrollDirectionHorizontal) {
        [self cat_prepareAttributeHorizontallyIfNeeded];
    } else {
        [self cat_prepareAttributeVerticallyIfNeeded];
    }
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:1 + 6 * kDaysPerWeek];
    [_indicatorAttributes enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if (CGRectIntersectsRect([obj frame], rect)) {
            [array addObject:obj];
        }
    }];
    [_headerAttributes enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if (CGRectIntersectsRect([obj frame], rect)) {
            [array addObject:obj];
        }
    }];
    [_itemAttributes enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if (CGRectIntersectsRect([obj frame], rect)) {
            [array addObject:obj];
        }
    }];
    [_footerAttributes enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if (CGRectIntersectsRect([obj frame], rect)) {
            [array addObject:obj];
        }
    }];
    return array;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    return _itemAttributes[indexPath];
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind
                                                                     atIndexPath:(NSIndexPath *)indexPath {
    if ([elementKind isEqualToString:CATCollectionElementKindWeekdayIndicator]) {
        return _indicatorAttributes[indexPath];
    }
    if ([elementKind isEqualToString:CATCollectionElementKindSectionHeader]) {
        return _headerAttributes[indexPath];
    }
    if ([elementKind isEqualToString:CATCollectionElementKindSectionFooter]) {
        return _footerAttributes[indexPath];
    }
    return nil;
}

- (void)invalidateLayout {
    [super invalidateLayout];
    self.indicatorAttributes = self.headerAttributes = self.itemAttributes = self.footerAttributes = nil;
    self.contentSize = CGSizeZero;
}

#pragma mark layout
- (void)cat_prepareAttributeHorizontallyIfNeeded {
    if (_indicatorAttributes || _headerAttributes || _itemAttributes || _footerAttributes) return;

    const NSUInteger numberOfSections = [self.collectionView numberOfSections];
    if (numberOfSections == 0) return;
    
    // container
    NSMutableDictionary *indicatorAttributes = [NSMutableDictionary dictionary];
    NSMutableDictionary *headerAttributes = [NSMutableDictionary dictionary];
    NSMutableDictionary *itemAttributes = [NSMutableDictionary dictionary];
    NSMutableDictionary *footerAttributes = [NSMutableDictionary dictionary];
    
    // constants
    const CGFloat stepWidth = _itemSize.width + _itemInsets.left + _itemInsets.right;
    const CGFloat stepHeight = _itemSize.height + _itemInsets.top + _itemInsets.bottom;
    const CGFloat sectionWidth = stepWidth * kDaysPerWeek;
    const CGFloat pageWidth = sectionWidth + _sectionInsets.left + _sectionInsets.right;
    const Class class = [[self class] layoutAttributesClass];
    
    CGFloat maxY = 0;
    for (NSUInteger section = 0; section < numberOfSections; section++) {
        // indicator
        if (_indicatorHeight > 0) {
            NSString *kind = CATCollectionElementKindWeekdayIndicator;
            CGFloat x = section * pageWidth + _sectionInsets.left + _itemInsets.left;
            const CGFloat y = _sectionInsets.top;
            
            UICollectionViewLayoutAttributes *attribute = nil;
            for (NSUInteger row = 0; row < kDaysPerWeek; row++) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:section];
                attribute = [class layoutAttributesForSupplementaryViewOfKind:kind withIndexPath:indexPath];
                attribute.frame = CGRectMake(x, y, _itemSize.width, _indicatorHeight);
                indicatorAttributes[indexPath] = attribute;
                x += stepWidth;
            }
        }
        
        // header
        if (_headerHeight > 0) {
            NSString *kind = CATCollectionElementKindSectionHeader;
            const CGFloat x = section * pageWidth + _sectionInsets.left;
            const CGFloat y = _sectionInsets.top + _indicatorHeight;
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:section];
            UICollectionViewLayoutAttributes *attribute = [class layoutAttributesForSupplementaryViewOfKind:kind withIndexPath:indexPath];
            attribute.frame = CGRectMake(x, y, sectionWidth, _headerHeight);
            headerAttributes[indexPath] = attribute;
        }
        
        // cell
        CGFloat y = _sectionInsets.top + _indicatorHeight + _headerHeight + _itemInsets.top;
        if (_itemSize.width > 0 && _itemSize.height > 0) {
            NSUInteger numberOfItems = [self.collectionView numberOfItemsInSection:section];
            NSUInteger filling = 0;
            if (!_provider.fillingWeeks) {
                CATWeekday weekday = [_provider.calendar cat_weekdayFromDate:[_provider dateOfFirstDayInSection:section]];
                filling = (weekday - _provider.calendar.firstWeekday) % kDaysPerWeek;
            }
            CGFloat x = section * pageWidth + _sectionInsets.left + _itemInsets.left + filling * stepWidth;
            
            UICollectionViewLayoutAttributes *attribute = nil;
            for (NSUInteger row = 0; row < numberOfItems; row++) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:section];
                attribute = [class layoutAttributesForCellWithIndexPath:indexPath];
                attribute.frame = CGRectMake(x, y, _itemSize.width, _itemSize.height);
                itemAttributes[indexPath] = attribute;
                
                if ((filling + row + 1) % kDaysPerWeek == 0) {
                    x = section * pageWidth + _sectionInsets.left + _itemInsets.left;
                    y += stepHeight;
                } else {
                    x += stepWidth;
                }
            }
            
            y += (filling + numberOfItems) % kDaysPerWeek > 0 ? _itemSize.height + _itemInsets.bottom : 0;
        }
        
        // footer
        if (_footerHeight > 0) {
            NSString *kind = CATCollectionElementKindSectionFooter;
            const CGFloat x = section * pageWidth + _sectionInsets.left;
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:section];
            UICollectionViewLayoutAttributes *attribute = [class layoutAttributesForSupplementaryViewOfKind:kind withIndexPath:indexPath];
            attribute.frame = CGRectMake(x, y, sectionWidth, _footerHeight);
            footerAttributes[indexPath] = attribute;
            
            y += _footerHeight;
        }
        
        maxY = MAX(maxY, y);
    }
    
    // apply
    self.indicatorAttributes = indicatorAttributes;
    self.headerAttributes = headerAttributes;
    self.itemAttributes = itemAttributes;
    self.footerAttributes = footerAttributes;
    self.contentSize = CGSizeMake(pageWidth * numberOfSections, maxY + _sectionInsets.bottom);
}

- (void)cat_prepareAttributeVerticallyIfNeeded {
    if (_indicatorAttributes || _headerAttributes || _itemAttributes || _footerAttributes) return;
    
    const NSUInteger numberOfSections = [self.collectionView numberOfSections];
    if (numberOfSections == 0) return;
    
    // container
    NSMutableDictionary *indicatorAttributes = [NSMutableDictionary dictionary];
    NSMutableDictionary *headerAttributes = [NSMutableDictionary dictionary];
    NSMutableDictionary *itemAttributes = [NSMutableDictionary dictionary];
    NSMutableDictionary *footerAttributes = [NSMutableDictionary dictionary];
    
    // constants
    const CGFloat stepWidth = _itemSize.width + _itemInsets.left + _itemInsets.right;
    const CGFloat stepHeight = _itemSize.height + _itemInsets.top + _itemInsets.bottom;
    const CGFloat sectionWidth = stepWidth * kDaysPerWeek;
    const CGFloat pageWidth = sectionWidth + _sectionInsets.left + _sectionInsets.right;
    const Class class = [[self class] layoutAttributesClass];

    // indicator
    if (_indicatorHeight > 0) {
        NSString *kind = CATCollectionElementKindWeekdayIndicator;
        CGFloat x = _sectionInsets.left + _itemInsets.left;
        
        UICollectionViewLayoutAttributes *attribute = nil;
        for (NSUInteger row = 0; row < kDaysPerWeek; row++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
            attribute = [class layoutAttributesForSupplementaryViewOfKind:kind withIndexPath:indexPath];
            attribute.frame = CGRectMake(x, 0, _itemSize.width, _indicatorHeight);
            indicatorAttributes[indexPath] = attribute;
            x += stepWidth;
        }
    }
    
    CGFloat y = _indicatorHeight;
    for (NSUInteger section = 0; section < numberOfSections; section++) {
        y += _sectionInsets.top;

        // header
        if (_headerHeight > 0) {
            NSString *kind = CATCollectionElementKindSectionHeader;
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:section];
            UICollectionViewLayoutAttributes *attribute = [class layoutAttributesForSupplementaryViewOfKind:kind withIndexPath:indexPath];
            attribute.frame = CGRectMake(_sectionInsets.left, y, sectionWidth, _headerHeight);
            headerAttributes[indexPath] = attribute;
            
            y += _headerHeight;
        }
        
        // cell
        if (_itemSize.width > 0 && _itemSize.height > 0) {
            NSUInteger filling = 0;
            if (!_provider.fillingWeeks) {
                CATWeekday weekday = [_provider.calendar cat_weekdayFromDate:[_provider dateOfFirstDayInSection:section]];
                filling = (weekday - _provider.calendar.firstWeekday) % kDaysPerWeek;
            }
            NSUInteger numberOfItems = [self.collectionView numberOfItemsInSection:section];
            CGFloat x = _sectionInsets.left + _itemInsets.left + filling * stepWidth;
            
            UICollectionViewLayoutAttributes *attribute = nil;
            for (NSUInteger row = 0; row < numberOfItems; row++) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:section];
                attribute = [class layoutAttributesForCellWithIndexPath:indexPath];
                attribute.frame = CGRectMake(x, y, _itemSize.width, _itemSize.height);
                itemAttributes[indexPath] = attribute;
                
                if ((filling + row + 1) % kDaysPerWeek == 0) {
                    x = _sectionInsets.left + _itemInsets.left;
                    y += stepHeight;
                } else {
                    x += stepWidth;
                }
            }
            
            y += (filling + numberOfItems) % kDaysPerWeek > 0 ? _itemSize.height + _itemInsets.bottom : 0;
        }
        
        // footer
        if (_footerHeight > 0) {
            NSString *kind = CATCollectionElementKindSectionFooter;
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:section];
            UICollectionViewLayoutAttributes *attribute = [class layoutAttributesForSupplementaryViewOfKind:kind withIndexPath:indexPath];
            attribute.frame = CGRectMake(_sectionInsets.left, y, sectionWidth, _footerHeight);
            footerAttributes[indexPath] = attribute;
            
            y += _footerHeight;
        }
        
        y += _sectionInsets.bottom;
    }
    
    // apply
    self.indicatorAttributes = indicatorAttributes;
    self.headerAttributes = headerAttributes;
    self.itemAttributes = itemAttributes;
    self.footerAttributes = footerAttributes;
    self.contentSize = CGSizeMake(pageWidth, y);
}

@end
