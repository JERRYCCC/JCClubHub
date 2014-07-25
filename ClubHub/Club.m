//
//  Club.m
//  ClubHub
//
//  Created by Jerry on 7/23/14.
//  Copyright (c) 2014 JC. All rights reserved.
//

#import "Club.h"

@implementation Club

@synthesize clubId, name, email, password, description, tags, followNum, school, club, admins;

-(id) init
{
    if (self = [super init]) {
        name = [NSString stringWithFormat:@"Name"];
        email = [NSString stringWithFormat:@"Email"];
        password = [NSString stringWithFormat:@"password"];
        description = [NSString stringWithFormat:@"Description"];
        tags = nil;
        followNum = [NSNumber numberWithInt:1];
        school = nil;
        club = nil;
        admins = nil;
        
    }
        return self;
}
-(id) initWithId: (NSString*) newClubId;
{
    if(self = [super init]){
        clubId = newClubId;
    }
    return self;
}
/*
-(void)initWithName:(NSString*) newName
              Email:(NSString*) newEmail
           Passwrod:(NSString*) newPassword
        Description:(NSString*) newDescription
               Tags:(NSMutableArray*) newTags
             School:(School*) newSchool
               Club:(Club*) newClub
             Admins:(PFUser*) newAdmin;
{
    if(self = [super init]){
        name = newName;
        email = newEmail;
        password = newPassword;
        description = newDescription;
        tags = newTags;
        school = newSchool;
        club = newClub;
    }
    return self;
}
*/

-(void)saveClub
{
    PFObject *newClub = [PFObject objectWithClassName:@"Club"];
    newClub[@"name"] = name;
    newClub[@"email"] = email;
    newClub[@"password"] = password;
    newClub[@"tags"] = tags;
    newClub[@"followerNum"] = followNum;
    newClub[@"school"] = school;
    newClub[@"club"] = club;
    newClub[@"admins"] = admins;
    [newClub saveInBackground];
}


-(void)addAdmins:(PFUser *)newAdmin{
    
}

@end
