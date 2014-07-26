//
//  JCPostTableViewCell.m
//  ClubHub
//
//  Created by Jerry on 7/26/14.
//  Copyright (c) 2014 JC. All rights reserved.
//

#import "JCPostTableViewCell.h"

@implementation JCPostTableViewCell

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
    _label.text = _currentPost[@"postString"];
    
    NSLog(_label.text);
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
