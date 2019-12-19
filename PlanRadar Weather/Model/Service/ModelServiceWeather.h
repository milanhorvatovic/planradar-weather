//
//  ModelServiceWeather.h
//  PlanRadar Weather
//
//  Created by worker on 19/12/2019.
//  Copyright © 2019 Milan Horvatovic. All rights reserved.
//

@import Foundation;

@import Mantle;

@interface ModelServiceWeather: MTLModel

@property (nonnull, readonly, strong, nonatomic) NSNumber *identifier;
@property (nonnull, readonly, copy, nonatomic) NSString *cityName;
@property (nonnull, readonly, copy, nonatomic) NSString *countryCode;

@property (nonnull, readonly, copy, nonatomic) NSString *state;
@property (nonnull, readonly, strong, nonatomic) NSNumber *temperature;
@property (nonnull, readonly, strong, nonatomic) NSNumber *humidity;
@property (nonnull, readonly, strong, nonatomic) NSNumber *windSpeed;

@property (nonnull, readonly, strong, nonatomic) NSDate *date;

@end

