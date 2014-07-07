//
//  JCClubBuildViewController.m
//  ClubHub
//
//  Created by Jerry on 7/1/14.
//  Copyright (c) 2014 JC. All rights reserved.
//

#import "JCClubBuildViewController.h"
#import <Parse/Parse.h>

@interface JCClubBuildViewController ()

@end

@implementation JCClubBuildViewController{
    
    NSMutableArray *tagList;
    
    BOOL sBtn, fBtn, aBtn;
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
    _nameField.delegate = self;
    _emailField.delegate = self;
    _passwordField.delegate = self;
    _reEnterPasswordField.delegate = self;
    
    tagList = [[NSMutableArray alloc] init];
    _tagsTextView.text = (@"tag your club");
    [_tagsTextView setUserInteractionEnabled:NO];
    
    sBtn=NO;
    fBtn=NO;
    aBtn=NO;

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
    [_emailField resignFirstResponder];
    [_passwordField resignFirstResponder];
    [_reEnterPasswordField resignFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)sorrorityBtn:(id)sender
{
    [self tagAction:@"Sorrority" withMark:sBtn];
    sBtn=!sBtn;
}
-(IBAction)fraternityBtn:(id)sender
{
    [self tagAction:@"Freternity" withMark:fBtn];
    fBtn=!fBtn;
}
-(IBAction)academicBtn:(id)sender
{
    [self tagAction:@"Academic" withMark:aBtn];
    aBtn=!aBtn;
}

-(void)tagAction:(NSString*)name withMark:(BOOL)mark
{
    if(!mark){
        [tagList addObject:name];
        
        [_tagsTextView insertText:@"\n + "];
        
    }else{
        NSUInteger index = [tagList indexOfObjectIdenticalTo:name];
        [tagList removeObjectAtIndex:index];
        [_tagsTextView insertText:@"\n - "];
    }
    [_tagsTextView insertText:name];
    NSLog(@" %D", [tagList count]);
}

- (IBAction)buildBtn:(id)sender
{
    [_nameField resignFirstResponder];
    [_emailField resignFirstResponder];
    [_passwordField resignFirstResponder];
    [_reEnterPasswordField resignFirstResponder];
    [self checkFieldsComplete];
}

-(void) checkFieldsComplete{
    
    if([_nameField.text isEqualToString:@""]||
       [_emailField.text isEqualToString:@""] ||
       [_passwordField.text isEqualToString:@""] ||
       [_reEnterPasswordField.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oooopss!"
                                                        message:@"You need to complete all fields"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }else {
        [self checkPasswordsMatch];
    }
}

-(void) checkPasswordsMatch{
    if (![_passwordField.text isEqualToString:_reEnterPasswordField.text])
    {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Oooopss!"
                              message:@"Passwords don't match"
                              delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
    }
    else {
        [self checkTags];
    }
}

-(void) checkTags{

    if(tagList== nil || [tagList count]==0)
    {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Oooopss!"
                              message:@"Pick at least one tags for your club"
                              delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
    }
    else {
        [self registerNewClub];
    }
}

-(void) registerNewClub
{
    
    NSLog (@"buiding......");
    PFObject *targetSchool = [PFUser currentUser] [@"school"];
    [targetSchool fetchIfNeeded];
    NSString *schoolId = targetSchool.objectId;
   
    
    PFObject *newClub = [PFObject objectWithClassName: @"Club"];
    newClub[@"name"] = _nameField.text;
    newClub[@"email"] = _emailField.text;
    newClub[@"password"] = _passwordField.text;
    newClub[@"school"] = [PFObject objectWithoutDataWithClassName:@"School" objectId:schoolId];
    newClub[@"tags"] = tagList;
    
    //the current user become the club administer automatically when he builds the club
    PFUser *user = [PFUser currentUser];
    PFRelation *adminRelation = [newClub relationForKey:@"admins"];
    [adminRelation addObject:user];
    
    [newClub saveInBackgroundWithBlock: ^(BOOL succeeded, NSError *error){
        if (!error) {
            
            //current user follows the club he built immediately
            PFRelation *followRleaion = [user relationForKey:@"followClubs"];
            [followRleaion addObject:newClub];
            [user saveInBackground];
             
            NSLog(@"Build success!");
            _nameField.text = nil;
            _passwordField.text = nil;
            _reEnterPasswordField.text = nil;
            _emailField.text = nil;
            _tagsTextView.text = nil;
            
            [self performSegueWithIdentifier:@"toMain" sender:self];
            
        }else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ooops!" message:@"Sorry we had a problem building you a club" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
    }];
}

-(void) cancelBtn:(id)sender
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ooops!" message:@"Are you sure to cancel?" delegate:self cancelButtonTitle:@"Keep Building" otherButtonTitles:@"Give Up", nil];
    [alert show];
}

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex ==1){
        [self performSegueWithIdentifier:@"toMain" sender:self];
    }
}



@end
