//
//  JCEventCreateViewController.h
//  ClubHub
//
//  Created by Jerry on 7/2/14.
//  Copyright (c) 2014 JC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@protocol JCEventCreateViewControllerDelegate <NSObject>

-(void)doneEventCreate:(PFObject*)clubObject;

@end

@interface JCEventCreateViewController : UIViewController<UITextFieldDelegate, UITextViewDelegate, UIAlertViewDelegate>

@property (strong, nonatomic) IBOutlet UIBarButtonItem *saveBtn;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *cancelBtn;

@property (strong, nonatomic) IBOutlet UITextField *nameField;
@property (strong, nonatomic) IBOutlet UITextField *locationField;
@property (strong, nonatomic) IBOutlet UITextView *descriptionView;
@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;

@property (weak, nonatomic) PFObject *targetClub;

@property (assign, nonatomic) id <JCEventCreateViewControllerDelegate> delegate;

-(IBAction)saveBtn:(id)sender;
-(IBAction)cancelBtn:(id)sender;


@end
