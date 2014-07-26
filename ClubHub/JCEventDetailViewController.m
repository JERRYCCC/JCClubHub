//
//  JCEventDetailViewController.m
//  ClubHub
//
//  Created by Jerry on 6/30/14.
//  Copyright (c) 2014 JC. All rights reserved.
//

#import "JCEventDetailViewController.h"
#import "JCEventEditViewController.h"
#import "JCPostCreateViewController.h"
#import "JCPostTableViewCell.h"
#import <Parse/Parse.h>


@interface JCEventDetailViewController ()

@end

@implementation JCEventDetailViewController{
    NSString *cancelString;
    NSArray *postList;
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
    }else{
        _adminBtn.hidden = YES;
    }
    
    if([self markStatus]){
        [_markBtn setTitle:@"Unmark" forState:UIControlStateNormal];
    }else{
        [_markBtn setTitle:@"Mark" forState:UIControlStateNormal];
    }
    
    
    if(_currentEvent[@"available"] == [NSNumber numberWithBool:YES]){
        cancelString = @"Cancel Event";
    }else{
         cancelString = @"Revive Event";
        _dateLabel.text = @"This event has been canceled.";
    }
    
    _markerNum.text = [[self getMarkerNum] stringValue];
    
    
    //get the post query related to currentEvent
    PFQuery *postQuery = [PFQuery queryWithClassName:@"Post"];
    [postQuery whereKey:@"event" equalTo:_currentEvent];
    [postQuery orderByDescending:@"createdAt"];
    postList = [postQuery findObjects];
}

//to see if the event's club's admins field has the current user
-(BOOL) checkPriority{
    
    //[_currentEvent[@"club"] fetchIfNeeded];
    PFObject *targetClub = _currentEvent[@"club"];
    
    PFRelation *relation = [targetClub relationForKey:@"admins"];
    PFQuery *adminsQuery = [relation query];
    
    PFUser *user = [PFUser currentUser];
    
    [adminsQuery whereKey:@"objectId" equalTo:user.objectId];
        
        if([adminsQuery getFirstObject]==nil||adminsQuery==nil){
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
    
    if([eventList getFirstObject]==nil||eventList==nil){
        return NO;
    }else{
        return YES;
    }
}

-(IBAction)markBtn:(id)sender
{
    
    PFUser *user = [PFUser currentUser];
    PFRelation *relation = [user relationForKey:@"markEvents"];
    
    //mark the event, else unmark the events
    
    if (![self markStatus]) {
        [relation addObject:_currentEvent];
        [user saveInBackground];
        [sender setTitle:@"Unmark" forState:UIControlStateNormal];
        
        int newNum = [[_currentEvent objectForKey:@"markerNum"] intValue] +1;
        [_currentEvent setObject:[NSNumber numberWithInt:newNum] forKey:@"markerNum"];
        [_currentEvent saveInBackground];
        [_markerNum setText:[_currentEvent[@"markerNum"] stringValue]];
        
        
    }else{
        [relation removeObject:_currentEvent];
        [user saveInBackground];
        [sender setTitle:@"Mark" forState:UIControlStateNormal];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Refresh" message:@"Event Unmarked! Wanna refresh your list?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Refresh", nil];
        [alert show];
        
        int newNum = [[_currentEvent objectForKey:@"markerNum"] intValue] -1;
        [_currentEvent setObject:[NSNumber numberWithInt:newNum] forKey:@"markerNum"];
        [_currentEvent saveInBackground];
        [_markerNum setText:[_currentEvent[@"markerNum"] stringValue]];
    }
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqualToString:@"toEventEdit"]){
        JCEventEditViewController* eventEditVC = [segue destinationViewController];
        eventEditVC.currentEvent = _currentEvent;
    }
    
    //this is a push segue, so that we can use the navigation bar,  but we dont neet a buttone action for the push
    if([[segue identifier] isEqualToString:@"toPost"]){
        JCPostCreateViewController* postCreateVC = [segue destinationViewController];
        postCreateVC.currentEvent = _currentEvent;
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
    
    
    if([[alertView title] isEqualToString:@"Refresh"] && buttonIndex ==1){
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Done!"
                                                        message:@"You have unmark the event"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        
        [self performSegueWithIdentifier:@"toMain" sender:self];
    }
}

-(NSNumber *) getMarkerNum
{
    PFQuery *query = [PFUser query];
    [query whereKey:@"markEvents" equalTo:_currentEvent];
    NSNumber *num = [NSNumber numberWithInt:[query countObjects]];
    
    _currentEvent[@"markerNum"] = num;
    [_currentEvent saveInBackground];
    return num;
}

/**
 *
 * Below is for the post tableview
 *
 *
 *
 */

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [postList count];
}

-(UITableViewCell*)tableView:(UITableView *)tableView
       cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"postCell";
    JCPostTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    if(cell==nil){
        cell = [[JCPostTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    cell.currentPost = [postList objectAtIndex:indexPath.row];
        
    return cell;
}




@end
