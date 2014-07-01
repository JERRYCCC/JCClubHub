//
//  JCBasicFunctionsTests.m
//  ClubHub
//
//  Created by Jerry on 7/1/14.
//  Copyright (c) 2014 JC. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "JCSchoolForRegister.h"

@interface JCBasicFunctionsTests : XCTestCase

@end

@implementation JCBasicFunctionsTests{
    JCSchoolForRegister *sfr;
}

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    sfr = [[JCSchoolForRegister alloc] init];
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}


- (void)testGetSchoolNameList
{
    
    NSString *testName = @"Austin College";
    
    
    
    XCTAssertEqualObjects([sfr getSchoolNameList][0], testName, @"Equal");
}

-(void)testGetSchoolId
{
    NSString *testId = @"qyAfrZlJk6";
    XCTAssertEqualObjects([sfr getSchoolId:0], testId, @"Equal");
}

@end
