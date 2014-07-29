//
//  JCEventEditViewController.h
//  ClubHub
//
//  Created by Jerry on 7/9/14.
//  Copyright (c) 2014 JC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@class JCEventEditViewController;
@protocol JCEventEditViewControllerDelegate <NSObject>

-(void)doneEditing:(JCEventEditViewController*)editVC pass:(PFObject*)eventObject;

@end


@interface JCEventEditViewController : UIViewController <UITextFieldDelegate, UITextViewDelegate, UIAlertViewDelegate>

@property (strong, nonatomic) PFObject *currentEvent;

@property (strong, nonatomic) IBOutlet UITextField *nameField;
@property (strong, nonatomic) IBOutlet UITextField *locationField;
@property (strong, nonatomic) IBOutlet UITextView *descriptionView;
@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;

@property (assign, nonatomic) id <JCEventEditViewControllerDelegate> delegate;

-(IBAction)saveBtn:(id)sender;

@end
