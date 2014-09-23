//
//  JCTPickClubTableViewController.h
//  ClubHub
//
//  Created by Jerry on 7/2/14.
//  Copyright (c) 2014 JC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "JCClubBuildViewController.h"

@interface JCPickClubTableViewController : PFQueryTableViewController <UITableViewDelegate, UITableViewDataSource, JCClubBuildViewControllerDelegate, UIAlertViewDelegate>

@property (strong, nonatomic) IBOutlet UIBarButtonItem *menuBtn;


-(IBAction)buildClubBtn:(id)sender;

@end
