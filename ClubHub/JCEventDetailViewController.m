//
//  JCEventDetailViewController.m
//  ClubHub
//
//  Created by Jerry on 6/30/14.
//  Copyright (c) 2014 JC. All rights reserved.
//

#import "JCEventDetailViewController.h"


@interface JCEventDetailViewController ()

@end

@implementation JCEventDetailViewController

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
    
    _nameLabel.text = (_currentEvent[@"name"]);
    
    NSDate *date=[_currentEvent objectForKey:@"date"];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"h:mm a           EEE, MMM-d"];
    _dateLabel.text = [formatter stringFromDate:date];
    
    _locationTextView.text = (_currentEvent[@"location"]);
    _locationTextView.editable = NO;
    
    _descriptionTextView.text = (_currentEvent[@"description"]);
    _descriptionTextView.editable=NO;


}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//to see if the event's club's admins field has the current user
-(BOOL) checkPriority{
    
    [_currentEvent[@"club"] fetchIfNeeded];
    PFObject *targetClub = _currentEvent[@"club"];
    
    PFRelation *relation = [targetClub relationForKey:@"admins"];
    PFQuery *adminsQuery = [relation query];
    
    PFUser *user = [PFUser currentUser];
    
    [adminsQuery whereKey:@"objectId" equalTo:user.objectId];
        
        if([adminsQuery countObjects]!=0){
            return YES;
        }else{
            return NO;
        }
}


-(IBAction)deleteBtn:(id)sender
{
    if([self checkPriority]){
        [_currentEvent deleteInBackground];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Done!"
                                                        message:@"Event is deleted"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        
        //go back to event list
        [self performSegueWithIdentifier:@"toEventList" sender:self];
        
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oooopss!"
                                                        message:@"You don't have to priority to delete this event"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    
    }
}



@end
