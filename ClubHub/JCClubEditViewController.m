//
//  JCClubEditViewController.m
//  ClubHub
//
//  Created by Jerry on 7/18/14.
//  Copyright (c) 2014 JC. All rights reserved.
//

#import "JCClubEditViewController.h"
#import "JCClubDetailViewController.h"

@interface JCClubEditViewController ()

@end

@implementation JCClubEditViewController{
    NSString* oldName;
}

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
    _nameField.delegate = self;
    _descriptionView.delegate = self;
    
    oldName = _currentClub[@"name"];
    _nameField.text = _currentClub[@"name"];
    _descriptionView.text = _currentClub[@"description"];
    
    PFFile *file = [_currentClub objectForKey:@"image"];
    [file getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        [_imageBtn setBackgroundImage:[UIImage imageWithData:data] forState:UIControlStateNormal];
    }];
    
    NSArray *tagList = _currentClub[@"tags"];
    
    if([tagList containsObject:@"Academic"]){
        _academicSwitch.on = YES;
    }else{
        _academicSwitch.on = NO;
    }
    
    if([tagList containsObject:@"Sorority"]){
        _sororitySwitch.on = YES;
    }else{
        _sororitySwitch.on = NO;
    }
    
    if([tagList containsObject:@"Fraternity"]){
        _fraternitySwitch.on = YES;
    }else{
        _fraternitySwitch.on = NO;
    }
    
    if([tagList containsObject:@"Sports"]){
        _sportsSwitch.on = YES;
    }else{
        _sportsSwitch.on = NO;
    }
    
    if([tagList containsObject:@"Cultural"]){
        _culturalSwitch.on = YES;
    }else{
        _culturalSwitch.on = NO;
    }
    
    if([tagList containsObject:@"Religious"]){
        _religiousSwitch.on = YES;
    }else{
        _religiousSwitch.on = NO;
    }
}

-(BOOL)textFieldShouldReturn:(UITextField*) textField{
    if(textField){
        [textField resignFirstResponder];
    }
    return NO;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_nameField resignFirstResponder];
    [_descriptionView resignFirstResponder];
}

-(void)imageBtn:(id)sender
{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    [self presentViewController:imagePicker animated:YES completion:NULL];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [_imageBtn setBackgroundImage:image forState:UIControlStateNormal];
    [self dismissViewControllerAnimated:YES completion:NULL];
}


-(IBAction)saveBtn:(id)sender
{
    [self checkFieldsComplete];
}

-(void) checkFieldsComplete{
    
    if([_nameField.text isEqualToString:@""]||[_descriptionView.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oooopss!"
                                                        message:@"You need to complete all fields"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }else {
        [self checkTags];
    }
}


-(void) checkTags{
    
    if(_sororitySwitch.on==NO && _fraternitySwitch.on==NO && _academicSwitch.on==NO &&_sportsSwitch.on==NO && _culturalSwitch.on==NO && _religiousSwitch.on==NO)
    {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Oooopss!"
                              message:@"Pick at least one tags for your club"
                              delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
    }
    else {
        
        //no change to the name
        if([_nameField.text isEqualToString:oldName]){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Congratulation"
                                                            message:@"Want to save this club now?"
                                                           delegate:self
                                                  cancelButtonTitle:@"Cancel"
                                                  otherButtonTitles:@"Save", nil];
            [alert show];
        }else{
            [self checkUniqeness];
        }
    }
}

-(void) checkUniqeness
{
    PFQuery *query = [PFQuery queryWithClassName:@"Club"];
    [query whereKey:@"name" equalTo:_nameField.text];
    NSArray *clubList = [query findObjects];
    
    if([clubList count]==0||clubList==nil){
        //build the club
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Congratulation"
                                                        message:@"Want to save this club now?"
                                                       delegate:self
                                              cancelButtonTitle:@"Cancel"
                                              otherButtonTitles:@"Save", nil];
        [alert show];
    }else{
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Oooopss!"
                              message:@"Club Name has been taken"
                              delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
    }
}

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    
    if([[alertView title] isEqualToString:@"Congratulation"] && buttonIndex ==1){
        
        [self saveEditedClub];
    }
    
    if ([[alertView title] isEqualToString:@"Cancel Edit"]) {
        [self performSegueWithIdentifier:@"toClubDetail" sender:self];
    }
}


-(void)saveEditedClub
{
    
    NSLog(@"Saving......");
    
    NSMutableArray *tagList = [[NSMutableArray alloc] init];
    if(_sororitySwitch.on==YES){
        [tagList addObject:@"Sorority"];
    }
    if(_fraternitySwitch.on==YES){
        [tagList addObject:@"Fraternity"];
    }
    if(_academicSwitch.on==YES){
        [tagList addObject:@"Academic"];
    }
    if(_sportsSwitch.on == YES){
        [tagList addObject:@"Sports"];
    }
    if(_culturalSwitch.on == YES){
        [tagList addObject:@"Cultural"];
    }
    if(_religiousSwitch.on == YES){
        [tagList addObject:@"Religious"];
    }
    
    _currentClub[@"name"] = _nameField.text;
    _currentClub[@"description"] = _descriptionView.text;
    _currentClub[@"tags"] = tagList;
    PFFile *imageFile = [PFFile fileWithData:UIImagePNGRepresentation(_imageBtn.currentBackgroundImage)];
    _currentClub[@"image"] = imageFile;
    
    [_currentClub saveInBackgroundWithBlock: ^(BOOL succeeded, NSError *error){
        if (!error) {
            
            NSLog(@"save success!");
            
            [self.delegate doneClubEditing:_currentClub];
            
        }else{
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ooops!" message:@"Sorry we had a problem saving you a club" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            
            [alert show];
            
        }
    }];
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if ([[segue identifier] isEqualToString:@"toClubDetail"]) {
        
        JCClubDetailViewController *detailVC = [segue destinationViewController];
        detailVC.currentClub = _currentClub;
    }
    
}

//moving the view when edit
-(void)textViewDidBeginEditing:(UITextView*)textView
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.2];
    [UIView setAnimationBeginsFromCurrentState:YES];
    self.view.frame = CGRectMake(self.view.frame.origin.x, (self.view.frame.origin.y - 80.0), self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
}

-(void)textViewDidEndEditing:(UITextView*)textView
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.2];
    [UIView setAnimationBeginsFromCurrentState:YES];
    self.view.frame = CGRectMake(self.view.frame.origin.x, (self.view.frame.origin.y + 80.0), self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
}

@end
