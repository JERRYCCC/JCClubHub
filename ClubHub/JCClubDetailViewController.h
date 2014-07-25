//
//  JCClubViewController.h
//  ClubHub
//
//  Created by Jerry on 6/29/14.
//  Copyright (c) 2014 JC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface JCClubDetailViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate>

@property (weak, nonatomic) PFObject *currentClub;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UITextView *tagsTextView;
@property (strong, nonatomic) IBOutlet UITextView *descriptionTextView;
@property (strong, nonatomic) IBOutlet UILabel *followerNum;

@property (weak, nonatomic) IBOutlet UITableView *eventListTableView;

@property (strong, nonatomic) IBOutlet UIButton *followBtn;
@property (strong, nonatomic) IBOutlet UIButton *adminBtn;

-(IBAction)followBtn:(id)sender;
-(IBAction)backBtn:(id)sender;
-(IBAction)addEventBtn:(id)sender;
-(IBAction)moreBtn:(id)sender;



@end
