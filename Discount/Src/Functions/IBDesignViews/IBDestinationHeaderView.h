//
//  IBDestinationHeaderView.h
//  Discount
//
//  Created by jackyzeng on 3/21/15.
//  Copyright (c) 2015 wanjiahui. All rights reserved.
//

#import "IBDesignableView.h"

typedef NS_ENUM(NSInteger, E_DESITION) {
    E_DESITION_BEGIN = 1,
    E_DESITION_ASIA = E_DESITION_BEGIN,
    E_DESITION_EUROP,
    E_DESITION_NORTH_AMERICA,
    E_DESITION_AUSTRALIA,
    
    E_DESITION_END
};

@protocol DestinationHeaderViewDelegate;

@interface IBDestinationHeaderView : IBDesignableView

@property(nonatomic, weak) IBOutlet id<DestinationHeaderViewDelegate> delegate;
@property(nonatomic) E_DESITION dest;
@property(nonatomic) BOOL shouldHideMarkLine; // default is YES

- (void)setDest:(E_DESITION)dest animated:(BOOL)animated;

@end

@protocol DestinationHeaderViewDelegate <NSObject>

@optional
- (void)view:(IBDestinationHeaderView *)view didSelectDestination:(E_DESITION)destination;

@end
