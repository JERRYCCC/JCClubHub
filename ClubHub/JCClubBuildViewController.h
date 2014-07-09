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


@property (strong, nonatomic) IBOutlet UISwitch *sororitySwitch;
@property (strong, nonatomic) IBOutlet UISwitch *fraternitySwitch;
@property (strong, nonatomic) IBOutlet UISwitch *academicSwitch;




-(IBAction)buildBtn:(id)sender;
-(IBAction)cancelBtn:(id)sender;

@end
