//
//  JCClubTableViewController.h
//  ClubHub
//
//  Created by Jerry on 6/29/14.
//  Copyright (c) 2014 JC. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface JCClubTableViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic)  NSArray  *nameList;
@property (strong, nonatomic)  NSArray  *tagsList;

@property (strong, nonatomic) IBOutlet UIButton *buildBtn;


@end
