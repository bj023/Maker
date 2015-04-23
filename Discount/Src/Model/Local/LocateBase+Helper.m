//
//  LocateBase+Helper.m
//  Discount
//
//  Created by jackyzeng on 3/28/15.
//  Copyright (c) 2015 wanjiahui. All rights reserved.
//

#import "LocateBase+Helper.h"

@implementation LocateBase (Helper)

- (void)setServicesArray:(NSArray *)servicesArray {
    NSData *arrayData = [NSKeyedArchiver archivedDataWithRootObject:servicesArray];
    self.services = arrayData;
}

- (NSArray *)servicesArray {
    return [NSKeyedUnarchiver unarchiveObjectWithData:self.services];
}

- (void)setFloorsArray:(NSArray *)floorsArray {
    NSData *arrayData = [NSKeyedArchiver archivedDataWithRootObject:floorsArray];
    self.floors = arrayData;
}

- (NSArray *)floorsArray {
    return [NSKeyedUnarchiver unarchiveObjectWithData:self.floors];
}

- (void)setCoordsArray:(NSArray *)coordsArray {
    NSData *arrayData = [NSKeyedArchiver archivedDataWithRootObject:coordsArray];
    self.coords = arrayData;
}

- (NSArray *)coordsArray {
    return [NSKeyedUnarchiver unarchiveObjectWithData:self.coords];
}

@end
