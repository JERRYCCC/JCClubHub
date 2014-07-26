//
//  JCPostCreateViewController.h
//  ClubHub
//
//  Created by Jerry on 7/25/14.
//  Copyright (c) 2014 JC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface JCPostCreateViewController : UIViewController<UITextViewDelegate, UIAlertViewDelegate>

@property (strong, nonatomic) PFObject *currentEvent;

@property (strong, nonatomic) IBOutlet UITextView *postTextView;
@property (strong, nonatomic) IBOutlet UIImageView *postImageView;


-(IBAction)postBtn:(id)sender;
-(IBAction)pickPicBtn: (id)sender;
@end
