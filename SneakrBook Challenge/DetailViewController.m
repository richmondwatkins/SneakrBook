//
//  DetailViewController.m
//  SneakrBook Challenge
//
//  Created by Richmond on 10/22/14.
//  Copyright (c) 2014 Richmond. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()
<UIImagePickerControllerDelegate, UINavigationControllerDelegate >

@property (strong, nonatomic) IBOutlet UIButton *saveButton;

@property (strong, nonatomic) IBOutlet UILabel *brandLabel;
@property (strong, nonatomic) IBOutlet UILabel *sizeLabel;
@property (strong, nonatomic) IBOutlet UILabel *colorLabel;
@property (strong, nonatomic) IBOutlet UIButton *addFriendButton;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UIButton *addImageButton;
@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.selectedPerson[@"name"];
    self.brandLabel.text = self.selectedPerson[@"sneaker"][@"brand"];
    self.sizeLabel.text = [self.selectedPerson[@"sneaker"][@"size"] stringValue];
    self.colorLabel.text = self.selectedPerson[@"sneaker"][@"color"];
    self.saveButton.hidden = YES;
    if (self.isFriend) {
        self.saveButton.hidden = NO;
        self.addFriendButton.hidden = YES;
    }
    if (self.sneakerImage) {
        self.imageView.image = self.sneakerImage;
    }
}


- (IBAction)addPhoto:(UIButton *)sender {

        [sender setTitle:@"Add Image" forState:UIControlStateNormal];
        UIImagePickerController* imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        } else {
            imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        }

        [self presentViewController:imagePicker animated:YES completion:^{
            
        }];

}
- (IBAction)saveImage:(UIButton *)button {
    if (self.imageView.image) {
        [self.delegate onSaveButtonTapped:self.selectedPerson withImage:(UIImage *)self.imageView.image];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:^{

    }];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    [self dismissModalViewControllerAnimated:YES];


    self.imageView.image = image; //image view from storyboard
}

- (IBAction)addFriendButtonTapped:(id)sender {
    [self.delegate onAddFriendButtonTapped:self.selectedPerson];
}

@end
