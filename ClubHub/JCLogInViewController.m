//
//  JCLogInViewController.m
//  ClubHub
//
//  Created by Jerry on 6/29/14.
//  Copyright (c) 2014 JC. All rights reserved.
//

#import "JCLogInViewController.h"

@interface JCLogInViewController ()

@end

@implementation JCLogInViewController

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
   
    _usernameField.delegate = self;
    _passwordField.delegate = self;
}

//log in automatically
-(void)viewDidAppear:(BOOL)animated{
    PFUser *user = [PFUser currentUser];
    if(user.username !=nil){
        [self performSegueWithIdentifier:@"login" sender:self];
    }
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
    [_passwordField resignFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)loginButton:(id)sender {
    [PFUser logInWithUsernameInBackground:_usernameField.text password:_passwordField.text block:^(PFUser *user, NSError *error) {
        if (!error) {
            NSLog(@"Login user!");
            _passwordField.text = nil;
            _usernameField.text = nil;
            
            [self performSegueWithIdentifier:@"login" sender:self];
        }
        if (error) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sorry" message:@"Please make sure you enter the right account and password" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
    }];
}



@end
