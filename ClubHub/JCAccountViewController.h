//
//  JCAccountViewController.h
//  ClubHub
//
//  Created by Jerry Cai on 10/1/14.
//  Copyright (c) 2014 JC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface JCAccountViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIBarButtonItem *menuBtn;
@property (strong, nonatomic) IBOutlet UIButton *registerBtn;
@property (strong, nonatomic) IBOutlet UIButton *logOutBtn;

-(IBAction)registerBtn:(id)sender;
-(IBAction)logOutBtn:(id)sender;

@end
