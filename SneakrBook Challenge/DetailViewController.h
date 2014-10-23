//
//  DetailViewController.h
//  SneakrBook Challenge
//
//  Created by Richmond on 10/22/14.
//  Copyright (c) 2014 Richmond. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DetailControllerDelegate <NSObject>

-(void)onAddFriendButtonTapped:(NSDictionary *)friend;
-(void)onSaveButtonTapped:(NSDictionary *)friend withImage:(UIImage *)image;
@end

@interface DetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;
@property NSDictionary *selectedPerson;
@property BOOL isFriend;
@property UIImage *sneakerImage;
@property id<DetailControllerDelegate> delegate;
@end

