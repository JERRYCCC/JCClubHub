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
#import "JCCommentViewController.h"
#import <Parse/Parse.h>

@interface JCEventDetailViewController ()

@end

@implementation JCEventDetailViewController{
    NSString *cancelString;
    NSArray *postList;
}

-(void)donePosting:(PFObject*)eventObject
{
    [self.navigationController popViewControllerAnimated:YES];
    NSLog(@"Done Posting");
    
    PFQuery *postQuery = [PFQuery queryWithClassName:@"Post"];
    [postQuery whereKey:@"event" equalTo:eventObject];
    [postQuery orderByDescending:@"createdAt"];
    
    //this line will be run in the end, when done, renew the posttableview again
    [postQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error){
        postList = objects ;
        [self.postTableView reloadData];
    }];
}

-(void)doneEditing:(PFObject*)eventObject
{
    [self.navigationController popViewControllerAnimated:YES];
    NSLog(@"DONE EDITING");
    _currentEvent = eventObject;
    [self viewDidLoad];
    
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
    
    [self setMarkStatus];
    
    if(_currentEvent[@"available"] == [NSNumber numberWithBool:YES]){
        cancelString = @"Cancel Event";
    }else{
         cancelString = @"Revive Event";
        _dateLabel.text = @"This event has been canceled.";
    }
    
    _markerNum.text = [_currentEvent[@"markerNum"] stringValue];
    
    
    //get the post query related to currentEvent
    PFQuery *postQuery = [PFQuery queryWithClassName:@"Post"];
    [postQuery whereKey:@"event" equalTo:_currentEvent];
    [postQuery orderByDescending:@"createdAt"];
   
    //this line will be run in the end, when done, renew the posttableview again
    [postQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error){
        postList = objects ;
        [self.postTableView reloadData];
    }];
}

-(IBAction)detailBtn:(id)sender
{
    NSString *detail = _currentEvent[@"description"];
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Detail" message:detail delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alertView show];
}

-(void)setMarkStatus
//set the button, and set the ini
{
    PFUser *user = [PFUser currentUser];
    PFRelation *relation = [user relationForKey:@"markEvents"];
    PFQuery *eventList = [relation query];
    [eventList whereKey:@"objectId" equalTo:_currentEvent.objectId];
    
    [eventList countObjectsInBackgroundWithBlock:^(int number, NSError *error){
        
        if(!error){
            if (number==0||eventList==nil) {
                [_markBtn setTitle:@"Mark" forState:UIControlStateNormal];
            }else{
                [_markBtn setTitle:@"Unmark" forState:UIControlStateNormal];
            }
        }
    }];
}

-(IBAction)markBtn:(id)sender
{
    
    PFUser *user = [PFUser currentUser];
    PFRelation *relation = [user relationForKey:@"markEvents"];
    
    //mark the event, else unmark the events
    if ([_markBtn.titleLabel.text isEqual:@"Mark"]) {
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
        eventEditVC.delegate = self;
    }
    
    //this is a push segue, so that we can use the navigation bar,  but we dont neet a buttone action for the push
    if([[segue identifier] isEqualToString:@"toPost"]){
        JCPostCreateViewController* postCreateVC = [segue destinationViewController];
        postCreateVC.currentEvent = _currentEvent;
        postCreateVC.delegate = self;
    }
    
    if([[segue identifier] isEqualToString:@"toComment"]){
        
        //we find the position we tap and locate the cell index
        CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.postTableView];
        NSIndexPath *indexPath = [self.postTableView indexPathForRowAtPoint:buttonPosition];
       
        JCCommentViewController* commentVC = [segue destinationViewController];
        commentVC.currentPost = postList[indexPath.row];
    }
}


-(IBAction)moreBtn:(id)sender
{
    //[_currentEvent[@"club"] fetchIfNeeded];
    PFObject *targetClub = _currentEvent[@"club"];
    PFRelation *relation = [targetClub relationForKey:@"admins"];
    PFQuery *adminsQuery = [relation query];
    
    [adminsQuery whereKey:@"objectId" equalTo:[PFUser currentUser].objectId];
    [adminsQuery countObjectsInBackgroundWithBlock:^(int number, NSError *error){
       
        if(!error){
            if (number==0||adminsQuery==nil) {
                 [self performSegueWithIdentifier:@"toPost" sender:self];
            }else{
                UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Administration"
                                                                         delegate:self
                                                                cancelButtonTitle:@"Cancel"
                                                           destructiveButtonTitle:nil
                                                                otherButtonTitles:@"Add a Post", @"Edit Event", cancelString, nil];
                
                [actionSheet showInView:self.view];
            }
        }
        
    }];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            [self performSegueWithIdentifier:@"toPost" sender:self];
            break;
            
        case 1:
            [self performSegueWithIdentifier:@"toEventEdit" sender:self];
            break;
        
        case 2:
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

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PFObject *object = [postList objectAtIndex:indexPath.row];
    NSString *postString = object[@"postString"];
    
    CGSize constraint = CGSizeMake(304, CGFLOAT_MAX);
    CGSize size = [postString sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
    
    
    int add;
    if([object[@"withImage"] isEqualToNumber:[NSNumber numberWithBool:YES]]){
        add=210;
    }else{
        add=210;
    }
    
    return add+size.height;
}



@end
