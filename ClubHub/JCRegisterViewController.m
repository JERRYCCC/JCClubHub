//
//  JCRegisterViewController.m
//  ClubHub
//
//  Created by Jerry on 6/29/14.
//  Copyright (c) 2014 JC. All rights reserved.
//

#import "JCRegisterViewController.h"
#import <Parse/Parse.h>

@interface JCRegisterViewController ()

@end

@implementation JCRegisterViewController{
    
    int pickRow;
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    
    //Hiding the keyboard
    self.usernameField.delegate = self;
    self.emailField.delegate = self;
    self.passwordField.delegate = self;
    self.reEnterPasswordField.delegate = self;
    
    
    //getting the school list
    PFQuery *query = [PFQuery queryWithClassName:@"School"];
    [query orderByAscending:@"Name"];
    NSArray *schoolList = [query findObjects];
    int count = [query countObjects];
    
    _schoolName = [[NSMutableArray alloc] init];
    
    for(int i=0; i<count; i++){
        
        NSString *stringName = schoolList[i][@"Name"];
        
        [_schoolName addObject:stringName];
    }
}

-(BOOL)textFieldShouldReturn:(UITextField*) textField{
    [textField resignFirstResponder];
    return NO;
}
 
-(void)viewDidAppear:(BOOL)animated{
    PFUser *user = [PFUser currentUser];
    if(user.username !=nil){
        [self performSegueWithIdentifier:@"login" sender:self];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)registerAction:(id)sender{
    
    [_usernameField resignFirstResponder];
    [_emailField resignFirstResponder];
    [_passwordField resignFirstResponder];
    [_reEnterPasswordField resignFirstResponder];
    [_schoolPicker resignFirstResponder];
    [self checkFieldsComplete];
}

-(void) checkFieldsComplete{
    if ([_usernameField.text isEqualToString:@""] || [_emailField.text isEqualToString:@""] || [_passwordField.text isEqualToString:@""] || [_reEnterPasswordField.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oooopss!" message:@"You need to complete all fields" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    else {
        [self checkPasswordsMatch];
    }
}

-(void)checkSchoolMatchEmail{
    
}

-(void) checkPasswordsMatch{
    if (![_passwordField.text isEqualToString:_reEnterPasswordField.text]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oooopss!" message:@"Passwords don't match" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    else {
        [self registerNewUser];
    }
}

-(void) registerNewUser{
    NSLog(@"registering...");
    PFUser *newUser = [PFUser user];
    newUser.username = _usernameField.text;
    newUser.email = _emailField.text;
    newUser.password = _passwordField.text;
    
    //newUser.schoolId = query[pickRow][@"objectId"];    don't use the default user input method, connect to the table directely
    
    
    [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if(!error) {
            NSLog(@"Registration success!");
            _usernameField.text = nil;
            _passwordField.text = nil;
            _reEnterPasswordField.text = nil;
            _emailField.text = nil;
            [self performSegueWithIdentifier:@"login" sender:self];
        }
        else{
            NSLog(@"There was an error in registration");
        }
    }];
}

-(NSInteger) numberOfComponentsInPickerView: (UIPickerView *) pickerView
{
    return 1;
}

-(NSInteger) pickerView:(UIPickerView*)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return _schoolName.count;
}

-(NSString*) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return _schoolName[row];
}

-(void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    pickRow = row;
}









@end
