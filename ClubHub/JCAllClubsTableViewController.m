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

@end

@implementation JCAllClubsTableViewController
{
    NSMutableArray *searchList;
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

-(void)viewDidAppear:(BOOL)animated
{
    [self loadObjects];
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
    [query whereKey:@"school" equalTo:schoolObject];
    
    //exclude the followed clubs , only show the not followed clubs
    PFRelation *relation=[user relationForKey:@"followClubs"];
    PFQuery *followedClubList = [relation query];
    
    [followedClubList countObjectsInBackgroundWithBlock:^(int number, NSError *error) {
        
        NSLog(@"%d", number);
        if(number!=0||followedClubList!=nil){
            [query whereKey:@"objectId" doesNotMatchKey:@"objectId" inQuery:followedClubList];
        }
        
    }];
    
    
    [query orderByDescending:@"followerNum"];
    
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

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(searchList!=nil){
        return [searchList count];
    }else{
        return [self.objects count];
    }
}


-(UITableViewCell *) tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
                        object:(PFObject *)object
{
    
    static NSString *cellIdentifier = @"ClubCell";
    
    JCClubTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(cell==nil){
        cell = [[JCClubTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }

    if(searchList!=nil){
        cell.currentClub  = searchList[indexPath.row];
    }else{
        cell.currentClub = object;
    }

    
    
    return cell;
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if(searchText.length==0){
        searchList=nil;
    }else{
        searchList = [[NSMutableArray alloc] init];
        
        for (PFObject *object in self.objects) {
            NSRange nameRange = [object[@"name"] rangeOfString:searchText options:NSCaseInsensitiveSearch];
            
            if(nameRange.location !=NSNotFound)
            {
                [searchList addObject:object];
            }
        }
    }
    [self.tableView reloadData];
}

-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:YES animated:YES];
}

-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:NO animated:YES];
}


-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    //pass the whole object directly, instead the data of the object
    
    if([[segue identifier] isEqualToString:@"clubDetails"]){
        
        JCClubDetailViewController *clubDetailViewController = [segue destinationViewController];
        NSIndexPath *myIndexPath = [self.tableView indexPathForSelectedRow];
        
        int row = [myIndexPath row];
        PFObject *object = [self.objects objectAtIndex:row];
        clubDetailViewController.currentClub = object;
    }
}

@end
