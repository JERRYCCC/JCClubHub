//
//  JCClubViewController.m
//  ClubHub
//
//  Created by Jerry on 6/29/14.
//  Copyright (c) 2014 JC. All rights reserved.
//

#import "JCClubDetailViewController.h"

@interface JCClubDetailViewController ()

@end

@implementation JCClubDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _nameLabel.text = (_clubObject[@"name"]);
    
    NSString *tagString=@"";
    for(NSString *string in _clubObject[@"tags"]){
        
        tagString = [tagString stringByAppendingString:string];
        tagString = [tagString stringByAppendingString:@ ", "];
    }
   
    _tagsTextView.text = tagString;
    _tagsTextView.editable=NO;
    
    _descriptionTextView = (_clubObject[@"description"]);
    _descriptionTextView.editable=NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
