//
//  JCClubViewController.m
//  ClubHub
//
//  Created by Jerry on 6/29/14.
//  Copyright (c) 2014 JC. All rights reserved.
//

#import "JCClubDetailViewController.h"

@interface JCClubDetailViewController ()

@end

@implementation JCClubDetailViewController

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
    
    if([self followStatus]){
        _followBtn.titleLabel.text = @"Unfollow";
    }else{
        _followBtn.titleLabel.text = @"Follow";
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)followStatus
{
    PFUser *user = [PFUser currentUser];
    [user fetchIfNeeded];
    PFRelation *relation=[user relationForKey:@"followClubs"];
    PFQuery *clubList = [relation query];
    [clubList whereKey:@"objectId" equalTo:_currentClub.objectId];
    
    if([clubList countObjects]==0){
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
        [relation addObject:_currentClub];
        [user saveInBackground];
        [sender setTitle:@"Unfollow" forState:UIControlStateNormal];
        
    }else{
        [relation removeObject:_currentClub];
        [user saveInBackground];
        //done unfollowing the club and check the button text to "follow"
        [sender setTitle:@"Follow" forState:UIControlStateNormal];
    }
}


@end
