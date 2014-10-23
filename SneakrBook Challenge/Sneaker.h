//
//  Sneaker.h
//  
//
//  Created by Richmond on 10/22/14.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class User;

@interface Sneaker : NSManagedObject

@property (nonatomic, retain) NSString * brand;
@property (nonatomic, retain) NSString * color;
@property (nonatomic, retain) NSNumber * size;
@property (nonatomic, retain) NSData * photo;
@property (nonatomic, retain) User *user;

@end
