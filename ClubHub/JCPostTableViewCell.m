//
//  JCPostTableViewCell.m
//  ClubHub
//
//  Created by Jerry on 7/26/14.
//  Copyright (c) 2014 JC. All rights reserved.
//

#import "JCPostTableViewCell.h"

@implementation JCPostTableViewCell

@synthesize postTextView, label;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void) layoutSubviews
{
    self.postTextView.text = self.currentPost[@"postString"];
    self.label.text = self.currentPost[@"postString"];
    NSLog(@"%@", self.postTextView.text);
    NSLog(@"%@", self.label.text);
    
    UIButton *scanQRCodeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    scanQRCodeButton.frame = CGRectMake(0.0f, 5.0f, 320.0f, 44.0f);
    scanQRCodeButton.backgroundColor = [UIColor redColor];
    [scanQRCodeButton setTitle:@"Hello" forState:UIControlStateNormal];
    [self addSubview:scanQRCodeButton];
    
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
