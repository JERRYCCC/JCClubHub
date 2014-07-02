//
//  JCEventTableViewController.m
//  ClubHub
//
//  Created by Jerry on 6/29/14.
//  Copyright (c) 2014 JC. All rights reserved.
//

#import "JCEventTableViewController.h"
#import "JCEventTableViewCell.h"
#import "JCEventDetailViewController.h"
#import "JCEventCreateViewController.h"
#import "JCPickClubTableViewController.h"

@interface JCEventTableViewController ()

@end

@implementation JCEventTableViewController{
    NSArray* eventList;
    PFObject *targetClub;
    PFQuery* adminClubList;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        
        // This table displays items in the Club class
        self.pullToRefreshEnabled = YES;
        self.paginationEnabled = YES;
        self.objectsPerPage = 25;
    }
    return self;
}

-(PFQuery*) queryForTable{
    
    PFQuery *query = [PFQuery queryWithClassName:@"Event"];
    
    //only get the clubs from current user's school
    PFUser *user = [PFUser currentUser];
    PFObject *schoolObject = user[@"school"];
    [query whereKey:@"school" equalTo: schoolObject];
    [query orderByAscending:@"createdAt"];
    
    eventList = [query findObjects];  //for prepareForSegue use
    
    //if Pull to Refresh is enabled, query against the network by default
    if(self.pullToRefreshEnabled){
        query.cachePolicy = kPFCachePolicyNetworkOnly;
    }
    
    //if no objects are loaded in memory, we look to the cache first to fill the table
    if([self.objects count]==0){
        query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    }
    return query;
}

-(UITableViewCell *) tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
                        object:(PFObject *)object
{
    
    static NSString *CellIdentifier = @"EventCell";
    
    JCEventTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell==nil){
        cell = [[JCEventTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    cell.titleLable.text = [object objectForKey:@"name"];
    
    NSDate *date=[object objectForKey:@"date"];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"h:mm a           EEE, MMM-d"];
    cell.dateLabel.text = [formatter stringFromDate:date];
    
    return cell;
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    //pass the whole object directly, instead the data of the object
    if([[segue identifier] isEqualToString:@"eventDetail"]){
        
        JCEventDetailViewController *eventDetailViewController = [segue destinationViewController];
        
        NSIndexPath *myIndexPath = [self.tableView indexPathForSelectedRow];
        
        int row = [myIndexPath row];
        PFObject *object = [eventList objectAtIndex:row];
        eventDetailViewController.eventObject = object;
    }
    
    if([[segue identifier] isEqualToString:@"toCreateEvent"]){
        
        JCEventCreateViewController *eventCreateViewController = [segue destinationViewController];
        eventCreateViewController.targetClub = targetClub;
    }
}

-(void)createBtn:(id)sender
{
    PFObject *user = [PFUser currentUser];
    PFQuery *query = [PFQuery queryWithClassName:@"Club"];
    [query whereKey:@"admins" equalTo:user];
    [query orderByAscending:@"name"];
    
    if([query countObjects]==0){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oooopss!"
                                                        message:@"You need to have at least one club to build a event for"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    if([query countObjects]==1){
        targetClub = [query getFirstObject];
        [self performSegueWithIdentifier:@"toCreateEvent" sender:self];
    }
    if([query countObjects]>1){
        [self performSegueWithIdentifier:@"toPickClub" sender:self];
    }
}

@end
