//
//  JCEventDetailViewController.h
//  ClubHub
//
//  Created by Jerry on 6/30/14.
//  Copyright (c) 2014 JC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface JCEventDetailViewController : UIViewController

@property (weak, nonatomic) PFObject *currentEvent;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic) IBOutlet UITextView *locationTextView;
@property (strong, nonatomic) IBOutlet UITextView *descriptionTextView;

-(IBAction)deleteBtn:(id)sender;


@end
