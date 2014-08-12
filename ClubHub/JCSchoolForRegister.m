//
//  JCRegisterFunction.m
//  ClubHub
//
//  Created by Jerry on 7/1/14.
//  Copyright (c) 2014 JC. All rights reserved.
//

#import "JCSchoolForRegister.h"
#import <Parse/Parse.h>

@implementation JCSchoolForRegister{
    PFQuery *schoolQuery;
    NSArray *schoolList;
}

- (id)init
{
    self = [super init];
    if (self) {
    
        // Custom initialization
        schoolQuery = [PFQuery queryWithClassName:@"School"];
        schoolQuery.cachePolicy = kPFCachePolicyNetworkElseCache;
        [schoolQuery orderByAscending:@"name"];
        schoolList = [schoolQuery findObjects];
        
    }
    return self;
}


-(NSMutableArray *)getSchoolNameList{
    
    NSInteger count = [schoolList count];
    NSMutableArray *schoolNameList = [[NSMutableArray alloc] init];
    
    for(int i=0; i<count; i++){
        
        NSString *stringName = schoolList[i][@"name"];
        
        [schoolNameList addObject:stringName];
    }
    
    return schoolNameList;
}

-(NSString *)getSchoolId:(NSInteger)rowNum{
    
    return [schoolList[rowNum] objectId];
}

-(NSString*) getSchoolDomain:(NSInteger)rowNum{
    
    NSString* domain = schoolList[rowNum][@"domain"];
    return domain;
}



@end
