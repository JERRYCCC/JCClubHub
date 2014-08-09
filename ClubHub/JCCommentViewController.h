//
//  JCCommentViewController.h
//  ClubHub
//
//  Created by Jerry on 8/6/14.
//  Copyright (c) 2014 JC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface JCCommentViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property (strong, nonatomic) PFObject *currentPost;
@property (strong, nonatomic) IBOutlet UITextField*commentTextField;

@property (strong, nonatomic) IBOutlet UITableView *commentTableView;

-(IBAction)sendBtn:(id)sender;

@end
