//
//  JCClubBuildDetailViewController.m
//  ClubHub
//
//  Created by Jerry on 7/9/14.
//  Copyright (c) 2014 JC. All rights reserved.
//

#import "JCClubBuildDetailViewController.h"
#import "JCClubDetailViewController.h"
#import <Parse/Parse.h>

@interface JCClubBuildDetailViewController ()

@end

@implementation JCClubBuildDetailViewController



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
    
    NSLog(@"%@",_currentClub[@"name"]);

    
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"Awesome!"
                          message:@"Your Club is built, you can add some description about your club here. :)"
                          delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil];
    [alert show];
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_detailTextView resignFirstResponder];
}

-(void) saveBtn:(id)sender
{
    _currentClub[@"description"] = _detailTextView.text;
    [_currentClub saveInBackground];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Save" message:@"You can find this club on your CREATE EVENT page now" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Got it", nil];
    [alert show];
}


-(void) cancelBtn:(id)sender
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Cancel Event" message:@"Are you sure to cancel?" delegate:self cancelButtonTitle:@"Keep Building" otherButtonTitles:@"Give Up", nil];
    [alert show];
    
}

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex ==1){
        
        [self performSegueWithIdentifier:@"toClubDetail" sender:self];
        
    }
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"toClubDetail"]) {
        
        JCClubDetailViewController *clubDetailVC = [segue destinationViewController];
        
        clubDetailVC.currentClub = _currentClub;
        
    }
}





@end
