//
//  JCRegisterViewController.m
//  ClubHub
//
//  Created by Jerry on 6/29/14.
//  Copyright (c) 2014 JC. All rights reserved.
//

#import "JCRegisterViewController.h"
#import <Parse/Parse.h>
#import "JCSchoolForRegister.h"

@interface JCRegisterViewController ()

@end

@implementation JCRegisterViewController{
    int pickRow;
    JCSchoolForRegister *sfr;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        
        
    }
    return self;
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    //Hiding the keyboard
    _usernameField.delegate = self;
    _emailField.delegate = self;
    _passwordField.delegate = self;
    _reEnterPasswordField.delegate = self;
    
    sfr = [[JCSchoolForRegister alloc] init];
    _schoolNameList = [sfr getSchoolNameList];
    
    
}


-(BOOL)textFieldShouldReturn:(UITextField*) textField{
    if(textField){
        [textField resignFirstResponder];
    }
    return NO;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_usernameField resignFirstResponder];
    [_emailField resignFirstResponder];
    [_passwordField resignFirstResponder];
    [_reEnterPasswordField resignFirstResponder];
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
    if ([_usernameField.text isEqualToString:@""] ||
        [_emailField.text isEqualToString:@""] ||
        [_passwordField.text isEqualToString:@""] ||
        [_reEnterPasswordField.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oooopss!" message:@"You need to complete all fields" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    else {
        [self checkPasswordsMatch];
    }
}

-(void) checkPasswordsMatch{
    if (![_passwordField.text isEqualToString:_reEnterPasswordField.text]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oooopss!" message:@"Passwords don't match" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    else {
        [self checkDomain];
    }
}

-(void) checkDomain{
    
    NSString *string = _emailField.text;
    NSRange range = [string rangeOfString:@"@"];
    
    if ([string rangeOfString:@"@"].location == NSNotFound){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oooopss!" message:@"Please enter a valid email address" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }else{
        NSString* domainName = [[string substringFromIndex:NSMaxRange(range)] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
        if([[sfr getSchoolDomain:pickRow] isEqualToString: domainName]){
            [self registerNewUser];
        }else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oooopss!" message:@"School don't match your email" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
    }
}


-(void) registerNewUser{
    NSLog(@"registering...");
    PFUser *newUser = [PFUser user];
    newUser.username = _usernameField.text;
    newUser.email = _emailField.text;
    newUser.password = _passwordField.text;
    
    NSString *schoolId = [sfr getSchoolId:pickRow];
    newUser[@"school"] = [PFObject objectWithoutDataWithClassName:@"School" objectId:schoolId];
    
    
    [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if(!error) {
            NSLog(@"Registration success!");
            _usernameField.text = nil;
            _passwordField.text = nil;
            _reEnterPasswordField.text = nil;
            _emailField.text = nil;
            [self performSegueWithIdentifier:@"login" sender:self];
        }else{
            NSString *string = [error description];
            NSRange range = [string rangeOfString:@"error="];
            NSString *substring = [[string substringFromIndex:NSMaxRange(range)] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            substring = [substring stringByReplacingOccurrencesOfString:@"}" withString:@" :("];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ooops!" message:substring delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
    }];
}

-(NSInteger) numberOfComponentsInPickerView: (UIPickerView *) pickerView
{
    return 1;
}

-(NSInteger) pickerView:(UIPickerView*)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return _schoolNameList.count;
}

-(NSString*) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return _schoolNameList[row];
}

-(void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    pickRow = row;
}

- (IBAction)logInBtn:(id)sender
{
    [self performSegueWithIdentifier:@"toLogIn" sender:self];
}








@end
