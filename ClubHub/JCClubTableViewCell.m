//
//  JCClubTableViewCell.m
//  ClubHub
//
//  Created by Jerry on 6/29/14.
//  Copyright (c) 2014 JC. All rights reserved.
//

#import "JCClubTableViewCell.h"

@implementation JCClubTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
}

//"viewDidLoad" for the TableViewCell, run automatically when the cell is built
-(void)layoutSubviews
{
    
    _titleLable.text = _currentClub[@"name"];
    
    NSArray *tagList = [_currentClub objectForKey:@"tags"];
    NSString *tagString = @"";
    
    //show the follower number
    if(_currentClub[@"followerNum"]!=nil){
        tagString = [tagString stringByAppendingString:[_currentClub[@"followerNum"] stringValue]];
        tagString = [tagString stringByAppendingString:@" | "];
    }
    //show the tags
    for(NSString *string in tagList){
        tagString = [tagString stringByAppendingString:string];
        tagString = [tagString stringByAppendingString:@", "];
    }
    
    _tagsLable.text = tagString;
}

-(IBAction)followBtn:(id)sender
{
    _followBtn.hidden=YES;
    
    PFUser *user = [PFUser currentUser];
    PFRelation *relation=[user relationForKey:@"followClubs"];
    [self markAllClubEvents]; //mark all the events belongs to this club
    [relation addObject:_currentClub];    //follow
    [user saveInBackground];
    
    int newNum = [[_currentClub objectForKey:@"followerNum"] intValue] + 1;
    [_currentClub setObject:[NSNumber numberWithInt:newNum] forKey:@"followerNum"];
    [_currentClub saveInBackground];
    
    NSArray *tagList = [_currentClub objectForKey:@"tags"];
    NSString *tagString = @"";
    
    //show the follower number
    if(_currentClub[@"followerNum"]!=nil){
        tagString = [tagString stringByAppendingString:[_currentClub[@"followerNum"] stringValue]];
        tagString = [tagString stringByAppendingString:@" | "];
    }
    //show the tags
    for(NSString *string in tagList){
        tagString = [tagString stringByAppendingString:string];
        tagString = [tagString stringByAppendingString:@", "];
    }
    
    _tagsLable.text = tagString;
    
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

-(NSArray*) getEventList
{
    PFQuery *query = [PFQuery queryWithClassName:@"Event"];
    
    //only get the events of current club
    [query whereKey:@"club" equalTo:_currentClub];
    [query whereKey:@"date" greaterThanOrEqualTo:[[NSDate date] dateByAddingTimeInterval:-60*60]];
    [query orderByDescending:@"date"];
    NSArray *list = [query findObjects];
    return list;
}

@end
