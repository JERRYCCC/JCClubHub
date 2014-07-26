//
//  JCPostTableViewCell.h
//  ClubHub
//
//  Created by Jerry on 7/26/14.
//  Copyright (c) 2014 JC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface JCPostTableViewCell : UITableViewCell <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) PFObject *currentPost;

@property (strong, nonatomic) IBOutlet UITextView *postTextView;
@property (strong, nonatomic) IBOutlet UIImageView *postImageView;

@property (strong, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic) IBOutlet UILabel *locationLabel;
@property (strong, nonatomic) IBOutlet UIButton *likeBtn;
@property (strong, nonatomic) IBOutlet UIButton *commentBtn;

@property (strong, nonatomic) IBOutlet UITableView *commentTableView;

-(IBAction)likeBtn:(id)sender;
-(IBAction)commentBtn:(id)sender;

@end
