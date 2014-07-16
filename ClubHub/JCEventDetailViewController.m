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

@implementation JCEventDetailViewController{
    NSString *cancelString;
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
    
    _nameLabel.text = (_currentEvent[@"name"]);
    
    NSDate *date=[_currentEvent objectForKey:@"date"];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"h:mm a  EEE, MMM-d"];
    _dateLabel.text = [formatter stringFromDate:date];
    
    _locationTextView.text = (_currentEvent[@"location"]);
    _locationTextView.editable = NO;
    
    _descriptionTextView.text = (_currentEvent[@"description"]);
    _descriptionTextView.editable=NO;

    
    if([self checkPriority]){
        _adminBtn.hidden = NO;
        _markBtn.hidden = YES;
    }else{
        _adminBtn.hidden = YES;
        _markBtn.hidden = NO;
        
        if([self markStatus]){
            _markBtn.titleLabel.text = @"Unmark";
        }else{
            _markBtn.titleLabel.text = @"Mark";
        }
    }
    
    if(_currentEvent[@"available"] == [NSNumber numberWithBool:YES]){
        cancelString = @"Cancel Event";
    }else{
         cancelString = @"Revive Event";
        _dateLabel.text = @"This event has been canceled.";
    }
    
     self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"greyBackground"]];
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
        
        if([adminsQuery countObjects]==0||adminsQuery==nil){
            return NO;
        }else{
            return YES;
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
        [self performSegueWithIdentifier:@"toMain" sender:self];
        
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
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Unmark" message:@"Are you sure to take the event off your list?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Unmark", nil];
        [alert show];
    }
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqualToString:@"toEventEdit"]){
        JCEventEditViewController* eventEditVC = [segue destinationViewController];
        eventEditVC.currentEvent = _currentEvent;
    }
}


-(IBAction)adminBtn:(id)sender
{
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Administration"
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                otherButtonTitles:@"Edit Event", cancelString, nil];
    
    [actionSheet showInView:self.view];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            [self performSegueWithIdentifier:@"toEventEdit" sender:self];
            break;
        
        case 1:
            if(_currentEvent[@"available"] == [NSNumber numberWithBool:YES]){
                
                _currentEvent[@"available"] = [NSNumber numberWithBool:NO];
                cancelString = @"Revive Event";
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oooopss!"
                                                                message:@"You have canceled this event"
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
                [alert show];
                _dateLabel.text = @"This event has been canceled.";
            }else{
                
                _currentEvent[@"available"] = [NSNumber numberWithBool:YES];
                cancelString = @"Cancel Event";
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Congratulation!"
                                                                message:@"You have revived this event"
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
                [alert show];
                
                NSDate *date=[_currentEvent objectForKey:@"date"];
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                [formatter setDateFormat:@"h:mm a  EEE, MMM-d"];
                _dateLabel.text = [formatter stringFromDate:date];
                
            }
            [_currentEvent saveInBackground];
            break;
            
        default:
            break;
    }
}

-(IBAction)backBtn:(id)sender;
{
    [self performSegueWithIdentifier:@"toMain" sender:self];
}

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    
    if([[alertView title] isEqualToString:@"Unmark"] && buttonIndex ==1){
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Done!"
                                                        message:@"You have unmark the event"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        
        [self performSegueWithIdentifier:@"toMain" sender:self];
    }
    
    
}

@end
