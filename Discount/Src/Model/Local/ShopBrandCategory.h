//
//  ShopBrandCategory.h
//  Discount
//
//  Created by jackyzeng on 3/21/15.
//  Copyright (c) 2015 wanjiahui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ShopBrandCategoryInfo, ShopBrandLetterInfo;

@interface ShopBrandCategory : NSManagedObject

@property (nonatomic, retain) NSNumber * hasCategory;
@property (nonatomic, retain) NSString * shopName;
@property (nonatomic, retain) NSNumber * shopId;
@property (nonatomic, retain) NSOrderedSet *categories;
@property (nonatomic, retain) NSOrderedSet *letters;
@end

@interface ShopBrandCategory (CoreDataGeneratedAccessors)

- (void)insertObject:(ShopBrandCategoryInfo *)value inCategoriesAtIndex:(NSUInteger)idx;
- (void)removeObjectFromCategoriesAtIndex:(NSUInteger)idx;
- (void)insertCategories:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeCategoriesAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInCategoriesAtIndex:(NSUInteger)idx withObject:(ShopBrandCategoryInfo *)value;
- (void)replaceCategoriesAtIndexes:(NSIndexSet *)indexes withCategories:(NSArray *)values;
- (void)addCategoriesObject:(ShopBrandCategoryInfo *)value;
- (void)removeCategoriesObject:(ShopBrandCategoryInfo *)value;
- (void)addCategories:(NSOrderedSet *)values;
- (void)removeCategories:(NSOrderedSet *)values;
- (void)insertObject:(ShopBrandLetterInfo *)value inLettersAtIndex:(NSUInteger)idx;
- (void)removeObjectFromLettersAtIndex:(NSUInteger)idx;
- (void)insertLetters:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeLettersAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInLettersAtIndex:(NSUInteger)idx withObject:(ShopBrandLetterInfo *)value;
- (void)replaceLettersAtIndexes:(NSIndexSet *)indexes withLetters:(NSArray *)values;
- (void)addLettersObject:(ShopBrandLetterInfo *)value;
- (void)removeLettersObject:(ShopBrandLetterInfo *)value;
- (void)addLetters:(NSOrderedSet *)values;
- (void)removeLetters:(NSOrderedSet *)values;
@end
