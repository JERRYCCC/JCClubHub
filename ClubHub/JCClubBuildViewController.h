//
//  JCClubBuildViewController.h
//  ClubHub
//
//  Created by Jerry on 7/1/14.
//  Copyright (c) 2014 JC. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JCClubBuildViewControllerDelegate <NSObject>

-(void) doneClubBuild;

@end

@interface JCClubBuildViewController : UIViewController <UITextFieldDelegate, UIAlertViewDelegate, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) IBOutlet UITextField *nameField;
@property (strong, nonatomic) IBOutlet UITextField *emailField;
@property (strong, nonatomic) IBOutlet UIButton *imageBtn;
@property (strong, nonatomic) IBOutlet UITextField *passwordField;
@property (strong, nonatomic) IBOutlet UITextField *reEnterPasswordField;
@property (strong, nonatomic) IBOutlet UITextView *detailTextView;


@property (strong, nonatomic) IBOutlet UISwitch *sororitySwitch;
@property (strong, nonatomic) IBOutlet UISwitch *fraternitySwitch;
@property (strong, nonatomic) IBOutlet UISwitch *academicSwitch;
@property (strong, nonatomic) IBOutlet UISwitch *sportsSwitch;
@property (strong, nonatomic) IBOutlet UISwitch *culturalSwitch;
@property (strong, nonatomic) IBOutlet UISwitch *religiousSwitch;

@property (assign, nonatomic) id <JCClubBuildViewControllerDelegate> delegate;


-(IBAction)saveBtn:(id)sender;
-(IBAction)imageBtn:(id)sender;

@end
