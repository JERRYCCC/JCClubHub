//
//  JCEventEditViewController.m
//  ClubHub
//
//  Created by Jerry on 7/9/14.
//  Copyright (c) 2014 JC. All rights reserved.
//

#import "JCEventEditViewController.h"
#import "JCEventDetailViewController.h"

@interface JCEventEditViewController ()

@end

@implementation JCEventEditViewController

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
    
    _nameField.text = _currentEvent[@"name"];
    _locationField.text = _currentEvent[@"location"];
    _descriptionView.text = _currentEvent[@"description"];
    _datePicker.date = _currentEvent[@"date"];
}

-(BOOL)prefersStatusBarHidden
{
    return NO;
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

-(IBAction)saveBtn:(id)sender
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
        [self saveEvent];
    }
    
}

-(void) saveEvent
{
    
    _currentEvent[@"name"] = _nameField.text;
    _currentEvent[@"location"] = _locationField.text;
    _currentEvent[@"description"] = _descriptionView.text;
    _currentEvent[@"date"] = _datePicker.date;
    
    [_currentEvent saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
        
        if(!error){
            [self.delegate doneEditing:_currentEvent];
            
        }else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ooops!" message:@"Sorry we had a problem saving this event" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
    }];
}


-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex ==1){
        [self performSegueWithIdentifier:@"toEventDetail" sender:self];
    }
}

//moving the view when edit
-(void)textViewDidBeginEditing:(UITextView*)textView
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.2];
    [UIView setAnimationBeginsFromCurrentState:YES];
    self.view.frame = CGRectMake(self.view.frame.origin.x, (self.view.frame.origin.y - 95.0), self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
}

-(void)textViewDidEndEditing:(UITextView*)textView
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.2];
    [UIView setAnimationBeginsFromCurrentState:YES];
    self.view.frame = CGRectMake(self.view.frame.origin.x, (self.view.frame.origin.y + 95.0), self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
}


@end
