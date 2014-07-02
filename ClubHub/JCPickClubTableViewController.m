//
//  JCTPickClubTableViewController.m
//  ClubHub
//
//  Created by Jerry on 7/2/14.
//  Copyright (c) 2014 JC. All rights reserved.
//

#import "JCPickClubTableViewController.h"
#import "JCEventCreateViewController.h"

@interface JCPickClubTableViewController ()

@end

@implementation JCPickClubTableViewController{
    NSArray *clubList;
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

-(PFQuery*) queryForTable
{
    PFObject *user = [PFUser currentUser];
    PFQuery *query = [PFQuery queryWithClassName:@"Club"];
    [query whereKey:@"admins" equalTo:user];
    [query orderByAscending:@"name"];
    clubList = [query findObjects];
    
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

-(UITableViewCell*) tableView:(UITableView *)tableView
        cellForRowAtIndexPath:(NSIndexPath *)indexPath
                       object:(PFObject *)object
{
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if(cell==nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    
    cell.textLabel.text = [object objectForKey:@"name"];
    
    NSArray *tagList = [object objectForKey:@"tags"];
    NSString *tagString = @" ";
    for(NSString *string in tagList){
        tagString = [tagString stringByAppendingString:string];
        tagString = [tagString stringByAppendingString:@", "];
    }
    cell.detailTextLabel.text = tagString;
    
    return cell;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    //pass the whole object directly, instead the data of the object
    
    if([[segue identifier] isEqualToString:@"toCreateEvent"]){
        
        JCEventCreateViewController *eventCreateViewController = [segue destinationViewController];
        NSIndexPath *myIndexPath = [self.tableView indexPathForSelectedRow];
        
        int row = [myIndexPath row];
        PFObject *object = [clubList objectAtIndex:row];
        eventCreateViewController.targetClub = object;
    }
}

@end
