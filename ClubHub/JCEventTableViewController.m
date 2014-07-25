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

@property (strong, nonatomic) NSArray *eventList;

@end

@implementation JCEventTableViewController


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
    
    [self.menuBtn setTarget:self.revealViewController];
    [self.menuBtn setAction:@selector(revealToggle:)];
    [self.navigationController.navigationBar addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
}

-(PFQuery*) queryForTable{
    
    PFUser *user = [PFUser currentUser];
    PFRelation *relation = [user relationForKey:@"markEvents"];
    PFQuery *query = [relation query];
    
    //getting the events which start one hour ago from now
    [query whereKey:@"date" greaterThanOrEqualTo:[[NSDate date] dateByAddingTimeInterval:-(60*60)]];
    
    
    [query orderByAscending:@"date"];
    
    self.eventList = [query findObjects];  //for prepareForSegue use
    


    //if Pull to Refresh is enabled, query against the network by default
    if(self.pullToRefreshEnabled){
        query.cachePolicy = kPFCachePolicyNetworkOnly;
    }
    return query;
}

-(UITableViewCell *) tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
                        object:(PFObject *)object
{
    
    NSString *CellIdentifier = @"EventCell";
    
    JCEventTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell==nil){
        cell = [[JCEventTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    cell.titleLable.text = [object objectForKey:@"name"];
    
    //show the status of the event
    if(object[@"available"]== [NSNumber numberWithBool:NO]){
        cell.dateLabel.text = @"Canceled";
    }else if ([object[@"date"] timeIntervalSinceDate:[[NSDate date] dateByAddingTimeInterval:-(60*60)]]<=60*60){
        cell.dateLabel.text = @"Happening";
    }
    else{
        NSDate *date=[object objectForKey:@"date"];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"h:mm a   EEE, MMM-d"];
        cell.dateLabel.text = [formatter stringFromDate:date];
    }
    
    
    //add utility buttons
    
    NSMutableArray *leftUtilityButtons = [NSMutableArray new];
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];

    [leftUtilityButtons sw_addUtilityButtonWithColor:[UIColor colorWithRed:0.2f green:1.0f blue:0.2f alpha:0.7] title:@"Remind"];
    
    [leftUtilityButtons sw_addUtilityButtonWithColor:[UIColor colorWithRed:0.2f green:0.2f blue:1.0f alpha:0.7] title:@"More"];
    
    [rightUtilityButtons sw_addUtilityButtonWithColor:[UIColor colorWithRed:1.0f green:0.231f blue:0.188f alpha:1.0] title:@"Delete"];
    
    cell.leftUtilityButtons = leftUtilityButtons;
    cell.rightUtilityButtons = rightUtilityButtons;
    cell.delegate = self;
                           
    return cell;
}


/**
 *  add the action to the swip cell buttons
 *
 *
 *
 */
-(void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerLeftUtilityButtonWithIndex:(NSInteger)index
{
    switch (index) {
        case 0:
        {
            //remind
            break;
        }
        case 1:
        {
            //more
            break;
        }
        default:
            break;
    }
}

-(void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index
{
    switch (index) {
        case 0:
        {
            //delete event (unmark)
            //two step :
            //1. take it away from user's event list
            //2. take away the cell immediately
            
            PFUser *user = [PFUser currentUser];
            PFRelation *relation = [user relationForKey:@"markEvents"];
            PFObject *currentEvent = self.eventList[index];
            [relation removeObject:currentEvent];
            [user saveInBackground];
            
            NSIndexPath *cellIndexPath = [self.tableView indexPathForCell:cell];
            [self.tableView deleteRowsAtIndexPaths:@[cellIndexPath] withRowAnimation:UITableViewRowAnimationLeft];
            
            break;
        }
        default:
            break;
    }
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"eventDetail" sender:self];
}



-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    //pass the whole object directly, instead the data of the object
   
    
    if([[segue identifier] isEqualToString:@"eventDetail"]){
        
        JCEventDetailViewController *eventDetailViewController = [segue destinationViewController];
        NSIndexPath *myIndexPath = [self.tableView indexPathForSelectedRow];
        int row = [myIndexPath row];
        eventDetailViewController.currentEvent = [self.eventList objectAtIndex:row];
    
    }
}

@end
