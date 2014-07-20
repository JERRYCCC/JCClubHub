//
//  JCClubViewController.m
//  ClubHub
//
//  Created by Jerry on 6/29/14.
//  Copyright (c) 2014 JC. All rights reserved.
//

#import "JCClubDetailViewController.h"
#import "JCEventTableViewCell.h"
#import "JCEventDetailViewController.h"
#import "JCEventCreateViewController.h"
#import "JCClubEditViewController.h"

@interface JCClubDetailViewController ()


@end

@implementation JCClubDetailViewController{
    NSArray *eventList;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _nameLabel.text = (_currentClub[@"name"]);
    
    NSString *tagString=@"";
    for(NSString *string in _currentClub[@"tags"]){
        
        tagString = [tagString stringByAppendingString:string];
        tagString = [tagString stringByAppendingString:@ ", "];
    }
   
    _tagsTextView.text = tagString;
    _tagsTextView.editable=NO;
    
    _descriptionTextView.text = (_currentClub[@"description"]);
    _descriptionTextView.editable=NO;
    
    if([self checkPriority]){
        _adminBtn.hidden = NO;
        _followBtn.hidden = YES;
    }else{
        _adminBtn.hidden = YES;
        _followBtn.hidden = NO;
        
        if([self followStatus]){
            _followBtn.titleLabel.text = @"Unfollow";
        }else{
            _followBtn.titleLabel.text = @"Follow";
        }
    }
    eventList = [self getEventList];
    
    
    //once any user read the detail, the system will refresh the clubs follower number
    //instead just increase or decrease
    _followerNum.text = [[self getFollowerNum] stringValue];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)checkPriority{
    PFRelation *relation = [_currentClub relationForKey:@"admins"];
    PFQuery *adminQuery = [relation query];
    [adminQuery whereKey:@"objectId" equalTo:[PFUser currentUser].objectId];
    
    if([adminQuery countObjects]==0||adminQuery==nil){
        return NO;
    }else{
        return YES;
    }
}

-(BOOL)followStatus
{
    PFUser *user = [PFUser currentUser];
    [user fetchIfNeeded];
    PFRelation *relation=[user relationForKey:@"followClubs"];
    PFQuery *clubList = [relation query];
    [clubList whereKey:@"objectId" equalTo:_currentClub.objectId];
    
    
    if([clubList countObjects]==0||clubList==nil){
        return NO;
        
    }else{
        return YES;
        
    }
}


-(IBAction)followBtn:(id)sender
{
    
    PFUser *user = [PFUser currentUser];
    [user fetchIfNeeded];
    PFRelation *relation=[user relationForKey:@"followClubs"];
    
    //follow the club,  else unfollow the club
    
    if(![self followStatus]){
        [self markAllClubEvents]; //mark all the events belongs to this club
        [relation addObject:_currentClub];    //follow
        [user saveInBackground];
        [sender setTitle:@"Unfollow" forState:UIControlStateNormal];
        
        //increase the followerNum in database and reset the follower label
        int newNum = [[_currentClub objectForKey:@"followerNum"] intValue] +1;
        [_currentClub setObject:[NSNumber numberWithInt:newNum] forKey:@"followerNum"];
        [_currentClub saveInBackground];
        [_followerNum setText:[_currentClub[@"followerNum"] stringValue]];
        
    }else{
        
        [relation removeObject:_currentClub];  //unfollow
        [user saveInBackground];
        //done unfollowing the club and check the button text to "follow"
        [sender setTitle:@"Follow" forState:UIControlStateNormal];
        
        
        //decrease the followerNum in database and reset the follower label
        int newNum = [[_currentClub objectForKey:@"followerNum"] intValue] - 1;
        [_currentClub setObject:[NSNumber numberWithInt:newNum] forKey:@"followerNum"];
        [_currentClub saveInBackground];
        [_followerNum setText:[_currentClub[@"followerNum"] stringValue]];
        
        
        //show the unmark all related events AlertView
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Unmark its Events" message:@"Do you also want to unmark all the events related to this club?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Yes", nil];
        [alert show];
        
        //[self performSegueWithIdentifier:@"toMain" sender:self];
    }
}

-(void)markAllClubEvents
{
    PFUser *user = [PFUser currentUser];
    PFRelation *relation = [user relationForKey:@"markEvents"];

    for (PFObject *event in self.getEventList) {
        [relation addObject:event];
    }
    [user saveInBackground];
}

-(void)unmarkAllClubEevnts
{
    PFUser *user = [PFUser currentUser];
    PFRelation *relation = [user relationForKey:@"markEvents"];
    for (PFObject *event in self.getEventList) {
        [relation removeObject:event];
    }
    [user saveInBackground];
    
}

-(NSArray*) getEventList
{
    PFQuery *query = [PFQuery queryWithClassName:@"Event"];
    
    [query whereKey:@"club" equalTo:_currentClub];
    [query whereKey:@"date" greaterThanOrEqualTo:[[NSDate date] dateByAddingTimeInterval:-60*60]];
    [query orderByAscending:@"date"];
    NSArray *futureEvent = [query findObjects];
    
    PFQuery *query2 = [PFQuery queryWithClassName:@"Event"];
    [query2 whereKey:@"club" equalTo:_currentClub];
    [query2 whereKey:@"date" lessThan:[[NSDate date] dateByAddingTimeInterval:-60*60]];
    [query2 orderByDescending:@"date"];
    NSArray *pastEvent = [query2 findObjects];
     
    NSArray *list = [futureEvent arrayByAddingObjectsFromArray:pastEvent];
    return list;
     
}

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [eventList count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdenrifier = @"eventCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdenrifier];
    
    if (cell==nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdenrifier];
    }
    
    PFObject *event = eventList[indexPath.row];
    cell.textLabel.text = event[@"name"];
    
    if(event[@"available"]== [NSNumber numberWithBool:NO])
    {
        cell.detailTextLabel.text = @"Canceled";
    }else if([event[@"date"] timeIntervalSince1970]<[[NSDate date] timeIntervalSince1970]-60*60)
    {
        cell.detailTextLabel.text = @"Past";
    }else if([event[@"date"] timeIntervalSince1970]<[[NSDate date] timeIntervalSince1970])
    {
        cell.detailTextLabel.text = @"Happening";
    }else{
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"h:mm a   EEE, MMM-d"];
        cell.detailTextLabel.text = [formatter stringFromDate:event[@"date"]];
    }
    return cell;
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    //pass the whole object directly, instead the data of the object
    if([[segue identifier] isEqualToString:@"toEventDetail"]){
        
        JCEventDetailViewController *eventDetailViewController = [segue destinationViewController];
        
        NSIndexPath *myIndexPath = [_eventListTableView indexPathForSelectedRow];
        
        int row = [myIndexPath row];
        PFObject *object = [eventList objectAtIndex:row];
        eventDetailViewController.currentEvent = object;
    }
    
    if([[segue identifier] isEqualToString:@"toEventCreate"]){
        
        JCEventCreateViewController *eventCreateVC = [segue destinationViewController];
        eventCreateVC.targetClub = _currentClub;
        
    }
    
    if([[segue identifier] isEqualToString:@"toClubEdit"]){
        JCClubEditViewController * clubEditVC = [segue destinationViewController];
        clubEditVC.currentClub = _currentClub ;
    }
}

-(IBAction)backBtn:(id)sender
{
    [self performSegueWithIdentifier:@"toMain" sender:self];
}

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{

    if([[alertView title] isEqualToString:@"Done Unfollow the Club"] && buttonIndex ==1){
        
        [self unmarkAllClubEevnts];  //unmark all the events belongs to this club
    }
    
    
    
}

-(IBAction)addEventBtn:(id)sender
{
    [self performSegueWithIdentifier:@"toEventCreate" sender:self];
}

-(IBAction)adminBtn:(id)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Administration"
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"Edit Club", nil];
    
    [actionSheet showInView:self.view];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            [self performSegueWithIdentifier:@"toClubEdit" sender:self];
            break;
            
        default:
            break;
    }
}

//once any user read the detail, the system will refresh the clubs follower number
//instead of just increase or decrease
-(NSNumber*)getFollowerNum
{
    PFQuery *query = [PFUser query];
    [query whereKey:@"followClubs" equalTo:_currentClub];
    NSNumber* num = [NSNumber numberWithInt:[query countObjects]];
    //set the followers number for the object as well
    
    _currentClub[@"followerNum"]=num;
    [_currentClub saveInBackground];
    return num;
}










@end
