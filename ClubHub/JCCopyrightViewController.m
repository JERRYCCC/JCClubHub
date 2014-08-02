//
//  JCCopyrightViewController.m
//  ClubHub
//
//  Created by Jerry on 7/6/14.
//  Copyright (c) 2014 JC. All rights reserved.
//

#import "JCCopyrightViewController.h"
#import "SWRevealViewController.h"
#import <Parse/Parse.h>

@interface JCCopyrightViewController ()

@end

@implementation JCCopyrightViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    
    [self.menuBtn setTarget:self.revealViewController];
    [self.menuBtn setAction:@selector(revealToggle:)];
    [self.navigationController.navigationBar addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
    _textView.delegate = self;
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_textView resignFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)sendBtn:(id)sender
{
    [_textView resignFirstResponder];
    [self checkComplete];
}

-(void)checkComplete
{
    if([_textView.text isEqualToString:@""]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oooopss!"
                                                        message:@"You need to complete all fields"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }else{
        [self submit];
    }
}

-(void)submit
{
    PFObject *newComment = [PFObject objectWithClassName:@"AppComment"];
    newComment[@"comment"] = _textView.text;
    newComment[@"user"] = [PFUser currentUser];
    
    [newComment saveInBackground];
    
    _textView.text = nil;
}
-(IBAction)emailBtn:(id)sender
{
   
}

@end
