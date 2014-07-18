//
//  JCClubEditViewController.m
//  ClubHub
//
//  Created by Jerry on 7/18/14.
//  Copyright (c) 2014 JC. All rights reserved.
//

#import "JCClubEditViewController.h"
#import "JCClubDetailViewController.h"

@interface JCClubEditViewController ()

@end

@implementation JCClubEditViewController

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
    _descriptionView.delegate = self;
    
    _nameField.text = _currentClub[@"name"];
    _descriptionView.text = _currentClub[@"description"];
    NSArray *tagList = _currentClub[@"tags"];
    
    if([tagList containsObject:@"Academic"]){
        _academicSwitch.on = YES;
    }else{
        _academicSwitch.on = NO;
    }
    
    if([tagList containsObject:@"Sorority"]){
        _sororitySwitch.on = YES;
    }else{
        _sororitySwitch.on = NO;
    }
    
    if([tagList containsObject:@"Fraternity"]){
        _fraternitySwitch.on = YES;
    }else{
        _fraternitySwitch.on = NO;
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
    [_nameField resignFirstResponder];
    [_descriptionView resignFirstResponder];
}

-(IBAction)saveBtn:(id)sender
{
    [self checkFieldsComplete];
}

-(void) checkFieldsComplete{
    
    if([_nameField.text isEqualToString:@""]||[_descriptionView.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oooopss!"
                                                        message:@"You need to complete all fields"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }else {
        [self checkTags];
    }
}


-(void) checkTags{
    
    if(_sororitySwitch.on==NO && _fraternitySwitch.on==NO && _academicSwitch.on==NO)
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
                                                        message:@"Want to save this club now?"
                                                       delegate:self
                                              cancelButtonTitle:@"Cancel"
                                              otherButtonTitles:@"Save", nil];
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

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    
    if([[alertView title] isEqualToString:@"Congratulation"] && buttonIndex ==1){
        
        [self saveEditedClub];
    }
    
    if ([[alertView title] isEqualToString:@"Cancel Edit"]) {
        [self performSegueWithIdentifier:@"toClubDetail" sender:self];
    }
}


-(void)saveEditedClub
{
    
    NSLog(@"Saving......");
    
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
    
    _currentClub[@"name"] = _nameField.text;
    _currentClub[@"description"] = _descriptionView.text;
    _currentClub[@"tags"] = tagList;
    
    [_currentClub saveInBackgroundWithBlock: ^(BOOL succeeded, NSError *error){
        if (!error) {
            
            NSLog(@"save success!");
            
            [self performSegueWithIdentifier:@"toClubDetail" sender:self];
        }else{
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ooops!" message:@"Sorry we had a problem saving you a club" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            
            [alert show];
            
        }
    }];
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if ([[segue identifier] isEqualToString:@"toClubDetail"]) {
        
        JCClubDetailViewController *detailVC = [segue destinationViewController];
        detailVC.currentClub = _currentClub;
    }
    
}

-(void) cancelBtn:(id)sender
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Cancel Edit" message:@"Are you sure to cancel?" delegate:self cancelButtonTitle:@"Keep Editing" otherButtonTitles:@"Give Up", nil];
    [alert show];
}


@end
