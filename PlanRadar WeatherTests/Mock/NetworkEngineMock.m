//
//  NetworkEngineMock.m
//  PlanRadar WeatherTests
//
//  Created by worker on 19/12/2019.
//  Copyright © 2019 Milan Horvatovic. All rights reserved.
//

#import "NetworkEngineMock.h"

@import AFNetworking;

#import "NetworkEngine.h"

@implementation NetworkEngineMock

+ (id<NetworkEngine>)realMock {
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    return manager;
}

@end
