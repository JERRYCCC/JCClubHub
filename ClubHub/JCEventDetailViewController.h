//
//  JCEventDetailViewController.h
//  ClubHub
//
//  Created by Jerry on 6/30/14.
//  Copyright (c) 2014 JC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JCEventDetailViewController : UIViewController < UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) NSString *name;
@property (weak, nonatomic) NSString *date;
@property (weak, nonatomic) NSString *time;
@property (weak, nonatomic) NSString *location;
@property (weak, nonatomic) NSString *description;


@property (strong, nonatomic) NSArray *eventTitleModal;
@property (strong, nonatomic) NSArray *eventDetailModal;


@end
