//
//  JCAllClubsTableViewController.m
//  ClubHub
//
//  Created by Jerry on 7/6/14.
//  Copyright (c) 2014 JC. All rights reserved.
//

#import "JCAllClubsTableViewController.h"
#import "JCClubTableViewCell.h"
#import "JCClubDetailViewController.h"
#import "SWRevealViewController.h"

@interface JCAllClubsTableViewController ()
@property (strong, nonatomic) NSArray* searchResult;

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
    
    _searchResult = [[NSArray alloc] init];
}

-(PFQuery *) queryForTable{
    
    PFQuery *query = [PFQuery queryWithClassName:@"Club"];
    
    //only get the clubs from current user's school
    PFUser *user = [PFUser currentUser];
    PFObject *schoolObject = user[@"school"];
    [query whereKey:@"school" equalTo: schoolObject];
    [query orderByDescending:@"followerNum"];
    
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

/*
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView == self.searchDisplayController.searchResultsTableView)
    {
        return [self.searchResult count];
    }else{
        return [clubList count];
    }
}
*/
-(UITableViewCell *) tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
                        object:(PFObject *)object
{
    
    static NSString *cellIdentifier = @"ClubCell";
    
    JCClubTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(cell==nil){
        cell = [[JCClubTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    /*
    if(tableView == self.searchDisplayController.searchResultsTableView){
        cell.currentClub = [self.searchResult objectAtIndex:indexPath.row];
    }else{
        cell.currentClub = object;
    }
    */
    cell.currentClub = object;
    
    return cell;
}
/*
-(void)filterContentForSearchText:(NSString*) searchText scope:(NSString*)scope
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF beginswith[c] %@", searchText];
    self.searchResult = [clubList filteredArrayUsingPredicate:predicate];
}

-(BOOL) searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    
    [self filterContentForSearchText:searchString scope:[[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    
    return YES;
}
 */


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
