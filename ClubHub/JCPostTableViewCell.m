//
//  JCPostTableViewCell.m
//  ClubHub
//
//  Created by Jerry on 7/26/14.
//  Copyright (c) 2014 JC. All rights reserved.
//

#import "JCPostTableViewCell.h"

@implementation JCPostTableViewCell
{
    UIImage *postImage;
}

@synthesize postLabel, dateLabel, currentPost, postImageView, likeBtn, imageBtn;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)layoutSubviews
{
    postLabel.text = currentPost[@"postString"];
    
    CGSize maximumlabelSize = CGSizeMake(304, FLT_MAX);
    CGSize expectedLabelSize = [postLabel.text sizeWithFont:postLabel.font constrainedToSize:maximumlabelSize lineBreakMode:NSLineBreakByWordWrapping];
    
    CGRect newFrame = postLabel.frame;
    newFrame.size.height = expectedLabelSize.height;
    postLabel.frame = newFrame;
    
    
    if([currentPost[@"withImage"] isEqualToNumber:[NSNumber numberWithBool:YES]]){
        PFFile *file = [currentPost objectForKey:@"image"];
        [file getDataInBackgroundWithBlock:^(NSData *data, NSError *error){
            postImageView.image = [UIImage imageWithData:data];
        }];
    }else{
        //set funnny pic
        
    }
    
   
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm MMM-d"];
    dateLabel.text = [formatter stringFromDate:currentPost.createdAt];
    
    NSString* string=@"Like(";
    string = [string stringByAppendingString:[NSString stringWithFormat:@"%@", currentPost[@"likeNum"]]];
    string = [string stringByAppendingString:@")"];
    [likeBtn setTitle:string forState:UIControlStateNormal];
    
    [self setLikeStatus];
}

-(void)setLikeStatus
{
    PFRelation *relation = [currentPost relationforKey:@"like"];
    PFQuery *query = [relation query];
    [query whereKey:@"objectId" equalTo:[PFUser currentUser].objectId];
    
    [query countObjectsInBackgroundWithBlock:^(int number, NSError *error){
        
        if(!error){
            if(number==0||query==nil){
                likeBtn.enabled = YES;
            }else{
                likeBtn.enabled = NO;
                [likeBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            }
        }
    }];
}

-(IBAction)likeBtn:(id)sender
{
    PFRelation *relation = [currentPost relationforKey:@"like"];
    [relation addObject:[PFUser currentUser]];
    
    [currentPost incrementKey:@"likeNum"];
    [currentPost saveInBackground];
    
    NSString* string=@"Like(";
    string = [string stringByAppendingString:[NSString stringWithFormat:@"%@", currentPost[@"likeNum"]]];
    string = [string stringByAppendingString:@")"];
    
     likeBtn.enabled = NO;
    [sender setTitle:string forState:UIControlStateNormal];
    [sender setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
}

-(IBAction)imageBtn:(id)sender
{
    /*
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:currentPost[@"postString"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:
                              CGRectMake(10.0, 10.0, 100.0, 300.0)];
	imageView.image = imageBtn.currentBackgroundImage;
    
    [self addSubview:imageView];
     */
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}


@end
