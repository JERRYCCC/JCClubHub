//
//  JCRegisterFunction.h
//  ClubHub
//
//  Created by Jerry on 7/1/14.
//  Copyright (c) 2014 JC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JCSchoolForRegister : NSObject

-(NSMutableArray*)getSchoolNameList;
-(id)getSchoolId: (int)rowNum;

@end
