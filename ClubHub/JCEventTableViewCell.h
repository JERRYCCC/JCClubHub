//
//  JCEventTableViewCell.h
//  ClubHub
//
//  Created by Jerry on 6/30/14.
//  Copyright (c) 2014 JC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWTableViewCell.h"

@interface JCEventTableViewCell : SWTableViewCell

@property (strong, nonatomic) IBOutlet UILabel *titleLable;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;

@property (strong, nonatomic) UIButton *deleteBtn;
@property (strong, nonatomic) UIButton *moreBtn;
@property (strong, nonatomic) UIButton *remindBtn;

-(IBAction)deleteBtn:(id)sender;
-(IBAction)moreBtn:(id)sender;
-(IBAction)remind:(id)sender;

@end
