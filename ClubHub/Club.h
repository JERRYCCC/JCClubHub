//
//  Club.h
//  ClubHub
//
//  Created by Jerry on 7/23/14.
//  Copyright (c) 2014 JC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import "School.h"
#import "Club.h"

@interface Club : PFObject


@property (strong, nonatomic) NSString* clubId;  //assigned by the system
@property (readwrite, strong, nonatomic) NSString *name;
@property (readwrite, strong, nonatomic) NSString *email;
@property (readwrite, strong, nonatomic) NSString *password;
@property (readwrite, strong, nonatomic) NSString *description;
@property (readwrite, strong, nonatomic) NSMutableArray *tags;
@property (readwrite, strong, nonatomic) NSNumber *followNum;
@property (readwrite, strong, nonatomic) School *school;
@property (readwrite, strong, nonatomic) Club *club;
@property (readwrite, strong, nonatomic) PFRelation *admins;


//id was assigned by system, and the followNumber is "1" when built
/*
-(void)initWithName:(NSString*) newName
              Email:(NSString*) newEmail
           Passwrod:(NSString*) newPassword
        Description:(NSString*) newDescription
               Tags:(NSMutableArray*) newTags
             School:(School*) newSchool
               Club:(Club*) newClub
             Admins:(PFUser*) newAdmin;
 */

-(void)saveClub;
-(void)addAdmins:(PFRelation *)admins;









@end
