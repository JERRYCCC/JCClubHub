//
//  JCClubTableViewController.m
//  ClubHub
//
//  Created by Jerry on 6/29/14.
//  Copyright (c) 2014 JC. All rights reserved.
//

#import "JCClubTableViewController.h"
#import "JCClubTableViewCell.h"
#import "JCClubDetailViewController.h"


@interface JCClubTableViewController ()

@end

@implementation JCClubTableViewController


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        
        // This table displays items in the Club class
        //self.pullToRefreshEnabled = YES;
        //self.paginationEnabled = NO;
        //self.objectsPerPage = 25;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    _nameList = @[@"Club One", @"Club Two", @"Club Three",];
    _tagsList = @[@"This is a description",@"This is a description",@"This is a description",];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return 1;
}
/*
-(PFQuery *) queryForTable{
    
    PFQuery *query = [PFQuery queryWithClassName:@"Club"];
    
    //if the objects are loaded in memory, we look to the cache
    //first to fill the table and then subsequently do a query
    //against the network.
    
    if([self.objects count]==0){
        query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    }
    
    [query orderByDescending:@"createdAt"]; //changed to how many people follow later...... check the relation "follow"
    
    return query;
}
*/

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_nameList count];
}


-(UITableViewCell *) tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
                        //object:(PFObject *)object
{
    
    static NSString *cellIdentifier = @"ClubCell";
    
    JCClubTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(cell==nil){
        cell = [[JCClubTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    //cell.titleLable.text = [object objectForKey:@"name"];
    //cell.tagsTextView.text = [object objectForKey:@"tags"];
    
    cell.titleLable.text = [_nameList objectAtIndex:indexPath.row];
    cell.tagsLable.text = [_tagsList objectAtIndex:indexPath.row];
    
    return cell;
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if([[segue identifier] isEqualToString:@"clubDetails"]){
        JCClubDetailViewController *detailViewController = [segue destinationViewController];
        
        NSIndexPath *myIndexPath = [self.tableView indexPathForSelectedRow];
        
        int row = [myIndexPath row];
        detailViewController.name = [_nameList objectAtIndex:row];
        detailViewController.description = [_tagsList objectAtIndex:row];
    }
}


/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: is forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
