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
    _tagsTextView.text = (@"tag your club\n");
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
    [self tagAction:@"Sorrority\n" withMark:sBtn];
    sBtn=!sBtn;
}
-(IBAction)fraternityBtn:(id)sender
{
    [self tagAction:@"Freternity\n" withMark:fBtn];
    fBtn=!fBtn;
}
-(IBAction)academicBtn:(id)sender
{
    [self tagAction:@"Academic\n" withMark:aBtn];
    aBtn=!aBtn;
}

-(void)tagAction:(NSString*)name withMark:(BOOL)mark
{
    if(!mark){
        [tagList addObject:name];
        
        [_tagsTextView insertText:@"+ "];
        
    }else{
        NSUInteger index = [tagList indexOfObjectIdenticalTo:name];
        [tagList removeObjectAtIndex:index];
        [_tagsTextView insertText:@"- "];
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
    if(tagList==NULL)
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
    NSString *schoolName = [targetSchool[@"name"] stringByReplacingOccurrencesOfString:@" " withString:@"_"];
    NSString *targetClassName = [schoolName stringByAppendingString:@"_Club"];
    //NSLog(targetClassName);
    
    PFObject *newClub = [PFObject objectWithClassName: targetClassName];
    newClub[@"name"] = _nameField.text;
    newClub[@"email"] = _emailField.text;
    newClub[@"password"] = _passwordField.text;
    newClub[@"school"] = [PFObject objectWithoutDataWithClassName:@"School" objectId:schoolId];
    
    [newClub saveInBackgroundWithBlock: ^(BOOL succeeded, NSError *error){
        if (!error) {
            NSLog(@"Build success!");
            _nameField.text = nil;
            _passwordField.text = nil;
            _reEnterPasswordField.text = nil;
            _emailField.text = nil;
            //[self performSequeWithIdentifier:@"clubLogIn" sender:self];
        }else{
            NSLog(@"There was an error in building club");
        }
    }];
}




@end
