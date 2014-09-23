//
//  JCPickSchoolTableViewController.m
//  ClubHub
//
//  Created by Jerry Cai on 9/22/14.
//  Copyright (c) 2014 JC. All rights reserved.
//

#import "JCPickSchoolTableViewController.h"

@interface JCPickSchoolTableViewController ()

@end

@implementation JCPickSchoolTableViewController


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


- (void)viewDidLoad {
    [super viewDidLoad];
}


//log in automatically
-(void)viewDidAppear:(BOOL)animated{
    PFUser *user = [PFUser currentUser];
    if(user.username !=nil){
        [self performSegueWithIdentifier:@"toMain" sender:self];
    }
}


-(PFQuery *)queryForTable{

    PFQuery *query = [PFQuery queryWithClassName:@"School"];
    [query orderByAscending:@"name"];
    return query;
}


-(UITableViewCell *) tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
                        object:(PFObject *)object
{
    
    static NSString *cellIdentifier = @"schoolCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(cell==nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    cell.textLabel.text = object[@"name"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath {
    
    PFObject *object = [self.objects objectAtIndex:indexPath.row];
    [PFUser logInWithUsernameInBackground:object[@"domain"] password:@"password" block:^(PFUser *user, NSError *error) {
        
        if (error) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sorry" message:@"This school is not available" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        } else {
            [self performSegueWithIdentifier:@"toMain" sender:self];
            
        }
    }];
    
}


@end
