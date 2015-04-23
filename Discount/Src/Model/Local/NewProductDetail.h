//
//  NewProductDetail.h
//  Discount
//
//  Created by fengfeng on 15/3/17.
//  Copyright (c) 2015年 wanjiahui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class NewProductImages;

@interface NewProductDetail : NSManagedObject

@property (nonatomic, retain) NSString * brand;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * price1;
@property (nonatomic, retain) NSString * price2;
@property (nonatomic, retain) NSString * artNo;
@property (nonatomic, retain) NSString * color;
@property (nonatomic, retain) NSString * intro;
@property (nonatomic, retain) NSNumber * isFavorite;
@property (nonatomic, retain) NSNumber * shopID;
@property (nonatomic, retain) NSNumber * goodsID;
@property (nonatomic, retain) NSOrderedSet *images;
@end

@interface NewProductDetail (CoreDataGeneratedAccessors)

- (void)insertObject:(NewProductImages *)value inImagesAtIndex:(NSUInteger)idx;
- (void)removeObjectFromImagesAtIndex:(NSUInteger)idx;
- (void)insertImages:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeImagesAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInImagesAtIndex:(NSUInteger)idx withObject:(NewProductImages *)value;
- (void)replaceImagesAtIndexes:(NSIndexSet *)indexes withImages:(NSArray *)values;
- (void)addImagesObject:(NewProductImages *)value;
- (void)removeImagesObject:(NewProductImages *)value;
- (void)addImages:(NSOrderedSet *)values;
- (void)removeImages:(NSOrderedSet *)values;
@end
