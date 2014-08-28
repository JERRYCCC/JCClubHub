//
//  JCPostCreateViewController.h
//  ClubHub
//
//  Created by Jerry on 7/25/14.
//  Copyright (c) 2014 JC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@class JCPostCreateViewController;

@protocol JCPostCreateViewControllerDelegate <NSObject>

-(void)donePosting:(PFObject*) eventObject;

@end

@interface JCPostCreateViewController : UIViewController<UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIAlertViewDelegate, UITextFieldDelegate>


@property (strong, nonatomic) PFObject *currentEvent;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorView;

@property (assign, nonatomic) id <JCPostCreateViewControllerDelegate> delegate;


-(IBAction)cameraBtn:(id)sender;
-(IBAction)postBtn:(id)sender;



@end
