//
//  JCClubViewController.h
//  ClubHub
//
//  Created by Jerry on 6/29/14.
//  Copyright (c) 2014 JC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JCClubDetailViewController : UIViewController

@property (weak, nonatomic) NSString *name;
@property (weak, nonatomic) NSString *description;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UITableView *tagsTextView;
@property (strong, nonatomic) IBOutlet UITextView *descriptionTextView;


@property (weak, nonatomic) IBOutlet UITableView *eventList;


@end
