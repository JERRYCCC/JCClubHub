//
//  JCClubViewController.h
//  ClubHub
//
//  Created by Jerry on 6/29/14.
//  Copyright (c) 2014 JC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "JCClubEditViewController.h"
#import "JCEventCreateViewController.h"

@interface JCClubDetailViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate, JCClubEditViewControllerDelegate, JCEventCreateViewControllerDelegate>

@property (weak, nonatomic) PFObject *currentClub;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UITextView *tagsTextView;
@property (strong, nonatomic) IBOutlet UITextView *descriptionTextView;
@property (strong, nonatomic) IBOutlet UILabel *followerNum;

@property (weak, nonatomic) IBOutlet UITableView *eventListTableView;

@property (strong, nonatomic) IBOutlet UIButton *followBtn;

-(IBAction)followBtn:(id)sender;
-(IBAction)moreBtn:(id)sender;



@end
