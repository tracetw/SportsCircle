//
//  SportsCircleTests.m
//  SportsCircleTests
//
//  Created by  tracetw on 2015/7/8.
//  Copyright (c) 2015年 SportsCircle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "TrendViewController.h"
@interface SportsCircleTests : XCTestCase

@end

@implementation SportsCircleTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    XCTAssert(YES, @"Pass");
}

- (void)testPlus {
    // This is an example of a functional test case.
    
    TrendViewController *class = [TrendViewController new];
    
    NSInteger result = [class plusWithNumber1:8 number2:3];
    
    XCTAssertEqual(result, 11, @"8 + 3 should be 11.");
    
    XCTAssert(YES, @"Plus Test Pass");
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
        int numbe1 = 0;
        int numbe2 = 0;
        int numbe3 = numbe1 + numbe2;
        NSLog(@"number:%d",numbe3);
        for (int i = 0; i<100; i++) {
            NSLog(@"number:%ld",(long)numbe3);
        }
    }];
}

@end
