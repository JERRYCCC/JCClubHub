//
//  JCPostTableViewCell.h
//  ClubHub
//
//  Created by Jerry on 7/26/14.
//  Copyright (c) 2014 JC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface JCPostTableViewCell : UITableViewCell<UITextFieldDelegate>


@property (strong, nonatomic) PFObject *currentPost;

@property (strong, nonatomic) IBOutlet UILabel *postLabel;
@property (strong, nonatomic) IBOutlet UIImageView *postImageView;
@property (strong, nonatomic) IBOutlet UIButton *imageBtn;

@property (strong, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic) IBOutlet UIButton *likeBtn;

-(IBAction)likeBtn:(id)sender;
-(IBAction)imageBtn:(id)sender;

@end
