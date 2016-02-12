//
//  NikeFetchDataTestTests.m
//  NikeFetchDataTestTests
//
//  Created by SureshDokula on 09/02/16.
//  Copyright © 2016 SureshDokula. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ViewController.h"
#import "Products.h"

@interface NikeFetchDataTestTests : XCTestCase<DataDownLoaderProtocol>
{
    XCTestExpectation *expectation;
    ViewController *test;
}
@end

@implementation NikeFetchDataTestTests

-(void)downloadedData:(NSData*)data withCurrentDownloaderObject:(DataDownLoader*)downldr
{
    [expectation fulfill];
    NSLog(@"result %@",data);
    [self checkingResultData:data];
}

-(void)checkingResultData:(NSData*)data
{
    NSMutableArray *arrproducts = [NSMutableArray array];
    __block NSInteger countOfProducts  = 0;
    dispatch_sync(dispatch_get_main_queue(), ^{
        NSError *error;
        id jsonresult = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves  error:&error];
        XCTAssertNotNil(jsonresult, "data should not be nil");
        XCTAssertNil(error, "error should be nil");
        if(error == nil)
        {
            if([jsonresult isKindOfClass:[NSDictionary class]])
            {
                NSDictionary *dict = (NSDictionary*)jsonresult;
                if([dict objectForKey:@"results"] != nil && [[dict objectForKey:@"results"] isKindOfClass:[NSArray class]]){
                    NSMutableArray *arr = [NSMutableArray arrayWithArray:[dict objectForKey:@"results"]];
                    for (NSDictionary *obj in arr) {
                        Products *prd      = [Products new];
                        [prd setProduct:obj];
                        [arrproducts addObject:prd];
                    }
                    countOfProducts = [[dict objectForKey:@"results"] count];
                    XCTAssertEqual([arrproducts count],countOfProducts, @"Equal size downloaded and saved");
                }
            }
        }
    });

}
-(void)failWithError:(NSError*)error withCurrentDownloaderObject:(DataDownLoader*)downldr
{
    [expectation fulfill];
    NSLog(@"result %@",error);
}

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}


- (void)testAsynchronousDelegate
{
    // asynchronous block callback was called expectation
    expectation = [self expectationWithDescription:@"HTTP request"];
    test = [ViewController new];
//    XCTAssertNil(test.tableView, "Before loading the table view should be nil");
//    XCTAssertTrue(test.tableView != nil, "The table view should be set");
   
    [test downloadData:@"http://www.petesalvo.com/products.json" andDelegate:self];
    /* wait for the asynchronous block callback was called expectation to be fulfilled
     fail after 5 seconds */
    [self waitForExpectationsWithTimeout:5
                                 handler:^(NSError *error) {
                                     // handler is called on _either_ success or failure
                                     if (error != nil) {
                                         XCTFail(@"timeout error: %@", error);
                                     }
                                 }];
}


- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
