//
//  JCClubTableViewCell.h
//  ClubHub
//
//  Created by Jerry on 6/29/14.
//  Copyright (c) 2014 JC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface JCClubTableViewCell : UITableViewCell

@property (strong, nonatomic) PFObject *currentClub;
@property (strong, nonatomic) IBOutlet UIImageView *clubImageView;
@property (strong, nonatomic) IBOutlet UILabel *titleLable;
@property (strong, nonatomic) IBOutlet UILabel *tagsLable;
@property (strong, nonatomic) IBOutlet UILabel *numLable;
@property (weak, nonatomic) IBOutlet UIButton *followBtn;


-(IBAction)followBtn:(id)sender;



@end
