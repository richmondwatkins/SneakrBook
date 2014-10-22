//
//  DetailViewController.m
//  SneakrBook Challenge
//
//  Created by Richmond on 10/22/14.
//  Copyright (c) 2014 Richmond. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()
@property (strong, nonatomic) IBOutlet UILabel *brandLabel;
@property (strong, nonatomic) IBOutlet UILabel *sizeLabel;
@property (strong, nonatomic) IBOutlet UILabel *colorLabel;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.selectedPerson[@"name"];
    self.brandLabel.text = self.selectedPerson[@"sneaker"][@"brand"];
    self.sizeLabel.text = [self.selectedPerson[@"sneaker"][@"size"] stringValue];
    self.colorLabel.text = self.selectedPerson[@"sneaker"][@"color"];
}


- (IBAction)addFriendButtonTapped:(id)sender {
    [self.delegate onAddFriendButtonTapped:self.selectedPerson];
}

@end
