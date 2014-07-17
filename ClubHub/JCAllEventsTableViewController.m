//
//  JCAllEventsTableViewController.m
//  ClubHub
//
//  Created by Jerry on 7/6/14.
//  Copyright (c) 2014 JC. All rights reserved.
//

#import "JCAllEventsTableViewController.h"
#import "JCEventDetailViewController.h"
#import "SWRevealViewController.h"

@interface JCAllEventsTableViewController ()

@end

@implementation JCAllEventsTableViewController{
    NSArray *eventList;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        self.pullToRefreshEnabled = YES;
        self.paginationEnabled = YES;
        self.objectsPerPage = 25;
    }
    return self;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    
    [self.menuBtn setTarget:self.revealViewController];
    [self.menuBtn setAction:@selector(revealToggle:)];
    [self.navigationController.navigationBar addGestureRecognizer:self.revealViewController.panGestureRecognizer];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(PFQuery*) queryForTable{
    
    PFQuery *query = [PFQuery queryWithClassName:@"Event"];
    
    //only get the clubs from current user's school
    PFUser *user = [PFUser currentUser];
    PFObject *schoolObject = user[@"school"];
    [query whereKey:@"school" equalTo: schoolObject];
    [query whereKey:@"available" equalTo:[NSNumber numberWithBool:YES]]; //only get the even that is available
    [query whereKey:@"date" greaterThanOrEqualTo:[[NSDate date] dateByAddingTimeInterval:-60*60]]; //getting the events which start one hour ago from now
    //get the event later than current date
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
    
    static NSString *CellIdentifier = @"eventCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell==nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.text = [object objectForKey:@"name"];
    
    
    if(object[@"available"]==[NSNumber numberWithBool:NO]) {
        cell.detailTextLabel.text = @"Canceled";
    }else if([object[@"date"] timeIntervalSinceDate:[[NSDate date] dateByAddingTimeInterval:-(60*60)]]<=60*60)
    {
        cell.detailTextLabel.text = @"Happening";
    }else{
        NSDate *date=[object objectForKey:@"date"];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"h:mm a  EEE, MMM-d"];
        cell.detailTextLabel.text = [formatter stringFromDate:date];
    }
    
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
