//
//  JCClubBuildDetailViewController.h
//  ClubHub
//
//  Created by Jerry on 7/9/14.
//  Copyright (c) 2014 JC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface JCClubBuildDetailViewController : UIViewController <UITextFieldDelegate, UIAlertViewDelegate>

@property (strong, nonatomic) IBOutlet UITextView *detailTextView;
@property (strong, nonatomic) PFObject *currentClub;

-(IBAction)saveBtn:(id)sender;
-(IBAction)cancelBtn:(id)sender;

@end
