//
//  JCAllClubsTableViewController.m
//  ClubHub
//
//  Created by Jerry on 7/6/14.
//  Copyright (c) 2014 JC. All rights reserved.
//

#import "JCAllClubsTableViewController.h"
#import "JCClubDetailViewController.h"
#import "SWRevealViewController.h"

@interface JCAllClubsTableViewController ()

@end

@implementation JCAllClubsTableViewController{
    NSArray* clubList;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        
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

-(PFQuery *) queryForTable{
    
    PFQuery *query = [PFQuery queryWithClassName:@"Club"];
    
    //only get the clubs from current user's school
    PFUser *user = [PFUser currentUser];
    PFObject *schoolObject = user[@"school"];
    [query whereKey:@"school" equalTo: schoolObject];
    [query orderByAscending:@"name"];
    
    clubList = [query findObjects];  //for prepareForSegue use
    
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
    
    static NSString *cellIdentifier = @"ClubCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(cell==nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    cell.textLabel.text = [object objectForKey:@"name"];
    
    NSArray *tagList = [object objectForKey:@"tags"];
    NSString *tagString = @" ";
    for(NSString *string in tagList){
        tagString = [tagString stringByAppendingString:string];
        tagString = [tagString stringByAppendingString:@", "];
    }
    cell.detailTextLabel.text = tagString;
    cell.imageView.image = [UIImage imageNamed:@"CLUB-HUB-LOGO.png"];
    
    return cell;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    //pass the whole object directly, instead the data of the object
    
    if([[segue identifier] isEqualToString:@"clubDetails"]){
        
        JCClubDetailViewController *clubDetailViewController = [segue destinationViewController];
        NSIndexPath *myIndexPath = [self.tableView indexPathForSelectedRow];
        
        int row = [myIndexPath row];
        PFObject *object = [clubList objectAtIndex:row];
        clubDetailViewController.currentClub = object;
    }
}

@end
