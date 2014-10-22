//
//  User.h
//  SneakrBook Challenge
//
//  Created by Richmond on 10/22/14.
//  Copyright (c) 2014 Richmond. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface User : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *sneakers;
@end

@interface User (CoreDataGeneratedAccessors)

- (void)addSneakersObject:(NSManagedObject *)value;
- (void)removeSneakersObject:(NSManagedObject *)value;
- (void)addSneakers:(NSSet *)values;
- (void)removeSneakers:(NSSet *)values;

@end
