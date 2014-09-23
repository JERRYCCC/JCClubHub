//
//  JCAdminTableViewController.h
//  ClubHub
//  pretty good  yesa
//  Created by Jerry on 7/7/14.
//  Copyright (c) 2014 JC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "JCClubBuildViewController.h"

@interface JCAdminTableViewController : PFQueryTableViewController < UITableViewDataSource, UITableViewDelegate, JCClubBuildViewControllerDelegate, UIAlertViewDelegate>

@property (strong, nonatomic) IBOutlet UIBarButtonItem *menuBtn;

-(IBAction)logoutBtn:(id)sender;

-(IBAction)buildClubBtn:(id)sender;

@end
