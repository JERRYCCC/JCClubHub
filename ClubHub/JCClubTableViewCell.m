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

- (void)awakeFromNib
{
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(IBAction)followBtn:(id)sender
{
    _followBtn.hidden=YES;
    
    PFUser *user = [PFUser currentUser];
    PFRelation *relation=[user relationForKey:@"followClubs"];
    [self markAllClubEvents]; //mark all the events belongs to this club
    [relation addObject:_currentClub];    //follow
    [user saveInBackground];
    
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
