//
//  JCClubBuildViewController.m
//  ClubHub
//
//  Created by Jerry on 7/1/14.
//  Copyright (c) 2014 JC. All rights reserved.
//

#import "JCClubBuildViewController.h"
#import "JCClubBuildDetailViewController.h"
#import <Parse/Parse.h>

@interface JCClubBuildViewController ()

@end

@implementation JCClubBuildViewController{
    PFObject *newClub;
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
    
    _sororitySwitch.on = NO;
    _fraternitySwitch.on = NO;
    _academicSwitch.on = NO;
    _sportsSwitch.on = NO;
    _culturalSwitch.on = NO;
    _religiousSwitch.on = NO;

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


- (IBAction)buildBtn:(id)sender
{
    
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

    if(_sororitySwitch.on==NO
       && _fraternitySwitch.on==NO
       && _academicSwitch.on==NO
       && _sportsSwitch.on == NO
       && _culturalSwitch.on ==NO
       && _religiousSwitch.on == NO)
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
        [self checkUniqeness];
    }
}

-(void) checkUniqeness
{
    PFQuery *query = [PFQuery queryWithClassName:@"Club"];
    [query whereKey:@"name" equalTo:_nameField.text];
    NSArray *clubList = [query findObjects];
    
    NSLog(@"%d", [clubList count]);
    
    if([clubList count]==0||clubList==nil){
        //build the club
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Congratulation"
                                                        message:@"Want to build this club now?"
                                                       delegate:self
                                              cancelButtonTitle:@"Cancel"
                                              otherButtonTitles:@"Build", nil];
        [alert show];
    }else{
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Oooopss!"
                              message:@"Club Name has been taken"
                              delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
    }
}

-(void) registerNewClub
{
    
    NSLog (@"buiding......");
    PFObject *targetSchool = [PFUser currentUser] [@"school"];
    [targetSchool fetchIfNeeded];
    NSString *schoolId = targetSchool.objectId;
    
    
    NSMutableArray *tagList = [[NSMutableArray alloc] init];
    if(_sororitySwitch.on==YES){
        [tagList addObject:@"Sorority"];
    }
    if(_fraternitySwitch.on==YES){
        [tagList addObject:@"Fraternity"];
    }
    if(_academicSwitch.on==YES){
        [tagList addObject:@"Academic"];
    }
    if(_sportsSwitch.on == YES){
        [tagList addObject:@"Sports"];
    }
    if(_culturalSwitch.on == YES){
        [tagList addObject:@"Cultural"];
    }
    if(_religiousSwitch.on == YES){
        [tagList addObject:@"Religious"];
    }
    
    newClub = [PFObject objectWithClassName: @"Club"];
    newClub[@"name"] = _nameField.text;
    newClub[@"email"] = _emailField.text;
    newClub[@"password"] = _passwordField.text;
    newClub[@"school"] = [PFObject objectWithoutDataWithClassName:@"School" objectId:schoolId];
    newClub[@"tags"] = tagList;
    newClub[@"followerNum"] = [NSNumber numberWithInt:1];
    
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
            
            [self performSegueWithIdentifier:@"toDetail" sender:self];
            
        }else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ooops!" message:@"Sorry we had a problem building you a club" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
            [alert show];
        }
    }];
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if ([[segue identifier] isEqualToString:@"toDetail"]) {
        
        JCClubBuildDetailViewController *detailVC = [segue destinationViewController];
        detailVC.currentClub = newClub;
    }
    
}

-(void) cancelBtn:(id)sender
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Cancel Event" message:@"Are you sure to cancel?" delegate:self cancelButtonTitle:@"Keep Building" otherButtonTitles:@"Give Up", nil];
    [alert show];
}

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    
    if([[alertView title] isEqualToString:@"Congratulation"] && buttonIndex ==1){
        
        [self registerNewClub];
    }
    
    if([[alertView title] isEqualToString:@"Cancel Event"] && buttonIndex ==1){
        
        [self performSegueWithIdentifier:@"toMain" sender:self];
        
    }
}


@end
