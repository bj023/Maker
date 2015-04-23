//
//  BrandDetail+Helper.m
//  Discount
//
//  Created by jackyzeng on 4/12/15.
//  Copyright (c) 2015 wanjiahui. All rights reserved.
//

#import "BrandDetail+Helper.h"

@implementation BrandDetail (Helper)

- (void)setCoordsArray:(NSArray *)coordsArray {
    NSData *arrayData = [NSKeyedArchiver archivedDataWithRootObject:coordsArray];
    self.coords = arrayData;
}

- (NSArray *)coordsArray {
    return [NSKeyedUnarchiver unarchiveObjectWithData:self.coords];
}

@end
