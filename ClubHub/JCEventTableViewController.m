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
#import "SWRevealViewController.h"

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

-(void)viewDidLoad{
    [super viewDidLoad];
    
    self.navigationController.view.backgroundColor =
    [UIColor colorWithPatternImage:[UIImage imageNamed:@"greyBackground"]];
    
    [self.menuBtn setTarget:self.revealViewController];
    [self.menuBtn setAction:@selector(revealToggle:)];
    [self.navigationController.navigationBar addGestureRecognizer:self.revealViewController.panGestureRecognizer];
}

-(PFQuery*) queryForTable{
    
    PFUser *user = [PFUser currentUser];
    PFRelation *relation = [user relationForKey:@"markEvents"];
    PFQuery *query = [relation query];
    
    
    [query orderByAscending:@"date"];
    
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
    [formatter setDateFormat:@"h:mm a   EEE, MMM-d"];
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
        eventDetailViewController.currentEvent = object;
    }
}




@end
