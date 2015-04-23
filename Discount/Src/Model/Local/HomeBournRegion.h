//
//  HomeBournRegion.h
//  Discount
//
//  Created by jackyzeng on 3/22/15.
//  Copyright (c) 2015 wanjiahui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class HomeBourn, HomeBournShop;

@interface HomeBournRegion : NSManagedObject

@property (nonatomic, retain) NSString * region;
@property (nonatomic, retain) HomeBourn *bourn;
@property (nonatomic, retain) NSOrderedSet *shops;
@end

@interface HomeBournRegion (CoreDataGeneratedAccessors)

- (void)insertObject:(HomeBournShop *)value inShopsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromShopsAtIndex:(NSUInteger)idx;
- (void)insertShops:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeShopsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInShopsAtIndex:(NSUInteger)idx withObject:(HomeBournShop *)value;
- (void)replaceShopsAtIndexes:(NSIndexSet *)indexes withShops:(NSArray *)values;
- (void)addShopsObject:(HomeBournShop *)value;
- (void)removeShopsObject:(HomeBournShop *)value;
- (void)addShops:(NSOrderedSet *)values;
- (void)removeShops:(NSOrderedSet *)values;
@end
