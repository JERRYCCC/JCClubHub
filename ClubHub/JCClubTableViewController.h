//
//  JCClubTableViewController.h
//  ClubHub
//
//  Created by Jerry on 6/29/14.
//  Copyright (c) 2014 JC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>


@interface JCClubTableViewController : PFQueryTableViewController <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UIButton *buildBtn;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *menuBtn;


@end
