//
//  HomeBourn.h
//  Discount
//
//  Created by jackyzeng on 3/21/15.
//  Copyright (c) 2015 wanjiahui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class HomeBournRegion;

@interface HomeBourn : NSManagedObject

@property (nonatomic, retain) NSNumber *bournId;
@property (nonatomic, retain) NSOrderedSet *regions;
@end

@interface HomeBourn (CoreDataGeneratedAccessors)

- (void)insertObject:(HomeBournRegion *)value inRegionsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromRegionsAtIndex:(NSUInteger)idx;
- (void)insertRegions:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeRegionsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInRegionsAtIndex:(NSUInteger)idx withObject:(HomeBournRegion *)value;
- (void)replaceRegionsAtIndexes:(NSIndexSet *)indexes withRegions:(NSArray *)values;
- (void)addRegionsObject:(HomeBournRegion *)value;
- (void)removeRegionsObject:(HomeBournRegion *)value;
- (void)addRegions:(NSOrderedSet *)values;
- (void)removeRegions:(NSOrderedSet *)values;
@end
