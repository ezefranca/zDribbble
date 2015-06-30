//
//  zDribbbleTests.m
//  zDribbbleTests
//
//  Created by Ezequiel França on 6/28/15.
//  Copyright (c) 2015 Ezequiel França. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "ShotsViewController.h"
#import "DetalhesViewController.h"

@interface zDribbbleTests : XCTestCase

@property (nonatomic) ShotsViewController *vcTest;
@property (nonatomic) DetalhesViewController *dtTest;
@end

@implementation zDribbbleTests

- (void)setUp {
    [super setUp];
    
    // Testar a requisicao para API do Dribble
    
    _vcTest = [[ShotsViewController alloc]init];
    [_vcTest loadShots];
    XCTAssertEqualObjects(_vcTest.shotsArray, nil, @"A Requisicao para API nao funcionou");
    
    if (_vcTest.shotsArray) {
        _dtTest = [[DetalhesViewController alloc]init];
        _dtTest.shot = [_vcTest.shotsArray objectAtIndex:0];
        XCTAssertEqualObjects(_dtTest.shot, nil, @"A Atribuicao do Shot para os detalhes nao funcionou");
    }
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    XCTAssert(YES, @"Pass");
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
