//
//  JCCommentViewController.m
//  ClubHub
//
//  Created by Jerry on 8/6/14.
//  Copyright (c) 2014 JC. All rights reserved.
//

#import "JCCommentViewController.h"

@interface JCCommentViewController ()

@end

@implementation JCCommentViewController
{
    NSMutableArray *commentList;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _commentTextField.delegate = self;
    
    //get the comment list
    commentList = [[NSMutableArray alloc] init];
    if(_currentPost[@"comment"]!=nil){
        commentList = _currentPost[@"comment"];
    }
    
    _commentTextField.text = [[PFUser currentUser][@"username"] stringByAppendingString:@" : "];
    
}

//scroll to the bottom
- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (_commentTableView.contentSize.height > _commentTableView.frame.size.height)
    {
        CGPoint offset = CGPointMake(0, _commentTableView.contentSize.height - _commentTableView.frame.size.height);
        [self.commentTableView setContentOffset:offset animated:YES];
    }
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_commentTextField resignFirstResponder];
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
    if(self.commentTextField){
        [self.commentTextField resignFirstResponder];
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

-(IBAction)sendBtn:(id)sender
{
    if ([_commentTextField.text isEqualToString:([[PFUser currentUser][@"username"] stringByAppendingString:@" : "])]) {
        
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Oooopss!"
                              message:@"Comment Can Not Be Empty!"
                              delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
        
    } else {
        [self sendComment];
    }
}

-(void) sendComment
{
    [commentList addObject:_commentTextField.text];
    _currentPost[@"comment"] = commentList;
    [_currentPost saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if(succeeded){
            [self.commentTableView reloadData];
            _commentTextField.text = [[PFUser currentUser][@"username"] stringByAppendingString:@" : "];
            [self viewDidAppear:YES];
        }
    }];
    
    [_commentTextField resignFirstResponder];
}

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [commentList count];
}

-(UITableViewCell*)tableView:(UITableView *)tableView
       cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"commentCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    if(cell==nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.textLabel.text = [commentList objectAtIndex:indexPath.row];
    
    return cell;
}

@end
