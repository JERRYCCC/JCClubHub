//
//  JCEventTableViewCell.h
//  ClubHub
//
//  Created by Jerry on 6/30/14.
//  Copyright (c) 2014 JC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "SWTableViewCell.h"

@interface JCEventTableViewCell : SWTableViewCell <SWTableViewCellDelegate>


@property (strong, nonatomic) PFObject *currentEvent;
@property (strong, nonatomic) IBOutlet UILabel *titleLable;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;

@end
