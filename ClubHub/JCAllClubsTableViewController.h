
//
//  JCAllClubsTableViewController.h
//  ClubHub
//
//  Created by Jerry on 7/6/14.
//  Copyright (c) 2014 JC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>


@interface JCAllClubsTableViewController : PFQueryTableViewController <UITableViewDelegate, UITableViewDataSource, UISearchDisplayDelegate>

@property (strong, nonatomic) IBOutlet UIBarButtonItem *menuBtn;


@end
