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
    
    PFFile *file = [_currentClub objectForKey:@"image"];
    [file getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        _clubImageView.image = [UIImage imageWithData:data];
    }];
    
    _titleLable.text = _currentClub[@"name"];
    
    NSArray *tagList = [_currentClub objectForKey:@"tags"];
    NSString *tagString = @"";
    
    //show the follower number
    _numLable.text = [NSString stringWithFormat:@"%@", _currentClub[@"followerNum"]];
    
    //show the tags
    for(NSString *string in tagList){
        tagString = [tagString stringByAppendingString:string];
        tagString = [tagString stringByAppendingString:@", "];
    }
    
    _tagsLable.text = tagString;
}


-(IBAction)followBtn:(id)sender
{
    if([[PFUser currentUser][@"accountType"] isEqual:@"demo"]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sorry"
                                                        message:@"You need an account to follow the club"
                                                       delegate:self
                                              cancelButtonTitle:@"Cancel"
                                              otherButtonTitles: nil];
        [alert show];
        
    }else{
    
    _followBtn.enabled = NO;
    
    PFUser *user = [PFUser currentUser];
    PFRelation *relation=[user relationForKey:@"followClubs"];
    [self markAllClubEvents]; //mark all the events belongs to this club
    [relation addObject:_currentClub];    //follow
    [user saveInBackground];
    
    int newNum = [[_currentClub objectForKey:@"followerNum"] intValue] + 1;
    [_currentClub setObject:[NSNumber numberWithInt:newNum] forKey:@"followerNum"];
    [_currentClub saveInBackground];
    
     _numLable.text = [NSString stringWithFormat:@"%@", _currentClub[@"followerNum"]];

    }
}


-(void)markAllClubEvents
{
    PFUser *user = [PFUser currentUser];
    PFRelation *relation = [user relationForKey:@"markEvents"];
    
    PFQuery *query = [PFQuery queryWithClassName:@"Event"];
    
    //only get the events of current club
    [query whereKey:@"club" equalTo:_currentClub];
    [query whereKey:@"date" greaterThanOrEqualTo:[[NSDate date] dateByAddingTimeInterval:-60*60]];
    [query orderByDescending:@"date"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        for (PFObject *event in objects) {
            [relation addObject:event];
        }
        
        [user saveInBackground];
    }];
}


@end
