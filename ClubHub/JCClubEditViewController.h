//
//  JCClubEditViewController.h
//  ClubHub
//
//  Created by Jerry on 7/18/14.
//  Copyright (c) 2014 JC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@protocol JCClubEditViewControllerDelegate <NSObject>

-(void)doneClubEditing:(PFObject*)clubObject;

@end

@interface JCClubEditViewController : UIViewController<UITextFieldDelegate, UITextViewDelegate, UIAlertViewDelegate>

@property (strong, nonatomic) PFObject *currentClub;
@property (strong, nonatomic) IBOutlet UITextField *nameField;
@property (strong, nonatomic) IBOutlet UITextView *descriptionView;

@property (strong, nonatomic) IBOutlet UISwitch *sororitySwitch;
@property (strong, nonatomic) IBOutlet UISwitch *fraternitySwitch;
@property (strong, nonatomic) IBOutlet UISwitch *academicSwitch;
@property (strong, nonatomic) IBOutlet UISwitch *sportsSwitch;
@property (strong, nonatomic) IBOutlet UISwitch *culturalSwitch;
@property (strong, nonatomic) IBOutlet UISwitch *religiousSwitch;

@property (assign, nonatomic) id <JCClubEditViewControllerDelegate> delegate;

-(IBAction)saveBtn:(id)sender;


@end
