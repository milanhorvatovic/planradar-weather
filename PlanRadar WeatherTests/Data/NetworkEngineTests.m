//
//  NetworkEngineTests.m
//  PlanRadar WeatherTests
//
//  Created by worker on 19/12/2019.
//  Copyright © 2019 Milan Horvatovic. All rights reserved.
//

@import XCTest;

@import Mantle;

#import "NetworkEngine.h"
#import "NetworkEngineMock.h"
#import "ModelServiceWeather.h"

@interface NetworkEngineTests: XCTestCase

@end

@interface NetworkEngineTests (Prepare)

- (id<NetworkEngine>)_prepareRealNetworkEngine;

@end

@implementation NetworkEngineTests

- (void)test_load_from_network {
    id<NetworkEngine> networkEngine = [self _prepareRealNetworkEngine];
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Async network engine request"];
    
    Request *request = [[Request alloc] initWithBasePath:@"https://api.openweathermap.org/data/2.5"
                                            relativePath:@"/weather"
                                              queryItems:@[[NSURLQueryItem queryItemWithName:@"appid" value:@"d982cf2f779410e5a9e80342b414d39f"],
                                                           [NSURLQueryItem queryItemWithName:@"q" value:@"vienna"]]];
    [networkEngine performRequest:request
                     completition:^(NSDictionary * _Nullable json, NSError * _Nullable error) {
        XCTAssertNotNil(json);
        XCTAssertNil(error);
        NSLog(@"Received JSON: %@", json);
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:60
                                 handler:^(NSError * _Nullable error) {
        if (error) {
            XCTFail(@"Expectation Failed with error: %@", error);
        }
    }];
}

- (void)test_service_model_mapping {
    id<NetworkEngine> networkEngine = [self _prepareRealNetworkEngine];
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Async network engine request"];
    
    Request *request = [[Request alloc] initWithBasePath:@"https://api.openweathermap.org/data/2.5"
                                            relativePath:@"/weather"
                                              queryItems:@[[NSURLQueryItem queryItemWithName:@"appid" value:@"d982cf2f779410e5a9e80342b414d39f"],
                                                           [NSURLQueryItem queryItemWithName:@"q" value:@"vienna"]]];
    [networkEngine performRequest:request
                     completition:^(NSDictionary * _Nullable json, NSError * _Nullable error) {
        XCTAssertNotNil(json);
        XCTAssertNil(error);
        NSLog(@"Received JSON: %@", json);
        ModelServiceWeather *object = [MTLJSONAdapter modelOfClass:ModelServiceWeather.class
                                                fromJSONDictionary:json
                                                             error:&error];
        XCTAssertNil(error);
        XCTAssertNotNil(object);
        NSLog(@"Transformed object: %@", object);
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:60
                                 handler:^(NSError * _Nullable error) {
        if (error) {
            XCTFail(@"Expectation Failed with error: %@", error);
        }
    }];
}

@end

@implementation NetworkEngineTests (Prepare)

- (id<NetworkEngine>)_prepareRealNetworkEngine {
    return [NetworkEngineMock realMock];
}

@end
