//
//  ModelServiceWeatherList.h
//  PlanRadar Weather
//
//  Created by worker on 20/12/2019.
//  Copyright © 2019 Milan Horvatovic. All rights reserved.
//

@import Foundation;

@import Mantle;
@class ModelServiceWeather;

@interface ModelServiceWeatherList: MTLModel

@property (nonnull, readonly, strong, nonatomic) NSArray<ModelServiceWeather *> *list;

@end

