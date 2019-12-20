//
//  StaticCityDetailViewController.h
//  PlanRadar Weather
//
//  Created by worker on 20/12/2019.
//  Copyright © 2019 Milan Horvatovic. All rights reserved.
//

#import "CityDetailViewController.h"

@class WeatherInfo;

NS_ASSUME_NONNULL_BEGIN

@interface StaticCityDetailViewController: CityDetailViewController

- (instancetype)initWithWeatherInfo:(WeatherInfo *)weatherInfo;

@end

NS_ASSUME_NONNULL_END
