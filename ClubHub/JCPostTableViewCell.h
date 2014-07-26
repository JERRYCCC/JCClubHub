//
//  JCPostTableViewCell.h
//  ClubHub
//
//  Created by Jerry on 7/26/14.
//  Copyright (c) 2014 JC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface JCPostTableViewCell : UITableViewCell

@property (strong, nonatomic) PFObject *currentPost;

@property (strong, nonatomic) IBOutlet UILabel *label;

@end
