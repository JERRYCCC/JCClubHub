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
    
    NSRange range = [_usernameField.text rangeOfString:@"@"];
    NSString *username;
    
    if (range.location == NSNotFound) {
        
        NSLog(@"log in with username");
        //log in with username
        username = _usernameField.text;
        
    }else{

        NSLog(@"log in with email");
        //log in with email
        PFQuery *userList =[PFUser query];
        [userList whereKey:@"email" equalTo:_usernameField.text];
        PFObject *user = [userList getFirstObject];
        username = user[@"username"];
    }
    
    [PFUser logInWithUsernameInBackground:username
                                 password:_passwordField.text
                                    block:^(PFUser *user, NSError *error)
    {
        if (!error) {
            NSLog(@"Login user!");
            _passwordField.text = nil;
            _usernameField.text = nil;
            
            [self performSegueWithIdentifier:@"login" sender:self];
        }else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sorry" message:@"Please make sure you enter the right account or password" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
    }];
}

-(IBAction)resetBtn:(id)sender
{
    NSRange range = [_usernameField.text rangeOfString:@"@"];
    
    if(range.location == NSNotFound){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sorry"
                                                        message:@"Enter your email(.edu) please!"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        
    }else{
        
        
        [PFUser requestPasswordResetForEmailInBackground: _usernameField.text block:^(BOOL succeeded, NSError *error){
            
            if (!error) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Email sent"
                                                                message:@"Check your inbox and reset your passwrod"
                                                               delegate:self
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
                [alert show];
            } else {
                
                NSString *string = [error description];
                NSRange range = [string rangeOfString:@"error="];
                NSString *substring = [[string substringFromIndex:NSMaxRange(range)] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                substring = [substring stringByReplacingOccurrencesOfString:@"}" withString:@" "];
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sorry"
                                                                message:substring
                                                               delegate:self
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
                [alert show];
            }
            
        }];
    
    }
    
}




@end
