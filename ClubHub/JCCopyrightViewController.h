//
//  JCCopyrightViewController.h
//  ClubHub
//
//  Created by Jerry on 7/6/14.
//  Copyright (c) 2014 JC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JCCopyrightViewController : UIViewController <UITextViewDelegate>

@property (strong, nonatomic) IBOutlet UIBarButtonItem *menuBtn;

@property (strong, nonatomic) IBOutlet UITextView *textView;

-(IBAction)sendBtn:(id)sender;
-(IBAction)emailBtn:(id)sender;
@end
