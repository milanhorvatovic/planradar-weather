//
//  DataLoaderTests.m
//  PlanRadar WeatherTests
//
//  Created by worker on 19/12/2019.
//  Copyright © 2019 Milan Horvatovic. All rights reserved.
//

@import XCTest;

#import "DataLoader.h"
#import "NetworkEngine.h"
#import "NetworkEngineMock.h"
#import "DataLoaderMock.h"

@interface DataLoaderTests: XCTestCase

@end

@interface DataLoaderTests (Prepare)

- (DataLoader *)_prepareRealLoaderWithEngine:(id<NetworkEngine>)engine;
- (id<NetworkEngine>)_prepareRealNetworkEngine;

@end

@interface DataLoaderTests (Try)

- (void)_tryWithName:(NSString *)name
               using:(DataLoader *)loader;

- (void)_tryWithIds:(NSArray<NSNumber *> *)ids
              using:(DataLoader *)loader;

@end

@implementation DataLoaderTests

- (void)test_load {
    DataLoader *loader = [self _prepareRealLoaderWithEngine:[self _prepareRealNetworkEngine]];
    
    
    NSArray<NSString *> *samples = @[@"san francisco",
                                     @"chicago",
                                     @"new york",
                                     @"london",
                                     @"vienna"];
    
    for (NSString *sample in samples) {
        [self _tryWithName:sample
                     using:loader];
    }
}

- (void)test_load_multiple {
    DataLoader *loader = [self _prepareRealLoaderWithEngine:[self _prepareRealNetworkEngine]];
    
    NSArray<NSNumber *> *samples = @[@3669881,
                                     @4887398,
                                     @5128581,
                                     @2643743,
                                     @2761369,];
    
    [self _tryWithIds:samples
                 using:loader];
}

@end

@implementation DataLoaderTests (Prepare)

- (DataLoader *)_prepareRealLoaderWithEngine:(id<NetworkEngine>)engine {
    return [DataLoaderMock realMockWithEngine:engine];
}

- (id<NetworkEngine>)_prepareRealNetworkEngine {
    return [NetworkEngineMock realMock];
}

@end


@implementation DataLoaderTests (Try)

- (void)_tryWithName:(NSString *)name
               using:(DataLoader *)loader {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Async data loading"];
    
    [loader loadWeatherWithName:name
                   completition:^(ModelServiceWeather * _Nullable object, NSError * _Nullable error) {
        XCTAssertNotNil(object);
        XCTAssertNil(error);
        NSLog(@"Received object: %@", object);
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:60
                                 handler:^(NSError * _Nullable error) {
        if (error) {
            XCTFail(@"Expectation Failed with error: %@", error);
        }
    }];
}

- (void)_tryWithIds:(NSArray<NSNumber *> *)ids
               using:(DataLoader *)loader {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Async data loading"];
    
    [loader loadWeathersWithIds:ids
                   completition:^(NSArray<ModelServiceWeather *> * _Nullable object, NSError * _Nullable error) {
        XCTAssertNotNil(object);
        XCTAssertNil(error);
        XCTAssertTrue(object.count > 0);
        NSLog(@"Received object: %@", object);
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
