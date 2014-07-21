//
//  JCAdminTableViewController.h
//  ClubHub
//
//  Created by Jerry on 7/7/14.
//  Copyright (c) 2014 JC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface JCAdminTableViewController : PFQueryTableViewController < UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UIBarButtonItem *menuBtn;

-(IBAction)logoutBtn:(id)sender;

@end
