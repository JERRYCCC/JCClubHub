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

@synthesize postTextView, dateLabel, currentPost, postImageView, locationLabel, likeBtn, commentBtn, commentTableView;

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
    postTextView.editable = NO;
    postTextView.text = currentPost[@"postString"];
    
    if(currentPost[@"image"]!=nil){
        PFFile *file = [currentPost objectForKey:@"image"];
        NSData  *data = [file getData];
        postImage = [UIImage imageWithData:data];
        postImageView.image = postImage;
    }
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm MMM-d"];
    dateLabel.text = [formatter stringFromDate:currentPost.createdAt];
    
    locationLabel.text = currentPost[@"location"];
    
    NSString* string=@"Like(";
    string = [string stringByAppendingString:[NSString stringWithFormat:@"%@", currentPost[@"likeNum"]]];
    string = [string stringByAppendingString:@")"];
    [likeBtn setTitle:string forState:UIControlStateNormal];
    
    PFRelation *relation = [currentPost relationforKey:@"like"];
    PFQuery *query = [relation query];
    [query whereKey:@"objectId" equalTo:[PFUser currentUser].objectId];
    
    if([query getFirstObject]==nil||query==nil){
        likeBtn.enabled = YES;
    }else{
        likeBtn.enabled = NO;
        [likeBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    }
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

-(IBAction)commentBtn:(id)sender
{
    NSLog(@"comment Btn");
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:currentPost[@"postString"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    
    UITableView *tableView = [[UITableView alloc] init];
    NSMutableArray *commentArray = currentPost[@"comment"];

    [alert addSubview:tableView];
    
    
    [alert show];
    
}

-(IBAction)imageBtn:(id)sender
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:currentPost[@"postString"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:postImage];
    [alert addSubview:imageView];
    
    [alert show];
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end
