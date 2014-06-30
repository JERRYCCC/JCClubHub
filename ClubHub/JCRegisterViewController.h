//
//  JCRegisterViewController.h
//  ClubHub
//
//  Created by Jerry on 6/29/14.
//  Copyright (c) 2014 JC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface JCRegisterViewController : UIViewController <UIPickerViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITextField *usernameField;
@property (strong, nonatomic) IBOutlet UITextField *emailField;
@property (strong, nonatomic) IBOutlet UITextField *passwordField;
@property (strong, nonatomic) IBOutlet UITextField *reEnterPasswordField;
@property (strong, nonatomic) IBOutlet UIPickerView *schoolPicker;

@property (strong, nonatomic) NSMutableArray *schoolName;

@property (weak, nonatomic) UIButton *registerBtn;

- (IBAction)registerAction:(id)sender;


@end
