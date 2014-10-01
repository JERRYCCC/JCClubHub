//
//  JCAccountViewController.m
//  ClubHub
//
//  Created by Jerry Cai on 10/1/14.
//  Copyright (c) 2014 JC. All rights reserved.
//

#import "JCAccountViewController.h"
#import "SWRevealViewController.h"

@interface JCAccountViewController ()

@end

@implementation JCAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //set up the menu button
    [self.menuBtn setTarget:self.revealViewController];
    [self.menuBtn setAction:@selector(revealToggle:)];
    [self.navigationController.navigationBar addGestureRecognizer:self.revealViewController.panGestureRecognizer];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)registerBtn:(id)sender{
    
    [self performSegueWithIdentifier:@"toLogIn" sender:self];
}

-(IBAction)logOutBtn:(id)sender{
    [PFUser logOut];
    [self performSegueWithIdentifier:@"logOut" sender:self];
    
}



@end
