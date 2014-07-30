//
//  JCAdminTableViewController.m
//  ClubHub
//
//  Created by Jerry on 7/7/14.
//  Copyright (c) 2014 JC. All rights reserved.
//

#import "JCAdminTableViewController.h"
#import "JCClubDetailViewController.h"
#import "JCEventDetailViewController.h"
#import "SWRevealViewController.h"

@interface JCAdminTableViewController ()

@end

@implementation JCAdminTableViewController{
    NSArray* clubList;
}

-(void)doneClubBuild
{
    [self.navigationController popViewControllerAnimated:YES];
    [self loadObjects];
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        
        //basic rules for the Parse-TableView
        self.pullToRefreshEnabled =YES;
        self.paginationEnabled = YES;
        self.objectsPerPage = 10;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //set up the menu button
    [self.menuBtn setTarget:self.revealViewController];
    [self.menuBtn setAction:@selector(revealToggle:)];
    [self.navigationController.navigationBar addGestureRecognizer:self.revealViewController.panGestureRecognizer];
}

-(PFQuery*) queryForTable
{
    PFQuery *query = [PFQuery queryWithClassName:@"Club"];
    [query whereKey:@"admins" equalTo:[PFUser currentUser]];
    
    clubList = [query findObjects];
    NSLog(@"%d", [clubList count]);
    
    return query;
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object
{
    //two section, one for club, one for event
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
    
    if([[segue identifier] isEqualToString:@"toClubBuild"]){
        
        JCClubBuildViewController *clubBuildVC = [segue destinationViewController];
        clubBuildVC.delegate = self;
    }
}
-(void) logoutBtn:(id)sender{
    [PFUser logOut];
    [self performSegueWithIdentifier:@"toLogIn" sender:self];
}

-(IBAction)buildClubBtn:(id)sender
{
    [self performSegueWithIdentifier:@"toClubBuild" sender:self];
}

@end