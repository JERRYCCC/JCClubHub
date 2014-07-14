//
//  JCEventCreateViewController.m
//  ClubHub
//
//  Created by Jerry on 7/2/14.
//  Copyright (c) 2014 JC. All rights reserved.
//

#import "JCEventCreateViewController.h"
#import "JCEventDetailViewController.h"
#import <Parse/Parse.h>

@interface JCEventCreateViewController ()

@end

@implementation JCEventCreateViewController
{
    PFObject *newEvent;
    BOOL ava;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        _datePicker = [[UIDatePicker alloc] init];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _nameField.delegate = self;
    _locationField.delegate = self;
    _descriptionView.delegate = self;
    
    _descriptionView.text = [@"Add some details about the event.\n\nBy: " stringByAppendingString: _targetClub[@"name"]];
    
    //the user can only build an event for one hour later
    NSDate *currrentTime = [NSDate date];
    [_datePicker setMinimumDate:[currrentTime dateByAddingTimeInterval:60*60]];
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
    
    newEvent = [PFObject objectWithClassName:@"Event"];
    newEvent[@"name"] = _nameField.text;
    newEvent[@"location"] = _locationField.text;
    newEvent[@"description"] = _descriptionView.text;
    newEvent[@"date"] = _datePicker.date;
    newEvent[@"club"] = _targetClub;
    newEvent[@"school"] =_targetClub[@"school"];
    newEvent[@"available"] = [NSNumber numberWithBool:YES]; //set the event is available when it is built
    
    
    [newEvent saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
        
        if(!error){
            
            //current user marks the event he create immediately
            PFUser *user = [PFUser currentUser];
            PFRelation *followRelation = [user relationForKey:@"markEvents"];
            [followRelation addObject:newEvent];
            [user saveInBackground];
            
            NSLog(@"Create success!");
            _nameField.text = nil;
            _locationField.text = nil;
            _descriptionView.text = nil;
            
            [self performSegueWithIdentifier:@"toEventDetail" sender:self];
            
        }else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ooops!" message:@"Sorry we had a problem creating an event" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
    }];
}


-(void) cancelBtn:(id)sender
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ooops!" message:@"Are you sure to cancel?" delegate:self cancelButtonTitle:@"Keep Creating" otherButtonTitles:@"Give Up", nil];
    [alert show];
}

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex ==1){
        [self performSegueWithIdentifier:@"toMain" sender:self];
    }
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqualToString:@"toEventDetail"]){
        JCEventDetailViewController *eventDetailViewController = [segue destinationViewController];
        eventDetailViewController.currentEvent = newEvent;
    }
}




@end
