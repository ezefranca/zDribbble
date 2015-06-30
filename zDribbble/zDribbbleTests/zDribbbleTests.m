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
    if (_vcTest.shotsArray) {
        _dtTest = [[DetalhesViewController alloc]init];
        _dtTest.shot = [_vcTest.shotsArray objectAtIndex:0];
    }
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testDaRotinadeErro{
    // teste simples da rotina de erros
    NSError *erro = [[NSError alloc]initWithDomain:@"Teste" code:42 userInfo:@{@"nome":@"Erro Teste"}];
    [_vcTest errorAlert:erro];
}

-(void)testDownloadShots{
    _vcTest = [[ShotsViewController alloc]init];
    [_vcTest loadShots];
    XCTAssertNil(_vcTest.shotsArray, @"A Requisicao para API nao funcionou");
}

-(void)testDetalhesViewControllerCreate{
    _vcTest = [[ShotsViewController alloc]init];
    [_vcTest loadShots];
    XCTAssertNil(_vcTest.shotsArray, @"A Requisicao para API nao funcionou");
    
    if (_vcTest.shotsArray) {
        _dtTest = [[DetalhesViewController alloc]init];
        _dtTest.shot = [_vcTest.shotsArray objectAtIndex:0];
        XCTAssertNil(_dtTest.shot, @"A Atribuicao do Shot para os detalhes nao funcionou");
    }
}

- (void)testShotsIntegridade{
    _vcTest = [[ShotsViewController alloc]init];
    [_vcTest loadShots];
    Shots *shot = [_vcTest.shotsArray objectAtIndex:0];
    XCTAssertNil(shot.shotId, @"ShotID Quebrado");
    XCTAssertNil(shot.shotTitle, @"ShotID Quebrado");
    XCTAssertNil(shot.shotDescription, @"ShotDescription Quebrado");
    XCTAssertNil(shot.shotHeigth, @"Height Quebrado");
    XCTAssertNil(shot.shotWidth, @"Width Quebrado");
    XCTAssertNil(shot.shotLikesCount, @"LikesCount Quebrado");
    XCTAssertNil(shot.shotCommentsCount, @"CommentsCount Quebrado");
    XCTAssertNil(shot.shotReboundsCount, @"ReboundsCount Quebrado");
    XCTAssertNil(shot.shotUrl, @"ShotUrl Quebrado");
    XCTAssertNil(shot.shotShortUrl, @"ShotShortURL Quebrado");
    XCTAssertNil(shot.shotViewsCount, @"Views Count Quebrado");
    XCTAssertNil(shot.shotReboundSourceId, @"ReboundSourceID Quebrado");
    XCTAssertNil(shot.shotImageUrl, @"shotImageUrl Quebrado");
    XCTAssertNil(shot.shotImageTeaserUrl, @"ImageTeaserUrl Quebrado");
    XCTAssertNil(shot.shotImage400Url, @"Image400 Quebrado");
    XCTAssertNil(shot.shotReboundSourceId, @"ReboundSourceID Quebrado");
    XCTAssertNil(shot.shotImageUrl, @"ImageUrl Quebrado");
    XCTAssertNil(shot.shotPlayer, @"shotPlayer Quebrado");
    XCTAssertNil(shot.shotCreatedAt, @"Data Criacao Quebrado");
    XCTAssert(YES, @"Fim do teste de integridade de um objeto Shot");
}


- (void)testExample {
    // This is an example of a functional test case.
    XCTAssert(YES, @"Pass");
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    _vcTest = [[ShotsViewController alloc]init];
    
    [self measureBlock:^{
        // Performace do tempo do request
        [_vcTest loadShots];
        XCTAssert(YES, @"Pass");
    }];
}

- (void)testConectividadeAPI {
    NSURL *URL = [NSURL URLWithString:@"http://api.dribbble.com/shots/popular"];
    NSString *description = [NSString stringWithFormat:@"GET %@", URL];
    XCTestExpectation *expectation = [self expectationWithDescription:description];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithURL:URL
                                        completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
                                  {
                                      XCTAssertNotNil(data, "data nao pode ser nula");
                                      XCTAssertNil(error, "erro deve ser nulo");
                                      
                                      if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
                                          NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
                                          XCTAssertEqual(httpResponse.statusCode, 200, @"OK - HTTP 200");
                                      } else {
                                          XCTFail(@"Resposta quebrada - nao eh NSHTTPURLResponse");
                                      }
                                      
                                      [expectation fulfill];
                                  }];
    
    [task resume];
    
    [self waitForExpectationsWithTimeout:task.originalRequest.timeoutInterval handler:^(NSError *error) {
        if (error != nil) {
            NSLog(@"Error: %@", error.localizedDescription);
        }
        [task cancel];
    }];
}

@end
