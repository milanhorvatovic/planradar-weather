//
//  NetworkEngineMock.m
//  PlanRadar WeatherTests
//
//  Created by worker on 19/12/2019.
//  Copyright © 2019 Milan Horvatovic. All rights reserved.
//

@import Foundation;

@protocol NetworkEngine;

NS_ASSUME_NONNULL_BEGIN

@interface NetworkEngineMock: NSObject

+ (id<NetworkEngine>)realMock;
    
@end

NS_ASSUME_NONNULL_END
