//
//  ShareItem.h
//  
//
//  Created by jackyzeng on 4/11/15.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface ShareItem : NSManagedObject

@property (nonatomic, retain) NSString * image;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * link;
@property (nonatomic, retain) NSString * content;
@property (nonatomic, retain) NSNumber * item_id;
@property (nonatomic, retain) NSNumber * event_id;
@property (nonatomic, retain) NSNumber * guide_id;

@end
