//
//  JCEventTableViewController.h
//  ClubHub
//
//  Created by Jerry on 6/29/14.
//  Copyright (c) 2014 JC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JCEventTableViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) NSArray *nameList;
@property (strong, nonatomic) NSArray *dateList;
@property (strong, nonatomic) NSArray *timeList;


@end
