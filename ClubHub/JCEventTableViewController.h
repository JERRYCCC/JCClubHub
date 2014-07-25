//
//  JCEventTableViewController.h
//  ClubHub
//
//  Created by Jerry on 6/29/14.
//  Copyright (c) 2014 JC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "SWTableViewCell.h"

@interface JCEventTableViewController : PFQueryTableViewController<UITableViewDelegate, UITableViewDataSource, SWTableViewCellDelegate>

@property (strong, nonatomic) IBOutlet UIBarButtonItem *menuBtn;


@end
