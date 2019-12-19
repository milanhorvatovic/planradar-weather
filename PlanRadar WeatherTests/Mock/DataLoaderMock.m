//
//  DataLoaderMock.m
//  PlanRadar WeatherTests
//
//  Created by worker on 19/12/2019.
//  Copyright © 2019 Milan Horvatovic. All rights reserved.
//

#import "DataLoaderMock.h"

#import "DataLoader.h"
#import "NetworkEngine.h"

@implementation DataLoaderMock

+ (DataLoader *)realMockWithEngine:(id<NetworkEngine>)engine {
    return [[DataLoader alloc] initWithBasePath:@"https://api.openweathermap.org/data/2.5"
                                         engine:engine];
}

@end
