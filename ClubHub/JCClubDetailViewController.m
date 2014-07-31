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

#import <Parse/Parse.h>

@interface JCClubDetailViewController ()


@end

@implementation JCClubDetailViewController{
    
    NSArray *oldEvents;
    NSArray *futureEvents;
    NSArray *eventList;
    UITextField *passwordTextField;
    BOOL admin;
}

-(void)doneClubEditing:(PFObject*)clubObject
{
    [self.navigationController popViewControllerAnimated:YES];
    NSLog(@"DONE EDITING");
    _currentClub = clubObject;
    [self viewDidLoad];
}

-(void)doneEventCreate:(PFObject*)clubObject
{
    [self.navigationController popViewControllerAnimated:YES];
    NSLog(@"Done Creating Event");
    _currentClub = clubObject;
    [self setEventList];
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
    
    _followerNum.text = _currentClub[@"followNum"];
   
    _tagsTextView.text = tagString;
    _tagsTextView.editable=NO;
    
    _descriptionTextView.text = (_currentClub[@"description"]);
    _descriptionTextView.editable=NO;
  
    [self setPriority];
    [self setEventList];
}

-(void)setPriority{
    PFRelation *relation = [_currentClub relationForKey:@"admins"];
    PFQuery *adminQuery = [relation query];
    [adminQuery whereKey:@"objectId" equalTo:[PFUser currentUser].objectId];
    
    [adminQuery countObjectsInBackgroundWithBlock:^(int number, NSError *error){
        if(!error){
            if(number==0||adminQuery==nil){
                admin=NO;
                _followBtn.hidden = NO;
                [self setFollowStatus];
            }else{
                admin=YES;
                _followBtn.hidden = YES;
            }
        }
    }];
}

-(void)setFollowStatus
{
    PFUser *user = [PFUser currentUser];
    [user fetchIfNeeded];
    PFRelation *relation=[user relationForKey:@"followClubs"];
    PFQuery *clubList = [relation query];
    [clubList whereKey:@"objectId" equalTo:_currentClub.objectId];
    
    [clubList countObjectsInBackgroundWithBlock:^(int number, NSError *error){
        if(!error){
            if(number==0||clubList==nil){
                [_followBtn setTitle:@"Follow" forState:UIControlStateNormal];
            }else{
                [_followBtn setTitle:@"Unfollow" forState:UIControlStateNormal];
            }
        }
    }];
}

-(void) setEventList
{
    eventList = [[NSMutableArray alloc] init];
    
    PFQuery *query = [PFQuery queryWithClassName:@"Event"];
    
    //the future events
    [query whereKey:@"club" equalTo:_currentClub];
    [query whereKey:@"date" greaterThanOrEqualTo:[[NSDate date] dateByAddingTimeInterval:-60*60]];
    [query orderByAscending:@"date"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        futureEvents = objects;
        
        //the pass events
        PFQuery *query2 = [PFQuery queryWithClassName:@"Event"];
        [query2 whereKey:@"club" equalTo:_currentClub];
        [query2 whereKey:@"date" lessThan:[[NSDate date] dateByAddingTimeInterval:-60*60]];
        [query2 orderByDescending:@"date"];
        
        [query2 findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            
            oldEvents = objects;
            eventList = [futureEvents arrayByAddingObjectsFromArray:oldEvents];
            [self.eventListTableView reloadData];
        }];
        
    }];
}

-(IBAction)followBtn:(id)sender
{
    
    PFUser *user = [PFUser currentUser];
    [user fetchIfNeeded];
    PFRelation *relation=[user relationForKey:@"followClubs"];
    
    //follow the club,  else unfollow the club
    
    if([_followBtn.titleLabel.text isEqual:@"Follow"]){
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
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Total Delete" message:@"Do you also want to unmark all the events related to this club?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Yes", nil];
        [alert show];
        
        //[self performSegueWithIdentifier:@"toMain" sender:self];
    }
}

-(void)markAllClubEvents
{
    PFUser *user = [PFUser currentUser];
    PFRelation *relation = [user relationForKey:@"markEvents"];
    
    for (PFObject *event in eventList) {
        [relation addObject:event];
    }
    [user saveInBackground];
}

-(void)unmarkAllClubEevnts
{
    PFUser *user = [PFUser currentUser];
    PFRelation *relation = [user relationForKey:@"markEvents"];
    for (PFObject *event in eventList) {
        [relation removeObject:event];
    }
    [user saveInBackground];
    
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
    
    if([[segue identifier] isEqualToString:@"toEventCreate"] ||[[segue identifier] isEqualToString:@"toEventCeateModal"]){
        
        JCEventCreateViewController *eventCreateVC = [segue destinationViewController];
        eventCreateVC.targetClub = _currentClub;
        eventCreateVC.delegate = self;
        
    }
    
    if([[segue identifier] isEqualToString:@"toClubEdit"]){
        JCClubEditViewController * clubEditVC = [segue destinationViewController];
        clubEditVC.currentClub = _currentClub;
        clubEditVC.delegate = self;
    }
}

-(IBAction)backBtn:(id)sender
{
    [self performSegueWithIdentifier:@"toMain" sender:self];
}

-(IBAction)addEventBtn:(id)sender
{
    [self performSegueWithIdentifier:@"toEventCeateModal" sender:self];
}

-(IBAction)moreBtn:(id)sender
{
 
    if(admin){
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Administration"
                                                                 delegate:self
                                                        cancelButtonTitle:@"Cancel"
                                                   destructiveButtonTitle:nil
                                                        otherButtonTitles:@"Add Event", @"Edit Club", nil];
        
        [actionSheet showInView:self.view];
    }else{
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Entitle"
                                                                 delegate:self
                                                        cancelButtonTitle:@"Cancel"
                                                   destructiveButtonTitle:nil
                                                        otherButtonTitles:@"Enter Club Password", nil];
        
        [actionSheet showInView:self.view];
    }
    
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if([[actionSheet title] isEqualToString:@"Administration"]){
        switch (buttonIndex) {
                
            case 0:
                [self performSegueWithIdentifier:@"toEventCreate" sender:self];
                break;
                
            case 1:
                [self performSegueWithIdentifier:@"toClubEdit" sender:self];
                break;
                
            default:
                break;
    }
    }
    
    if([[actionSheet title] isEqualToString:@"Entitle"]){
        
        switch (buttonIndex) {
            case 0:
                [self enterPassword:NO];
                break;
                
                
            default:
                break;
        }
    }
    
    
}

-(void)enterPassword:(BOOL) wrongPassword
{
    NSString* message;
    
    if(wrongPassword){
        message = @"Wrong Password, Enter again Please";
    }else{
        message = @"Enter Password Please!";
    }
    
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Entitle"
                                                      message:message
                                                     delegate:self
                                            cancelButtonTitle:@"Cancel"
                                            otherButtonTitles:@"Continue", nil];
    alertView.alertViewStyle = UIAlertViewStyleSecureTextInput;
    passwordTextField = [alertView textFieldAtIndex:0];
    
    [alertView show];
}

-(void) alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if([[alertView title] isEqualToString:@"Total Delete"] && buttonIndex ==1){
        
        [self unmarkAllClubEevnts];  //unmark all the events belongs to this club
    }
    
    
    if([[alertView title] isEqualToString:@"Entitle"] && buttonIndex == 1){
        
        if([passwordTextField.text isEqualToString: _currentClub[@"password"]]){
            [self entitleNewAdmin];
            [self performSegueWithIdentifier:@"toClubEdit" sender:self];
        }else{
            [self enterPassword:YES];
        }
    }
}

-(void)entitleNewAdmin
{
    PFUser *user = [PFUser currentUser];
    PFRelation *adminRelation = [_currentClub relationForKey:@"admins"];
    [adminRelation addObject:user];
    [_currentClub saveInBackground];
    
    //current user follows the club he built immediately
    PFRelation *followRleaion = [user relationForKey:@"followClubs"];
    [followRleaion addObject:_currentClub];
    [user saveInBackground];
    
}










@end
