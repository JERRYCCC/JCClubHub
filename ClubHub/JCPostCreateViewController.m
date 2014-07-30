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

@synthesize imageView, textField;


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
    textField.delegate =self;
    
    NSString *string = @"";
    string = [string stringByAppendingString:[PFUser currentUser].username];
    string = [string stringByAppendingString:@": "];
    [textField setText:string];
}

-(void)cameraBtn:(id)sender
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Upload a photo" message:nil delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:@"Take a photo", @"Choose existing", nil];
    
    alert.alertViewStyle = UIAlertViewStyleDefault;
    
    [alert show];
}

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex ==1){
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        [imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
        [self presentViewController:imagePicker animated:YES completion:NULL];
    }
    
    if(buttonIndex ==2){
        UIImagePickerController *imagePicker2 = [[UIImagePickerController alloc] init];
        imagePicker2.delegate = self;
        [self presentViewController:imagePicker2 animated:YES completion:NULL];
    }
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [imageView setImage:image];
    [self dismissViewControllerAnimated:YES completion:NULL];
}


-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [textField resignFirstResponder];
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
    if(self.textField){
        [self.textField resignFirstResponder];
    }
    return NO;
}

//moving the view when edit
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.2];
    [UIView setAnimationBeginsFromCurrentState:YES];
    self.view.frame = CGRectMake(self.view.frame.origin.x, (self.view.frame.origin.y - 215.0), self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.2];
    [UIView setAnimationBeginsFromCurrentState:YES];
    self.view.frame = CGRectMake(self.view.frame.origin.x, (self.view.frame.origin.y + 215.0), self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
}

-(IBAction)postBtn:(id)sender
{
    NSLog(@"posting.....");
    
    PFObject *newPost = [PFObject objectWithClassName:@"Post"];
    newPost[@"user"] = [PFObject objectWithoutDataWithClassName:@"_User" objectId:[PFUser currentUser].objectId];
    newPost[@"event"] = [PFObject objectWithoutDataWithClassName:@"Event" objectId:_currentEvent.objectId];
    newPost[@"postString"] = textField.text;
    
    //the image need to saved as PFFile and passed as data
    PFFile *imageFile = [PFFile fileWithData:UIImagePNGRepresentation(imageView.image)];
    if (imageFile!=nil) {
        newPost[@"image"] = imageFile;
    }
    
    //you like the post automatically if you submit the post
    newPost[@"likeNum"] = [NSNumber numberWithInt:1];
    PFRelation *relation = [newPost relationforKey:@"like"];
    [relation addObject:[PFUser currentUser]];
    
    [newPost saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
        
        if(!error){
            
            NSLog(@"Done post!!!!");
            [self.delegate donePosting:_currentEvent];
            
        }else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ooops!" message:@"Sorry we had a problem sending your post" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            
            [alert show];
        }
    }];
}

@end
