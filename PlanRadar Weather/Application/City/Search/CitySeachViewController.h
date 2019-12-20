//
//  CitySeachViewController.h
//  PlanRadar Weather
//
//  Created by worker on 20/12/2019.
//  Copyright © 2019 Milan Horvatovic. All rights reserved.
//

#import "CommonViewController.h"

@protocol WeatherDataLoader, SaveDataProvider;

NS_ASSUME_NONNULL_BEGIN

@interface CitySeachViewController: CommonViewController

- (instancetype)initWithWeatherDataLoader:(id<WeatherDataLoader>)dataLoader
                         saveDataProvider:(id<SaveDataProvider>)dataProvider;

@end

NS_ASSUME_NONNULL_END
