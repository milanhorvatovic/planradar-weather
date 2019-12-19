//
//  DataLoaderMock.h
//  PlanRadar WeatherTests
//
//  Created by worker on 19/12/2019.
//  Copyright © 2019 Milan Horvatovic. All rights reserved.
//

@import Foundation;

@class DataLoader;
@protocol NetworkEngine;

NS_ASSUME_NONNULL_BEGIN

@interface DataLoaderMock : NSObject

+ (DataLoader *)realMockWithEngine:(id<NetworkEngine>)engine;

@end

NS_ASSUME_NONNULL_END
