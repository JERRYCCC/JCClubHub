//
//  JCClubBuildViewController.h
//  ClubHub
//
//  Created by Jerry on 7/1/14.
//  Copyright (c) 2014 JC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JCClubBuildViewController : UIViewController <UITextFieldDelegate, UIAlertViewDelegate>

@property (strong, nonatomic) IBOutlet UIButton *buildBtn;
@property (strong, nonatomic) IBOutlet UIButton *cancelBtn;

@property (strong, nonatomic) IBOutlet UITextField *nameField;
@property (strong, nonatomic) IBOutlet UITextField *emailField;
@property (strong, nonatomic) IBOutlet UITextField *passwordField;
@property (strong, nonatomic) IBOutlet UITextField *reEnterPasswordField;

@property (strong, nonatomic) IBOutlet UITextView *tagsTextView;
@property (strong, nonatomic) IBOutlet UIButton *sorrorityBtn;
@property (strong, nonatomic) IBOutlet UIButton *fraternityBtn;
@property (strong, nonatomic) IBOutlet UIButton *academicBtn;


-(IBAction)buildBtn:(id)sender;
-(IBAction)cancelBtn:(id)sender;
-(IBAction)sorrorityBtn:(id)sender;
-(IBAction)fraternityBtn:(id)sender;
-(IBAction)academicBtn:(id)sender;

@end