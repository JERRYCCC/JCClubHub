//
//  JCPostCreateViewController.m
//  ClubHub
//
//
//  Created by Jerry on 7/25/14.
//  Copyright (c) 2014 JC. All rights reserved.
//

#import "JCPostCreateViewController.h"
#import "JCEventDetailViewController.h"

@interface JCPostCreateViewController ()

@end

@implementation JCPostCreateViewController
{
    NSString *userinfo;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
       
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = _currentEvent[@"name"];
    _postTextView.delegate=self;
    
    userinfo = [PFUser currentUser][@"username"];
    userinfo = [userinfo stringByAppendingString:@":\n"];
    _postTextView.text = userinfo;
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_postTextView resignFirstResponder];
}

-(IBAction)postBtn:(id)sender
{
    [self checkViewComplete];
}

-(void)checkViewComplete
{
    if([_postTextView.text isEqualToString:userinfo]&&_postImageView.image==nil){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oooopss!"
                                                        message:@"You cannot submit a blank post."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }else{
        [self createPost];
    }
}

-(void)createPost
{
    NSLog(@"posting.....");
    
    PFObject *newPost = [PFObject objectWithClassName:@"Post"];
    newPost[@"user"] = [PFObject objectWithoutDataWithClassName:@"_User" objectId:[PFUser currentUser].objectId];
    newPost[@"event"] = [PFObject objectWithoutDataWithClassName:@"Event" objectId:_currentEvent.objectId];
    newPost[@"postString"] = _postTextView.text;
    if (_postImageView.image!=nil) {
        newPost[@"image"] = _postImageView.image;
    }
    
    //you like the post automatically if you submit the post
    [newPost setObject:[PFUser currentUser] forKey:@"beLikedBy"];
    
    [newPost saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
        
        if(!error){
            NSLog(@"Post success!");
            _postImageView.image = nil;
            _postTextView.text = nil;
            
            [self performSegueWithIdentifier:@"toEventDetail" sender:self];
        }else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ooops!" message:@"Sorry we had a problem sending your post" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            
            [alert show];
        }
    }];
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if ([[segue identifier] isEqualToString:@"toEventDetail"]) {
        JCEventDetailViewController *eventDetailVC = [segue destinationViewController];
        eventDetailVC.currentEvent = _currentEvent;
    }
}

-(IBAction)selectPicBtn:(id)sender
{
    
    
    
}
-(IBAction)pickPicBtn: (id)sender
{
    
    
    
}

@end
