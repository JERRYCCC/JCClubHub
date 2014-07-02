//
//  JCEventCreateViewController.m
//  ClubHub
//
//  Created by Jerry on 7/2/14.
//  Copyright (c) 2014 JC. All rights reserved.
//

#import "JCEventCreateViewController.h"
#import <Parse/Parse.h>

@interface JCEventCreateViewController ()

@end

@implementation JCEventCreateViewController

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
    _nameField.delegate = self;
    _locationField.delegate = self;
    _descriptionView.delegate = self;
    
    _descriptionView.text = _targetClub[@"name"];
}

-(BOOL)textFieldShouldReturn:(UITextField*) textField{
    if(textField){
        [textField resignFirstResponder];
    }
    return NO;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_nameField resignFirstResponder];
    [_locationField resignFirstResponder];
    [_descriptionView resignFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(IBAction)createBtn:(id)sender
{
    [_nameField resignFirstResponder];
    [_locationField resignFirstResponder];
    [_descriptionView resignFirstResponder];
    [_datePicker resignFirstResponder];
    [self checkFieldsComplete];
}

-(void)checkFieldsComplete
{
    if([_nameField.text isEqualToString:@""]||
       [_locationField.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oooopss!"
                                                        message:@"You need to complete all fields"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }else {
        [self createNewEvent];
    }
    
}

-(void)createNewEvent
{
    NSLog(@"Creating.........");
    //PFObject *targetClub =
}


-(void) cancelBtn:(id)sender
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ooops!" message:@"Are you sure to cancel?" delegate:self cancelButtonTitle:@"Keep Creating" otherButtonTitles:@"Give Up", nil];
    [alert show];
}

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex ==1){
        [self performSegueWithIdentifier:@"segueToTabBar" sender:self];
    }
}



@end
