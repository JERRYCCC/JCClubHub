//
//  JCClub.m
//  ClubHub
//
//  Created by Jerry on 7/8/14.
//  Copyright (c) 2014 JC. All rights reserved.
//

#import "JCClub.h"
#import <Parse/Parse.h>

@implementation JCClub{
    PFQuery *query;
    NSArray *clublist;
    PFObject *club;
}

-(id)init{
    if(self){
        query = [PFQuery queryWithClassName:@"Club"];
    }
    return self;
}

-(id)initWithId:(NSString*) clubId
{
    
    if(self){
        query = [PFQuery queryWithClassName :@"Club"];
        club = [query getObjectWithId:clubId];
    }
    
    return self;
}

-(void)deleteClub{
    
    PFQuery *Userquery = [PFQuery queryWithClassName:@"user"];
    //remove club's follow relation
    
    
    //remove club's event marked relation
    
    //remove
    [club delete];
}

@end
