//
//  JCEventDetailViewController.m
//  ClubHub
//
//  Created by Jerry on 6/30/14.
//  Copyright (c) 2014 JC. All rights reserved.
//

#import "JCEventDetailViewController.h"
#import "JCEventEditViewController.h"


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

    if([self markStatus]){
        _markBtn.titleLabel.text = @"Unmark";
    }else{
        _markBtn.titleLabel.text = @"Mark";
    }
    
    if([self checkPriority]){
        _deleteBtn.hidden = NO;
        _editBtn.hidden = NO;
    }else{
        _deleteBtn.hidden =YES;
        _editBtn.hidden = YES;
    }

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
        [_currentEvent delete];
        
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

-(BOOL)markStatus
{
    PFUser *user = [PFUser currentUser];
    [user fetchIfNeeded];
    PFRelation *relation = [user relationForKey:@"markEvents"];
    PFQuery *eventList = [relation query];
    [eventList whereKey:@"objectId" equalTo:_currentEvent.objectId];
    
    if([eventList countObjects]==0){
        return NO;
    }else{
        return YES;
    }
}

-(IBAction)markBtn:(id)sender
{
    
    PFUser *user = [PFUser currentUser];
    [user fetchIfNeeded];
    PFRelation *relation = [user relationForKey:@"markEvents"];
    
    //mark the event, else unmark the events
    
    if (![self markStatus]) {
        [relation addObject:_currentEvent];
        [user saveInBackground];
        [sender setTitle:@"Unmark" forState:UIControlStateNormal];
    }else{
        [relation removeObject:_currentEvent];
        [user saveInBackground];
        [sender setTitle:@"Mark" forState:UIControlStateNormal];
    }
}

-(IBAction)editBtn:(id)sender
{
    [self performSegueWithIdentifier:@"toEventEdit" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqualToString:@"toEventEdit"]){
        JCEventEditViewController* eventEditVC = [segue destinationViewController];
        eventEditVC.currentEvent = _currentEvent;
    }
}

@end
