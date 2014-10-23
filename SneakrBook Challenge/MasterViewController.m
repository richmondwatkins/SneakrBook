//
//  MasterViewController.m
//  SneakrBook Challenge
//
//  Created by Richmond on 10/22/14.
//  Copyright (c) 2014 Richmond. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"
#import <YOLOKit/YOLO.h>
#import "CustomTableViewCell.h"
#import "User.h"
#import "Sneaker.h"
@interface MasterViewController ()<DetailControllerDelegate>
@property NSMutableArray *people;
@property NSArray *sneakerArray;
@property NSArray *friends;
@end

@implementation MasterViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];

    self.people = [NSMutableArray array];
    NSDictionary *sneaker1 = @{@"brand": @"Nike", @"color": @"red", @"size": @(10)};
    NSDictionary *sneaker2 = @{@"brand": @"Adidas", @"color": @"white", @"size": @(12)};
    NSDictionary *sneaker3 = @{@"brand": @"Reebok", @"color": @"blue", @"size": @(9)};
    NSDictionary *sneaker4 = @{@"brand": @"New Balance", @"color": @"green", @"size": @(11)};

    self.sneakerArray = @[sneaker1, sneaker2, sneaker3, sneaker4];

    self.navigationItem.leftBarButtonItem = self.editButtonItem;

    [self loadUsersFromWeb];
}

-(void)loadUsersFromWeb{
    NSURL *url = [NSURL URLWithString:@"http://s3.amazonaws.com/mobile-makers-assets/app/public/ckeditor_assets/attachments/18/friends.json"];
    NSURLSessionConfiguration *defaultConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:defaultConfig delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];

    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSArray *results = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];

        results.each(^(id n){
            NSMutableDictionary *person = [NSMutableDictionary new];

            [person setObject:n forKey:@"name"];

            NSDictionary *randomSneaker = self.sneakerArray.sample;
            [person setObject:randomSneaker forKey:@"sneaker"];
            [self.people addObject:person];

        });

        [self.tableView reloadData];
    }];

    [dataTask resume];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.people.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    NSDictionary *person = [self.people objectAtIndex:indexPath.row];

    cell.subTitleLabel.text = person[@"sneaker"][@"brand"];
    if (self.friends.count) {
        self.friends.each(^(User *n){
            if ([n.name isEqualToString:person[@"name"]]) {
                NSArray *tempArray = [n.sneakers allObjects];
                Sneaker *sneaker = tempArray[0];
                cell.subTitleLabel.text = sneaker.brand;
                cell.addFriendButton.text =  @"";
            }
        });
    }

    cell.leftDetailLabel.text = person[@"name"];
    return cell;
}

-(void)onAddFriendButtonTapped:(NSDictionary *)friend{
    User *user = [NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:self.managedObjectContext];
    user.name = friend[@"name"];

    Sneaker *sneaker = [NSEntityDescription insertNewObjectForEntityForName:@"Sneaker" inManagedObjectContext:self.managedObjectContext];
    sneaker.color = friend[@"sneaker"][@"color"];
    sneaker.brand = friend[@"sneaker"][@"brand"];
    sneaker.size = friend[@"sneaker"][@"size"];
    [user addSneakersObject:sneaker];

    [self.managedObjectContext save:nil];
    [self.managedObjectContext save:nil];

}

-(void)onSaveButtonTapped:(NSDictionary *)friend withImage:(UIImage *)image{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Sneaker"];
    NSArray *results = [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];

    results.each(^(Sneaker *n){
        if ([n.brand isEqualToString:friend[@"sneaker"][@"brand"]]) {
            NSData *imageData = UIImagePNGRepresentation(image);
            n.photo = imageData;
            [self.managedObjectContext save:nil];
            [self loadData];
        }
    });
}

-(void)loadData{
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"User"];
    NSArray *results  = [self.managedObjectContext executeFetchRequest:request error:nil];
    self.friends = results;
    [self.tableView reloadData];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    DetailViewController *detailViewCtrl = segue.destinationViewController;
    detailViewCtrl.delegate = self;
    NSDictionary *selectedPerson = [self.people objectAtIndex:self.tableView.indexPathForSelectedRow.row];
    detailViewCtrl.isFriend = NO;
        if (self.friends.count) {
            for(User *n in self.friends){
                if ([n.name isEqualToString:selectedPerson[@"name"]]) {
                    NSArray *tempArray = [n.sneakers allObjects];
                    Sneaker *sneaker = tempArray[0];
                    selectedPerson = @{@"name":n.name , @"sneaker": @{@"brand": sneaker.brand, @"color": sneaker.color, @"size": sneaker.size}};
                    detailViewCtrl.isFriend = YES;
                    detailViewCtrl.sneakerImage = [UIImage imageWithData:sneaker.photo];
                }
            }
        }

    detailViewCtrl.selectedPerson = selectedPerson;
}

-(void)viewDidAppear:(BOOL)animated{
    [self loadData];
}


@end
